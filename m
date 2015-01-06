Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55294 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705AbbAFVJU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Jan 2015 16:09:20 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuah.kh@samsung.com>,
	Ole Ernst <olebowle@gmx.com>,
	Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCHv3 17/20] dvb-frontend: enable tuner link when the FE thread starts
Date: Tue,  6 Jan 2015 19:08:48 -0200
Message-Id: <c4337c6cc08e1d5bcd4bf234e4f95a0f28ff3374.1420578087.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420578087.git.mchehab@osg.samsung.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420578087.git.mchehab@osg.samsung.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the dvb frontend thread starts, the tuner should be switched
to the frontend. Add a code that ensures that this will happen,
using the media controller.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index c2c559105f64..04e949ad9722 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -590,12 +590,99 @@ static void dvb_frontend_wakeup(struct dvb_frontend *fe)
 	wake_up_interruptible(&fepriv->wait_queue);
 }
 
+/**
+ * dvb_enable_media_tuner() - tries to enable the DVB tuner
+ *
+ * @fe:		struct dvb_frontend pointer
+ *
+ * This function ensures that just one media tuner is enabled for a given
+ * frontend. It has two different behaviors:
+ * - For trivial devices with just one tuner:
+ *   it just enables the existing tuner->fe link
+ * - For devices with more than one tuner:
+ *   It is up to the driver to implement the logic that will enable one tuner
+ *   and disable the other ones. However, if more than one tuner is enabled for
+ *   the same frontend, it will print an error message and return -EINVAL.
+ *
+ * At return, it will return the error code returned by media_entity_setup_link,
+ * or 0 if everything is OK, if no tuner is linked to the frontend or if the
+ * mdev is NULL.
+ */
+static int dvb_enable_media_tuner(struct dvb_frontend *fe)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
+	struct dvb_adapter *adapter = fe->dvb;
+	struct media_device *mdev = adapter->mdev;
+	struct media_entity  *entity, *source;
+	struct media_link *link, *found_link = NULL;
+	int i, ret, n_links = 0, active_links = 0;
+
+	if (!mdev)
+		return 0;
+
+	entity = fepriv->dvbdev->entity;
+	for (i = 0; i < entity->num_links; i++) {
+		link = &entity->links[i];
+		if (link->sink->entity == entity) {
+			found_link = link;
+			n_links++;
+			if (link->flags & MEDIA_LNK_FL_ENABLED)
+				active_links++;
+		}
+	}
+
+	if (!n_links || active_links == 1 || !found_link)
+		return 0;
+
+	/*
+	 * If a frontend has more than one tuner linked, it is up to the driver
+	 * to select with one will be the active one, as the frontend core can't
+	 * guess. If the driver doesn't do that, it is a bug.
+	 */
+	if (n_links > 1 && active_links != 1) {
+		dev_err(fe->dvb->device,
+			"WARNING: there are %d active links among %d tuners. This is a driver's bug!\n",
+			active_links, n_links);
+		return -EINVAL;
+	}
+
+	source = found_link->source->entity;
+	for (i = 0; i < source->num_links; i++) {
+		struct media_entity *sink;
+		int flags = 0;
+
+		link = &source->links[i];
+		sink = link->sink->entity;
+
+		if (sink == entity)
+			flags = MEDIA_LNK_FL_ENABLED;
+
+		ret = media_entity_setup_link(link, flags);
+		if (ret) {
+			dev_err(fe->dvb->device,
+				"Couldn't change link %s->%s to %s. Error %d\n",
+				source->name, sink->name,
+				flags ? "enabled" : "disabled",
+				ret);
+			return ret;
+		} else
+			dev_dbg(fe->dvb->device,
+				"link %s->%s was %s\n",
+				source->name, sink->name,
+				flags ? "ENABLED" : "disabled");
+	}
+#endif
+	return 0;
+}
+
 static int dvb_frontend_thread(void *data)
 {
 	struct dvb_frontend *fe = data;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	fe_status_t s;
 	enum dvbfe_algo algo;
+	int ret;
 
 	bool re_tune = false;
 	bool semheld = false;
@@ -609,6 +696,13 @@ static int dvb_frontend_thread(void *data)
 	fepriv->wakeup = 0;
 	fepriv->reinitialise = 0;
 
+	ret = dvb_enable_media_tuner(fe);
+	if (ret) {
+		/* FIXME: return an error if it fails */
+		dev_info(fe->dvb->device,
+			"proceeding with FE task\n");
+	}
+
 	dvb_frontend_init(fe);
 
 	set_freezable();
-- 
2.1.0

