Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:54377 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161146AbbKSUFD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 15:05:03 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi, xpert-reactos@gmx.de,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 07/10] si2165: Fix DVB-T bandwidth default
Date: Thu, 19 Nov 2015 21:03:59 +0100
Message-Id: <1447963442-9764-8-git-send-email-zzam@gentoo.org>
In-Reply-To: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
References: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 807a3c9..e97b0e6 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -811,19 +811,18 @@ static int si2165_set_frontend(struct dvb_frontend *fe)
 	u8 val[3];
 	u32 dvb_rate = 0;
 	u16 bw10k;
+	u32 bw_hz = p->bandwidth_hz;
 
 	dprintk("%s: called\n", __func__);
 
 	if (!state->has_dvbt)
 		return -EINVAL;
 
-	if (p->bandwidth_hz > 0) {
-		dvb_rate = p->bandwidth_hz * 8 / 7;
-		bw10k = p->bandwidth_hz / 10000;
-	} else {
-		dvb_rate = 8 * 8 / 7;
-		bw10k = 800;
-	}
+	if (bw_hz == 0)
+		bw_hz = 8000000;
+
+	dvb_rate = bw_hz * 8 / 7;
+	bw10k = bw_hz / 10000;
 
 	/* standard = DVB-T */
 	ret = si2165_writereg8(state, 0x00ec, 0x01);
-- 
2.6.3

