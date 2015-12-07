Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41190 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932855AbbLGPId (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2015 10:08:33 -0500
Subject: Re: [PATCH 3/5] [media] v4l: vsp1: separate links creation from
 entities init
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1441296036-20727-1-git-send-email-javier@osg.samsung.com>
 <1441296036-20727-4-git-send-email-javier@osg.samsung.com>
 <7559062.XA9lTlmQ7K@avalon>
Cc: linux-kernel@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-sh@vger.kernel.org, linux-media@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <5665A0EB.5050202@osg.samsung.com>
Date: Mon, 7 Dec 2015 12:08:27 -0300
MIME-Version: 1.0
In-Reply-To: <7559062.XA9lTlmQ7K@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

On 12/05/2015 11:51 PM, Laurent Pinchart wrote:
> Hi Javier,
> 
> Thank you for the patch.
>

Thanks for your feedback.
 
> On Thursday 03 September 2015 18:00:34 Javier Martinez Canillas wrote:
>> The vsp1 driver initializes the entities and creates the pads links
>> before the entities are registered with the media device. This doesn't
>> work now that object IDs are used to create links so the media_device
>> has to be set.
>>
>> Split out the pads links creation from the entity initialization so are
>> made after the entities registration.
>>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>> ---
>>
>>  drivers/media/platform/vsp1/vsp1_drv.c  | 14 ++++++++++--
>>  drivers/media/platform/vsp1/vsp1_rpf.c  | 29 ++++++++++++++++--------
>>  drivers/media/platform/vsp1/vsp1_rwpf.h |  5 +++++
>>  drivers/media/platform/vsp1/vsp1_wpf.c  | 40 +++++++++++++++++-------------
>>  4 files changed, 62 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c
>> b/drivers/media/platform/vsp1/vsp1_drv.c index 2aa427d3ff39..8f995d267646
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_drv.c
>> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
>> @@ -260,9 +260,19 @@ static int vsp1_create_entities(struct vsp1_device
>> *vsp1)
>>
>>  	/* Create links. */
>>  	list_for_each_entry(entity, &vsp1->entities, list_dev) {
>> -		if (entity->type == VSP1_ENTITY_LIF ||
>> -		    entity->type == VSP1_ENTITY_RPF)
>> +		if (entity->type == VSP1_ENTITY_LIF) {
>> +			ret = vsp1_wpf_create_pads_links(vsp1, entity);
> 
> Could you please s/pads_links/links/ ? There's no other type of links handled 
> by the driver.
>

Sure, I'll do that for all the drivers that only handle pad links.
 
>> +			if (ret < 0)
>> +				goto done;
>> +			continue;
> 
> I would use
> 
> 	} else if (...) {
> 
> instead of a continue.
>

Yes, that will be better indeed.
 
>> +		}
>> +
>> +		if (entity->type == VSP1_ENTITY_RPF) {
>> +			ret = vsp1_rpf_create_pads_links(vsp1, entity);
>> +			if (ret < 0)
>> +				goto done;
>>  			continue;
> 
> Same here.
>

Ok.
 
> Apart from that,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>

Thanks.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
