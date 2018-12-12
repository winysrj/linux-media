Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,T_MIXED_ES,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E767C04EB8
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 08:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF3D22086D
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 08:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544602706;
	bh=uMqjeKS5jfpNVGBlOQhPp0iCt59gnb6qd9kQaZ6sbSg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=cD9viFTBXJhWEHa0SpTA0Svyqzz8XOm2491yvLHxbSwgBGCLWhwHRtoBQwA9KCoFp
	 t9fU6Hs+Xj2zdfOoGDJ8THDmmK9ngR9VJtm+HPkSSAyYgwfZdYXCMs0idVE4PDa055
	 UkvUQne8ydRvnu8DSjkvtyQRGkWkPl8DLvLLGhFc=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF3D22086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbeLLIS0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 03:18:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:54168 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbeLLIS0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 03:18:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fLMJbZx4pEAyn4jQRtDG+guOuCFxbNFxGFUZk0ZOel0=; b=ouYxr7kQ8dLGZ5MLz0Ssj6fAh0
        C7aJJJ8TQvuJHeFr/F5jJ8yxtZg99IteGqiQDSqs8vcpl+9QJCaoGyfgjkZIPd+pANFngZIj5TnWt
        mXnNFpO/MfR9ADNGqSMovGr3ydWIUGXY95LZxLW0vLEqbMcZlQjc8bhqiMwRoy4nqp85fv/HwnrDJ
        7P1wVSTfibLoojJALpGeF2IHIEh0smK4WEQ2Hq45EHHujzjcj1ow4eMGcDjEIr6X46Iq+wU/Qz80M
        A5djClsR2eNfLCEao/BmR1SdIH7vOsMIGuXGjIPFDuADYyAQlHiUO+CqjDwMkzjOVrMAiVr6mOcTb
        iY2IA8qw==;
Received: from [177.159.254.7] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gWzip-0005d0-Ej; Wed, 12 Dec 2018 08:18:23 +0000
Date:   Wed, 12 Dec 2018 06:18:19 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv4 PATCH 1/3] uapi/linux/media.h: add property support
Message-ID: <20181212061819.111a9631@coco.lan>
In-Reply-To: <20181121154024.13906-2-hverkuil@xs4all.nl>
References: <20181121154024.13906-1-hverkuil@xs4all.nl>
        <20181121154024.13906-2-hverkuil@xs4all.nl>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 21 Nov 2018 16:40:22 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add a new topology struct that includes properties and adds
> index fields to quickly find references from one object to
> another in the topology arrays.

