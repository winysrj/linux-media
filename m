Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:54347 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934033AbbKSUEw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 15:04:52 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi, xpert-reactos@gmx.de,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 02/10] si2165: rename si2165_set_parameters to si2165_set_frontend
Date: Thu, 19 Nov 2015 21:03:54 +0100
Message-Id: <1447963442-9764-3-git-send-email-zzam@gentoo.org>
In-Reply-To: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
References: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index d36b36c..a0e4600 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -767,7 +767,7 @@ static int si2165_set_if_freq_shift(struct si2165_state *state, u32 IF)
 	return si2165_writereg32(state, 0x00e8, reg_value);
 }
 
-static int si2165_set_parameters(struct dvb_frontend *fe)
+static int si2165_set_frontend(struct dvb_frontend *fe)
 {
 	int ret;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
@@ -952,7 +952,7 @@ static struct dvb_frontend_ops si2165_ops = {
 	.init = si2165_init,
 	.sleep = si2165_sleep,
 
-	.set_frontend      = si2165_set_parameters,
+	.set_frontend      = si2165_set_frontend,
 	.read_status       = si2165_read_status,
 
 	.release = si2165_release,
-- 
2.6.3

