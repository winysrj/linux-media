Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33174
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752156AbdI0Vky (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:40:54 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>
Subject: [PATCH v2 07/37] media: dvb_frontend: cleanup dvb_frontend_ioctl_properties()
Date: Wed, 27 Sep 2017 18:40:08 -0300
Message-Id: <b172f37079f9e0f09e068d0bbfded540b491bc8f.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use a switch() on this function, just like on other ioctl
handlers and handle parameters inside each part of the
switch.

That makes it easier to integrate with the already existing
ioctl handler function.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 83 +++++++++++++++++++++--------------
 1 file changed, 51 insertions(+), 32 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 8abe4f541a36..725cb1c8a088 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1971,21 +1971,25 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int err = 0;
-
-	struct dtv_properties *tvps = parg;
-	struct dtv_property *tvp = NULL;
-	int i;
+	int err, i;
 
 	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
-	if (cmd == FE_SET_PROPERTY) {
-		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n", __func__, tvps->num);
-		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n", __func__, tvps->props);
+	switch(cmd) {
+	case FE_SET_PROPERTY: {
+		struct dtv_properties *tvps = parg;
+		struct dtv_property *tvp = NULL;
 
-		/* Put an arbitrary limit on the number of messages that can
-		 * be sent at once */
-		if ((tvps->num == 0) || (tvps->num > DTV_IOCTL_MAX_MSGS))
+		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
+			__func__, tvps->num);
+		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
+			__func__, tvps->props);
+
+		/*
+		 * Put an arbitrary limit on the number of messages that can
+		 * be sent at once
+		 */
+		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
 			return -EINVAL;
 
 		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
@@ -1994,23 +1998,34 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 
 		for (i = 0; i < tvps->num; i++) {
 			err = dtv_property_process_set(fe, tvp + i, file);
-			if (err < 0)
-				goto out;
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
 			(tvp + i)->result = err;
 		}
 
 		if (c->state == DTV_TUNE)
 			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n", __func__);
 
-	} else if (cmd == FE_GET_PROPERTY) {
+		kfree(tvp);
+		break;
+	}
+	case FE_GET_PROPERTY: {
+		struct dtv_properties *tvps = parg;
+		struct dtv_property *tvp = NULL;
 		struct dtv_frontend_properties getp = fe->dtv_property_cache;
 
-		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n", __func__, tvps->num);
-		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n", __func__, tvps->props);
+		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
+			__func__, tvps->num);
+		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
+			__func__, tvps->props);
 
-		/* Put an arbitrary limit on the number of messages that can
-		 * be sent at once */
-		if ((tvps->num == 0) || (tvps->num > DTV_IOCTL_MAX_MSGS))
+		/*
+		 * Put an arbitrary limit on the number of messages that can
+		 * be sent at once
+		 */
+		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
 			return -EINVAL;
 
 		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
@@ -2025,28 +2040,32 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 		 */
 		if (fepriv->state != FESTATE_IDLE) {
 			err = dtv_get_frontend(fe, &getp, NULL);
-			if (err < 0)
-				goto out;
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
 		}
 		for (i = 0; i < tvps->num; i++) {
 			err = dtv_property_process_get(fe, &getp, tvp + i, file);
-			if (err < 0)
-				goto out;
+			if (err < 0) {
+				kfree(tvp);
+				return err;
+			}
 			(tvp + i)->result = err;
 		}
 
 		if (copy_to_user((void __user *)tvps->props, tvp,
 				 tvps->num * sizeof(struct dtv_property))) {
-			err = -EFAULT;
-			goto out;
+			kfree(tvp);
+			return -EFAULT;
 		}
-
-	} else
-		err = -EOPNOTSUPP;
-
-out:
-	kfree(tvp);
-	return err;
+		kfree(tvp);
+		break;
+	}
+	default:
+		return -ENOTSUPP;
+	} /* switch */
+	return 0;
 }
 
 static int dtv_set_frontend(struct dvb_frontend *fe)
-- 
2.13.5
