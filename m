Return-path: <linux-media-owner@vger.kernel.org>
Received: from ip78-183-211-87.adsl2.static.versatel.nl ([87.211.183.78]:40759
	"EHLO god.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbZIVVFO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 17:05:14 -0400
Date: Tue, 22 Sep 2009 23:05:00 +0200
From: spam@systol-ng.god.lan
To: linux-media@vger.kernel.org
Cc: mkrufky@gmail.com
Subject: [PATCH 1/4] tda18271_set_analog_params major bugfix
Message-ID: <20090922210500.GA8661@systol-ng.god.lan>
Reply-To: Henk.Vergonet@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Multiplication by 62500 causes an overflow in the 32 bits "freq" register when
using radio. FM radio reception on a Zolid Hybrid PCI is now working. Other
tda18271 configurations may also benefit from this change ;)

Signed-off-by: Henk.Vergonet@gmail.com

diff -r 29e4ba1a09bc linux/drivers/media/common/tuners/tda18271-fe.c
--- a/linux/drivers/media/common/tuners/tda18271-fe.c	Sat Sep 19 09:45:22 2009 -0300
+++ b/linux/drivers/media/common/tuners/tda18271-fe.c	Tue Sep 22 22:06:31 2009 +0200
@@ -1001,38 +1020,43 @@
 	struct tda18271_std_map_item *map;
 	char *mode;
 	int ret;
-	u32 freq = params->frequency * 62500;
+	u32 freq;
 
 	priv->mode = TDA18271_ANALOG;
 
 	if (params->mode == V4L2_TUNER_RADIO) {
-		freq = freq / 1000;
+		freq = params->frequency * 625;
+		freq = freq / 10;
 		map = &std_map->fm_radio;
 		mode = "fm";
-	} else if (params->std & V4L2_STD_MN) {
-		map = &std_map->atv_mn;
-		mode = "MN";
-	} else if (params->std & V4L2_STD_B) {
-		map = &std_map->atv_b;
-		mode = "B";
-	} else if (params->std & V4L2_STD_GH) {
-		map = &std_map->atv_gh;
-		mode = "GH";
-	} else if (params->std & V4L2_STD_PAL_I) {
-		map = &std_map->atv_i;
-		mode = "I";
-	} else if (params->std & V4L2_STD_DK) {
-		map = &std_map->atv_dk;
-		mode = "DK";
-	} else if (params->std & V4L2_STD_SECAM_L) {
-		map = &std_map->atv_l;
-		mode = "L";
-	} else if (params->std & V4L2_STD_SECAM_LC) {
-		map = &std_map->atv_lc;
-		mode = "L'";
 	} else {
-		map = &std_map->atv_i;
-		mode = "xx";
+		freq = params->frequency * 62500;
+	
+		if (params->std & V4L2_STD_MN) {
+			map = &std_map->atv_mn;
+			mode = "MN";
+		} else if (params->std & V4L2_STD_B) {
+			map = &std_map->atv_b;
+			mode = "B";
+		} else if (params->std & V4L2_STD_GH) {
+			map = &std_map->atv_gh;
+			mode = "GH";
+		} else if (params->std & V4L2_STD_PAL_I) {
+			map = &std_map->atv_i;
+			mode = "I";
+		} else if (params->std & V4L2_STD_DK) {
+			map = &std_map->atv_dk;
+			mode = "DK";
+		} else if (params->std & V4L2_STD_SECAM_L) {
+			map = &std_map->atv_l;
+			mode = "L";
+		} else if (params->std & V4L2_STD_SECAM_LC) {
+			map = &std_map->atv_lc;
+			mode = "L'";
+		} else {
+			map = &std_map->atv_i;
+			mode = "xx";
+		}
 	}
 
 	tda_dbg("setting tda18271 to system %s\n", mode);
