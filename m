Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,T_MIXED_ES,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D899C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 17:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C226120851
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 17:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544723687;
	bh=yfvC/R1qCdxBdBL2bUj8ewvyuKQxfoBBqi+kZ2vfwhs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=EbzIByVD1rul91w8CEWV57h+KcaxI86lzsSiBdiqCBYSUC6kW4Q64VAXKrHlL+H84
	 na5fbTF17pzGMShI2JJfs7pAaNXWdvCkxTNNTiCd4hbp914szqB69hkgRU/LjYMkGS
	 NPlQlnB1Rxw1M1r8QCh/hcCp7txRdToH47PMkbRY=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C226120851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbeLMRyr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 12:54:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:37300 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727511AbeLMRyr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 12:54:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HnzUzd4DLAO/eMNcnmx+MHXPZuAhp9I9sx/axBdSHYU=; b=Fo4sBfbP4JyMHWyZYk6ch76/Ds
        RYWxxwnZWtlO1CXYj9xcF4I1jXOfrp3W5F75lUYpkBMe3/YNWZ28RAzBP8jAcZ3d1YKVb7vlPPZfq
        ++giOgXiSSjYmfoKZFygb5PlpVizIM+noRwWldD/SKxZ4W1uZNbSz7p//KvAbtmsRU2eB5mDCd86g
        B6+aOT3vDNCmkLnEvGw5tNaMTKAK8o+hjBNBiDRQQH7YzdNXi0Gfe4sf/LqdAgzNaSON+HEEUdcoh
        OI7Q8U4DRkUdPgEJmmBej7Cy/ThO3zcUGDXIjeqcTB+uHwQlaJ8pbiUbWMAkEborsF/O9SdYfBlFI
        Fxec3V5Q==;
Received: from 177.43.150.95.dynamic.adsl.gvt.net.br ([177.43.150.95] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gXVC8-0004IL-A3; Thu, 13 Dec 2018 17:54:44 +0000
Date:   Thu, 13 Dec 2018 15:54:40 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv5 PATCH 1/4] uapi/linux/media.h: add property support
Message-ID: <20181213155440.657020f8@coco.lan>
In-Reply-To: <44af48c1-8daf-7022-6cda-bf984f9d2322@xs4all.nl>
References: <20181213134113.15247-1-hverkuil-cisco@xs4all.nl>
        <20181213134113.15247-2-hverkuil-cisco@xs4all.nl>
        <20181213144113.713ce59c@coco.lan>
        <44af48c1-8daf-7022-6cda-bf984f9d2322@xs4all.nl>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Thu, 13 Dec 2018 18:13:03 +0100
Hans Verkuil <hverkuil-cisco@xs4all.nl> escreveu:

