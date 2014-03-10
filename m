Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50439 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbaCJL7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 07:59:52 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 08/15] drx-j: propagate returned error from request_firmware()
Date: Mon, 10 Mar 2014 08:59:00 -0300
Message-Id: <1394452747-5426-9-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
References: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a smatch warning:
	drivers/media/dvb-frontends/drx39xyj/drxj.c:11711 drx_ctrl_u_code() info: why not propagate 'rc' from request_firmware() instead of (-2)?

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index c5205d5c997e..a26ddc9fa2bc 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -11708,7 +11708,7 @@ static int drx_ctrl_u_code(struct drx_demod_instance *demod,
 		rc = request_firmware(&fw, mc_file, demod->i2c->dev.parent);
 		if (rc < 0) {
 			pr_err("Couldn't read firmware %s\n", mc_file);
-			return -ENOENT;
+			return rc;
 		}
 		demod->firmware = fw;
 
-- 
1.8.5.3

