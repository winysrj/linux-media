Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab2J0UmH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:07 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 56/68] [media] tua9001: fix a warning
Date: Sat, 27 Oct 2012 18:41:14 -0200
Message-Id: <1351370486-29040-57-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/tuners/tua9001.c:211:5: warning: 'ret' may be used uninitialized in this function [-Wmaybe-uninitialized]

Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/tua9001.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/tuners/tua9001.c b/drivers/media/tuners/tua9001.c
index 3896684..83a6240 100644
--- a/drivers/media/tuners/tua9001.c
+++ b/drivers/media/tuners/tua9001.c
@@ -136,7 +136,7 @@ static int tua9001_set_params(struct dvb_frontend *fe)
 {
 	struct tua9001_priv *priv = fe->tuner_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret, i;
+	int ret = 0, i;
 	u16 val;
 	u32 frequency;
 	struct reg_val data[2];
-- 
1.7.11.7

