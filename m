Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:37483 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751534AbbHYNdZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 09:33:25 -0400
Message-ID: <55DC6DFF.1000204@xs4all.nl>
Date: Tue, 25 Aug 2015 15:30:39 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v7 18/44] [media] media: make media_link more generic
 to handle interace links
References: <cover.1440359643.git.mchehab@osg.samsung.com>	<cec7a29d26c1abc95bd0df9ca6a92910ec1561ad.1440359643.git.mchehab@osg.samsung.com>	<55DC1B91.70302@xs4all.nl> <20150825065343.5829158d@recife.lan>
In-Reply-To: <20150825065343.5829158d@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/25/15 11:53, Mauro Carvalho Chehab wrote:
> Em Tue, 25 Aug 2015 09:38:57 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 08/23/2015 10:17 PM, Mauro Carvalho Chehab wrote:
>>> By adding an union at media_link, we get for free a way to
>>> represent interface->entity links.
>>>
>>> No need to change anything at the code, just at the internal
>>> header file.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>
>>> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
>>> index 17bb5cbbd67d..f6e8fa801cf9 100644
>>> --- a/include/media/media-entity.h
>>> +++ b/include/media/media-entity.h
>>> @@ -75,14 +75,20 @@ struct media_pipeline {
>>>  struct media_link {
>>>  	struct media_gobj graph_obj;
>>>  	struct list_head list;
>>> -	struct media_pad *source;	/* Source pad */
>>> -	struct media_pad *sink;		/* Sink pad  */
>>> +	union {
>>> +		struct media_gobj *port0;
>>> +		struct media_pad *source;
>>> +	};
>>> +	union {
>>> +		struct media_gobj *port1;
>>
>> Why add port0 and port1 here instead of intf and entity (now added in patch 20)?
>> port0/port1 isn't used, so I'd postpone adding that until it is needed.
> 
> Because we need to use it to be able to identify the object type.
> This is used (actually, it should be used - see my comments for 19/44)
> on the next patch.

Ah, right. It makes much more sense when the debug function uses it. The
fact that it didn't confused me.

> 
>> Part of the reason is also that I am not convinced about the 'port' name, so
>> let's not add this yet.
> 
> I'm not bound to "port" name. If you have a better suggestion, this could
> easily be fixed.
> 
> However, we can't use here source/sink, as this means something
> directional, but the interface<->entity link is bidirectional.
> 
> I chose "port" because it is the ITU-T name for the graph element that
> represents the connection points at the entities.

Since it is a media_gobj pointer, I would think 'gobj0/1' would be more
sensible since that doesn't introduce a new name ('port').

Regards,

	Hans

> 
>>
>> Regards,
>>
>> 	Hans
>>
>>> +		struct media_pad *sink;
>>> +	};
>>>  	struct media_link *reverse;	/* Link in the reverse direction */
>>>  	unsigned long flags;		/* Link flags (MEDIA_LNK_FL_*) */
>>>  };
>>>  
>>>  struct media_pad {
>>> -	struct media_gobj graph_obj;
>>> +	struct media_gobj graph_obj;	/* should be the first object */
>>>  	struct media_entity *entity;	/* Entity this pad belongs to */
>>>  	u16 index;			/* Pad index in the entity pads array */
>>>  	unsigned long flags;		/* Pad flags (MEDIA_PAD_FL_*) */
>>> @@ -105,7 +111,7 @@ struct media_entity_operations {
>>>  };
>>>  
>>>  struct media_entity {
>>> -	struct media_gobj graph_obj;
>>> +	struct media_gobj graph_obj;	/* should be the first object */
>>>  	struct list_head list;
>>>  	const char *name;		/* Entity name */
>>>  	u32 type;			/* Entity type (MEDIA_ENT_T_*) */
>>> @@ -119,7 +125,7 @@ struct media_entity {
>>>  	u16 num_backlinks;		/* Number of backlinks */
>>>  
>>>  	struct media_pad *pads;		/* Pads array (num_pads objects) */
>>> -	struct list_head links;		/* Links list */
>>> +	struct list_head links;		/* Pad-to-pad links list */
>>>  
>>>  	const struct media_entity_operations *ops;	/* Entity operations */
>>>  
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
