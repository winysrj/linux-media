Return-path: <linux-media-owner@vger.kernel.org>
Received: from ip78-183-211-87.adsl2.static.versatel.nl ([87.211.183.78]:40760
	"EHLO god.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbZIVVGc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 17:06:32 -0400
Date: Tue, 22 Sep 2009 23:06:35 +0200
From: spam@systol-ng.god.lan
To: linux-media@vger.kernel.org
Cc: mkrufky@gmail.com
Subject: [PATCH 2/4] 18271_calc_main_pll small bugfix
Message-ID: <20090922210635.GB8661@systol-ng.god.lan>
Reply-To: Henk.Vergonet@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Removed code fragment that is not part of the (C2) specs. Possibly an early
remnant of an attempted if_notch filter configuration. It is already
handled correctly in the tda18271_set_if_notch function.

Signed-off-by: Henk.Vergonet@gmail.com

diff -r 29e4ba1a09bc linux/drivers/media/common/tuners/tda18271-common.c
--- a/linux/drivers/media/common/tuners/tda18271-common.c	Sat Sep 19 09:45:22 2009 -0300
+++ b/linux/drivers/media/common/tuners/tda18271-common.c	Tue Sep 22 22:06:31 2009 +0200
@@ -582,15 +582,6 @@
 
 	regs[R_MPD]   = (0x77 & pd);
 
-	switch (priv->mode) {
-	case TDA18271_ANALOG:
-		regs[R_MPD]  &= ~0x08;
-		break;
-	case TDA18271_DIGITAL:
-		regs[R_MPD]  |=  0x08;
-		break;
-	}
-
 	div =  ((d * (freq / 1000)) << 7) / 125;
 
 	regs[R_MD1]   = 0x7f & (div >> 16);
