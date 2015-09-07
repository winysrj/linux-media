Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34693 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbbIGOKa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Sep 2015 10:10:30 -0400
Subject: Re: [PATCH 4/5] [media] uvcvideo: create pad links after subdev
 registration
To: linux-kernel@vger.kernel.org
References: <1441296036-20727-1-git-send-email-javier@osg.samsung.com>
 <1441296036-20727-5-git-send-email-javier@osg.samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Message-ID: <55ED9AD1.1090205@osg.samsung.com>
Date: Mon, 7 Sep 2015 16:10:25 +0200
MIME-Version: 1.0
In-Reply-To: <1441296036-20727-5-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 09/03/2015 06:00 PM, Javier Martinez Canillas wrote:
> The uvc driver creates the pads links before the media entity is
> registered with the media device. This doesn't work now that obj
> IDs are used to create links so the media_device has to be set.
> 
> Move entities registration logic before pads links creation.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> ---
> 
>  drivers/media/usb/uvc/uvc_entity.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_entity.c b/drivers/media/usb/uvc/uvc_entity.c
> index 429e428ccd93..9dde1f86cc4b 100644
> --- a/drivers/media/usb/uvc/uvc_entity.c
> +++ b/drivers/media/usb/uvc/uvc_entity.c
> @@ -37,6 +37,10 @@ static int uvc_mc_register_entity(struct uvc_video_chain *chain,
>  	if (sink == NULL)
>  		return 0;
>  
> +	ret = v4l2_device_register_subdev(&chain->dev->vdev, &entity->subdev);

Testing this patch on an Exynos Chromebook that has a built-in USB camera, I
noticed that v4l2_device_register_subdev() was wrongly called for UVC entities
with UVC_ENTITY_TYPE() == UVC_TT_STREAMING.

So I have the following [0] v2 patch. This patch was tested on an Exynos5800
Peach Pi Chromebook using qv4l2 to test video capture and the output of the
media-ctl -p command was compared with and without the MC next gen patches
to verify that was identical in both cases.

The media-ctl -p output is: http://hastebin.com/enalitofoz.coffee

And the mc_next_gen -e -i -I -l output is http://hastebin.com/umevuragaq.pas

Normally I would just resend the complete series but since there are so many
in-flight patches, I preferred to only re-send this patch one in this thread.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America


[0]:
>From 8be356e77eeefdc5c0738dd429205f3398c5b76c Mon Sep 17 00:00:00 2001
From: Javier Martinez Canillas <javier@osg.samsung.com>
Date: Thu, 3 Sep 2015 13:46:06 +0200
Subject: [PATCH v2 4/5] [media] uvcvideo: create pad links after subdev
 registration

The uvc driver creates the pads links before the media entity is
registered with the media device. This doesn't work now that obj
IDs are used to create links so the media_device has to be set.

Move entities registration logic before pads links creation.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

Changes since v1:
 - Don't try to register a UVC entity subdev for type UVC_TT_STREAMING.

 drivers/media/usb/uvc/uvc_entity.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_entity.c b/drivers/media/usb/uvc/uvc_entity.c
index 429e428ccd93..7f82b65b238e 100644
--- a/drivers/media/usb/uvc/uvc_entity.c
+++ b/drivers/media/usb/uvc/uvc_entity.c
@@ -26,6 +26,15 @@
 static int uvc_mc_register_entity(struct uvc_video_chain *chain,
 	struct uvc_entity *entity)
 {
+	if (UVC_ENTITY_TYPE(entity) == UVC_TT_STREAMING)
+		return 0;
+
+	return v4l2_device_register_subdev(&chain->dev->vdev, &entity->subdev);
+}
+
+static int uvc_mc_create_pads_links(struct uvc_video_chain *chain,
+				    struct uvc_entity *entity)
+{
 	const u32 flags = MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE;
 	struct media_entity *sink;
 	unsigned int i;
@@ -62,10 +71,7 @@ static int uvc_mc_register_entity(struct uvc_video_chain *chain,
 			return ret;
 	}
 
-	if (UVC_ENTITY_TYPE(entity) == UVC_TT_STREAMING)
-		return 0;
-
-	return v4l2_device_register_subdev(&chain->dev->vdev, &entity->subdev);
+	return 0;
 }
 
 static struct v4l2_subdev_ops uvc_subdev_ops = {
@@ -124,5 +130,14 @@ int uvc_mc_register_entities(struct uvc_video_chain *chain)
 		}
 	}
 
+	list_for_each_entry(entity, &chain->entities, chain) {
+		ret = uvc_mc_create_pads_links(chain, entity);
+		if (ret < 0) {
+			uvc_printk(KERN_INFO, "Failed to create pads links for "
+				   "entity %u\n", entity->id);
+			return ret;
+		}
+	}
+
 	return 0;
 }
-- 
2.4.3
