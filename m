Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC2E5C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 17:13:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92FD620851
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 17:13:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92FD620851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbeLMRNG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 12:13:06 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:37071 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727511AbeLMRNG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 12:13:06 -0500
Received: from [IPv6:2001:983:e9a7:1:8c39:f7d7:e233:2ba6] ([IPv6:2001:983:e9a7:1:8c39:f7d7:e233:2ba6])
        by smtp-cloud9.xs4all.net with ESMTPA
        id XUXngrsFIMlDTXUXogPoFY; Thu, 13 Dec 2018 18:13:04 +0100
Subject: Re: [RFCv5 PATCH 1/4] uapi/linux/media.h: add property support
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20181213134113.15247-1-hverkuil-cisco@xs4all.nl>
 <20181213134113.15247-2-hverkuil-cisco@xs4all.nl>
 <20181213144113.713ce59c@coco.lan>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <44af48c1-8daf-7022-6cda-bf984f9d2322@xs4all.nl>
Date:   Thu, 13 Dec 2018 18:13:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181213144113.713ce59c@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFMNN81c2/a4eKNtSjZOu3VCh7o4Kl0Kd0vdw9s/iGxfZdoVuoCj/F6AtQR2Gt3DjSpEVJuppVaz/j1vom67brI/UWDYJgJ6IQR1c3NSWWCrEx9ZN9A4
 PStbuFqfeeECHy3LskJ5lIZHJJt9PB8lvXMS6CNFcr0/s4R4pcdX2oAL/LEsVWcWxLqQT3wJWTT3p0lufcYiW8/iiBZ+3UGrQvcFDZrR+JcCczh+pEhGjWWs
 AkibX5rxSnk6btn0e9YBGPvXiIo5R37PaApbFtFsTbs6vXmqFz1vivcERKeC+c8DKGl4H8rKQ+OzrClThe5+Y7qrxcXxLaNeyZFTkzzfrQyQhAzlxCCJQZZg
 ef5DMJ8j
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/13/18 5:41 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 13 Dec 2018 14:41:10 +0100
> hverkuil-cisco@xs4all.nl escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Extend the topology struct with a properties array.
>>
>> Add a new media_v2_prop structure to store property information.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  include/uapi/linux/media.h | 56 ++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 56 insertions(+)
>>
>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
>> index e5d0c5c611b5..12982327381e 100644
>> --- a/include/uapi/linux/media.h
>> +++ b/include/uapi/linux/media.h
>> @@ -342,6 +342,58 @@ struct media_v2_link {
>>  	__u32 reserved[6];
>>  } __attribute__ ((packed));
>>  
>> +#define MEDIA_PROP_TYPE_GROUP	1
>> +#define MEDIA_PROP_TYPE_U64	2
>> +#define MEDIA_PROP_TYPE_S64	3
>> +#define MEDIA_PROP_TYPE_STRING	4
> 
>> +#define MEDIA_OWNER_TYPE_ENTITY			0
>> +#define MEDIA_OWNER_TYPE_PAD			1
>> +#define MEDIA_OWNER_TYPE_LINK			2
>> +#define MEDIA_OWNER_TYPE_INTF			3
>> +#define MEDIA_OWNER_TYPE_PROP			4
> 
>> +
>> +/**
>> + * struct media_v2_prop - A media property
>> + *
>> + * @id:		The unique non-zero ID of this property
>> + * @type:	Property type
> 
>> + * @owner_id:	The ID of the object this property belongs to
> 
> I'm in doubt about this. With this field, properties and objects
> will have a 1:1 mapping. If this is removed, it would be possible
> to map 'n' objects to a single property (N:1 mapping), with could
> be interesting.

But then every object would somehow have to list all the properties
that belong to it. That doesn't easily fit in e.g. the entities array
that's returned by G_TOPOLOGY.

> 
>> + * @owner_type:	The type of the object this property belongs to
> 
> I would remove this (and the corresponding defines). The type
> can easily be identified from the owner_id - as it already contains
> the object type embedded at the ID.
> In other words, it is:
> 
> 	owner_type = (owner_id & MEDIA_ENT_TYPE_MASK) >> MEDIA_ENT_TYPE_SHIFT;

I'm fine with that as well, but you expose how the ID is constructed as part of
the uAPI. And you can't later change that.

If nobody has a problem with that, then I can switch to this.

> 
>> + * @flags:	Property flags
>> + * @name:	Property name
>> + * @payload_size: Property payload size, 0 for U64/S64
>> + * @payload_offset: Property payload starts at this offset from &prop.id.
>> + *		This is 0 for U64/S64.
> 
> Please specify how this will be used for the group type, with is not
> obvious. I *suspect* that, on a group, you'll be adding a vector of
> u32 (cpu endian) and payload_size is the number of elements at the
> vector (or the vector size?).

Ah, sorry, groups were added later and the comments above were not updated.
A group property has no payload, so these payload fields are 0. A group really
just has a name and an ID, and that ID is referred to as the owner_id by
subproperties.

So you can have an entity with a 'sensor' group property, and that can have
a sub-property called 'orientation'.

These properties will be part of the uAPI, so they will have to be defined
and documented. So in this example you'd have to document the sensor.orientation
property.

> 
>> + * @reserved:	Property reserved field, will be zeroed.
>> + */
>> +struct media_v2_prop {
>> +	__u32 id;
>> +	__u32 type;
>> +	__u32 owner_id;
>> +	__u32 owner_type;
>> +	__u32 flags;
> 
> The way it is defined, name won't be 64-bits aligned (well, it will, if
> you remove the owner_type).

Why should name be 64 bit aligned? Not that I mind moving 'flags' after
'name'.

> 
>> +	char name[32];
>> +	__u32 payload_size;
>> +	__u32 payload_offset;
>> +	__u32 reserved[18];

If we keep owner_type, then 18 should be changed to 17. I forgot that.

>> +} __attribute__ ((packed));
>> +
>> +static inline const char *media_prop2string(const struct media_v2_prop *prop)
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
> 
> Shouldn't you define also a media_prop2group()?

No, groups have no payload.

> 
>>  struct media_v2_topology {
>>  	__u64 topology_version;
>>  
>> @@ -360,6 +412,10 @@ struct media_v2_topology {
>>  	__u32 num_links;
>>  	__u32 reserved4;
>>  	__u64 ptr_links;
>> +
>> +	__u32 num_props;
>> +	__u32 props_payload_size;
>> +	__u64 ptr_props;
> 
> Please document those new fields.

This struct doesn't have any docbook documentation. I can add that once everyone agrees
with this API.

Regards,

	Hans

> 
>>  } __attribute__ ((packed));
>>  
>>  /* ioctls */
> 
> 
> 
> Thanks,
> Mauro
> 

