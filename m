Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54266 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab1KJXet (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 18:34:49 -0500
Received: by iage36 with SMTP id e36so3520899iag.19
        for <linux-media@vger.kernel.org>; Thu, 10 Nov 2011 15:34:49 -0800 (PST)
From: Patrick Dickey <pdickeybeta@gmail.com>
To: linux-media@vger.kernel.org
Cc: Patrick Dickey <pdickeybeta@gmail.com>
Subject: [PATCH 00/25] Add PCTV-80e Support to v4l
Date: Thu, 10 Nov 2011 17:31:20 -0600
Message-Id: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These are the files required to support the Pinnacle PCTV-80e USB Tuner in
video-4-linux. The files were originally downloaded from 
http://www.kernellabs.com/hg/~dheitmueller/v4l-dvb-80e and modified to fix
compilation errors and also to move the driver files from the drx39xy
subdirectory to the frontends directory.

There are still coding style errors (mainly trailing whitespace and DOS Line
Endings, but some other style errors exist as well). I have successfully 
compiled and installed this under the 3.0.x kernel, but haven't tried under any
later kernels.


Patrick Dickey (25):
  added PCTV80e information to cardlist file
  added bsp_host for pctv80e support
  added bsp_i2c for pctv80e support
  added bsp_tuner for pctv80e support
  added bsp_types for pctv80e support
  added drx39xxj for pctv80e support
  added drx39xxj header for pctv80e support
  added drx39_dummy for pctv80e support
  added drx_dap_fasi for pctv80e support
  added drx_dap_fasi header for pctv80e support
  added drx_driver for pctv80e support
  added drx_driver header for pctv80e support
  added drx_driver_version header for pctv80e support
  added drxj for pctv80e support
  added drxj header for pctv80e support
  added drxj_map header for pctv80e support
  added drxj_mc header for pctv80e support
  added drxj_mc_vsb header for pctv80e support
  added drxj_mc_vsbqam header for pctv80e support
  added drxj_options header for pctv80e support
  modified Kconfig to include pctv80e support
  modified Makefile for pctv80e support
  modified em28xx-cards for pctv80e support
  modified em28xx-dvb for pctv80e support
  modified em28xx header for pctv80e support

 Documentation/video4linux/CARDLIST.em28xx        |    1 +
 drivers/media/dvb/frontends/Kconfig              |    8 +
 drivers/media/dvb/frontends/Makefile             |    2 +
 drivers/media/dvb/frontends/bsp_host.h           |   80 +
 drivers/media/dvb/frontends/bsp_i2c.h            |  217 +
 drivers/media/dvb/frontends/bsp_tuner.h          |  215 +
 drivers/media/dvb/frontends/bsp_types.h          |  229 +
 drivers/media/dvb/frontends/drx39xxj.c           |  464 +
 drivers/media/dvb/frontends/drx39xxj.h           |   40 +
 drivers/media/dvb/frontends/drx39xxj_dummy.c     |  135 +
 drivers/media/dvb/frontends/drx_dap_fasi.c       |  670 +
 drivers/media/dvb/frontends/drx_dap_fasi.h       |  268 +
 drivers/media/dvb/frontends/drx_driver.c         | 1504 +++
 drivers/media/dvb/frontends/drx_driver.h         | 2588 ++++
 drivers/media/dvb/frontends/drx_driver_version.h |   82 +
 drivers/media/dvb/frontends/drxj.c               |15732 ++++++++++++++++++++++
 drivers/media/dvb/frontends/drxj.h               |  990 ++
 drivers/media/dvb/frontends/drxj_map.h           |15359 +++++++++++++++++++++
 drivers/media/dvb/frontends/drxj_mc.h            | 3939 ++++++
 drivers/media/dvb/frontends/drxj_mc_vsb.h        |  744 +
 drivers/media/dvb/frontends/drxj_mc_vsbqam.h     | 1437 ++
 drivers/media/dvb/frontends/drxj_options.h       |   65 +
 drivers/media/video/em28xx/em28xx-cards.c        |   20 +
 drivers/media/video/em28xx/em28xx-dvb.c          |   25 +
 drivers/media/video/em28xx/em28xx.h              |    1 +
 25 files changed, 44815 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/dvb/frontends/bsp_host.h
 create mode 100644 drivers/media/dvb/frontends/bsp_i2c.h
 create mode 100644 drivers/media/dvb/frontends/bsp_tuner.h
 create mode 100644 drivers/media/dvb/frontends/bsp_types.h
 create mode 100644 drivers/media/dvb/frontends/drx39xxj.c
 create mode 100644 drivers/media/dvb/frontends/drx39xxj.h
 create mode 100644 drivers/media/dvb/frontends/drx39xxj_dummy.c
 create mode 100644 drivers/media/dvb/frontends/drx_dap_fasi.c
 create mode 100644 drivers/media/dvb/frontends/drx_dap_fasi.h
 create mode 100644 drivers/media/dvb/frontends/drx_driver.c
 create mode 100644 drivers/media/dvb/frontends/drx_driver.h
 create mode 100644 drivers/media/dvb/frontends/drx_driver_version.h
 create mode 100644 drivers/media/dvb/frontends/drxj.c
 create mode 100644 drivers/media/dvb/frontends/drxj.h
 create mode 100644 drivers/media/dvb/frontends/drxj_map.h
 create mode 100644 drivers/media/dvb/frontends/drxj_mc.h
 create mode 100644 drivers/media/dvb/frontends/drxj_mc_vsb.h
 create mode 100644 drivers/media/dvb/frontends/drxj_mc_vsbqam.h
 create mode 100644 drivers/media/dvb/frontends/drxj_options.h

-- 
1.7.5.4

