Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:37762 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758766AbbIVR2C (ORCPT
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
Subject: [PATCH v3 04/21] media: Media Controller enable/disable source handler API
Date: Tue, 22 Sep 2015 11:19:23 -0600
Message-Id: <2cf8f0b5ea1c63c3897a82d430a993e2af646220.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new fields to struct media_device to add enable_source, and
disable_source handlers, and source_priv to stash driver private
data that is need to run these handlers. The enable_source handler
finds source entity for the passed in entity and check if it is
available, and activate the link using __media_entity_setup_link()
interface. Bridge driver is expected to implement and set these
handlers and private data when media_device is registered or when
bridge driver finds the media_device during probe. This is to enable
the use-case to find tuner entity connected to the decoder entity and
check if it is available, and activate it and start pipeline between
the source and the entity. The disable_source handler deactivates the
link and stops the pipeline. This handler can be invoked from the
media core (v4l-core, dvb-core) as well as other drivers such as ALSA
that control the media device.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 include/media/media-device.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/media/media-device.h b/include/media/media-device.h
index a3854f6..117c169 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -84,6 +84,24 @@ struct media_device {
 	/* Serializes graph operations. */
 	struct mutex graph_mutex;
 
+	/* Handlers to find source entity for the sink entity and
+	 * check if it is available, and activate the link using
+	 * media_entity_setup_link() interface and start pipeline
+	 * from the source to the entity.
+	 * Bridge driver is expected to implement and set the
+	 * handler when media_device is registered or when
+	 * bridge driver finds the media_device during probe.
+	 * Bridge driver sets source_priv with information
+	 * necessary to run enable/disable source handlers.
+	 *
+	 * Use-case: find tuner entity connected to the decoder
+	 * entity and check if it is available, and activate the
+	 * using media_entity_setup_link() if it is available.
+	*/
+	void *source_priv;
+	int (*enable_source)(struct media_entity *entity,
+			     struct media_pipeline *pipe);
+	void (*disable_source)(struct media_entity *entity);
 	int (*link_notify)(struct media_link *link, u32 flags,
 			   unsigned int notification);
 };
-- 
2.1.4

