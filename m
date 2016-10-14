Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48631 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754919AbcJNRrG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:06 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 21/25] [media] tvaudio: mark printk continuation lines as such
Date: Fri, 14 Oct 2016 14:45:59 -0300
Message-Id: <021117151e8e22c249b32db2654954f97c47a395.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver has printk continuation lines for
debugging purposes. Since commit 563873318d32
("Merge branch 'printk-cleanups'"), this won't work as expected
anymore. So, let's add KERN_CONT to those lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/tvaudio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tvaudio.c b/drivers/media/i2c/tvaudio.c
index 42d1e26e581c..ce86534450ac 100644
--- a/drivers/media/i2c/tvaudio.c
+++ b/drivers/media/i2c/tvaudio.c
@@ -1894,8 +1894,9 @@ static int tvaudio_probe(struct i2c_client *client, const struct i2c_device_id *
 		printk(KERN_INFO "tvaudio: TV audio decoder + audio/video mux driver\n");
 		printk(KERN_INFO "tvaudio: known chips: ");
 		for (desc = chiplist; desc->name != NULL; desc++)
-			printk("%s%s", (desc == chiplist) ? "" : ", ", desc->name);
-		printk("\n");
+			printk(KERN_CONT "%s%s",
+			       (desc == chiplist) ? "" : ", ", desc->name);
+		printk(KERN_CONT "\n");
 	}
 
 	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
-- 
2.7.4


