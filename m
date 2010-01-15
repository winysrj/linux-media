Return-path: <linux-media-owner@vger.kernel.org>
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:59433 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757429Ab0AOMPc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 07:15:32 -0500
Date: Fri, 15 Jan 2010 13:08:57 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Cc: siccegge@stud.informatik.uni-erlangen.de,
	Reinhard.Tartler@informatik.uni-erlangen.de
Subject: [PATCH] obsolete config in kernel source (DVB_DIBCOM_DEBUG)
Message-ID: <20100115120857.GA3321@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	By this we discovered the config Option DVB_DIBCOM_DEBUG,
which was dropped while removing the dibusb driver in favor of dvb-usb
in 2005. However it remaind existant at some places of the kernel
config.

	Probably one should be a bit more agressive here as the dprintk
macro now expands to a do{}while(0) unconditionally so all blocks
using them can also be dropped to remove in-tree cruft but the patch
does a first cleanup.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

--M9NhX3UHpAaciwkO
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0004-remove-obsolete-conditionalizing-on-DVB_DIBCOM_DEBUG.patch"

>From 34bc227926b5554a881799fe69ce5323e2042352 Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Fri, 15 Jan 2010 12:49:41 +0100
Subject: [PATCH 4/4] remove obsolete conditionalizing on DVB_DIBCOM_DEBUG

The dibusb driver was dropped in 2005 in favour of the generic dvb-usb
system. However the DEBUG option wasn't removed from all parts of the
code which is fixed by this patch

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
---
 drivers/media/dvb/frontends/dib3000mb.c      |   11 -----------
 drivers/media/dvb/frontends/dib3000mb_priv.h |    5 -----
 2 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/media/dvb/frontends/dib3000mb.c b/drivers/media/dvb/frontends/dib3000mb.c
index ad4c8cf..5fdb6de 100644
--- a/drivers/media/dvb/frontends/dib3000mb.c
+++ b/drivers/media/dvb/frontends/dib3000mb.c
@@ -38,11 +38,6 @@
 #define DRIVER_DESC "DiBcom 3000M-B DVB-T demodulator"
 #define DRIVER_AUTHOR "Patrick Boettcher, patrick.boettcher@desy.de"
 
-#ifdef CONFIG_DVB_DIBCOM_DEBUG
-static int debug;
-module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug, "set debugging level (1=info,2=xfer,4=setfe,8=getfe (|-able)).");
-#endif
 #define deb_info(args...) dprintk(0x01,args)
 #define deb_i2c(args...)  dprintk(0x02,args)
 #define deb_srch(args...) dprintk(0x04,args)
@@ -51,12 +46,6 @@ MODULE_PARM_DESC(debug, "set debugging level (1=info,2=xfer,4=setfe,8=getfe (|-a
 #define deb_setf(args...) dprintk(0x04,args)
 #define deb_getf(args...) dprintk(0x08,args)
 
-#ifdef CONFIG_DVB_DIBCOM_DEBUG
-static int debug;
-module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug, "set debugging level (1=info,2=i2c,4=srch (|-able)).");
-#endif
-
 static int dib3000_read_reg(struct dib3000_state *state, u16 reg)
 {
 	u8 wb[] = { ((reg >> 8) | 0x80) & 0xff, reg & 0xff };
diff --git a/drivers/media/dvb/frontends/dib3000mb_priv.h b/drivers/media/dvb/frontends/dib3000mb_priv.h
index 1a12747..806f5b0 100644
--- a/drivers/media/dvb/frontends/dib3000mb_priv.h
+++ b/drivers/media/dvb/frontends/dib3000mb_priv.h
@@ -37,12 +37,7 @@
 
 /* debug */
 
-#ifdef CONFIG_DVB_DIBCOM_DEBUG
-#define dprintk(level,args...) \
-    do { if ((debug & level)) { printk(args); } } while (0)
-#else
 #define dprintk(args...) do { } while (0)
-#endif
 
 /* mask for enabling a specific pid for the pid_filter */
 #define DIB3000_ACTIVATE_PID_FILTERING	(0x2000)
-- 
1.6.3.3


--M9NhX3UHpAaciwkO--
