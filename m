Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42693 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbcD0IJr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 04:09:47 -0400
Date: Wed, 27 Apr 2016 11:09:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] tw686x: off by one bugs in tw686x_fields_map()
Message-ID: <20160427080928.GC22469@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The > ARRAY_SIZE() should be >= ARRAY_SIZE().  Also this is a slightly
unrelated cleanup but I replaced the magic numbers 30 and 25 with
ARRAY_SIZE() - 1.

Fixes: 363d79f1d5bd ('[media] tw686x: Don't go past array')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index d2a0147..7b87f27 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -64,12 +64,12 @@ static unsigned int tw686x_fields_map(v4l2_std_id std, unsigned int fps)
 	unsigned int i;
 
 	if (std & V4L2_STD_525_60) {
-		if (fps > ARRAY_SIZE(std_525_60))
-			fps = 30;
+		if (fps >= ARRAY_SIZE(std_525_60))
+			fps = ARRAY_SIZE(std_525_60) - 1;
 		i = std_525_60[fps];
 	} else {
-		if (fps > ARRAY_SIZE(std_625_50))
-			fps = 25;
+		if (fps >= ARRAY_SIZE(std_625_50))
+			fps = ARRAY_SIZE(std_625_50) - 1;
 		i = std_625_50[fps];
 	}
 