> On 12/13/18 5:41 PM, Mauro Carvalho Chehab wrote:
> > Em Thu, 13 Dec 2018 14:41:10 +0100
> > hverkuil-cisco@xs4all.nl escreveu:
> >   
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> Extend the topology struct with a properties array.
> >>
> >> Add a new media_v2_prop structure to store property information.
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>  include/uapi/linux/media.h | 56 ++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 56 insertions(+)
> >>
> >> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> >> index e5d0c5c611b5..12982327381e 100644
> >> --- a/include/uapi/linux/media.h
> >> +++ b/include/uapi/linux/media.h
> >> @@ -342,6 +342,58 @@ struct media_v2_link {
> >>  	__u32 reserved[6];
> >>  } __attribute__ ((packed));
> >>  
> >> +#define MEDIA_PROP_TYPE_GROUP	1
> >> +#define MEDIA_PROP_TYPE_U64	2
> >> +#define MEDIA_PROP_TYPE_S64	3
> >> +#define MEDIA_PROP_TYPE_STRING	4  
> >   
> >> +#define MEDIA_OWNER_TYPE_ENTITY			0
> >> +#define MEDIA_OWNER_TYPE_PAD			1
> >> +#define MEDIA_OWNER_TYPE_LINK			2
> >> +#define MEDIA_OWNER_TYPE_INTF			3
> >> +#define MEDIA_OWNER_TYPE_PROP			4  
> >   
> >> +
> >> +/**
> >> + * struct media_v2_prop - A media property
> >> + *
> >> + * @id:		The unique non-zero ID of this property
> >> + * @type:	Property type  
> >   
> >> + * @owner_id:	The ID of the object this property belongs to  
> > 
> > I'm in doubt about this. With this field, properties and objects
> > will have a 1:1 mapping. If this is removed, it would be possible
> > to map 'n' objects to a single property (N:1 mapping), with could
> > be interesting.  
> 
> But then every object would somehow have to list all the properties
> that belong to it. That doesn't easily fit in e.g. the entities array
> that's returned by G_TOPOLOGY.

Already answered on a followup email. 

If we remove it from here, we would need to add a property_id to every
object type (including to properties). IMHO, it could be a more future
proof approach.

Yet, as I said, I'm not sure about what would be the best approach.

The thing is: if we add it here, we'll be stick forever to 1:1.
However, I can't think right now on a good use case for N:1 (but
see below: proprieties like "group" are better represented as N:1).

> 
> >   
> >> + * @owner_type:	The type of the object this property belongs to  
> > 
> > I would remove this (and the corresponding defines). The type
> > can easily be identified from the owner_id - as it already contains
> > the object type embedded at the ID.
> > In other words, it is:
> > 
> > 	owner_type = (owner_id & MEDIA_ENT_TYPE_MASK) >> MEDIA_ENT_TYPE_SHIFT; 

Hmm... this is actually wrong. This is for the legacy API.

Yeah, right now, we're not exposing how object_id is built.

> 
> I'm fine with that as well, but you expose how the ID is constructed as part of
> the uAPI. And you can't later change that.

It should be noticed that my mc_nextgen_test.c uses this knowledge:

	static uint32_t media_type(uint32_t id)
	{
		return id >> 24;
	}

	static inline uint32_t media_localid(uint32_t id)
	{
		return id & 0xffffff;
	}

I suspect that it is sane (and a good idea) to have macros like the
above at the uAPI header, as it makes life simpler for userspace
apps. The only drawback would be if we end by needing to redefine
it for whatever reason.

> If nobody has a problem with that, then I can switch to this.
> 
> >   
> >> + * @flags:	Property flags
> >> + * @name:	Property name
> >> + * @payload_size: Property payload size, 0 for U64/S64
> >> + * @payload_offset: Property payload starts at this offset from &prop.id.
> >> + *		This is 0 for U64/S64.  
> > 
> > Please specify how this will be used for the group type, with is not
> > obvious. I *suspect* that, on a group, you'll be adding a vector of
> > u32 (cpu endian) and payload_size is the number of elements at the
> > vector (or the vector size?).  
> 
> Ah, sorry, groups were added later and the comments above were not updated.
> A group property has no payload, so these payload fields are 0. A group really
> just has a name and an ID, and that ID is referred to as the owner_id by
> subproperties.

Ok. Inferred that after reviewing patch 3/4.

> So you can have an entity with a 'sensor' group property, and that can have
> a sub-property called 'orientation'.
> 
> These properties will be part of the uAPI, so they will have to be defined
> and documented. So in this example you'd have to document the sensor.orientation
> property.

Ok, makes sense.

In this specific case, a N:1 approach for properties make a lot of
sense. I mean, on a device like a car system where a driver can have
a large number of sensors, it would make sense to have all sensors
pointing to a single "sensor" group properties ID.

> >> + * @reserved:	Property reserved field, will be zeroed.
> >> + */
> >> +struct media_v2_prop {
> >> +	__u32 id;
> >> +	__u32 type;
> >> +	__u32 owner_id;
> >> +	__u32 owner_type;
> >> +	__u32 flags;  
> > 
> > The way it is defined, name won't be 64-bits aligned (well, it will, if
> > you remove the owner_type).  
> 
> Why should name be 64 bit aligned? Not that I mind moving 'flags' after
> 'name'.

It improves reading on some machines. If I'm not mistaken, on archs
like ARM and RISC, the cost of reading an integer is different if
the element is aligned or not. reading an aligned value can be done
with a single instruction. Reading unaligned data would require
reading two values and do some bit shifting logic.

I remember we had this care when applying the final version of the
media API. I would prefer to keep things 

Why not? 

> >> +	char name[32];
> >> +	__u32 payload_size;
> >> +	__u32 payload_offset;
> >> +	__u32 reserved[18];  
> 
> If we keep owner_type, then 18 should be changed to 17. I forgot that.

Yep.

> 
> >> +} __attribute__ ((packed));
> >> +
> >> +static inline const char *media_prop2string(const struct media_v2_prop *prop)
> >> +{
> >> +	return (const char *)prop + prop->payload_offset;
> >> +}
> >> +
> >> +static inline __u64 media_prop2u64(const struct media_v2_prop *prop)
> >> +{
> >> +	return *(const __u64 *)((const char *)prop + prop->payload_offset);
> >> +}
> >> +
> >> +static inline __s64 media_prop2s64(const struct media_v2_prop *prop)
> >> +{
> >> +	return *(const __s64 *)((const char *)prop + prop->payload_offset);
> >> +}
> >> +  
> > 
> > Shouldn't you define also a media_prop2group()?  
> 
> No, groups have no payload.

Ok.

> 
> >   
> >>  struct media_v2_topology {
> >>  	__u64 topology_version;
> >>  
> >> @@ -360,6 +412,10 @@ struct media_v2_topology {
> >>  	__u32 num_links;
> >>  	__u32 reserved4;
> >>  	__u64 ptr_links;
> >> +
> >> +	__u32 num_props;
> >> +	__u32 props_payload_size;
> >> +	__u64 ptr_props;  
> > 
> > Please document those new fields.  
> 
> This struct doesn't have any docbook documentation. I can add that once everyone agrees
> with this API.

It makes sense to add one :-)

> 
> Regards,
> 
> 	Hans
> 
> >   
> >>  } __attribute__ ((packed));
> >>  
> >>  /* ioctls */  
> > 
> > 
> > 
> > Thanks,
> > Mauro
> >   
> 



Thanks,
Mauro
