Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36345 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaG1SH2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jul 2014 14:07:28 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/4] ir-rc5-decoder: print the failed count
Date: Mon, 28 Jul 2014 15:07:22 -0300
Message-Id: <1406570842-26316-5-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1406570842-26316-1-git-send-email-m.chehab@samsung.com>
References: <1406570842-26316-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the decode fails, print on what bit this happened. This helps
to discover what's going wrong when fixing an IR decoding bug.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/rc/ir-rc5-decoder.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 93168daf82eb..2ef763928ca4 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -178,8 +178,8 @@ again:
 	}
 
 out:
-	IR_dprintk(1, "RC5(x/sz) decode failed at state %i (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	IR_dprintk(1, "RC5(x/sz) decode failed at state %i count %d (%uus %s)\n",
+		   data->state, data->count, TO_US(ev.duration), TO_STR(ev.pulse));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 }
-- 
1.9.3

