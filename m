Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39247 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbcBDP6r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2016 10:58:47 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Tina Ruchandani <ruchandani.tina@gmail.com>
Subject: [PATCH 7/7] [media] dvb_frontend: Don't let drivers to trash data at cache
Date: Thu,  4 Feb 2016 13:57:32 -0200
Message-Id: <ab7a0404d530f36c88933522b50c90027a475822.1454600641.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454600641.git.mchehab@osg.samsung.com>
References: <cover.1454600641.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454600641.git.mchehab@osg.samsung.com>
References: <cover.1454600641.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

GET_FRONTEND and G_PROPERTY can be called anytime, even when the
tuner/demod is not fully locked. However, several parameters
returned by those calls are available only after the demod get
VITERBI lock.

While several drivers do the right thing by checking the status before
returning the parameter, some drivers simply blindly update the
DTV properties cache without checking if the registers at the
hardware contain valid values.

Due to that, programs that call G_PROPERTY (or GET_FRONTEND)
before having a tuner lock may interfere at the zigzag logic,
as the DVB kthread calls the set_frontend() callback several
times, to fine tune the frequency and to identify if the signal
is inverted or not.

While the drivers should be fixed to report the right status,
we should prevent that such bugs would actually interfere at the
device operation.

So, let's use a separate var for userspace calls to get frontend.

As we copy the content of the cache, this should not cause any
troubles.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index d009478f16c4..4c35eb47472b 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2087,6 +2087,8 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n", __func__);
 
 	} else if (cmd == FE_GET_PROPERTY) {
+		struct dtv_frontend_properties getp = fe->dtv_property_cache;
+
 		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n", __func__, tvps->num);
 		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n", __func__, tvps->props);
 
@@ -2108,17 +2110,18 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 		}
 
 		/*
-		 * Fills the cache out struct with the cache contents, plus
-		 * the data retrieved from get_frontend, if the frontend
-		 * is not idle. Otherwise, returns the cached content
+		 * Let's use our own copy of property cache, in order to
+		 * avoid mangling with DTV zigzag logic, as drivers might
+		 * return crap, if they don't check if the data is available
+		 * before updating the properties cache.
 		 */
 		if (fepriv->state != FESTATE_IDLE) {
-			err = dtv_get_frontend(fe, c, NULL);
+			err = dtv_get_frontend(fe, &getp, NULL);
 			if (err < 0)
 				goto out;
 		}
 		for (i = 0; i < tvps->num; i++) {
-			err = dtv_property_process_get(fe, c, tvp + i, file);
+			err = dtv_property_process_get(fe, &getp, tvp + i, file);
 			if (err < 0)
 				goto out;
 			(tvp + i)->result = err;
@@ -2523,10 +2526,18 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		err = dvb_frontend_get_event (fe, parg, file->f_flags);
 		break;
 
-	case FE_GET_FRONTEND:
-		err = dtv_get_frontend(fe, c, parg);
-		break;
+	case FE_GET_FRONTEND: {
+		struct dtv_frontend_properties getp = fe->dtv_property_cache;
 
+		/*
+		 * Let's use our own copy of property cache, in order to
+		 * avoid mangling with DTV zigzag logic, as drivers might
+		 * return crap, if they don't check if the data is available
+		 * before updating the properties cache.
+		 */
+		err = dtv_get_frontend(fe, &getp, parg);
+		break;
+	}
 	case FE_SET_FRONTEND_TUNE_MODE:
 		fepriv->tune_mode_flags = (unsigned long) parg;
 		err = 0;
-- 
2.5.0


