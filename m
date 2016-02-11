Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:36280 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbcBKXmc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 18:42:32 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com,
	tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com,
	corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com,
	stefanr@s5r6.in-berlin.de, inki.dae@samsung.com,
	jh1009.sung@samsung.com, elfring@users.sourceforge.net,
	prabhakar.csengg@gmail.com, sw0312.kim@samsung.com,
	p.zabel@pengutronix.de, ricardo.ribalda@gmail.com,
	labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com,
	ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com,
	dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org,
	gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk,
	linuxbugs@vittgam.net, johan@oljud.se, klock.android@gmail.com,
	nenggun.kim@samsung.com, j.anaszewski@samsung.com,
	geliangtang@163.com, albert@huitsing.nl,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v3 20/22] media: dvb-frontend invoke enable/disable_source handlers
Date: Thu, 11 Feb 2016 16:41:36 -0700
Message-Id: <8e559c012b79575278241c03ec013f9f8af8cf23.1455233156.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1455233150.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1455233150.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change dvb frontend to check if tuner is free when
device opened in RW mode. Call to enable_source
handler either returns with an active pipeline to
tuner or error if tuner is busy. Tuner is released
when frontend is released calling the disable_source
handler.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 135 ++++++----------------------------
 1 file changed, 21 insertions(+), 114 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 03cc508..8221fa6 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -134,7 +134,6 @@ struct dvb_frontend_private {
 
 #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
 	struct media_pipeline pipe;
-	struct media_entity *pipe_start_entity;
 #endif
 };
 
@@ -596,104 +595,12 @@ static void dvb_frontend_wakeup(struct dvb_frontend *fe)
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
-	int ret, n_links = 0, active_links = 0;
-
-	fepriv->pipe_start_entity = NULL;
-
-	if (!mdev)
-		return 0;
-
-	entity = fepriv->dvbdev->entity;
-	fepriv->pipe_start_entity = entity;
-
-	list_for_each_entry(link, &entity->links, list) {
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
-	list_for_each_entry(link, &source->links, list) {
-		struct media_entity *sink;
-		int flags = 0;
-
-		sink = link->sink->entity;
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
 
@@ -706,20 +613,6 @@ static int dvb_frontend_thread(void *data)
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
@@ -829,12 +722,6 @@ restart:
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
@@ -2612,9 +2499,20 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 		fepriv->tone = -1;
 		fepriv->voltage = -1;
 
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+		if (fe->dvb->mdev && fe->dvb->mdev->enable_source) {
+			ret = fe->dvb->mdev->enable_source(dvbdev->entity,
+							   &fepriv->pipe);
+			if (ret) {
+				dev_err(fe->dvb->device,
+					"Tuner is busy. Error %d\n", ret);
+				goto err2;
+			}
+		}
+#endif
 		ret = dvb_frontend_start (fe);
 		if (ret)
-			goto err2;
+			goto err3;
 
 		/*  empty event queue */
 		fepriv->events.eventr = fepriv->events.eventw = 0;
@@ -2624,7 +2522,12 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 		mutex_unlock (&adapter->mfe_lock);
 	return ret;
 
+err3:
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+	if (fe->dvb->mdev && fe->dvb->mdev->disable_source)
+		fe->dvb->mdev->disable_source(dvbdev->entity);
 err2:
+#endif
 	dvb_generic_release(inode, file);
 err1:
 	if (dvbdev->users == -1 && fe->ops.ts_bus_ctrl)
@@ -2653,6 +2556,10 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 
 	if (dvbdev->users == -1) {
 		wake_up(&fepriv->wait_queue);
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+		if (fe->dvb->mdev && fe->dvb->mdev->disable_source)
+			fe->dvb->mdev->disable_source(dvbdev->entity);
+#endif
 		if (fe->exit != DVB_FE_NO_EXIT)
 			wake_up(&dvbdev->wait_queue);
 		if (fe->ops.ts_bus_ctrl)
-- 
2.5.0

