Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:43561 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752867AbbGVWmy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 18:42:54 -0400
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
Subject: [PATCH v2 12/19] staging media: omap4iss: Update graph_mutex to graph_lock spinlock
Date: Wed, 22 Jul 2015 16:42:13 -0600
Message-Id: <13f40d9fa030ad84ee1e5332132eabf15fee3293.1437599281.git.shuahkh@osg.samsung.com>
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
 drivers/staging/media/omap4iss/iss.c       | 4 ++--
 drivers/staging/media/omap4iss/iss_video.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 9bfb725..017ef74 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -494,7 +494,7 @@ int omap4iss_pipeline_pm_use(struct media_entity *entity, int use)
 	int change = use ? 1 : -1;
 	int ret;
 
-	mutex_lock(&entity->parent->graph_mutex);
+	spin_lock(&entity->parent->graph_lock);
 
 	/* Apply use count to node. */
 	entity->use_count += change;
@@ -505,7 +505,7 @@ int omap4iss_pipeline_pm_use(struct media_entity *entity, int use)
 	if (ret < 0)
 		entity->use_count -= change;
 
-	mutex_unlock(&entity->parent->graph_mutex);
+	spin_unlock(&entity->parent->graph_lock);
 
 	return ret;
 }
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 85c54fe..2db9d16 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -210,7 +210,7 @@ iss_video_far_end(struct iss_video *video)
 	struct media_device *mdev = entity->parent;
 	struct iss_video *far_end = NULL;
 
-	mutex_lock(&mdev->graph_mutex);
+	spin_lock(&mdev->graph_lock);
 	media_entity_graph_walk_start(&graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
@@ -227,7 +227,7 @@ iss_video_far_end(struct iss_video *video)
 		far_end = NULL;
 	}
 
-	mutex_unlock(&mdev->graph_mutex);
+	spin_unlock(&mdev->graph_lock);
 	return far_end;
 }
 
-- 
2.1.4

