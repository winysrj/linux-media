Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out26.alice.it ([85.33.2.26]:2882 "EHLO
	smtp-out26.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbZBQKXp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 05:23:45 -0500
Date: Tue, 17 Feb 2009 11:23:39 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH] mt9m111: Call icl->reset() on mt9m111_reset().
Message-Id: <20090217112339.f959035b.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Call icl->reset() on mt9m111_reset().

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index c043f62..92dd7f3 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -393,6 +393,8 @@ static int mt9m111_disable(struct soc_camera_device *icd)
 
 static int mt9m111_reset(struct soc_camera_device *icd)
 {
+	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct soc_camera_link *icl = mt9m111->client->dev.platform_data;
 	int ret;
 
 	ret = reg_set(RESET, MT9M111_RESET_RESET_MODE);
@@ -401,6 +403,10 @@ static int mt9m111_reset(struct soc_camera_device *icd)
 	if (!ret)
 		ret = reg_clear(RESET, MT9M111_RESET_RESET_MODE
 				| MT9M111_RESET_RESET_SOC);
+
+	if (icl->reset)
+		icl->reset(&mt9m111->client->dev);
+
 	return ret;
 }
 
