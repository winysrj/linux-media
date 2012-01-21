Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45667 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab2AUHkT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 02:40:19 -0500
Received: by iacb35 with SMTP id b35so733749iac.19
        for <linux-media@vger.kernel.org>; Fri, 20 Jan 2012 23:40:18 -0800 (PST)
From: pdickeybeta@gmail.com
To: linux-media@vger.kernel.org
Cc: Patrick Dickey <pdickeybeta@gmail.com>
Subject: [PATCH 0/2] Import PCTV-80e Drivers from Devin Heitmueller's Repository
Date: Sat, 21 Jan 2012 01:34:49 -0600
Message-Id: <1327131291-5174-1-git-send-email-pdickeybeta@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Patrick Dickey <pdickeybeta@gmail.com>

This series of patches will import the drx39xxj(drx39xyj) drivers from Devin
Heitmueller's HG Repository for the Pinnacle PCTV-80e USB Tuner.

Patrick Dickey (2):
  import-pctv-80e-from-devin-heitmueller-hg-repository
    Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>    
    Signed-off-by: Patrick Dickey <pdickeybeta@gmail.com>
  import-pctv-80e-from-devin-heitmueller-hg-repository
    Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>    
    Signed-off-by: Patrick Dickey <pdickeybeta@gmail.com>

 Documentation/video4linux/CARDLIST.em28xx          |    1 +
 .../staging/media/dvb/frontends/drx39xyj/Kconfig   |    7 +
 .../staging/media/dvb/frontends/drx39xyj/Makefile  |    3 +
 .../media/dvb/frontends/drx39xyj/bsp_host.h        |   80 +
 .../staging/media/dvb/frontends/drx39xyj/bsp_i2c.h |  217 +
 .../media/dvb/frontends/drx39xyj/bsp_tuner.h       |  215 +
 .../media/dvb/frontends/drx39xyj/bsp_types.h       |  229 +
 .../media/dvb/frontends/drx39xyj/drx39xxj.c        |  457 +
 .../media/dvb/frontends/drx39xyj/drx39xxj.h        |   40 +
 .../media/dvb/frontends/drx39xyj/drx39xxj_dummy.c  |  134 +
 .../media/dvb/frontends/drx39xyj/drx_dap_fasi.c    |  675 +
 .../media/dvb/frontends/drx39xyj/drx_dap_fasi.h    |  268 +
 .../media/dvb/frontends/drx39xyj/drx_driver.c      | 1600 ++
 .../media/dvb/frontends/drx39xyj/drx_driver.h      | 2588 +++
 .../dvb/frontends/drx39xyj/drx_driver_version.h    |   82 +
 .../staging/media/dvb/frontends/drx39xyj/drxj.c    |16758 ++++++++++++++++++++
 .../staging/media/dvb/frontends/drx39xyj/drxj.h    |  730 +
 .../media/dvb/frontends/drx39xyj/drxj_map.h        |15359 ++++++++++++++++++
 .../staging/media/dvb/frontends/drx39xyj/drxj_mc.h | 3939 +++++
 .../media/dvb/frontends/drx39xyj/drxj_mc_vsb.h     |  744 +
 .../media/dvb/frontends/drx39xyj/drxj_mc_vsbqam.h  | 1437 ++
 .../media/dvb/frontends/drx39xyj/drxj_options.h    |   65 +
 22 files changed, 45628 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/Kconfig
 create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/Makefile
 create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/bsp_host.h
 create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/bsp_i2c.h
 create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/bsp_tuner.h
 create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/bsp_types.h
 create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drx39xxj.c
 create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drx39xxj.h
 create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drx39xxj_dummy.c
 create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drx_dap_fasi.c
 create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drx_dap_fasi.h
 create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drx_driver.c
 create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drx_driver.h
 create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drx_driver_version.h
 create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drxj.c
 create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drxj.h
 create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drxj_map.h
 create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drxj_mc.h
 create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drxj_mc_vsb.h
 create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drxj_mc_vsbqam.h
 create mode 100644 drivers/staging/media/dvb/frontends/drx39xyj/drxj_options.h

-- 
1.7.7.6

