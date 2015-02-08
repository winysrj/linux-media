Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:58934 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbbBHUzk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Feb 2015 15:55:40 -0500
From: luisbg <luis@debethencourt.com>
Date: Sun, 8 Feb 2015 20:55:36 +0000
To: linux-media@vger.kernel.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	mchehab@osg.samsung.com, gregkh@linuxfoundation.org
Subject: [PATCH] media: cxd2099: move pre-init values out of init()
Message-ID: <20150208205536.GA31543@turing>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Improve code readability by moving out all pre-init values from the init
function.

Signed-off-by: Luis de Bethencourt <luis.bg@samsung.com>
---
 drivers/staging/media/cxd2099/cxd2099.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
index 657ea48..bafe36f 100644
--- a/drivers/staging/media/cxd2099/cxd2099.c
+++ b/drivers/staging/media/cxd2099/cxd2099.c
@@ -300,7 +300,6 @@ static int init(struct cxd *ci)
 	int status;
 
 	mutex_lock(&ci->lock);
-	ci->mode = -1;
 	do {
 		status = write_reg(ci, 0x00, 0x00);
 		if (status < 0)
@@ -420,7 +419,6 @@ static int init(struct cxd *ci)
 		status = write_regm(ci, 0x09, 0x08, 0x08);
 		if (status < 0)
 			break;
-		ci->cammode = -1;
 		cam_mode(ci, 0);
 	} while (0);
 	mutex_unlock(&ci->lock);
@@ -711,6 +709,8 @@ struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
 
 	ci->en = en_templ;
 	ci->en.data = ci;
+	ci->mode = -1;
+	ci->cammode = -1;
 	init(ci);
 	dev_info(&i2c->dev, "Attached CXD2099AR at %02x\n", ci->cfg.adr);
 	return &ci->en;
-- 
2.1.0

