Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33160
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751960AbdI0Vkt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:40:49 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v2 09/37] media: dvb_frontend: get rid of property cache's state
Date: Wed, 27 Sep 2017 18:40:10 -0300
Message-Id: <16be8178e61da36b8631f682dc2c2cc6d355f7ba.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the past, I guess the idea was to use state in order to
allow an autofush logic. However, in the current code, it is
used only for debug messages, on a poor man's solution, as
there's already a debug message to indicate when the properties
got flushed.

So, just get rid of it for good.

Reviewed-by: Shuah Khan <shuahkg@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 20 ++++++--------------
 drivers/media/dvb-core/dvb_frontend.h |  5 -----
 2 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 9e6ee9df233b..01bd19fd4c57 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -951,8 +951,6 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 	memset(c, 0, offsetof(struct dtv_frontend_properties, strength));
 	c->delivery_system = delsys;
 
-	c->state = DTV_CLEAR;
-
 	dev_dbg(fe->dvb->device, "%s: Clearing cache for delivery system %d\n",
 			__func__, c->delivery_system);
 
@@ -1775,13 +1773,13 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		dvb_frontend_clear_cache(fe);
 		break;
 	case DTV_TUNE:
-		/* interpret the cache of data, build either a traditional frontend
-		 * tunerequest so we can pass validation in the FE_SET_FRONTEND
-		 * ioctl.
+		/*
+		 * Use the cached Digital TV properties to tune the
+		 * frontend
 		 */
-		c->state = tvp->cmd;
-		dev_dbg(fe->dvb->device, "%s: Finalised property cache\n",
-				__func__);
+		dev_dbg(fe->dvb->device,
+			"%s: Setting the frontend from property cache\n",
+			__func__);
 
 		r = dtv_set_frontend(fe);
 		break;
@@ -1930,7 +1928,6 @@ static int dvb_frontend_ioctl(struct file *file, unsigned int cmd, void *parg)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int err;
 
@@ -1950,7 +1947,6 @@ static int dvb_frontend_ioctl(struct file *file, unsigned int cmd, void *parg)
 		return -EPERM;
 	}
 
-	c->state = DTV_UNDEFINED;
 	err = dvb_frontend_handle_ioctl(file, cmd, parg);
 
 	up(&fepriv->sem);
@@ -2134,10 +2130,6 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 			}
 			(tvp + i)->result = err;
 		}
-
-		if (c->state == DTV_TUNE)
-			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n", __func__);
-
 		kfree(tvp);
 		break;
 	}
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 852b91ba49d2..1bdeb10f0d78 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -620,11 +620,6 @@ struct dtv_frontend_properties {
 	struct dtv_fe_stats	post_bit_count;
 	struct dtv_fe_stats	block_error;
 	struct dtv_fe_stats	block_count;
-
-	/* private: */
-	/* Cache State */
-	u32			state;
-
 };
 
 #define DVB_FE_NO_EXIT  0
-- 
2.13.5
