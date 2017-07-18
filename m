Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:36549 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751189AbdGRHhe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 03:37:34 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] New adv748x driver
Message-ID: <58b3b3ef-3487-cfb4-04e2-45411a5fa107@xs4all.nl>
Date: Tue, 18 Jul 2017 09:37:30 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit a3db9d60a118571e696b684a6e8c692a2b064941:

  Merge tag 'v4.13-rc1' into patchwork (2017-07-17 11:17:36 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git adv748x

for you to fetch changes up to 5376ca8bf478886a495798f39a7648f78337c8b9:

  MAINTAINERS: Add ADV748x driver (2017-07-18 09:05:49 +0200)

----------------------------------------------------------------
Kieran Bingham (3):
      media: adv748x: Add adv7481, adv7482 bindings
      media: i2c: adv748x: add adv748x driver
      MAINTAINERS: Add ADV748x driver

 Documentation/devicetree/bindings/media/i2c/adv748x.txt |  95 ++++++++
 MAINTAINERS                                             |   6 +
 drivers/media/i2c/Kconfig                               |  12 ++
 drivers/media/i2c/Makefile                              |   1 +
 drivers/media/i2c/adv748x/Makefile                      |   7 +
 drivers/media/i2c/adv748x/adv748x-afe.c                 | 552 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/adv748x/adv748x-core.c                | 832 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/adv748x/adv748x-csi2.c                | 327 ++++++++++++++++++++++++++++
 drivers/media/i2c/adv748x/adv748x-hdmi.c                | 768 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/adv748x/adv748x.h                     | 425 ++++++++++++++++++++++++++++++++++++
 10 files changed, 3025 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/adv748x.txt
 create mode 100644 drivers/media/i2c/adv748x/Makefile
 create mode 100644 drivers/media/i2c/adv748x/adv748x-afe.c
 create mode 100644 drivers/media/i2c/adv748x/adv748x-core.c
 create mode 100644 drivers/media/i2c/adv748x/adv748x-csi2.c
 create mode 100644 drivers/media/i2c/adv748x/adv748x-hdmi.c
 create mode 100644 drivers/media/i2c/adv748x/adv748x.h
