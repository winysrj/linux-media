Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:42738 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755503AbbGTNBG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:01:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/12] usbvision: fix standards for S-Video/Composite inputs.
Date: Mon, 20 Jul 2015 14:59:37 +0200
Message-Id: <1437397178-5013-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
References: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The standards supported by S-Video and Composite inputs are not
limited by PAL, so make it more generic.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/usbvision/usbvision-video.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index a5e82c0..6ad3d56 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -540,7 +540,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 			strcpy(vi->name, "Green Video Input");
 		else
 			strcpy(vi->name, "Composite Video Input");
-		vi->std = V4L2_STD_PAL;
+		vi->std = USBVISION_NORMS;
 		break;
 	case 2:
 		vi->type = V4L2_INPUT_TYPE_CAMERA;
@@ -548,12 +548,12 @@ static int vidioc_enum_input(struct file *file, void *priv,
 			strcpy(vi->name, "Yellow Video Input");
 		else
 			strcpy(vi->name, "S-Video Input");
-		vi->std = V4L2_STD_PAL;
+		vi->std = USBVISION_NORMS;
 		break;
 	case 3:
 		vi->type = V4L2_INPUT_TYPE_CAMERA;
 		strcpy(vi->name, "Red Video Input");
-		vi->std = V4L2_STD_PAL;
+		vi->std = USBVISION_NORMS;
 		break;
 	}
 	return 0;
-- 
2.1.4

