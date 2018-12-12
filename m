Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCBB8C04EB8
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 08:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9760520839
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 08:43:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9760520839
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbeLLInJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 03:43:09 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:60808 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726242AbeLLInI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 03:43:08 -0500
Received: from [IPv6:2001:983:e9a7:1:d5c3:7636:7173:44a0] ([IPv6:2001:983:e9a7:1:d5c3:7636:7173:44a0])
        by smtp-cloud8.xs4all.net with ESMTPA
        id X06jgh319uDWoX06kgGtJD; Wed, 12 Dec 2018 09:43:06 +0100
Subject: Re: [RFCv4 PATCH 1/3] uapi/linux/media.h: add property support
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20181121154024.13906-1-hverkuil@xs4all.nl>
 <20181121154024.13906-2-hverkuil@xs4all.nl>
 <20181212061819.111a9631@coco.lan>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e26a07ef-836e-5943-508a-dd5f8c73f0cd@xs4all.nl>
Date:   Wed, 12 Dec 2018 09:43:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181212061819.111a9631@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNtgcrW9M82Bbhq/RNykyUjjphdJT8NezTIAqGeBe593dqtuIicr9Cl9mibSbEYIdLIFnGE9T8LGSa6tLqyZpOVCu9Tkouwx+PNHAGPuWGTK0UOfzihV
 kmLI5hAFMpXBdLT3wDJQgHumXFdFq3VWbL1nbic0UZaNMJ23coY3nI88jAl0b6RUmgqns1A9a5Rtpr9+p7wVySemp7Vz6PpJ8wuLzE7j/EzjOk/u+I3FilKN
 OmzKihdinuq92xDHXJSPdyp84hoOFF9OtwXdVthnAw5jw1VtdXJSJxa9TntFC1kqFjN28+QJPzk8hRmWMrnHUCkQlAuNtHhf4O2r1PVdHVeRDPyMQPMsbt7t
 HWO92vqY
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/12/18 9:18 AM, Mauro Carvalho Chehab wrote:
> Em Wed, 21 Nov 2018 16:40:22 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add a new topology struct that includes properties and adds
>> index fields to quickly find references from one object to
>> another in the topology arrays.
> 
> As mentioned on patch 0/3, hard to review it without documentation.
> 
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  include/uapi/linux/media.h | 88 ++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 84 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
>> index e5d0c5c611b5..a81e9723204c 100644
>> --- a/include/uapi/linux/media.h
>> +++ b/include/uapi/linux/media.h
>> @@ -144,6 +144,8 @@ struct media_device_info {
>>  /* Entity flags */
>>  #define MEDIA_ENT_FL_DEFAULT			(1 << 0)
>>  #define MEDIA_ENT_FL_CONNECTOR			(1 << 1)
>> +#define MEDIA_ENT_FL_PAD_IDX			(1 << 2)
>> +#define MEDIA_ENT_FL_PROP_IDX			(1 << 3)
>>  
>>  /* OR with the entity id value to find the next entity */
>>  #define MEDIA_ENT_ID_FLAG_NEXT			(1 << 31)
>> @@ -210,6 +212,9 @@ struct media_entity_desc {
>>  #define MEDIA_PAD_FL_SINK			(1 << 0)
>>  #define MEDIA_PAD_FL_SOURCE			(1 << 1)
>>  #define MEDIA_PAD_FL_MUST_CONNECT		(1 << 2)
>> +#define MEDIA_PAD_FL_LINK_IDX			(1 << 3)
>> +#define MEDIA_PAD_FL_PROP_IDX			(1 << 4)
>> +#define MEDIA_PAD_FL_ENTITY_IDX			(1 << 5)
>>  
>>  struct media_pad_desc {
>>  	__u32 entity;		/* entity ID */
>> @@ -221,6 +226,8 @@ struct media_pad_desc {
>>  #define MEDIA_LNK_FL_ENABLED			(1 << 0)
>>  #define MEDIA_LNK_FL_IMMUTABLE			(1 << 1)
>>  #define MEDIA_LNK_FL_DYNAMIC			(1 << 2)
> 
>> +#define MEDIA_LNK_FL_SOURCE_IDX			(1 << 3)
>> +#define MEDIA_LNK_FL_SINK_IDX			(1 << 4)
> 
> Why do we need those flags?
> 
>>  
>>  #define MEDIA_LNK_FL_LINK_TYPE			(0xf << 28)
>>  #  define MEDIA_LNK_FL_DATA_LINK		(0 << 28)
>> @@ -296,7 +303,9 @@ struct media_v2_entity {
>>  	char name[64];
>>  	__u32 function;		/* Main function of the entity */
>>  	__u32 flags;
>> -	__u32 reserved[5];
>> +	__u16 pad_idx;
>> +	__u16 prop_idx;
> 
> Hmm... pad_idx = 0 and prop_idx = 0 can't be used, in order to
> avoid breaking backward compat. It should be documented somewhere.

And that's why we have the flags: to indicate these index fields have
valid indices. I thought about reversing index 0, preventing it from
being used, but that's just ugly.

> 
> I've no idea what you intend here... an entity has multiple pads.
> linking it to a single one sounds a very bad idea. Also, this
> information is already present at the pads.

pad_idx is an index into the pads array where the pads for this entity
are stored. So all the pads for this entity are available starting at
index pad_idx and until the end of the pads array or the first pad with
a different entity ID. This way there is no need to create your own data
structures just to traverse the data structures.

Same for properties.

> 
> 
>> +	__u32 reserved[4];
>>  } __attribute__ ((packed));
>>  
>>  /* Should match the specific fields at media_intf_devnode */
>> @@ -305,11 +314,14 @@ struct media_v2_intf_devnode {
>>  	__u32 minor;
>>  } __attribute__ ((packed));
>>  
>> +#define MEDIA_INTF_FL_LINK_IDX			(1 << 0)
>> +
> 
> Why do we need it?
> 
>>  struct media_v2_interface {
>>  	__u32 id;
>>  	__u32 intf_type;
>>  	__u32 flags;
>> -	__u32 reserved[9];
>> +	__u16 link_idx;
>> +	__u16 reserved[17];
> 
> Why do we need a link_idx? The link itself already points to
> the interface. Also, that would limit the API if we ever
> need to have one interface with multiple links.

Same here: it is the index into the links array where the link for
this interface is stored.

> 
>>  
>>  	union {
>>  		struct media_v2_intf_devnode devnode;
>> @@ -331,7 +343,10 @@ struct media_v2_pad {
>>  	__u32 entity_id;
>>  	__u32 flags;
>>  	__u32 index;
>> -	__u32 reserved[4];
>> +	__u16 link_idx;
>> +	__u16 prop_idx;
>> +	__u16 entity_idx;
> 
> Same comments as above for link_idx and entity_idx.

And same comments from me.

> 
>> +	__u16 reserved[5];
>>  } __attribute__ ((packed));
>>  
>>  struct media_v2_link {
>> @@ -339,9 +354,68 @@ struct media_v2_link {
>>  	__u32 source_id;
>>  	__u32 sink_id;
>>  	__u32 flags;
>> -	__u32 reserved[6];
>> +	__u16 source_idx;
>> +	__u16 sink_idx;
> 
> What do you mean by source_idx and sink_idx?

Index of the source entity in the entities array. Ditto for the sink.
O(1) lookup for applications.

> 
>> +	__u32 reserved[5];
>>  } __attribute__ ((packed));
>>  
>> +#define MEDIA_PROP_TYPE_GROUP	1
>> +#define MEDIA_PROP_TYPE_U64	2
>> +#define MEDIA_PROP_TYPE_S64	3
>> +#define MEDIA_PROP_TYPE_STRING	4
>> +
>> +#define MEDIA_PROP_FL_OWNER			0xf
> 
> OWNER_TYPE? Just 0-15? Perhaps we should reserve more
> bits for it.

You are right, this should be 0xff (equivalent to MEDIA_BITS_PER_TYPE
as defined in media/media-entity.h).

> 
>> +#  define MEDIA_PROP_FL_ENTITY			0
>> +#  define MEDIA_PROP_FL_PAD			1
>> +#  define MEDIA_PROP_FL_LINK			2
>> +#  define MEDIA_PROP_FL_INTF			3
>> +#  define MEDIA_PROP_FL_PROP			4
>> +#define MEDIA_PROP_FL_PROP_IDX			(1 << 4)
> 
> Hmm... both OWNER and PROP_IDX are MEDIA_PROP_FL_*...
> are all of them mapped as flags? If so, it doesn't seem a 
> good idea to me to map both as flags.

I need to rename MEDIA_PROP_FL_OWNER to something like MEDIA_PROP_FL_OWNER_TYPE_MSK.
I.e. the first 8 (currently 4) bits of the flags field give the type of the object
that the property belongs to (entity, pad, link, interface, property).

The naming is confusing here.

> 
>> +
>> +/**
>> + * struct media_v2_prop - A media property
>> + *
>> + * @id:		The unique non-zero ID of this property
>> + * @owner_id:	The ID of the object this property belongs to
>> + * @type:	Property type
>> + * @flags:	Property flags
> 
> But here you added and explicit field for type and flags...
> I'm confused.

The type describes the property type: group, string, u64, s64.

Flags describe (among others) the type of the object that owns the property.

An alternative is to drop this and add a macro that extracts the object
type from an object ID since this is stored in the top 8 bits of the object
(graph) ID.

> 
>> + * @name:	Property name
>> + * @payload_size: Property payload size, 0 for U64/S64
>> + * @payload_offset: Property payload starts at this offset from &prop.id.
>> + *		This is 0 for U64/S64.
>> + * @prop_idx:	Index to sub-properties, 0 means there are no sub-properties.
>> + * @owner_idx:	Index to entities/pads/properties, depending on the owner ID
>> + *		type.
>> + * @reserved:	Property reserved field, will be zeroed.
>> + */
>> +struct media_v2_prop {
>> +	__u32 id;
>> +	__u32 owner_id;
>> +	__u32 type;
>> +	__u32 flags;
>> +	char name[32];
>> +	__u32 payload_size;
>> +	__u32 payload_offset;
>> +	__u16 prop_idx;
>> +	__u16 owner_idx;
>> +	__u32 reserved[17];
>> +} __attribute__ ((packed));
>> +
>> +static inline const char *media_prop2s(const struct media_v2_prop *prop)
> 
> Please call it "media_prop2string". Just "s" here is confusing.

What about media_prop2str()? Would that work for you?

> 
>> +{
>> +	return (const char *)prop + prop->payload_offset;
>> +}
>> +
>> +static inline __u64 media_prop2u64(const struct media_v2_prop *prop)
>> +{
>> +	return *(const __u64 *)((const char *)prop + prop->payload_offset);
>> +}
>> +
>> +static inline __s64 media_prop2s64(const struct media_v2_prop *prop)
>> +{
>> +	return *(const __s64 *)((const char *)prop + prop->payload_offset);
>> +}
>> +
>>  struct media_v2_topology {
>>  	__u64 topology_version;
>>  
>> @@ -360,6 +434,10 @@ struct media_v2_topology {
>>  	__u32 num_links;
>>  	__u32 reserved4;
>>  	__u64 ptr_links;
>> +
>> +	__u32 num_props;
>> +	__u32 props_payload_size;
>> +	__u64 ptr_props;
>>  } __attribute__ ((packed));
>>  
>>  /* ioctls */
>> @@ -368,6 +446,8 @@ struct media_v2_topology {
>>  #define MEDIA_IOC_ENUM_ENTITIES	_IOWR('|', 0x01, struct media_entity_desc)
>>  #define MEDIA_IOC_ENUM_LINKS	_IOWR('|', 0x02, struct media_links_enum)
>>  #define MEDIA_IOC_SETUP_LINK	_IOWR('|', 0x03, struct media_link_desc)
>> +/* Old MEDIA_IOC_G_TOPOLOGY ioctl without props support */
>> +#define MEDIA_IOC_G_TOPOLOGY_OLD 0xc0487c04
> 
> I would avoid calling it "_OLD". we may have a V3, V4, V5, ... of this
> ioctl.
> 
> I would, instead, define an _IOWR_COMPAT macro that would take an extra
> parameter, in order to get the size of part of the struct, e. g. something
> like:
> 
> #define MEDIA_IOC_G_TOPOLOGY_V1		_IOWR_COMPAT('|', 0x04, struct media_v2_topology, num_props)

That's not a bad idea, actually.

> 
> Also, I don't see any good reason why to keep this at uAPI (except for a
> mc-compliance tool that would test both versions - but this could be
> defined directly there).

Makes sense.

> 
>>  #define MEDIA_IOC_G_TOPOLOGY	_IOWR('|', 0x04, struct media_v2_topology)
>>  #define MEDIA_IOC_REQUEST_ALLOC	_IOR ('|', 0x05, int)
>>  
> 
> Thanks,
> Mauro
> 

Regards,

	Hans
