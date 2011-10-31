Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58562 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1JaQZb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 12:25:31 -0400
Received: by eye27 with SMTP id 27so5444327eye.19
        for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 09:25:29 -0700 (PDT)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>
Subject: [PATCH 00/17] Staging: Abilis Systems AS102 driver
Date: Mon, 31 Oct 2011 17:24:38 +0100
Message-Id: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have collected most of patches for Abilis Systems AS102 driver
recently submitted by Piotr and I'm resending it as the following
series. There were some issues with some of the previous patches,
due to improper e-mail encoding and some of them refused to apply
properly. Hopefully there is no issues this time, I have also
pushed the patches to a public git, as indicated below.

This change set superseeds all previous as102 patches from Piotr
Chmura, we've agreed to prepare another series addressing the
remaining issues in order to move the driver out of staging.

So this change set is meant as an initial pull to staging/media.
If there are any issues with the patches related to submission
procedure, authorship, etc., please let us know.

The original author dates as in mercurial repository at
http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/
has been preserved.

The patch set is based of off master branch at
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

It can be pulled from git://gitorious.org/linux-media/media_tree.git

The driver has been tested with PCTV picoStick (74e) DVB-T tuner.

--
Regards,
Sylwester

Devin Heitmueller (9):
  staging: as102: Fix CodingStyle errors in file as102_drv.c
  staging: as102: Fix CodingStyle errors in file as102_fw.c
  staging: as102: Fix CodingStyle errors in file as10x_cmd.c
  staging: as102: Fix CodingStyle errors in file as10x_cmd_stream.c
  staging: as102: Fix CodingStyle errors in file as102_fe.c
  staging: as102: Fix CodingStyle errors in file as102_usb_drv.c
  staging: as102: Fix CodingStyle errors in file as10x_cmd_cfg.c
  staging: as102: Add Elgato EyeTV DTT Deluxe
  staging: as102: Properly handle multiple product names

Pierrick Hascoet (2):
  staging: as102: Initial import from Abilis
  staging: as102: Fix licensing oversight

Piotr Chmura (3):
  staging: as102: Remove non-linux headers inclusion
  staging: as102: Enable compilation
  staging: as102: Add nBox Tuner Dongle support

Sylwester Nawrocki (3):
  staging: as102: Convert the comments to kernel-doc style
  staging: as102: Unconditionally compile code dependent on DVB_CORE
  staging: as102: Remove conditional compilation based on kernel version

 drivers/staging/Kconfig                        |    2 +
 drivers/staging/Makefile                       |    1 +
 drivers/staging/media/as102/Kconfig            |    7 +
 drivers/staging/media/as102/Makefile           |    6 +
 drivers/staging/media/as102/as102_drv.c        |  351 ++++++++++++++
 drivers/staging/media/as102/as102_drv.h        |  141 ++++++
 drivers/staging/media/as102/as102_fe.c         |  603 ++++++++++++++++++++++++
 drivers/staging/media/as102/as102_fw.c         |  251 ++++++++++
 drivers/staging/media/as102/as102_fw.h         |   42 ++
 drivers/staging/media/as102/as102_usb_drv.c    |  478 +++++++++++++++++++
 drivers/staging/media/as102/as102_usb_drv.h    |   59 +++
 drivers/staging/media/as102/as10x_cmd.c        |  452 ++++++++++++++++++
 drivers/staging/media/as102/as10x_cmd.h        |  540 +++++++++++++++++++++
 drivers/staging/media/as102/as10x_cmd_cfg.c    |  215 +++++++++
 drivers/staging/media/as102/as10x_cmd_stream.c |  223 +++++++++
 drivers/staging/media/as102/as10x_handle.h     |   58 +++
 drivers/staging/media/as102/as10x_types.h      |  198 ++++++++
 17 files changed, 3627 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/media/as102/Kconfig
 create mode 100644 drivers/staging/media/as102/Makefile
 create mode 100644 drivers/staging/media/as102/as102_drv.c
 create mode 100644 drivers/staging/media/as102/as102_drv.h
 create mode 100644 drivers/staging/media/as102/as102_fe.c
 create mode 100644 drivers/staging/media/as102/as102_fw.c
 create mode 100644 drivers/staging/media/as102/as102_fw.h
 create mode 100644 drivers/staging/media/as102/as102_usb_drv.c
 create mode 100644 drivers/staging/media/as102/as102_usb_drv.h
 create mode 100644 drivers/staging/media/as102/as10x_cmd.c
 create mode 100644 drivers/staging/media/as102/as10x_cmd.h
 create mode 100644 drivers/staging/media/as102/as10x_cmd_cfg.c
 create mode 100644 drivers/staging/media/as102/as10x_cmd_stream.c
 create mode 100644 drivers/staging/media/as102/as10x_handle.h
 create mode 100644 drivers/staging/media/as102/as10x_types.h

--
1.7.4.1
