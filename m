Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59122 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757011AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 52/57] [media] common: don't break long lines
Date: Fri, 14 Oct 2016 17:20:40 -0300
Message-Id: <fb42d176922bd896fe415fb6cc9dbaca88c6eeb1.1476475771.git.mchehab@s-opensource.com>
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
 drivers/media/common/tveeprom.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/common/tveeprom.c b/drivers/media/common/tveeprom.c
index 47da0378cad8..e0e2cb706087 100644
--- a/drivers/media/common/tveeprom.c
+++ b/drivers/media/common/tveeprom.c
@@ -510,8 +510,7 @@ void tveeprom_hauppauge_analog(struct i2c_client *c, struct tveeprom *tvee,
 			len = eeprom_data[i] & 0x07;
 			++i;
 		} else {
-			tveeprom_warn("Encountered bad packet header [%02x]. "
-				"Corrupt or not a Hauppauge eeprom.\n",
+			tveeprom_warn("Encountered bad packet header [%02x]. Corrupt or not a Hauppauge eeprom.\n",
 				eeprom_data[i]);
 			return;
 		}
-- 
2.7.4


