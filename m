Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:51553 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504AbbJBWHm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2015 18:07:42 -0400
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
Subject: [PATCH MC Next Gen 10/20] media: au0828 Use au8522_media_pads enum for pad defines
Date: Fri,  2 Oct 2015 16:07:22 -0600
Message-Id: <d319d6a1975a21f070b3e4524554c52b60bed0ca.1443822799.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1443822799.git.shuahkh@osg.samsung.com>
References: <cover.1443822799.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1443822799.git.shuahkh@osg.samsung.com>
References: <cover.1443822799.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change au0828-core to use au8522_media_pads enum defines
instead of hard-coding the pad values when it creates
media graph linking decode pads to other entities.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 1c12285..b04c2a5 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -20,6 +20,7 @@
  */
 
 #include "au0828.h"
+#include "au8522.h"
 
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -286,11 +287,13 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 		if (ret)
 			return ret;
 	}
-	ret = media_create_pad_link(decoder, 1, &dev->vdev.entity, 0,
+	ret = media_create_pad_link(decoder, AU8522_PAD_VID_OUT,
+				    &dev->vdev.entity, 0,
 			 	    MEDIA_LNK_FL_ENABLED);
 	if (ret)
 		return ret;
-	ret = media_create_pad_link(decoder, 2, &dev->vbi_dev.entity, 0,
+	ret = media_create_pad_link(decoder, AU8522_PAD_VBI_OUT,
+				    &dev->vbi_dev.entity, 0,
 				    MEDIA_LNK_FL_ENABLED);
 	if (ret)
 		return ret;
-- 
2.1.4

