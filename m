Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway31.websitewelcome.com ([192.185.143.5]:22447 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750812AbdFVEWv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Jun 2017 00:22:51 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id AF4672D0F6
        for <linux-media@vger.kernel.org>; Wed, 21 Jun 2017 23:22:48 -0500 (CDT)
Date: Wed, 21 Jun 2017 23:22:47 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Malcolm Priestley <tvboxspy@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] dvb-usb-v2: lmedm04: remove unnecessary variable in
 lme2510_stream_restart()
Message-ID: <20170622042247.GA11444@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unnecessary variable _ret_ and refactor the code.

Addresses-Coverity-ID: 1226934
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 594360a..a91fdad 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -207,15 +207,13 @@ static int lme2510_stream_restart(struct dvb_usb_device *d)
 	struct lme2510_state *st = d->priv;
 	u8 all_pids[] = LME_ALL_PIDS;
 	u8 stream_on[] = LME_ST_ON_W;
-	int ret;
 	u8 rbuff[1];
 	if (st->pid_off)
-		ret = lme2510_usb_talk(d, all_pids, sizeof(all_pids),
-			rbuff, sizeof(rbuff));
+		lme2510_usb_talk(d, all_pids, sizeof(all_pids),
+				 rbuff, sizeof(rbuff));
 	/*Restart Stream Command*/
-	ret = lme2510_usb_talk(d, stream_on, sizeof(stream_on),
-			rbuff, sizeof(rbuff));
-	return ret;
+	return lme2510_usb_talk(d, stream_on, sizeof(stream_on),
+				rbuff, sizeof(rbuff));
 }
 
 static int lme2510_enable_pid(struct dvb_usb_device *d, u8 index, u16 pid_out)
-- 
2.5.0
