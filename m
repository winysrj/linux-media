Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:43543 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758763AbbIVR2C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 13:28:02 -0400
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
Subject: [PATCH v3 05/21] media: Media Controller fix to not let stream_count go negative
Date: Tue, 22 Sep 2015 11:19:24 -0600
Message-Id: <c7adbc6c1e404841de70b35362136a340f60e660.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a range check to not let the stream_count become negative.
Wthout this check, calls to stop pipeline when there is no active
pipeline will result in stream_count < 0 condition and lock and
preventing link state (activate/deactivate) changes. This will
happen from error leg in start pipeline interface.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-entity.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 4d8e01c..68d5ec2 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -315,9 +315,12 @@ error:
 	media_entity_graph_walk_start(&graph, entity_err);
 
 	while ((entity_err = media_entity_graph_walk_next(&graph))) {
-		entity_err->stream_count--;
-		if (entity_err->stream_count == 0)
-			entity_err->pipe = NULL;
+		/* don't let the stream_count go negative */
+		if (entity->stream_count > 0) {
+			entity_err->stream_count--;
+			if (entity_err->stream_count == 0)
+				entity_err->pipe = NULL;
+		}
 
 		/*
 		 * We haven't increased stream_count further than this
@@ -355,9 +358,12 @@ void media_entity_pipeline_stop(struct media_entity *entity)
 	media_entity_graph_walk_start(&graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
-		entity->stream_count--;
-		if (entity->stream_count == 0)
-			entity->pipe = NULL;
+		/* don't let the stream_count go negative */
+		if (entity->stream_count > 0) {
+			entity->stream_count--;
+			if (entity->stream_count == 0)
+				entity->pipe = NULL;
+		}
 	}
 
 	mutex_unlock(&mdev->graph_mutex);
-- 
2.1.4

