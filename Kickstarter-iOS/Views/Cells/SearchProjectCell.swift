import KsApi
import Library
import Prelude
import UIKit

internal final class SearchProjectCell: UITableViewCell, ValueCell {
  fileprivate let viewModel: SearchProjectCellViewModelType = SearchProjectCellViewModel()

  @IBOutlet fileprivate weak var columnsStackView: UIStackView!
  @IBOutlet fileprivate weak var imageShadowView: UIView!
  @IBOutlet fileprivate weak var projectImageView: UIImageView!
  @IBOutlet fileprivate weak var projectImageWidthConstraint: NSLayoutConstraint!
  @IBOutlet fileprivate weak var projectLabel: UILabel!
  @IBOutlet fileprivate weak var projectNameContainerView: UIView!
  @IBOutlet fileprivate weak var separateView: UIView!
  @IBOutlet fileprivate weak var fundingLabel: UILabel!
  @IBOutlet fileprivate  weak var deadlineSubtitleLabel: UILabel!
  @IBOutlet fileprivate weak var deadlineTitleLabel: UILabel!

  func configureWith(value project: Project) {
    self.viewModel.inputs.configureWith(project: project)


//    self.projectImageView.image = nil
//    self.projectImageView.af_cancelImageRequest()
//    if let url = URL(string: project.photo.med) {
//      self.projectImageView.ksr_setImageWithURL(url)
//    }
  }

  internal override func bindStyles() {
    super.bindStyles()

    _ = self
      |> baseTableViewCellStyle()
      |> SearchProjectCell.lens.backgroundColor .~ .clear
      |> SearchProjectCell.lens.contentView.layoutMargins %~~ { _, cell in
        cell.traitCollection.isRegularRegular
          ? .init(topBottom: Styles.grid(4), leftRight: Styles.grid(24))
          : .init(topBottom: Styles.grid(2), leftRight: Styles.grid(2))
    }

    _ = self.fundingLabel
      |> UILabel.lens.font .~ UIFont.ksr_body(size: 12)

    _ = self.deadlineSubtitleLabel
      |> UILabel.lens.font .~ UIFont.ksr_body(size: 12)
      |> UILabel.lens.textColor .~ UIColor.ksr_navy_500

    _ = self.deadlineTitleLabel
      |> UILabel.lens.font .~ UIFont.ksr_body(size: 12)
      |> UILabel.lens.textColor .~ UIColor.ksr_navy_700

    _ = self.columnsStackView
      |> UIStackView.lens.alignment .~ .top
      |> UIStackView.lens.spacing %~~ { _, stackView in
        stackView.traitCollection.isRegularRegular
          ? Styles.grid(4)
          : Styles.grid(2)
      }
      |> UIStackView.lens.layoutMarginsRelativeArrangement .~ true
      |> UIStackView.lens.layoutMargins .~ .init(topBottom: 0, leftRight: Styles.grid(2))

    _ = self.imageShadowView
      |> dropShadowStyle()

    _ = self.projectImageView
      |> UIImageView.lens.contentMode .~ .scaleAspectFill
      |> UIImageView.lens.clipsToBounds .~ true

    self.projectImageWidthConstraint.constant = self.traitCollection.isRegularRegular ? 140 : 80

    _ = self.projectLabel
      |> UILabel.lens.font %~~ { _, label in
        label.traitCollection.isRegularRegular
          ? .ksr_title3()
          : .ksr_headline(size: 14)
      }
      |> UILabel.lens.textColor .~ .ksr_text_navy_600

    _ = self.projectNameContainerView
      |> UIView.lens.layoutMargins .~ .init(top: Styles.grid(1), left: 0, bottom: 0, right: 0)
      |> UIView.lens.backgroundColor .~ .clear

    _ = self.separateView
      |> separatorStyle
  }

  internal override func bindViewModel() {
    super.bindViewModel()

    self.viewModel.outputs.projectImageUrl
      .observeForUI()
      .on(event: { [weak self] _ in
        self?.projectImageView.image = nil
        self?.projectImageView.af_cancelImageRequest()
      })
      .skipNil()
      .observeValues { [weak self] in
        self?.projectImageView.af_setImage(withURL: $0)
    }

    self.fundingLabel.rac.text = self.viewModel.outputs.fundingLabelText
    self.deadlineSubtitleLabel.rac.text = self.viewModel.outputs.deadlineSubtitleLabelText
    self.deadlineTitleLabel.rac.text = self.viewModel.outputs.deadlineTitleLabelText
    self.projectLabel.rac.text = self.viewModel.outputs.projectNameLabelText

  }

}
