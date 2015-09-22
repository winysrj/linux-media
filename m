Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:49591 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758534AbbIVR2F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 13:28:05 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	tiwai@suse.de, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz,
	stefanr@s5r6.in-berlin.de, crope@iki.fi, dan.carpenter@oracle.com,
	tskd08@gmail.com, ruchandani.tina@gmail.com, arnd@arndb.de,
	chehabrafael@gmail.com, prabhakar.csengg@gmail.com,
	Julia.Lawall@lip6.fr, elfring@users.sourceforge.net,
	ricardo.ribalda@gmail.com, chris.j.arges@canonical.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, misterpib@gmail.com, takamichiho@gmail.com,
	pmatilai@laiskiainen.org, damien@zamaudio.com, daniel@zonque.org,
	vladcatoi@gmail.com, normalperson@yhbt.net, joe@oampo.co.uk,
	bugzilla.frnkcg@spamgourmet.com, jussi@sonarnerd.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v3 14/21] media: dvb-frontend invoke enable/disable_source handlers
Date: Tue, 22 Sep 2015 11:19:33 -0600
Message-Id: <96ac266ed092526d77d4638d84326e639c5f5a7c.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Checking for tuner availability from frontend thread start
disrupts video stream. Change to check for tuner and start
pipeline from frontend open instead and stop pipeline from
frontend release. In addition, make a change to invoke
enable_source and disable_source handlers to check for
tuner availability. The enable_source handler finds tuner
entity connected to the decoder and check is it is available
or busy. If tuner is available, link is activated and pipeline
is started. The disable_source handler to deactivate and stop
the pipeline. dvb_enable_media_tuner() is removed as it is no
longer necessary with dvb invoking enable_source and
disable_source handlers. pipe_start_entity field is removed
and pipe field is moved to dvb_frontend from dvb_frontend_private.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 135 ++++------------------------------
 drivers/media/dvb-core/dvb_frontend.h |   3 +
 2 files changed, 18 insertions(+), 120 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 842b9c8..c06dd61 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -132,11 +132,6 @@ struct dvb_frontend_private {
 	int quality;
 	unsigned int check_wrapped;
 	enum dvbfe_search algo_status;
-
-#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
-	struct media_pipeline pipe;
-	struct media_entity *pipe_start_entity;
-#endif
 };
 
 static void dvb_frontend_wakeup(struct dvb_frontend *fe);
@@ -597,107 +592,12 @@ static void dvb_frontend_wakeup(struct dvb_frontend *fe)
 	wake_up_interruptible(&fepriv->wait_queue);
 }
 
