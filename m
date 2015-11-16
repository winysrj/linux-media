Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:57255 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535AbbKPJBz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 04:01:55 -0500
Received: from [192.168.1.134] (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id 83371E3982
	for <linux-media@vger.kernel.org>; Mon, 16 Nov 2015 10:01:49 +0100 (CET)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.5] Fixes and new ti-vpe/cal driver
Message-ID: <56499B7C.5090603@xs4all.nl>
Date: Mon, 16 Nov 2015 10:01:48 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please note that this patch series assumes that my previous pull request was
merged first:

https://patchwork.linuxtv.org/patch/31872/

This is for the v4l2-pci-skeleton patch. The other three are independent of
the previous pull request.

Regards,

	Hans


The following changes since commit 54adb10d0947478b3364640a131fff1f1ab190fa:

  v4l2-dv-timings: add new arg to v4l2_match_dv_timings (2015-11-13 14:15:55 +0100)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.5b

for you to fetch changes up to 2cb88733214e31c04d1a87a1ef51cc6f26a44e09:

  media: v4l: ti-vpe: Document CAL driver (2015-11-16 09:50:13 +0100)

----------------------------------------------------------------
Benoit Parrot (2):
      media: v4l: ti-vpe: Add CAL v4l2 camera capture driver
      media: v4l: ti-vpe: Document CAL driver

Hans Verkuil (1):
      v4l2-pci-skeleton.c: forgot to update v4l2_match_dv_timings call

Julia Lawall (1):
      i2c: constify v4l2_ctrl_ops structures

 Documentation/devicetree/bindings/media/ti-cal.txt |   70 +++
 Documentation/video4linux/v4l2-pci-skeleton.c      |    2 +-
 drivers/media/i2c/mt9m032.c                        |    2 +-
 drivers/media/i2c/mt9p031.c                        |    2 +-
 drivers/media/i2c/mt9t001.c                        |    2 +-
 drivers/media/i2c/mt9v011.c                        |    2 +-
 drivers/media/i2c/mt9v032.c                        |    2 +-
 drivers/media/i2c/ov2659.c                         |    2 +-
 drivers/media/platform/Kconfig                     |   12 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/ti-vpe/Makefile             |    4 +
 drivers/media/platform/ti-vpe/cal.c                | 2164 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/ti-vpe/cal_regs.h           |  779 +++++++++++++++++++++++++++++++++
 13 files changed, 3038 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/ti-cal.txt
 create mode 100644 drivers/media/platform/ti-vpe/cal.c
 create mode 100644 drivers/media/platform/ti-vpe/cal_regs.h
