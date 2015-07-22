Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:33712 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752439AbbGVWnA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 18:43:00 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, tiwai@suse.de,
	sakari.ailus@linux.intel.com, perex@perex.cz, crope@iki.fi,
	arnd@arndb.de, stefanr@s5r6.in-berlin.de,
	ruchandani.tina@gmail.com, chehabrafael@gmail.com,
	dan.carpenter@oracle.com, prabhakar.csengg@gmail.com,
	chris.j.arges@canonical.com, agoode@google.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, daniel@zonque.org, vladcatoi@gmail.com,
	misterpib@gmail.com, damien@zamaudio.com, pmatilai@laiskiainen.org,
	takamichiho@gmail.com, normalperson@yhbt.net,
	bugzilla.frnkcg@spamgourmet.com, joe@oampo.co.uk,
	calcprogrammer1@gmail.com, jussi@sonarnerd.net,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	kgene@kernel.org, hyun.kwon@xilinx.com, michal.simek@xilinx.com,
	soren.brinkmann@xilinx.com, pawel@osciak.com,
	m.szyprowski@samsung.com, gregkh@linuxfoundation.org,
	skd08@gmail.com, nsekhar@ti.com,
	boris.brezillon@free-electrons.com, Julia.Lawall@lip6.fr,
	elfring@users.sourceforge.net, p.zabel@pengutronix.de,
	ricardo.ribalda@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org
Subject: [PATCH v2 17/19] media: dvb-frontend change to check for tuner availability from open
Date: Wed, 22 Jul 2015 16:42:18 -0600
Message-Id: <0d159793e88737e4b1774ebcb4eb8a1d2f8ed1a0.1437599281.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1437599281.git.shuahkh@osg.samsung.com>
References: <cover.1437599281.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1437599281.git.shuahkh@osg.samsung.com>
References: <cover.1437599281.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Checking for tuner availability from frontend thread start
disrupts video stream. Change to check for tuner and start
pipeline from frontend open instead and stop pipeline from
frontend release.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 43 ++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 842b9c8..b394e1e 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -694,10 +694,6 @@ static int dvb_frontend_thread(void *data)
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	enum fe_status s;
 	enum dvbfe_algo algo;
-#ifdef CONFIG_MEDIA_CONTROLLER_DVB
-	int ret;
-#endif
-
 	bool re_tune = false;
 	bool semheld = false;
 
@@ -710,20 +706,6 @@ static int dvb_frontend_thread(void *data)
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
@@ -833,12 +815,6 @@ restart:
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
@@ -2616,6 +2592,20 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 		fepriv->tone = -1;
 		fepriv->voltage = -1;
 
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+		ret = dvb_enable_media_tuner(fe);
+		if (ret) {
+			dev_err(fe->dvb->device,
+				"Tuner is busy. Error %d\n", ret);
+			goto err1;
+		} else if (fepriv->pipe_start_entity) {
+			ret = media_entity_pipeline_start(
+						fepriv->pipe_start_entity,
+						&fepriv->pipe);
+			if (ret)
+				goto err1;
+		}
+#endif
 		ret = dvb_frontend_start (fe);
 		if (ret)
 			goto err2;
@@ -2659,6 +2649,11 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 		wake_up(&fepriv->wait_queue);
 		if (fe->exit != DVB_FE_NO_EXIT)
 			wake_up(&dvbdev->wait_queue);
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+		if (fepriv->pipe_start_entity)
+			media_entity_pipeline_stop(fepriv->pipe_start_entity);
+		fepriv->pipe_start_entity = NULL;
+#endif
 		if (fe->ops.ts_bus_ctrl)
 			fe->ops.ts_bus_ctrl(fe, 0);
 	}
-- 
2.1.4

