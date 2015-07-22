Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-10v.sys.comcast.net ([96.114.154.169]:59006 "EHLO
	resqmta-po-10v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752524AbbGVWmv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 18:42:51 -0400
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
Subject: [PATCH v2 11/19] staging media: davinci_vpfe: Update graph_mutex to graph_lock spinlock
Date: Wed, 22 Jul 2015 16:42:12 -0600
Message-Id: <8e4896bee216cc4aa30a16d799b6ea896e99c919.1437599281.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1437599281.git.shuahkh@osg.samsung.com>
References: <cover.1437599281.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1437599281.git.shuahkh@osg.samsung.com>
References: <cover.1437599281.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update graph_mutex to graph_lock spinlock to be in sync with
the Media Conttroller change for the same.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 87048a1..2511614 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -143,7 +143,7 @@ static void vpfe_prepare_pipeline(struct vpfe_video_device *video)
 	else
 		pipe->outputs[pipe->output_num++] = video;
 
-	mutex_lock(&mdev->graph_mutex);
+	spin_lock(&mdev->graph_lock);
 	media_entity_graph_walk_start(&graph, entity);
 	while ((entity = media_entity_graph_walk_next(&graph))) {
 		if (entity == &video->video_dev.entity)
@@ -156,7 +156,7 @@ static void vpfe_prepare_pipeline(struct vpfe_video_device *video)
 		else
 			pipe->outputs[pipe->output_num++] = far_end;
 	}
-	mutex_unlock(&mdev->graph_mutex);
+	spin_unlock(&mdev->graph_lock);
 }
 
 /* update pipe state selected by user */
@@ -289,7 +289,7 @@ static int vpfe_pipeline_enable(struct vpfe_pipeline *pipe)
 		entity = &pipe->inputs[0]->video_dev.entity;
 
 	mdev = entity->parent;
-	mutex_lock(&mdev->graph_mutex);
+	spin_lock(&mdev->graph_lock);
 	media_entity_graph_walk_start(&graph, entity);
 	while ((entity = media_entity_graph_walk_next(&graph))) {
 
@@ -300,7 +300,7 @@ static int vpfe_pipeline_enable(struct vpfe_pipeline *pipe)
 		if (ret < 0 && ret != -ENOIOCTLCMD)
 			break;
 	}
-	mutex_unlock(&mdev->graph_mutex);
+	spin_unlock(&mdev->graph_lock);
 	return ret;
 }
 
@@ -329,7 +329,7 @@ static int vpfe_pipeline_disable(struct vpfe_pipeline *pipe)
 		entity = &pipe->inputs[0]->video_dev.entity;
 
 	mdev = entity->parent;
-	mutex_lock(&mdev->graph_mutex);
+	spin_lock(&mdev->graph_lock);
 	media_entity_graph_walk_start(&graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
@@ -341,7 +341,7 @@ static int vpfe_pipeline_disable(struct vpfe_pipeline *pipe)
 		if (ret < 0 && ret != -ENOIOCTLCMD)
 			break;
 	}
-	mutex_unlock(&mdev->graph_mutex);
+	spin_unlock(&mdev->graph_lock);
 
 	return ret ? -ETIMEDOUT : 0;
 }
-- 
2.1.4

