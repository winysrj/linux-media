Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:46399 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758790AbbIVR2F (ORCPT
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
Subject: [PATCH v3 12/21] media: au0828 fix au0828_create_media_graph() entity checks
Date: Tue, 22 Sep 2015 11:19:31 -0600
Message-Id: <9a717e8f411fc1a1bac2c984f154ada401a9186c.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

au0828_create_media_graph() checks if entity.links is null
or not to determine, if vbi_dev and vdev entities have been
registered. Checking entity.parent field is right way, as
parent field gets initialized when entity is registered. Fix
it to check entity.parent field.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 276598b..0b8dc49 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -263,11 +263,11 @@ static void au0828_create_media_graph(struct au0828_dev *dev)
 	if (tuner)
 		media_entity_create_link(tuner, 0, decoder, 0,
 					 MEDIA_LNK_FL_ENABLED);
-	if (dev->vdev.entity.links)
+	if (dev->vdev.entity.parent)
 		media_entity_create_link(decoder, AU8522_PAD_VID_OUT,
 					 &dev->vdev.entity, 0,
 					 MEDIA_LNK_FL_ENABLED);
-	if (dev->vbi_dev.entity.links)
+	if (dev->vbi_dev.entity.parent)
 		media_entity_create_link(decoder, AU8522_PAD_VBI_OUT,
 					 &dev->vbi_dev.entity, 0,
 					 MEDIA_LNK_FL_ENABLED);
-- 
2.1.4

