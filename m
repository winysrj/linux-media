Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:47163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028Ab1BVQoD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 11:44:03 -0500
Message-ID: <4D63E7E3.2030109@redhat.com>
Date: Tue, 22 Feb 2011 17:44:19 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Jean-Francois Moine <moinejf@free.fr>,
	Brian Johnson <brijohn@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [GIT PATCHES FOR 2.6.39] new vicam driver + gspca_sn9c20x fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

Please pull from my gspca tree, for a new driver for the vicam, removal of the
old vicam driver from staging, some gspca_sn9c20x fixes and a gspca_cpia1 fix.

Note this pull request supersedes my previous one.

The following changes since commit 5ed4bbdae09d207d141759e013a0f3c24ae76ecc:

   [media] tuner-core: Don't touch at standby during tuner_lookup (2011-02-15 10:31:01 -0200)

are available in the git repository at:
   git://linuxtv.org/hgoede/gspca.git gspca-for_v2.6.39

Hans de Goede (8):
       gspca_sn9c20x: Fix colored borders with ov7660 sensor
       gspca_sn9c20x: Add hflip and vflip controls for the ov7660 sensor
       gspca_sn9c20x: Add LED_REVERSE flag for 0c45:62bb
       gspca_sn9c20x: Make buffers slightly larger for JPEG frames
       gspca_sn9c20x: Add another MSI laptop to the sn9c20x upside down list
       gspca: Add new vicam subdriver
       gspca_cpia1: Don't allow the framerate divisor to go above 2
       staging-usbvideo: remove

  drivers/media/video/gspca/Kconfig   |   10 +
  drivers/media/video/gspca/Makefile  |    2 +
  drivers/media/video/gspca/cpia1.c   |    6 +-
  drivers/media/video/gspca/sn9c20x.c |   40 +-
  drivers/media/video/gspca/vicam.c   |  381 ++++++
  drivers/staging/Kconfig             |    2 -
  drivers/staging/Makefile            |    1 -
  drivers/staging/usbvideo/Kconfig    |   15 -
  drivers/staging/usbvideo/Makefile   |    2 -
  drivers/staging/usbvideo/TODO       |    5 -
  drivers/staging/usbvideo/usbvideo.c | 2230 -----------------------------------
  drivers/staging/usbvideo/usbvideo.h |  395 -------
  drivers/staging/usbvideo/vicam.c    |  952 ---------------
  drivers/staging/usbvideo/videodev.h |  318 -----
  14 files changed, 426 insertions(+), 3933 deletions(-)
  create mode 100644 drivers/media/video/gspca/vicam.c
  delete mode 100644 drivers/staging/usbvideo/Kconfig
  delete mode 100644 drivers/staging/usbvideo/Makefile
  delete mode 100644 drivers/staging/usbvideo/TODO
  delete mode 100644 drivers/staging/usbvideo/usbvideo.c
  delete mode 100644 drivers/staging/usbvideo/usbvideo.h
  delete mode 100644 drivers/staging/usbvideo/vicam.c
  delete mode 100644 drivers/staging/usbvideo/videodev.h

Thanks,

Hans
