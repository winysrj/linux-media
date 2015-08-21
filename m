Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:44335 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597AbbHUIIU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 04:08:20 -0400
Message-ID: <55D6DC48.3070406@xs4all.nl>
Date: Fri, 21 Aug 2015 10:07:36 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v6 2/8] [media] media: add a common struct to be embed
 on media graph objects
References: <cover.1439981515.git.mchehab@osg.samsung.com> <0622f35fe1287a61f7703ba3f99fd78e4f992806.1439981515.git.mchehab@osg.samsung.com> <1667127.681LBiMjnq@avalon>
In-Reply-To: <1667127.681LBiMjnq@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/2015 03:02 AM, Laurent Pinchart wrote:
> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Wednesday 19 August 2015 08:01:49 Mauro Carvalho Chehab wrote:
>> +/* Enums used internally at the media controller to represent graphs */
>> +
>> +/**
>> + * enum media_gobj_type - type of a graph element
> 
> Let's try to standardize the vocabulary, should it be called graph object or 
> graph element ? In the first case let's document it as graph object. In the 
> second case it would be more consistent to refer to it as enum 
> media_gelem_type (and struct media_gelem below).

For what it is worth, I prefer the term graph object.

> 
>> + *
>> + */
>> +enum media_gobj_type {
>> +	 /* FIXME: add the types here, as we embed media_gobj */
>> +	MEDIA_GRAPH_NONE
>> +};
>> +
>> +#define MEDIA_BITS_PER_TYPE		8
>> +#define MEDIA_BITS_PER_LOCAL_ID		(32 - MEDIA_BITS_PER_TYPE)
>> +#define MEDIA_LOCAL_ID_MASK		 GENMASK(MEDIA_BITS_PER_LOCAL_ID - 1, 0)
>> +
>> +/* Structs to represent the objects that belong to a media graph */
>> +
>> +/**
>> + * struct media_gobj - Define a graph object.
>> + *
>> + * @id:		Non-zero object ID identifier. The ID should be unique
>> + *		inside a media_device, as it is composed by
>> + *		MEDIA_BITS_PER_TYPE to store the type plus
>> + *		MEDIA_BITS_PER_LOCAL_ID	to store a per-type ID
>> + *		(called as "local ID").
> 
> I'd very much prefer using a single ID range and adding a type field. Abusing 
> bits of the ID field to store the type will just makes IDs impractical to use. 
> Let's do it properly.

Why is that impractical? I think it is more practical. Why waste memory on something
that is easy to encode in the ID?

I'm not necessarily opposed to splitting this up (Mauro's initial patch series used
a separate type field if I remember correctly), but it's not clear to me what the
benefits are. Keeping it in a single u32 makes describing links also very easy since
you just give it the two objects that are linked and it is immediately clear which
object types are linked: no need to either store the types in the link struct or
look up each object to find the type.

> 
>> + * All elements on the media graph should have this struct embedded
> 
> All elements (objects) or only the ones that need an ID ? Or maybe we'll 
> define graph element (object) as an element (object) that has an ID, making 
> some "elements" not elements.

Yes, all objects have an ID. I see no reason to special-case this.

You wrote this at 3 am, so you were probably sleep-deprived when you wrote the
second sentence as I can't wrap my head around that one :-)

> 
>> + */
>> +struct media_gobj {
>> +	u32			id;
>> +};
>> +
>> +
>>  struct media_pipeline {
>>  };
>>
>> @@ -118,6 +151,26 @@ static inline u32 media_entity_id(struct media_entity
>> *entity) return entity->id;
>>  }
>>
>> +static inline enum media_gobj_type media_type(struct media_gobj *gobj)
>> +{
>> +	return gobj->id >> MEDIA_BITS_PER_LOCAL_ID;
>> +}
>> +
>> +static inline u32 media_localid(struct media_gobj *gobj)
>> +{
>> +	return gobj->id & MEDIA_LOCAL_ID_MASK;
>> +}
>> +
>> +static inline u32 media_gobj_gen_id(enum media_gobj_type type, u32
>> local_id)
>> +{
>> +	u32 id;
>> +
>> +	id = type << MEDIA_BITS_PER_LOCAL_ID;
>> +	id |= local_id & MEDIA_LOCAL_ID_MASK;
>> +
>> +	return id;
>> +}
>> +
>>  #define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
>>  #define MEDIA_ENTITY_ENUM_MAX_ID	64
>>
>> @@ -131,6 +184,14 @@ struct media_entity_graph {
>>  	int top;
>>  };
>>
>> +#define gobj_to_entity(gobj) \
>> +		container_of(gobj, struct media_entity, graph_obj)
> 
> For consistency reason would this be called media_gobj_to_entity ? I would 
> also turn it into an inline function to ensure type checking.

Good one. I agree.

> 
>> +
>> +void media_gobj_init(struct media_device *mdev,
>> +		    enum media_gobj_type type,
>> +		    struct media_gobj *gobj);
>> +void media_gobj_remove(struct media_gobj *gobj);
>> +
>>  int media_entity_init(struct media_entity *entity, u16 num_pads,
>>  		struct media_pad *pads);
>>  void media_entity_cleanup(struct media_entity *entity);
> 

Regards,

	Hans
