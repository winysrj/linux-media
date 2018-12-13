Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F473C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 16:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3FED20851
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 16:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544719281;
	bh=2+QovrLruU13/Vj77txSsJY0/Gvt4kexhtFgtaffaew=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=BlMh31VFHA+fzzNmiSeWZm+QlMofvoNWR7MGSgzX3GoldLhdoHw0LqPgbM+oRrK5o
	 z2xMb0uE8JALxZ41hev9eCwnz/GgzGUrl250VIKKgYVgHyHuD+vSCBujw3Xu4cbXXu
	 GWoNkzWEqgWqzFMVzBg9z4IKgL45+f7/AJH+M27s=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3FED20851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbeLMQlV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 11:41:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:59252 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727579AbeLMQlU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 11:41:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KmjsuTPJ8DBpFlJy/QTLoRt4bCbys9VdM4sgdcDuOKQ=; b=BxEWG+svbVhJsIouk8dyeBvmE+
        jmYleDNtZiLwsoUoGoOxrTxv2oIsZq0LUmZ9ZUbeuuAKyV8UQ3FvYiwwY8o0RB7mRdnLVhsw7AiIW
        nZNDzbkC4N3OjxSsmWXoePeh98+y9SucMgIAixXBkfJX2iIcBdZlxTlVYeFZEo84LLB/RROLnS6Af
        EDLSCZYGq0tOw/rA0IlS/yoSll8+4JhSnKQ641uJKhjxhKrvcf0ulrjwES+Gue5gcTybAtZ67aMbm
        Nfscz+nGMPw/EFIUtGzyNwis8teRezmp+f9IvzaveyzwRRP0EQQNMdcVK7Cxclt6hTPznK8XPgs9N
        u5F8pJqA==;
Received: from 177.43.150.95.dynamic.adsl.gvt.net.br ([177.43.150.95] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gXU33-0001SA-No; Thu, 13 Dec 2018 16:41:18 +0000
Date:   Thu, 13 Dec 2018 14:41:13 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv5 PATCH 1/4] uapi/linux/media.h: add property support
Message-ID: <20181213144113.713ce59c@coco.lan>
In-Reply-To: <20181213134113.15247-2-hverkuil-cisco@xs4all.nl>
References: <20181213134113.15247-1-hverkuil-cisco@xs4all.nl>
        <20181213134113.15247-2-hverkuil-cisco@xs4all.nl>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Thu, 13 Dec 2018 14:41:10 +0100
hverkuil-cisco@xs4all.nl escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Extend the topology struct with a properties array.
> 
> Add a new media_v2_prop structure to store property information.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  include/uapi/linux/media.h | 56 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 56 insertions(+)
> 
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index e5d0c5c611b5..12982327381e 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -342,6 +342,58 @@ struct media_v2_link {
>  	__u32 reserved[6];
>  } __attribute__ ((packed));
>  
> +#define MEDIA_PROP_TYPE_GROUP	1
> +#define MEDIA_PROP_TYPE_U64	2
> +#define MEDIA_PROP_TYPE_S64	3
> +#define MEDIA_PROP_TYPE_STRING	4

> +#define MEDIA_OWNER_TYPE_ENTITY			0
> +#define MEDIA_OWNER_TYPE_PAD			1
> +#define MEDIA_OWNER_TYPE_LINK			2
> +#define MEDIA_OWNER_TYPE_INTF			3
> +#define MEDIA_OWNER_TYPE_PROP			4

> +
> +/**
> + * struct media_v2_prop - A media property
> + *
> + * @id:		The unique non-zero ID of this property
> + * @type:	Property type

> + * @owner_id:	The ID of the object this property belongs to

I'm in doubt about this. With this field, properties and objects
will have a 1:1 mapping. If this is removed, it would be possible
to map 'n' objects to a single property (N:1 mapping), with could
be interesting.

> + * @owner_type:	The type of the object this property belongs to

I would remove this (and the corresponding defines). The type
can easily be identified from the owner_id - as it already contains
the object type embedded at the ID.
In other words, it is:

	owner_type = (owner_id & MEDIA_ENT_TYPE_MASK) >> MEDIA_ENT_TYPE_SHIFT;

> + * @flags:	Property flags
> + * @name:	Property name
> + * @payload_size: Property payload size, 0 for U64/S64
> + * @payload_offset: Property payload starts at this offset from &prop.id.
> + *		This is 0 for U64/S64.

Please specify how this will be used for the group type, with is not
obvious. I *suspect* that, on a group, you'll be adding a vector of
u32 (cpu endian) and payload_size is the number of elements at the
vector (or the vector size?).

> + * @reserved:	Property reserved field, will be zeroed.
> + */
> +struct media_v2_prop {
> +	__u32 id;
> +	__u32 type;
> +	__u32 owner_id;
> +	__u32 owner_type;
> +	__u32 flags;

The way it is defined, name won't be 64-bits aligned (well, it will, if
you remove the owner_type).

> +	char name[32];
> +	__u32 payload_size;
> +	__u32 payload_offset;
> +	__u32 reserved[18];
> +} __attribute__ ((packed));
> +
> +static inline const char *media_prop2string(const struct media_v2_prop *prop)
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

Shouldn't you define also a media_prop2group()?

>  struct media_v2_topology {
>  	__u64 topology_version;
>  
> @@ -360,6 +412,10 @@ struct media_v2_topology {
>  	__u32 num_links;
>  	__u32 reserved4;
>  	__u64 ptr_links;
> +
> +	__u32 num_props;
> +	__u32 props_payload_size;
> +	__u64 ptr_props;

Please document those new fields.

>  } __attribute__ ((packed));
>  
>  /* ioctls */



Thanks,
Mauro
