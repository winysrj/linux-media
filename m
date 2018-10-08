Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:44849 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726291AbeJHWe3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Oct 2018 18:34:29 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.20] Various fixes
Message-ID: <a0404c6b-32bd-83fc-49e9-720a6562f43d@xs4all.nl>
Date: Mon, 8 Oct 2018 17:22:10 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Final pull request for 4.20 with odd 'n ends.

Regards,

	Hans

The following changes since commit 557c97b5133669297be561e6091da9ab6e488e65:

  media: cec: name for RC passthrough device does not need 'RC for' (2018-10-05 11:28:13 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br2-for-v4.20f

for you to fetch changes up to 295c6b7abc1beca6a3897e7aa4283f68a2d890d7:

  media: vivid: Add 16-bit bayer to format list (2018-10-08 17:20:41 +0200)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Biju Das (1):
      media: dt-bindings: media: rcar_vin: add device tree support for r8a7744

Bård Eirik Winther (2):
      media: v4l2-tpg-core: Add 16-bit bayer
      media: vivid: Add 16-bit bayer to format list

Colin Ian King (5):
      media: bttv-input: make const array addr_list static
      media: ivtv: make const array addr_list static
      media: cx23885: make const array addr_list static
      media: exynos4-is: make const array config_ids static
      media: cx231xx: fix potential sign-extension overflow on large shift

Dafna Hirschfeld (1):
      pvrusb2: replace `printk` with `pr_*`

Keiichi Watanabe (1):
      media: vivid: Support 480p for webcam capture

Nathan Chancellor (1):
      media: cx18: Don't check for address of video_dev

Vikash Garodia (1):
      venus: vdec: fix decoded data size

Wenwen Wang (1):
      media: isif: fix a NULL pointer dereference bug

 Documentation/devicetree/bindings/media/rcar_vin.txt |  1 +
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c        | 28 ++++++++++++++++++++++++++++
 drivers/media/pci/bt8xx/bttv-input.c                 |  2 +-
 drivers/media/pci/cx18/cx18-driver.c                 |  2 +-
 drivers/media/pci/cx23885/cx23885-i2c.c              |  2 +-
 drivers/media/pci/ivtv/ivtv-i2c.c                    |  2 +-
 drivers/media/platform/davinci/isif.c                |  3 ++-
 drivers/media/platform/exynos4-is/fimc-is.c          |  2 +-
 drivers/media/platform/qcom/venus/vdec.c             |  3 +--
 drivers/media/platform/vivid/vivid-vid-cap.c         |  5 ++++-
 drivers/media/platform/vivid/vivid-vid-common.c      | 28 ++++++++++++++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx-video.c            |  2 +-
 drivers/media/usb/pvrusb2/pvrusb2-debug.h            |  2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c              |  8 ++++----
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c         | 28 +++++++++++++---------------
 drivers/media/usb/pvrusb2/pvrusb2-main.c             |  4 ++--
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c             |  4 ++--
 17 files changed, 92 insertions(+), 34 deletions(-)
