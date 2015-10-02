Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-06v.sys.comcast.net ([96.114.154.165]:58984 "EHLO
	resqmta-po-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429AbbJBWJO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2015 18:09:14 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	tiwai@suse.de, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz,
	dan.carpenter@oracle.com, tskd08@gmail.com, arnd@arndb.de,
	ruchandani.tina@gmail.com, corbet@lwn.net, k.kozlowski@samsung.com,
	chehabrafael@gmail.com, prabhakar.csengg@gmail.com,
	elfring@users.sourceforge.net, Julia.Lawall@lip6.fr,
	p.zabel@pengutronix.de, ricardo.ribalda@gmail.com,
	labbott@fedoraproject.org, chris.j.arges@canonical.com,
	pierre-louis.bossart@linux.intel.com, johan@oljud.se,
	wsa@the-dreams.de, jcragg@gmail.com, clemens@ladisch.de,
	daniel@zonque.org, gtmkramer@xs4all.nl, misterpib@gmail.com,
	takamichiho@gmail.com, pmatilai@laiskiainen.org,
	vladcatoi@gmail.com, damien@zamaudio.com, normalperson@yhbt.net,
	joe@oampo.co.uk, jussi@sonarnerd.net, calcprogrammer1@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH MC Next Gen 04/20] media: Media Controller fix to not let stream_count go negative
Date: Fri,  2 Oct 2015 16:07:16 -0600
Message-Id: <28bf43b07b9ffbd90e6fae27b6a95ca07288b81b.1443822799.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1443822799.git.shuahkh@osg.samsung.com>
References: <cover.1443822799.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1443822799.git.shuahkh@osg.samsung.com>
References: <cover.1443822799.git.shuahkh@osg.samsung.com>
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
index eaeda25..797b7b3 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -502,9 +502,12 @@ error:
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
@@ -542,9 +545,12 @@ void media_entity_pipeline_stop(struct media_entity *entity)
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

