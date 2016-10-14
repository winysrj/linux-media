Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59118 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757008AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 55/57] [media] radio: don't break long lines
Date: Fri, 14 Oct 2016 17:20:43 -0300
Message-Id: <154660be380825a1a62cd3f368e49d0ce5b5589a.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/radio/radio-gemtek.c | 8 ++------
 drivers/media/radio/radio-wl1273.c | 3 +--
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/radio/radio-gemtek.c b/drivers/media/radio/radio-gemtek.c
index cff1eb144a5c..ca051ccbc3e4 100644
--- a/drivers/media/radio/radio-gemtek.c
+++ b/drivers/media/radio/radio-gemtek.c
@@ -67,14 +67,10 @@ module_param(probe, bool, 0444);
 MODULE_PARM_DESC(probe, "Enable automatic device probing.");
 
 module_param(hardmute, bool, 0644);
-MODULE_PARM_DESC(hardmute, "Enable 'hard muting' by shutting down PLL, may "
-	 "reduce static noise.");
+MODULE_PARM_DESC(hardmute, "Enable 'hard muting' by shutting down PLL, may reduce static noise.");
 
 module_param_array(io, int, NULL, 0444);
-MODULE_PARM_DESC(io, "Force I/O ports for the GemTek Radio card if automatic "
-	 "probing is disabled or fails. The most common I/O ports are: 0x20c "
-	 "0x30c, 0x24c or 0x34c (0x20c, 0x248 and 0x28c have been reported to "
-	 "work for the combined sound/radiocard).");
+MODULE_PARM_DESC(io, "Force I/O ports for the GemTek Radio card if automatic probing is disabled or fails. The most common I/O ports are: 0x20c 0x30c, 0x24c or 0x34c (0x20c, 0x248 and 0x28c have been reported to work for the combined sound/radiocard).");
 
 module_param_array(radio_nr, int, NULL, 0444);
 MODULE_PARM_DESC(radio_nr, "Radio device numbers");
diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index a93f681aa9d6..9ce4b12299b4 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -2068,8 +2068,7 @@ static int wl1273_fm_radio_probe(struct platform_device *pdev)
 			goto err_request_irq;
 		}
 	} else {
-		dev_err(radio->dev, WL1273_FM_DRIVER_NAME ": Core WL1273 IRQ"
-			" not configured");
+		dev_err(radio->dev, WL1273_FM_DRIVER_NAME ": Core WL1273 IRQ not configured");
 		r = -EINVAL;
 		goto pdata_err;
 	}
-- 
2.7.4


