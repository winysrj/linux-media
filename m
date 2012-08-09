Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41303 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759992Ab2HIWZl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Aug 2012 18:25:41 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 2/3] dvb_frontend: return -ENOTTY for unimplement IOCTL
Date: Fri, 10 Aug 2012 01:25:00 +0300
Message-Id: <1344551101-16700-3-git-send-email-crope@iki.fi>
In-Reply-To: <1344551101-16700-1-git-send-email-crope@iki.fi>
References: <1344551101-16700-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Earlier it was returning -EOPNOTSUPP.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 4548fc9..4fc11eb 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1830,7 +1830,7 @@ static int dvb_frontend_ioctl(struct file *file,
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	int err = -EOPNOTSUPP;
+	int err = -ENOTTY;
 
 	dev_dbg(fe->dvb->device, "%s: (%d)\n", __func__, _IOC_NR(cmd));
 	if (fepriv->exit != DVB_FE_NO_EXIT)
@@ -1948,7 +1948,7 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 		}
 
 	} else
-		err = -EOPNOTSUPP;
+		err = -ENOTTY;
 
 out:
 	kfree(tvp);
@@ -2081,7 +2081,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int cb_err, err = -EOPNOTSUPP;
+	int cb_err, err = -ENOTTY;
 
 	if (fe->dvb->fe_ioctl_override) {
 		cb_err = fe->dvb->fe_ioctl_override(fe, cmd, parg,
-- 
1.7.11.2