As mentioned on patch 0/3, hard to review it without documentation.

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  include/uapi/linux/media.h | 88 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 84 insertions(+), 4 deletions(-)
> 
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index e5d0c5c611b5..a81e9723204c 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -144,6 +144,8 @@ struct media_device_info {
>  /* Entity flags */
>  #define MEDIA_ENT_FL_DEFAULT			(1 << 0)
>  #define MEDIA_ENT_FL_CONNECTOR			(1 << 1)
> +#define MEDIA_ENT_FL_PAD_IDX			(1 << 2)
> +#define MEDIA_ENT_FL_PROP_IDX			(1 << 3)
>  
>  /* OR with the entity id value to find the next entity */
>  #define MEDIA_ENT_ID_FLAG_NEXT			(1 << 31)
> @@ -210,6 +212,9 @@ struct media_entity_desc {
>  #define MEDIA_PAD_FL_SINK			(1 << 0)
>  #define MEDIA_PAD_FL_SOURCE			(1 << 1)
>  #define MEDIA_PAD_FL_MUST_CONNECT		(1 << 2)
> +#define MEDIA_PAD_FL_LINK_IDX			(1 << 3)
> +#define MEDIA_PAD_FL_PROP_IDX			(1 << 4)
> +#define MEDIA_PAD_FL_ENTITY_IDX			(1 << 5)
>  
>  struct media_pad_desc {
>  	__u32 entity;		/* entity ID */
> @@ -221,6 +226,8 @@ struct media_pad_desc {
>  #define MEDIA_LNK_FL_ENABLED			(1 << 0)
>  #define MEDIA_LNK_FL_IMMUTABLE			(1 << 1)
>  #define MEDIA_LNK_FL_DYNAMIC			(1 << 2)

> +#define MEDIA_LNK_FL_SOURCE_IDX			(1 << 3)
> +#define MEDIA_LNK_FL_SINK_IDX			(1 << 4)

Why do we need those flags?

>  
>  #define MEDIA_LNK_FL_LINK_TYPE			(0xf << 28)
>  #  define MEDIA_LNK_FL_DATA_LINK		(0 << 28)
> @@ -296,7 +303,9 @@ struct media_v2_entity {
>  	char name[64];
>  	__u32 function;		/* Main function of the entity */
>  	__u32 flags;
> -	__u32 reserved[5];
> +	__u16 pad_idx;
> +	__u16 prop_idx;

Hmm... pad_idx = 0 and prop_idx = 0 can't be used, in order to
avoid breaking backward compat. It should be documented somewhere.

I've no idea what you intend here... an entity has multiple pads.
linking it to a single one sounds a very bad idea. Also, this
information is already present at the pads.


> +	__u32 reserved[4];
>  } __attribute__ ((packed));
>  
>  /* Should match the specific fields at media_intf_devnode */
> @@ -305,11 +314,14 @@ struct media_v2_intf_devnode {
>  	__u32 minor;
>  } __attribute__ ((packed));
>  
> +#define MEDIA_INTF_FL_LINK_IDX			(1 << 0)
> +

Why do we need it?

>  struct media_v2_interface {
>  	__u32 id;
>  	__u32 intf_type;
>  	__u32 flags;
> -	__u32 reserved[9];
> +	__u16 link_idx;
> +	__u16 reserved[17];

Why do we need a link_idx? The link itself already points to
the interface. Also, that would limit the API if we ever
need to have one interface with multiple links.

>  
>  	union {
>  		struct media_v2_intf_devnode devnode;
> @@ -331,7 +343,10 @@ struct media_v2_pad {
>  	__u32 entity_id;
>  	__u32 flags;
>  	__u32 index;
> -	__u32 reserved[4];
> +	__u16 link_idx;
> +	__u16 prop_idx;
> +	__u16 entity_idx;

Same comments as above for link_idx and entity_idx.

> +	__u16 reserved[5];
>  } __attribute__ ((packed));
>  
>  struct media_v2_link {
> @@ -339,9 +354,68 @@ struct media_v2_link {
>  	__u32 source_id;
>  	__u32 sink_id;
>  	__u32 flags;
> -	__u32 reserved[6];
> +	__u16 source_idx;
> +	__u16 sink_idx;

What do you mean by source_idx and sink_idx?

> +	__u32 reserved[5];
>  } __attribute__ ((packed));
>  
> +#define MEDIA_PROP_TYPE_GROUP	1
> +#define MEDIA_PROP_TYPE_U64	2
> +#define MEDIA_PROP_TYPE_S64	3
> +#define MEDIA_PROP_TYPE_STRING	4
> +
> +#define MEDIA_PROP_FL_OWNER			0xf

OWNER_TYPE? Just 0-15? Perhaps we should reserve more
bits for it.

> +#  define MEDIA_PROP_FL_ENTITY			0
> +#  define MEDIA_PROP_FL_PAD			1
> +#  define MEDIA_PROP_FL_LINK			2
> +#  define MEDIA_PROP_FL_INTF			3
> +#  define MEDIA_PROP_FL_PROP			4
> +#define MEDIA_PROP_FL_PROP_IDX			(1 << 4)

Hmm... both OWNER and PROP_IDX are MEDIA_PROP_FL_*...
are all of them mapped as flags? If so, it doesn't seem a 
good idea to me to map both as flags.

> +
> +/**
> + * struct media_v2_prop - A media property
> + *
> + * @id:		The unique non-zero ID of this property
> + * @owner_id:	The ID of the object this property belongs to
> + * @type:	Property type
> + * @flags:	Property flags

But here you added and explicit field for type and flags...
I'm confused.

> + * @name:	Property name
> + * @payload_size: Property payload size, 0 for U64/S64
> + * @payload_offset: Property payload starts at this offset from &prop.id.
> + *		This is 0 for U64/S64.
> + * @prop_idx:	Index to sub-properties, 0 means there are no sub-properties.
> + * @owner_idx:	Index to entities/pads/properties, depending on the owner ID
> + *		type.
> + * @reserved:	Property reserved field, will be zeroed.
> + */
> +struct media_v2_prop {
> +	__u32 id;
> +	__u32 owner_id;
> +	__u32 type;
> +	__u32 flags;
> +	char name[32];
> +	__u32 payload_size;
> +	__u32 payload_offset;
> +	__u16 prop_idx;
> +	__u16 owner_idx;
> +	__u32 reserved[17];
> +} __attribute__ ((packed));
> +
> +static inline const char *media_prop2s(const struct media_v2_prop *prop)

Please call it "media_prop2string". Just "s" here is confusing.

> +{
> +	return (const char *)prop + prop->payload_offset;
> +}
> +
> +static inline __u64 media_prop2u64(const struct media_v2_prop *prop)
> +{
> +	return *(const __u64 *)((const char *)prop + prop->payload_offset);
> +}
> +
> +static inline __s64 media_prop2s64(const struct media_v2_prop *prop)
> +{
> +	return *(const __s64 *)((const char *)prop + prop->payload_offset);
> +}
> +
>  struct media_v2_topology {
>  	__u64 topology_version;
>  
> @@ -360,6 +434,10 @@ struct media_v2_topology {
>  	__u32 num_links;
>  	__u32 reserved4;
>  	__u64 ptr_links;
> +
> +	__u32 num_props;
> +	__u32 props_payload_size;
> +	__u64 ptr_props;
>  } __attribute__ ((packed));
>  
>  /* ioctls */
> @@ -368,6 +446,8 @@ struct media_v2_topology {
>  #define MEDIA_IOC_ENUM_ENTITIES	_IOWR('|', 0x01, struct media_entity_desc)
>  #define MEDIA_IOC_ENUM_LINKS	_IOWR('|', 0x02, struct media_links_enum)
>  #define MEDIA_IOC_SETUP_LINK	_IOWR('|', 0x03, struct media_link_desc)
> +/* Old MEDIA_IOC_G_TOPOLOGY ioctl without props support */
> +#define MEDIA_IOC_G_TOPOLOGY_OLD 0xc0487c04

I would avoid calling it "_OLD". we may have a V3, V4, V5, ... of this
ioctl.

I would, instead, define an _IOWR_COMPAT macro that would take an extra
parameter, in order to get the size of part of the struct, e. g. something
like:

#define MEDIA_IOC_G_TOPOLOGY_V1		_IOWR_COMPAT('|', 0x04, struct media_v2_topology, num_props)

Also, I don't see any good reason why to keep this at uAPI (except for a
mc-compliance tool that would test both versions - but this could be
defined directly there).

>  #define MEDIA_IOC_G_TOPOLOGY	_IOWR('|', 0x04, struct media_v2_topology)
>  #define MEDIA_IOC_REQUEST_ALLOC	_IOR ('|', 0x05, int)
>  

Thanks,
Mauro