-/**
- * dvb_enable_media_tuner() - tries to enable the DVB tuner
- *
- * @fe:		struct dvb_frontend pointer
- *
- * This function ensures that just one media tuner is enabled for a given
- * frontend. It has two different behaviors:
- * - For trivial devices with just one tuner:
- *   it just enables the existing tuner->fe link
- * - For devices with more than one tuner:
- *   It is up to the driver to implement the logic that will enable one tuner
- *   and disable the other ones. However, if more than one tuner is enabled for
- *   the same frontend, it will print an error message and return -EINVAL.
- *
- * At return, it will return the error code returned by media_entity_setup_link,
- * or 0 if everything is OK, if no tuner is linked to the frontend or if the
- * mdev is NULL.
- */
-#ifdef CONFIG_MEDIA_CONTROLLER_DVB
-static int dvb_enable_media_tuner(struct dvb_frontend *fe)
-{
-	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	struct dvb_adapter *adapter = fe->dvb;
-	struct media_device *mdev = adapter->mdev;
-	struct media_entity  *entity, *source;
-	struct media_link *link, *found_link = NULL;
-	int i, ret, n_links = 0, active_links = 0;
-
-	fepriv->pipe_start_entity = NULL;
-
-	if (!mdev)
-		return 0;
-
-	entity = fepriv->dvbdev->entity;
-	fepriv->pipe_start_entity = entity;
-
-	for (i = 0; i < entity->num_links; i++) {
-		link = &entity->links[i];
-		if (link->sink->entity == entity) {
-			found_link = link;
-			n_links++;
-			if (link->flags & MEDIA_LNK_FL_ENABLED)
-				active_links++;
-		}
-	}
-
-	if (!n_links || active_links == 1 || !found_link)
-		return 0;
-
-	/*
-	 * If a frontend has more than one tuner linked, it is up to the driver
-	 * to select with one will be the active one, as the frontend core can't
-	 * guess. If the driver doesn't do that, it is a bug.
-	 */
-	if (n_links > 1 && active_links != 1) {
-		dev_err(fe->dvb->device,
-			"WARNING: there are %d active links among %d tuners. This is a driver's bug!\n",
-			active_links, n_links);
-		return -EINVAL;
-	}
-
-	source = found_link->source->entity;
-	fepriv->pipe_start_entity = source;
-	for (i = 0; i < source->num_links; i++) {
-		struct media_entity *sink;
-		int flags = 0;
-
-		link = &source->links[i];
-		sink = link->sink->entity;
-
-		if (sink == entity)
-			flags = MEDIA_LNK_FL_ENABLED;
-
-		ret = media_entity_setup_link(link, flags);
-		if (ret) {
-			dev_err(fe->dvb->device,
-				"Couldn't change link %s->%s to %s. Error %d\n",
-				source->name, sink->name,
-				flags ? "enabled" : "disabled",
-				ret);
-			return ret;
-		} else
-			dev_dbg(fe->dvb->device,
-				"link %s->%s was %s\n",
-				source->name, sink->name,
-				flags ? "ENABLED" : "disabled");
-	}
-	return 0;
-}
-#endif
-
 static int dvb_frontend_thread(void *data)
 {
 	struct dvb_frontend *fe = data;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	enum fe_status s;
 	enum dvbfe_algo algo;
-#ifdef CONFIG_MEDIA_CONTROLLER_DVB
-	int ret;
-#endif
-
 	bool re_tune = false;
 	bool semheld = false;
 
@@ -710,20 +610,6 @@ static int dvb_frontend_thread(void *data)
 	fepriv->wakeup = 0;
 	fepriv->reinitialise = 0;
 
-#ifdef CONFIG_MEDIA_CONTROLLER_DVB
-	ret = dvb_enable_media_tuner(fe);
-	if (ret) {
-		/* FIXME: return an error if it fails */
-		dev_info(fe->dvb->device,
-			"proceeding with FE task\n");
-	} else if (fepriv->pipe_start_entity) {
-		ret = media_entity_pipeline_start(fepriv->pipe_start_entity,
-						  &fepriv->pipe);
-		if (ret)
-			return ret;
-	}
-#endif
-
 	dvb_frontend_init(fe);
 
 	set_freezable();
@@ -833,12 +719,6 @@ restart:
 		}
 	}
 
-#ifdef CONFIG_MEDIA_CONTROLLER_DVB
-	if (fepriv->pipe_start_entity)
-		media_entity_pipeline_stop(fepriv->pipe_start_entity);
-	fepriv->pipe_start_entity = NULL;
-#endif
-
 	if (dvb_powerdown_on_sleep) {
 		if (fe->ops.set_voltage)
 			fe->ops.set_voltage(fe, SEC_VOLTAGE_OFF);
@@ -2616,6 +2496,17 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 		fepriv->tone = -1;
 		fepriv->voltage = -1;
 
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+		if (fe->dvb->mdev && fe->dvb->mdev->enable_source) {
+			ret = fe->dvb->mdev->enable_source(dvbdev->entity,
+						  &fe->pipe);
+			if (ret) {
+				dev_err(fe->dvb->device,
+					"Tuner is busy. Error %d\n", ret);
+				goto err1;
+			}
+		}
+#endif
 		ret = dvb_frontend_start (fe);
 		if (ret)
 			goto err2;
@@ -2659,6 +2550,10 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 		wake_up(&fepriv->wait_queue);
 		if (fe->exit != DVB_FE_NO_EXIT)
 			wake_up(&dvbdev->wait_queue);
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+		if (fe->dvb->mdev && fe->dvb->mdev->disable_source)
+			fe->dvb->mdev->disable_source(dvbdev->entity);
+#endif
 		if (fe->ops.ts_bus_ctrl)
 			fe->ops.ts_bus_ctrl(fe, 0);
 	}
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 4816947..03d328e 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -428,6 +428,9 @@ struct dvb_frontend {
 	int (*callback)(void *adapter_priv, int component, int cmd, int arg);
 	int id;
 	unsigned int exit;
+#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
+	struct media_pipeline pipe;
+#endif
 };
 
 extern int dvb_register_frontend(struct dvb_adapter *dvb,
-- 
2.1.4

