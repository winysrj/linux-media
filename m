Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64178 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2KOWG0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 17:06:26 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so1258234eek.19
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2012 14:06:25 -0800 (PST)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: dron0gus@gmail.com, tomasz.figa@gmail.com,
	oselas@community.pengutronix.de,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH RFC v3 0/3] S3C244X/S3C64XX SoC series camera interface driver
Date: Thu, 15 Nov 2012 23:05:12 +0100
Message-Id: <1353017115-11492-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds V4L2 driver for Samsung S3C244X/S3C64XX SoCs
camera interface.

Changes since v2:
 - use V4L2_CID_TEST_PATTERN instead of a private control,
 - added explicit PM_RUNTIME dependency,
 - device name appended in bus_info in vidioc_querycap ioctl,
 - added image effect controls,
 - added subdev controls value caching to prevent races,
   when referencing control values in the interrupt context,
 - included patch adding an entry in the MAINTAINERS file.

Complete branch for testing on mini2440 compatible boards can be pulled
from:

 git://linuxtv.org/snawrocki/media.git s3c-camif

I intend to finally send a pull request for this driver this week.


Andrey Gusakov (1):
  s3c-camif: Add image effect controls

Sylwester Nawrocki (2):
  V4L: Add driver for S3C244X/S3C64XX SoC series camera interface
  MAINTAINERS: Add entry for S3C24XX/S3C64XX SoC CAMIF driver

 MAINTAINERS                                      |    8 +
 drivers/media/platform/Kconfig                   |   12 +
 drivers/media/platform/Makefile                  |    1 +
 drivers/media/platform/s3c-camif/Makefile        |    5 +
 drivers/media/platform/s3c-camif/camif-capture.c | 1679 ++++++++++++++++++++++
 drivers/media/platform/s3c-camif/camif-core.c    |  662 +++++++++
 drivers/media/platform/s3c-camif/camif-core.h    |  393 +++++
 drivers/media/platform/s3c-camif/camif-regs.c    |  606 ++++++++
 drivers/media/platform/s3c-camif/camif-regs.h    |  269 ++++
 include/media/s3c_camif.h                        |   45 +
 10 files changed, 3680 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/platform/s3c-camif/Makefile
 create mode 100644 drivers/media/platform/s3c-camif/camif-capture.c
 create mode 100644 drivers/media/platform/s3c-camif/camif-core.c
 create mode 100644 drivers/media/platform/s3c-camif/camif-core.h
 create mode 100644 drivers/media/platform/s3c-camif/camif-regs.c
 create mode 100644 drivers/media/platform/s3c-camif/camif-regs.h
 create mode 100644 include/media/s3c_camif.h

--
1.7.4.1

