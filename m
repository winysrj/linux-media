Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:46542 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090AbaCPVtj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Mar 2014 17:49:39 -0400
Received: from localhost.localdomain (92-244-23-216.customers.ownit.se [92.244.23.216])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPA id 4A80DEB57B
	for <linux-media@vger.kernel.org>; Sun, 16 Mar 2014 22:41:13 +0100 (CET)
From: Benjamin Larsson <benjamin@southpole.se>
To: linux-media@vger.kernel.org
Subject: [PATCH] r820t: fix size and init values
Date: Sun, 16 Mar 2014 22:41:13 +0100
Message-Id: <1395006073-4361-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Correct the initialization values at the start of the function
and use proper variable sizes to prevent overflow.

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/media/tuners/r820t.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index d9ee43f..ce10c18 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -1468,7 +1468,8 @@ static int r820t_imr_prepare(struct r820t_priv *priv)
 static int r820t_multi_read(struct r820t_priv *priv)
 {
 	int rc, i;
-	u8 data[2], min = 0, max = 255, sum = 0;
+	u16 sum = 0;
+	u8 data[2], min = 255, max = 0;
 
 	usleep_range(5000, 6000);
 
-- 
1.8.3.2

