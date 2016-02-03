Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51513 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbcBCTuN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2016 14:50:13 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] [media] dvb_frontend: print DTV property dump also for SET_PROPERTY
Date: Wed,  3 Feb 2016 17:48:56 -0200
Message-Id: <1f4b7b810391d19c5643af01fd5a39ca6b193768.1454528618.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When debugging troubles with DTV properties get/set, it is
important to be able to see not only the properties from get, but
also the ones from set. So, improve the dumps to allow reporting
both.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index c38ef1a72b4a..881825f5febf 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1165,18 +1165,24 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
 	_DTV_CMD(DTV_STAT_TOTAL_BLOCK_COUNT, 0, 0),
 };
 
-static void dtv_property_dump(struct dvb_frontend *fe, struct dtv_property *tvp)
+static void dtv_property_dump(struct dvb_frontend *fe,
+			      bool is_set,
+			      struct dtv_property *tvp)
 {
 	int i;
 
 	if (tvp->cmd <= 0 || tvp->cmd > DTV_MAX_COMMAND) {
-		dev_warn(fe->dvb->device, "%s: tvp.cmd = 0x%08x undefined\n",
-				__func__, tvp->cmd);
+		dev_warn(fe->dvb->device, "%s: %s tvp.cmd = 0x%08x undefined\n",
+				__func__,
+				is_set ? "SET" : "GET",
+				tvp->cmd);
 		return;
 	}
 
-	dev_dbg(fe->dvb->device, "%s: tvp.cmd    = 0x%08x (%s)\n", __func__,
-			tvp->cmd, dtv_cmds[tvp->cmd].name);
+	dev_dbg(fe->dvb->device, "%s: %s tvp.cmd    = 0x%08x (%s)\n", __func__,
+		is_set ? "SET" : "GET",
+		tvp->cmd,
+		dtv_cmds[tvp->cmd].name);
 
 	if (dtv_cmds[tvp->cmd].buffer) {
 		dev_dbg(fe->dvb->device, "%s: tvp.u.buffer.len = 0x%02x\n",
@@ -1592,7 +1598,7 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 			return r;
 	}
 
-	dtv_property_dump(fe, tvp);
+	dtv_property_dump(fe, false, tvp);
 
 	return 0;
 }
@@ -1833,6 +1839,8 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 			return r;
 	}
 
+	dtv_property_dump(fe, true, tvp);
+
 	switch(tvp->cmd) {
 	case DTV_CLEAR:
 		/*
-- 
2.5.0


