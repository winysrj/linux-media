Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42954 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab3EFPpR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 May 2013 11:45:17 -0400
Received: by mail-ee0-f46.google.com with SMTP id b57so1805955eek.5
        for <linux-media@vger.kernel.org>; Mon, 06 May 2013 08:45:16 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 3/3] r820t: avoid potential memcpy buffer overflow in shadow_store()
Date: Mon,  6 May 2013 17:44:37 +0200
Message-Id: <1367855077-6134-4-git-send-email-gennarone@gmail.com>
In-Reply-To: <1367855077-6134-1-git-send-email-gennarone@gmail.com>
References: <1367855077-6134-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The memcpy in shadow_store() could exceed buffer limits when r > 0. 

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/tuners/r820t.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index d8fd16a..2d6d498 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -364,8 +364,8 @@ static void shadow_store(struct r820t_priv *priv, u8 reg, const u8 *val,
 	}
 	if (len <= 0)
 		return;
-	if (len > NUM_REGS)
-		len = NUM_REGS;
+	if (len > NUM_REGS - r)
+		len = NUM_REGS - r;
 
 	tuner_dbg("%s: prev  reg=%02x len=%d: %*ph\n",
 		  __func__, r + REG_SHADOW_START, len, len, val);
-- 
1.8.2.2

