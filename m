Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48643 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754945AbcJNRrG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:06 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 19/25] [media] imon: use %*ph to do small hexa dumps
Date: Fri, 14 Oct 2016 14:45:57 -0300
Message-Id: <d101010f63f0296d5cdebed32da5339aabd6afae.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit 563873318d32 ("Merge branch 'printk-cleanups"),
continuation lines require KERN_CONT. Instead, let's just
use %*ph to print the buffer.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/rc/imon.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 86cc70fe2534..d62b1f38292c 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1593,7 +1593,6 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	struct device *dev = ictx->dev;
 	unsigned long flags;
 	u32 kc;
-	int i;
 	u64 scancode;
 	int press_type = 0;
 	int msec;
@@ -1664,10 +1663,8 @@ static void imon_incoming_packet(struct imon_context *ictx,
 	}
 
 	if (debug) {
-		printk(KERN_INFO "intf%d decoded packet: ", intf);
-		for (i = 0; i < len; ++i)
-			printk("%02x ", buf[i]);
-		printk("\n");
+		printk(KERN_INFO "intf%d decoded packet: %*ph\n",
+		       intf, len, buf);
 	}
 
 	press_type = imon_parse_press_type(ictx, buf, ktype);
-- 
2.7.4


