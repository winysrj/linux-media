Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:33795 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751532AbdIKNuy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 09:50:54 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.15] Various fixes
Message-ID: <274819a4-0590-efa9-7e44-5ca32dd2591e@xs4all.nl>
Date: Mon, 11 Sep 2017 15:50:49 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

A bunch of small things all over the place.

Please note the "media: fix media Kconfig help syntax issues" patch: double
check that drivers/media/pci/netup_unidvb/Kconfig is OK.

Regards,

	Hans

The following changes since commit 1efdf1776e2253b77413c997bed862410e4b6aaf:

  media: leds: as3645a: add V4L2_FLASH_LED_CLASS dependency (2017-09-05 16:32:45 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.15b

for you to fetch changes up to 4730ba1fe2ef5074ce9465bfb9da99c8bc8cd832:

  cec.h: initialize *parent and *port in cec_phys_addr_validate (2017-09-11 15:36:14 +0200)

----------------------------------------------------------------
Geert Uytterhoeven (1):
      media: platform: VIDEO_QCOM_CAMSS should depend on HAS_DMA

Hans Verkuil (3):
      cobalt: do not register subdev nodes
      media: fix media Kconfig help syntax issues
      cec.h: initialize *parent and *port in cec_phys_addr_validate

Markus Elfring (3):
      DaVinci-VPBE-Display: Delete an error message for a failed memory allocation in init_vpbe_layer()
      DaVinci-VPBE-Display: Improve a size determination in two functions
      DaVinci-VPBE-Display: Adjust 12 checks for null pointers

Ricardo Ribalda Delgado (1):
      v4l-ioctl: Fix typo on v4l_print_frmsizeenum

 drivers/media/dvb-frontends/Kconfig           |  6 +++---
 drivers/media/pci/b2c2/Kconfig                |  4 ++--
 drivers/media/pci/cobalt/cobalt-driver.c      |  3 ---
 drivers/media/pci/netup_unidvb/Kconfig        | 12 ++++++------
 drivers/media/platform/Kconfig                |  2 +-
 drivers/media/platform/davinci/vpbe_display.c | 37 +++++++++++++++----------------------
 drivers/media/platform/exynos4-is/Kconfig     |  2 +-
 drivers/media/radio/wl128x/Kconfig            | 10 +++++-----
 drivers/media/usb/b2c2/Kconfig                |  6 +++---
 drivers/media/usb/gspca/Kconfig               | 16 ++++++++--------
 drivers/media/usb/pvrusb2/Kconfig             |  1 -
 drivers/media/v4l2-core/v4l2-ioctl.c          |  9 ++++++---
 include/media/cec.h                           |  4 ++++
 13 files changed, 54 insertions(+), 58 deletions(-)
