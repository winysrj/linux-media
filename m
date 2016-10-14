Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59140 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757035AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 46/57] [media] ttusb-budget: don't break long lines
Date: Fri, 14 Oct 2016 17:20:34 -0300
Message-Id: <8e5cf69c4241fbe313df35e9f735c6f7b624f972.1476475771.git.mchehab@s-opensource.com>
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
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
index d52d4a8d39ad..361e40b56045 100644
--- a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
@@ -767,8 +767,7 @@ static void ttusb_iso_irq(struct urb *urb)
 		for (i = 0; i < urb->number_of_packets; ++i) {
 			numpkt++;
 			if (time_after_eq(jiffies, lastj + HZ)) {
-				dprintk("frames/s: %lu (ts: %d, stuff %d, "
-					"sec: %d, invalid: %d, all: %d)\n",
+				dprintk("frames/s: %lu (ts: %d, stuff %d, sec: %d, invalid: %d, all: %d)\n",
 					numpkt * HZ / (jiffies - lastj),
 					numts, numstuff, numsec, numinvalid,
 					numts + numstuff + numsec + numinvalid);
-- 
2.7.4


