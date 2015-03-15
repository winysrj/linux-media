Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:56458 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbbCOW6E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 18:58:04 -0400
From: Benjamin Larsson <benjamin@southpole.se>
To: crope@iki.fi, mchehab@osg.samsung.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 02/10] r820t: change read_gain() code to match register layout
Date: Sun, 15 Mar 2015 23:57:47 +0100
Message-Id: <1426460275-3766-2-git-send-email-benjamin@southpole.se>
In-Reply-To: <1426460275-3766-1-git-send-email-benjamin@southpole.se>
References: <1426460275-3766-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/media/tuners/r820t.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 639c220..eaaf1dc 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -1199,7 +1199,7 @@ static int r820t_read_gain(struct r820t_priv *priv)
 	if (rc < 0)
 		return rc;
 
-	return ((data[3] & 0x0f) << 1) + ((data[3] & 0xf0) >> 4);
+	return ((data[3] & 0x08) << 1) + ((data[3] & 0xf0) >> 4);
 }
 
 #if 0
-- 
2.1.0

