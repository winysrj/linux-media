Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:42897 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751413AbdGRPcU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 11:32:20 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] Various fixes, improvements.
Message-ID: <269b632f-e20f-3d2d-24af-fb6fec5961ea@xs4all.nl>
Date: Tue, 18 Jul 2017 17:32:18 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro, feel free to cherry-pick from this series if needed.

Regards,

	Hans

The following changes since commit a3db9d60a118571e696b684a6e8c692a2b064941:

  Merge tag 'v4.13-rc1' into patchwork (2017-07-17 11:17:36 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.14b

for you to fetch changes up to e08dbd60ed38b3c182afcc9aef16372fe9c93921:

  platform: video-mux: convert to multiplexer framework (2017-07-18 16:27:36 +0200)

----------------------------------------------------------------
Anton Sviridenko (1):
      solo6x10: fix detection of TW2864B chips

Arnd Bergmann (1):
      usbvision-i2c: fix format overflow warning

Philipp Zabel (1):
      platform: video-mux: convert to multiplexer framework

Ramesh Shanmugasundaram (1):
      dt-bindings: media: Add r8a7796 DRIF bindings

Todor Tomov (1):
      v4l2-mediabus: Add helper functions

Ulrich Hecht (1):
      media: adv7180: add missing adv7180cp, adv7180st i2c device IDs

 Documentation/devicetree/bindings/media/renesas,drif.txt |  1 +
 drivers/media/i2c/adv7180.c                              |  2 ++
 drivers/media/pci/solo6x10/solo6x10-tw28.c               |  1 +
 drivers/media/platform/Kconfig                           |  1 +
 drivers/media/platform/video-mux.c                       | 53 +++++++----------------------------------------------
 drivers/media/usb/usbvision/usbvision-i2c.c              |  5 +++--
 include/media/v4l2-mediabus.h                            | 26 ++++++++++++++++++++++++++
 7 files changed, 41 insertions(+), 48 deletions(-)
