Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499Ab3CCP64 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Mar 2013 10:58:56 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r23Fwuon014119
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 3 Mar 2013 10:58:56 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 01/11] [media] mb86a20s: don't pollute dmesg with debug messages
Date: Sun,  3 Mar 2013 12:58:41 -0300
Message-Id: <1362326331-17541-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1362326331-17541-1-git-send-email-mchehab@redhat.com>
References: <1362326331-17541-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a few debug tests that are shown with dev_err() or
dev_info(). Replace them by dev_dbg().

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index f19cd73..44bfb88 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -1095,7 +1095,7 @@ static int mb86a20s_get_blk_error(struct dvb_frontend *fe,
 	if (rc < 0)
 		return rc;
 	*error |= rc;
-	dev_err(&state->i2c->dev, "%s: block error for layer %c: %d.\n",
+	dev_dbg(&state->i2c->dev, "%s: block error for layer %c: %d.\n",
 		__func__, 'A' + layer, *error);
 
 	/* Read Bit Count */
@@ -1386,7 +1386,7 @@ static int mb86a20s_get_main_CNR(struct dvb_frontend *fe)
 		return rc;
 
 	if (!(rc & 0x40)) {
-		dev_info(&state->i2c->dev, "%s: CNR is not available yet.\n",
+		dev_dbg(&state->i2c->dev, "%s: CNR is not available yet.\n",
 			 __func__);
 		return -EBUSY;
 	}
@@ -1441,7 +1441,7 @@ static int mb86a20s_get_blk_error_layer_CNR(struct dvb_frontend *fe)
 
 	/* Check if data is available */
 	if (!(rc & 0x01)) {
-		dev_info(&state->i2c->dev,
+		dev_dbg(&state->i2c->dev,
 			"%s: MER measures aren't available yet.\n", __func__);
 		return -EBUSY;
 	}
-- 
1.8.1.4

