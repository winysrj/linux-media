Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:47580 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755883Ab1GOTwF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 15:52:05 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-media@vger.kernel.org
Subject: [Patch] media_build: Include Kconfig of cxd2099 driver
Date: Fri, 15 Jul 2011 21:51:04 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107152151.05852@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Include cxd2099/Kconfig from Kconfig.staging,
so cxd2099 can be selected in menuconfig etc.

Signed-off-by: Oliver Endriss <o.endriss@gmx.de>

diff -r 61f1ae80149b v4l/Kconfig.staging
--- a/v4l/Kconfig.staging	Wed Jul 13 05:24:01 2011 +0200
+++ b/v4l/Kconfig.staging	Fri Jul 15 21:42:18 2011 +0200
@@ -36,6 +36,7 @@
 source "../linux/drivers/staging/tm6000/Kconfig"
 source "../linux/drivers/staging/lirc/Kconfig"
 source "../linux/drivers/staging/altera-stapl/Kconfig"
+source "../linux/drivers/staging/cxd2099/Kconfig"
 # Currently, there are no broken staging drivers with Kernel 2.6.31
 # if STAGING_BROKEN
 # endif

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
