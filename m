Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:43561 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752869AbbGVWm4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 18:42:56 -0400
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
Subject: [PATCH v2 14/19] media: Add enable_source handler field to struct media_device
Date: Wed, 22 Jul 2015 16:42:15 -0600
Message-Id: <352c24377393df058cf5e72dc988a02029e3bbda.1437599281.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1437599281.git.shuahkh@osg.samsung.com>
References: <cover.1437599281.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1437599281.git.shuahkh@osg.samsung.com>
References: <cover.1437599281.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new field to enable_source handler to find source entity
for the sink entity and check if it is available, and activate
the link using media_entity_setup_link() interface. Bridge driver
is expected to implement and set the handler when media_device is
registered or when bridge driver finds the media_device during
probe. This is to enable the use-case to find tuner entity
connected to the decoder entity and check if it is available,
and activate the using media_entity_setup_link() if it is available.
This hanlder can be invoked from media core (v4l-core, dvb-core)
as well as other drivers such as ALSA that control the media device.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 include/media/media-device.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/media/media-device.h b/include/media/media-device.h
index e73642c..377102b 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -84,6 +84,18 @@ struct media_device {
 	/* Serializes graph operations. */
 	spinlock_t graph_lock;
 
+	/* Handler to find source entity for the sink entity and
+	 * check if it is available, and activate the link using
+	 * media_entity_setup_link() interface.
+	 * Bridge driver is expected to implement and set the
+	 * handler when media_device is registered or when
+	 * bridge driver finds the media_device during probe.
+	 *
+	 * Use-case: find tuner entity connected to the decoder
+	 * entity and check if it is available, and activate the
+	 * using media_entity_setup_link() if it is available.
+	*/
+	int (*enable_source)(struct media_entity *sink);
 	int (*link_notify)(struct media_link *link, u32 flags,
 			   unsigned int notification);
 };
-- 
2.1.4

