Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41175 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933273AbbLGPE5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2015 10:04:57 -0500
Subject: Re: [PATCH 4/5] [media] uvcvideo: create pad links after subdev
 registration
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1441296036-20727-1-git-send-email-javier@osg.samsung.com>
 <1441296036-20727-5-git-send-email-javier@osg.samsung.com>
 <55ED9AD1.1090205@osg.samsung.com> <2329250.FAlNbDTqBe@avalon>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Message-ID: <5665A012.90509@osg.samsung.com>
Date: Mon, 7 Dec 2015 12:04:50 -0300
MIME-Version: 1.0
In-Reply-To: <2329250.FAlNbDTqBe@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

On 12/05/2015 11:44 PM, Laurent Pinchart wrote:
> Hi Javier,
> 
> Thank you for the patch.
>

Thanks for your review.
 
> On Monday 07 September 2015 16:10:25 Javier Martinez Canillas wrote:
> 
> [snip]
> 
>> From 8be356e77eeefdc5c0738dd429205f3398c5b76c Mon Sep 17 00:00:00 2001
>> From: Javier Martinez Canillas <javier@osg.samsung.com>
>> Date: Thu, 3 Sep 2015 13:46:06 +0200
>> Subject: [PATCH v2 4/5] [media] uvcvideo: create pad links after subdev
>>  registration
>>
>> The uvc driver creates the pads links before the media entity is
>> registered with the media device. This doesn't work now that obj
>> IDs are used to create links so the media_device has to be set.
>>
>> Move entities registration logic before pads links creation.
>>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>> ---
>>
>> Changes since v1:
>>  - Don't try to register a UVC entity subdev for type UVC_TT_STREAMING.
>>
>>  drivers/media/usb/uvc/uvc_entity.c | 23 +++++++++++++++++++----
>>  1 file changed, 19 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/usb/uvc/uvc_entity.c
>> b/drivers/media/usb/uvc/uvc_entity.c index 429e428ccd93..7f82b65b238e
>> 100644
>> --- a/drivers/media/usb/uvc/uvc_entity.c
>> +++ b/drivers/media/usb/uvc/uvc_entity.c
>> @@ -26,6 +26,15 @@
>>  static int uvc_mc_register_entity(struct uvc_video_chain *chain,
>>         struct uvc_entity *entity)
>>  {
>> +       if (UVC_ENTITY_TYPE(entity) == UVC_TT_STREAMING)
>> +               return 0;
>> +
>> +       return v4l2_device_register_subdev(&chain->dev->vdev,
>> &entity->subdev);
>> +}
>> +
>> +static int uvc_mc_create_pads_links(struct uvc_video_chain *chain,
>> +                                   struct uvc_entity *entity)
>> +{
>>         const u32 flags = MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE;
>>         struct media_entity *sink;
>>         unsigned int i;
>> @@ -62,10 +71,7 @@ static int uvc_mc_register_entity(struct uvc_video_chain
>> *chain, return ret;
>>         }
>>  
>> -       if (UVC_ENTITY_TYPE(entity) == UVC_TT_STREAMING)
>> -               return 0;
>> -
>> -       return v4l2_device_register_subdev(&chain->dev->vdev,
>> &entity->subdev);
>> +       return 0;
>>  }
>>  
>>  static struct v4l2_subdev_ops uvc_subdev_ops = {
>> @@ -124,5 +130,14 @@ int uvc_mc_register_entities(struct uvc_video_chain
>> *chain) }
>>         }
>>  
>> +       list_for_each_entry(entity, &chain->entities, chain) {
>> +               ret = uvc_mc_create_pads_links(chain, entity);
> 
> You can call this uvc_mc_create_links(), there's no other type of links in the 
> driver.
>

Ok.
 
>> +               if (ret < 0) {
>> +                       uvc_printk(KERN_INFO, "Failed to create pads links
>> for "
> 
> Same here, I'd s/pad links/links/.
>

Ok.
 
>> +                                  "entity %u\n", entity->id);
>> +                       return ret;
>> +               }
>> +       }
> 
> This creates three loops, and I think that's one too much. The reason why init 
> and register are separate is that the latter creates links, which requires all 
> entities to be initialized. If you move link create after registration I 
> believe you can init and register in a single loop (just move the 
> v4l2_device_register_subdev() call in the appropriate location in 
> uvc_mc_init_entity()) and then create links in a second loop.
> 

You are right, I'll simplify this to only have two loops as suggested.

>>         return 0;
>>  }
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
