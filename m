Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:55195 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932909AbeAOJ61 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 04:58:27 -0500
From: Sean Young <sean@mess.org>
To: Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 1/5] auxdisplay: charlcd: no need to call charlcd_gotoxy() if nothing changes
Date: Mon, 15 Jan 2018 09:58:20 +0000
Message-Id: <0cb9a05c09295bcad4dd914ee44806ac6c244cbd.1516008708.git.sean@mess.org>
In-Reply-To: <cover.1516008708.git.sean@mess.org>
References: <cover.1516008708.git.sean@mess.org>
In-Reply-To: <cover.1516008708.git.sean@mess.org>
References: <cover.1516008708.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the line extends beyond the width to the screen, nothing changes. The
existing code will call charlcd_gotoxy every time for this case.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/auxdisplay/charlcd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/auxdisplay/charlcd.c b/drivers/auxdisplay/charlcd.c
index 642afd88870b..45ec5ce697c4 100644
--- a/drivers/auxdisplay/charlcd.c
+++ b/drivers/auxdisplay/charlcd.c
@@ -192,10 +192,11 @@ static void charlcd_print(struct charlcd *lcd, char c)
 			c = lcd->char_conv[(unsigned char)c];
 		lcd->ops->write_data(lcd, c);
 		priv->addr.x++;
+
+		/* prevents the cursor from wrapping onto the next line */
+		if (priv->addr.x == lcd->bwidth)
+			charlcd_gotoxy(lcd);
 	}
-	/* prevents the cursor from wrapping onto the next line */
-	if (priv->addr.x == lcd->bwidth)
-		charlcd_gotoxy(lcd);
 }
 
 static void charlcd_clear_fast(struct charlcd *lcd)
-- 
2.14.3
