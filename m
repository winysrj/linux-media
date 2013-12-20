Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3132 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab3LTMVJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 07:21:09 -0500
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id rBKCL6RD005955
	for <linux-media@vger.kernel.org>; Fri, 20 Dec 2013 13:21:08 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.61.168.73] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id D269C2A2226
	for <linux-media@vger.kernel.org>; Fri, 20 Dec 2013 13:20:46 +0100 (CET)
Message-ID: <52B43630.6010801@xs4all.nl>
Date: Fri, 20 Dec 2013 13:21:04 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.14] Move omap2 and sn9c102 to staging
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The int-device dependent omap2 drivers are moved to staging and so is sn9c102.
By the end of next year these should be dropped altogether unless something is
done to get them into shape.

Regards,

	Hans

The following changes since commit d22d32e117c19efa1761d871d9dab5e294b7b77d:

  [media] Add USB IDs for Winfast DTV Dongle Mini-D (2013-12-19 09:26:15 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git removal

for you to fetch changes up to 334222a58ea89d96468fc1f550d25bc5b4484b07:

  omap24xx/tcm825x: move to staging for future removal. (2013-12-20 13:17:08 +0100)

----------------------------------------------------------------
Hans Verkuil (2):
      sn9c102: prepare for removal by moving it to staging.
      omap24xx/tcm825x: move to staging for future removal.

 MAINTAINERS                                                              |  3 +--
 drivers/media/i2c/Kconfig                                                |  8 --------
 drivers/media/i2c/Makefile                                               |  1 -
 drivers/media/platform/Kconfig                                           |  7 -------
 drivers/media/platform/Makefile                                          |  3 ---
 drivers/media/usb/Kconfig                                                |  1 -
 drivers/media/usb/Makefile                                               |  1 -
 drivers/media/v4l2-core/Kconfig                                          | 11 -----------
 drivers/media/v4l2-core/Makefile                                         |  1 -
 drivers/staging/media/Kconfig                                            |  4 ++++
 drivers/staging/media/Makefile                                           |  3 +++
 drivers/staging/media/omap24xx/Kconfig                                   | 35 +++++++++++++++++++++++++++++++++++
 drivers/staging/media/omap24xx/Makefile                                  |  5 +++++
 drivers/{media/platform => staging/media/omap24xx}/omap24xxcam-dma.c     |  0
 drivers/{media/platform => staging/media/omap24xx}/omap24xxcam.c         |  0
 drivers/{media/platform => staging/media/omap24xx}/omap24xxcam.h         |  2 +-
 drivers/{media/i2c => staging/media/omap24xx}/tcm825x.c                  |  2 +-
 drivers/{media/i2c => staging/media/omap24xx}/tcm825x.h                  |  2 +-
 drivers/{media/v4l2-core => staging/media/omap24xx}/v4l2-int-device.c    |  2 +-
 {include/media => drivers/staging/media/omap24xx}/v4l2-int-device.h      |  0
 drivers/{media/usb => staging/media}/sn9c102/Kconfig                     |  7 +++++--
 drivers/{media/usb => staging/media}/sn9c102/Makefile                    |  0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102.h                   |  0
 {Documentation/video4linux => drivers/staging/media/sn9c102}/sn9c102.txt |  0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_config.h            |  0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_core.c              |  0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_devtable.h          |  0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_hv7131d.c           |  0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_hv7131r.c           |  0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_mi0343.c            |  0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_mi0360.c            |  0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_mt9v111.c           |  0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_ov7630.c            |  0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_ov7660.c            |  0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_pas106b.c           |  0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_pas202bcb.c         |  0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_sensor.h            |  0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_tas5110c1b.c        |  0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_tas5110d.c          |  0
 drivers/{media/usb => staging/media}/sn9c102/sn9c102_tas5130d1b.c        |  0
 40 files changed, 57 insertions(+), 41 deletions(-)
 create mode 100644 drivers/staging/media/omap24xx/Kconfig
 create mode 100644 drivers/staging/media/omap24xx/Makefile
 rename drivers/{media/platform => staging/media/omap24xx}/omap24xxcam-dma.c (100%)
 rename drivers/{media/platform => staging/media/omap24xx}/omap24xxcam.c (100%)
 rename drivers/{media/platform => staging/media/omap24xx}/omap24xxcam.h (99%)
 rename drivers/{media/i2c => staging/media/omap24xx}/tcm825x.c (99%)
 rename drivers/{media/i2c => staging/media/omap24xx}/tcm825x.h (99%)
 rename drivers/{media/v4l2-core => staging/media/omap24xx}/v4l2-int-device.c (99%)
 rename {include/media => drivers/staging/media/omap24xx}/v4l2-int-device.h (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/Kconfig (58%)
 rename drivers/{media/usb => staging/media}/sn9c102/Makefile (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102.h (100%)
 rename {Documentation/video4linux => drivers/staging/media/sn9c102}/sn9c102.txt (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_config.h (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_core.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_devtable.h (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_hv7131d.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_hv7131r.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_mi0343.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_mi0360.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_mt9v111.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_ov7630.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_ov7660.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_pas106b.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_pas202bcb.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_sensor.h (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_tas5110c1b.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_tas5110d.c (100%)
 rename drivers/{media/usb => staging/media}/sn9c102/sn9c102_tas5130d1b.c (100%)
