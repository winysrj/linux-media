Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab2EDKKB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 May 2012 06:10:01 -0400
Message-ID: <4FA3AAF5.4070000@redhat.com>
Date: Fri, 04 May 2012 12:09:57 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Jean-Francois Moine <moinejf@free.fr>
Subject: [GIT PULL FOR 3.5] gspca_pac73XX improvements + misc fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro et al,

Please pull from my tree for:
-a small stk driver fix
-a bunch of gspca_pac73XX improvements
-removal of the long deprecated et61x251 driver

Note this pull request obsoletes my previous pull req.

The following changes since commit a1ac5dc28d2b4ca78e183229f7c595ffd725241c:

   [media] gspca - sn9c20x: Change the exposure setting of Omnivision sensors (2012-05-03 15:29:56 -0300)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v3.5

for you to fetch changes up to cfe42cea7b4040c6e18f113a0494426764bfa21b:

   media/video/et61x251: Remove this deprecated driver (2012-05-04 11:38:43 +0200)

----------------------------------------------------------------
Hans de Goede (13):
       stk-webcam: Don't flip the image by default
       gspca/autogain_functions.h: Allow users to declare what they want
       gspca_pac73xx: Remove comments from before the 7302 / 7311 separation
       gspca_pac7311: Make sure exposure changes get applied immediately
       gspca_pac7311: Adjust control scales to match registers
       gspca_pac7311: Switch to new gspca control mechanism
       gspca_pac7311: Switch to coarse expo autogain algorithm
       gspca_pac7311: Convert multi-line comments to standard kernel style
       gspca_pac7311: Properly set the compression balance
       gspca_pac7302: Convert multi-line comments to standard kernel style
       gspca_pac7302: Document some more registers
       gspca_pac7302: Improve the gain control
       media/video/et61x251: Remove this deprecated driver

  drivers/media/video/Kconfig                        |    2 -
  drivers/media/video/Makefile                       |    1 -
  drivers/media/video/et61x251/Kconfig               |   18 -
  drivers/media/video/et61x251/Makefile              |    4 -
  drivers/media/video/et61x251/et61x251.h            |  213 --
  drivers/media/video/et61x251/et61x251_core.c       | 2683 --------------------
  drivers/media/video/et61x251/et61x251_sensor.h     |  108 -
  drivers/media/video/et61x251/et61x251_tas5130d1b.c |  143 --
  drivers/media/video/gspca/autogain_functions.h     |    6 +-
  drivers/media/video/gspca/nw80x.c                  |    2 +
  drivers/media/video/gspca/pac7302.c                |  184 +-
  drivers/media/video/gspca/pac7311.c                |  380 +--
  drivers/media/video/gspca/sonixb.c                 |    2 +
  drivers/media/video/gspca/sonixj.c                 |    5 +-
  drivers/media/video/gspca/topro.c                  |    6 +-
  drivers/media/video/stk-webcam.c                   |    8 +-
  16 files changed, 239 insertions(+), 3526 deletions(-)
  delete mode 100644 drivers/media/video/et61x251/Kconfig
  delete mode 100644 drivers/media/video/et61x251/Makefile
  delete mode 100644 drivers/media/video/et61x251/et61x251.h
  delete mode 100644 drivers/media/video/et61x251/et61x251_core.c
  delete mode 100644 drivers/media/video/et61x251/et61x251_sensor.h
  delete mode 100644 drivers/media/video/et61x251/et61x251_tas5130d1b.c

Thanks & Regards,

Hans
