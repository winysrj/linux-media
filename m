Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40793 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbcBLLW1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 06:22:27 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>
Subject: [PATCH 1/2] [media] au0828: get rid of AU0828_VMUX_DEBUG
Date: Fri, 12 Feb 2016 09:21:00 -0200
Message-Id: <b39a8de587466a0052e696d8ebc3987066784384.1455276050.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is not used on the driver. remove it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c | 12 +++---------
 drivers/media/usb/au0828/au0828.h       |  1 -
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 4164302dd8ac..2fc2b29d2dd9 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -698,10 +698,9 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 	for (i = 0; i < AU0828_MAX_INPUT; i++) {
 		struct media_entity *ent = &dev->input_ent[i];
 
-		if (AUVI_INPUT(i).type == AU0828_VMUX_UNDEFINED)
-			break;
-
 		switch (AUVI_INPUT(i).type) {
+		case AU0828_VMUX_UNDEFINED:
+			break;
 		case AU0828_VMUX_CABLE:
 		case AU0828_VMUX_TELEVISION:
 		case AU0828_VMUX_DVB:
@@ -716,7 +715,6 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 			break;
 		case AU0828_VMUX_COMPOSITE:
 		case AU0828_VMUX_SVIDEO:
-		default: /* AU0828_VMUX_DEBUG */
 			/* FIXME: fix the decoder PAD */
 			ret = media_create_pad_link(ent, 0, decoder, 0, 0);
 			if (ret)
@@ -1460,7 +1458,6 @@ static int vidioc_enum_input(struct file *file, void *priv,
 		[AU0828_VMUX_CABLE] = "Cable TV",
 		[AU0828_VMUX_TELEVISION] = "Television",
 		[AU0828_VMUX_DVB] = "DVB",
-		[AU0828_VMUX_DEBUG] = "tv debug"
 	};
 
 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
@@ -1952,7 +1949,6 @@ static void au0828_analog_create_entities(struct au0828_dev *dev)
 		[AU0828_VMUX_CABLE] = "Cable TV",
 		[AU0828_VMUX_TELEVISION] = "Television",
 		[AU0828_VMUX_DVB] = "DVB",
-		[AU0828_VMUX_DEBUG] = "tv debug"
 	};
 	int ret, i;
 
@@ -1988,11 +1984,9 @@ static void au0828_analog_create_entities(struct au0828_dev *dev)
 		case AU0828_VMUX_CABLE:
 		case AU0828_VMUX_TELEVISION:
 		case AU0828_VMUX_DVB:
+		default: /* Just to shut up a warning */
 			ent->function = MEDIA_ENT_F_CONN_RF;
 			break;
-		default: /* AU0828_VMUX_DEBUG */
-			ent->function = MEDIA_ENT_F_CONN_TEST;
-			break;
 		}
 
 		ret = media_entity_pads_init(ent, 1, &dev->input_pad[i]);
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 19fd6a841988..23f869cf11da 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -76,7 +76,6 @@ enum au0828_itype {
 	AU0828_VMUX_CABLE,
 	AU0828_VMUX_TELEVISION,
 	AU0828_VMUX_DVB,
-	AU0828_VMUX_DEBUG
 };
 
 struct au0828_input {
-- 
2.5.0

