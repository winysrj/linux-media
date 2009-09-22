Return-path: <linux-media-owner@vger.kernel.org>
Received: from ip78-183-211-87.adsl2.static.versatel.nl ([87.211.183.78]:40762
	"EHLO god.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbZIVVHo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 17:07:44 -0400
Date: Tue, 22 Sep 2009 23:07:48 +0200
From: spam@systol-ng.god.lan
To: linux-media@vger.kernel.org
Cc: mkrufky@gmail.com
Subject: [PATCH 3/4] tda8290 enable deemphasis_50 module parameter.
Message-ID: <20090922210748.GC8661@systol-ng.god.lan>
Reply-To: Henk.Vergonet@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This adds a forgotten module_param macro needed to set a deemphasis of 50us.
It is the standard setting for commercial FM radio broadcasts outside the US.

Signed-off-by: Henk.Vergonet@gmail.com

diff -r 29e4ba1a09bc linux/drivers/media/common/tuners/tda8290.c
--- a/linux/drivers/media/common/tuners/tda8290.c	Sat Sep 19 09:45:22 2009 -0300
+++ b/linux/drivers/media/common/tuners/tda8290.c	Tue Sep 22 22:06:31 2009 +0200
@@ -34,6 +34,7 @@
 MODULE_PARM_DESC(debug, "enable verbose debug messages");
 
 static int deemphasis_50;
+module_param(deemphasis_50, int, 0644);
 MODULE_PARM_DESC(deemphasis_50, "0 - 75us deemphasis; 1 - 50us deemphasis");
 
 /* ---------------------------------------------------------------------- */
