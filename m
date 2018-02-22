Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:38610 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750752AbeBVStd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 13:49:33 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.17] Renesas Capture Engine Unit (CEU) V4L2 driver
Message-ID: <f6e35197-6389-22d9-f5f6-ce7df402840b@xs4all.nl>
Date: Thu, 22 Feb 2018 19:48:28 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds the new renesas-ceu driver as a modern alternative to the soc-camera driver.

Note: the dts patch from Jacopo's patch series will go through Geert's tree.
But since nobody maintains the sh architecture anymore the final arch/sh patch
is included in this pull request.

Regards,

	Hans

The following changes since commit 4395fb475a27ddcb33c27380e132ef5354ff67c6:

  tda1997x: get rid of an unused var (2018-02-22 12:54:28 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git ceu

for you to fetch changes up to 5668b9e8355f3cbb20d54f708604dade2bce4bb6:

  arch: sh: migor: Use new renesas-ceu camera driver (2018-02-22 19:43:16 +0100)

----------------------------------------------------------------
Jacopo Mondi (12):
      dt-bindings: media: Add Renesas CEU bindings
      include: media: Add Renesas CEU driver interface
      media: platform: Add Renesas CEU driver
      MAINTAINERS: Add entry for Renesas CEU
      media: i2c: Copy ov772x soc_camera sensor driver
      media: i2c: ov772x: Remove soc_camera dependencies
      media: i2c: ov772x: Support frame interval handling
      MAINTAINERS: Add entry for Omnivision OV772x
      media: i2c: Copy tw9910 soc_camera sensor driver
      media: i2c: tw9910: Remove soc_camera dependencies
      MAINTAINERS: Add entry for Techwell TW9910
      arch: sh: migor: Use new renesas-ceu camera driver

 Documentation/devicetree/bindings/media/renesas,ceu.txt |   81 +++
 MAINTAINERS                                             |   24 +
 arch/sh/boards/mach-migor/setup.c                       |  225 ++++-----
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c                  |    2 +-
 drivers/media/i2c/Kconfig                               |   20 +
 drivers/media/i2c/Makefile                              |    2 +
 drivers/media/i2c/ov772x.c                              | 1365 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/tw9910.c                              | 1039 ++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/Kconfig                          |    9 +
 drivers/media/platform/Makefile                         |    1 +
 drivers/media/platform/renesas-ceu.c                    | 1677 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/media/drv-intf/renesas-ceu.h                    |   26 +
 include/media/i2c/ov772x.h                              |    6 +-
 include/media/i2c/tw9910.h                              |    9 +
 14 files changed, 4358 insertions(+), 128 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,ceu.txt
 create mode 100644 drivers/media/i2c/ov772x.c
 create mode 100644 drivers/media/i2c/tw9910.c
 create mode 100644 drivers/media/platform/renesas-ceu.c
 create mode 100644 include/media/drv-intf/renesas-ceu.h
