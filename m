Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50446 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaCJL7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 07:59:52 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 07/15] drx-j: Fix usage of drxj_close()
Date: Mon, 10 Mar 2014 08:58:59 -0300
Message-Id: <1394452747-5426-8-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
References: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function is currently not used. However, it was meant to
be called at device release. So, add it there.

While here, remove the bad check, as reported by Dan, as
smatch warning:
	drivers/media/dvb-frontends/drx39xyj/drxj.c:20041 drxj_close() warn: variable dereferenced before check 'demod' (see line 20036)

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 828d0527f38d..c5205d5c997e 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -11510,8 +11510,7 @@ static int drxj_close(struct drx_demod_instance *demod)
 	int rc;
 	enum drx_power_mode power_mode = DRX_POWER_UP;
 
-	if ((demod == NULL) ||
-	    (demod->my_common_attr == NULL) ||
+	if ((demod->my_common_attr == NULL) ||
 	    (demod->my_ext_attr == NULL) ||
 	    (demod->my_i2c_dev_addr == NULL) ||
 	    (!demod->my_common_attr->is_opened)) {
@@ -12218,6 +12217,8 @@ static void drx39xxj_release(struct dvb_frontend *fe)
 	struct drx39xxj_state *state = fe->demodulator_priv;
 	struct drx_demod_instance *demod = state->demod;
 
+	drxj_close(demod);
+
 	kfree(demod->my_ext_attr);
 	kfree(demod->my_common_attr);
 	kfree(demod->my_i2c_dev_addr);
-- 
1.8.5.3

