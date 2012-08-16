Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52904 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab2HPA3P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 20:29:15 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/5] dvb_frontend: return -ENOTTY for unimplement IOCTL
Date: Thu, 16 Aug 2012 03:28:38 +0300
Message-Id: <1345076921-9773-3-git-send-email-crope@iki.fi>
In-Reply-To: <1345076921-9773-1-git-send-email-crope@iki.fi>
References: <1345076921-9773-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Earlier it was returning -EOPNOTSUPP.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-core/dvb_frontend.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 609e691..2bc80b1 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1816,7 +1816,7 @@ static int dvb_frontend_ioctl(struct file *file,
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	int err = -EOPNOTSUPP;
+	int err = -ENOTTY;
 
 	dev_dbg(fe->dvb->device, "%s: (%d)\n", __func__, _IOC_NR(cmd));
 	if (fepriv->exit != DVB_FE_NO_EXIT)
@@ -1934,7 +1934,7 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 		}
 
 	} else
-		err = -EOPNOTSUPP;
+		err = -ENOTTY;
 
 out:
 	kfree(tvp);
@@ -2067,7 +2067,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int err = -EOPNOTSUPP;
+	int err = -ENOTTY;
 
 	switch (cmd) {
 	case FE_GET_INFO: {
-- 
1.7.11.2

