Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,T_MIXED_ES,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF221C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 17:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93A0020879
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 17:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544722236;
	bh=bt04h5SEnarMiHxk9ElxwB34vqcbRO9TVune1vy93y0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=wZoHTzzebW2tT/Ml2I0uv2nX8khLORMFKjONhhtTpgUyqutdYh6uaN54uNcpj7CX+
	 n8zOIdRgDAgQ5/SdCrN7SKOEbqBkZK9MWOIqRKBwenQqq/hwSN3PjnAHLk3PyWN4+3
	 1fjpoVjfR69F8A0X9ENrD6QlrP+XSe33srv/ADxU=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93A0020879
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbeLMRaf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 12:30:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:35918 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728779AbeLMRaf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 12:30:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NIku+Eqqk7uw0FXk0QZZmEkx9a5K4P/TplYxi+8pR28=; b=cKGI+SUzoLEEmN0YwLRmGJQCmV
        1tMkBBs94Wgk4DR4P7EpxARpjLbXyEd3hbjQuPHgsYIToxe2G6kJJhg59sq30wrQ2AU2BhzDspum5
        rihGnnyx1Do0ZoAUEhOxSsZ4DvUfmFPKGmH3fdqYSpi5XzU5qo+We65ig92tOyho7wO5GQgJbiN9i
        V/regsugIwlT/5TehR62id1iMwnfvqRoM2wd0iPXpNwOCEy+LNtDdB3PNHv9SCd++3UKO1PwHTlAc
        II1ik8NtkSw9KBjGQ9lIp6ZbT9jwf89356bUbomDRuoHkySlkNVpwG1JJxkHyPhZmE7mKVrigslAm
        QgV1tTQQ==;
Received: from 177.43.150.95.dynamic.adsl.gvt.net.br ([177.43.150.95] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gXUoi-0003ae-VL; Thu, 13 Dec 2018 17:30:33 +0000
Date:   Thu, 13 Dec 2018 15:30:29 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org
Subject: Re: [RFCv5 PATCH 3/4] media: add functions to add properties to
 objects
Message-ID: <20181213153029.29b35064@coco.lan>
In-Reply-To: <20181213134113.15247-4-hverkuil-cisco@xs4all.nl>
References: <20181213134113.15247-1-hverkuil-cisco@xs4all.nl>
        <20181213134113.15247-4-hverkuil-cisco@xs4all.nl>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Thu, 13 Dec 2018 14:41:12 +0100
hverkuil-cisco@xs4all.nl escreveu:

> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> Add functions to add properties to entities, pads and other
> properties. This can be extended to include interfaces and links
> in the future when needed.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
>  drivers/media/media-entity.c |  64 +++++++++
>  include/media/media-entity.h | 264 +++++++++++++++++++++++++++++++++++
>  2 files changed, 328 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 62c4d5b4d33f..cdb35bc8e9a0 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -251,6 +251,70 @@ int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
>  }
>  EXPORT_SYMBOL_GPL(media_entity_pads_init);
>  
> +static struct media_prop *media_create_prop(struct media_gobj *owner, u32 type,
> +					    const char *name, const void *ptr,
> +					    u32 payload_size)
> +{
> +	struct media_prop *prop = kzalloc(sizeof(*prop) + payload_size,
> +					  GFP_KERNEL);
> +
> +	if (!prop)
> +		return ERR_PTR(-ENOMEM);
> +	prop->type = type;
> +	strscpy(prop->name, name, sizeof(prop->name));
> +	if (owner->mdev)
> +		media_gobj_create(owner->mdev, MEDIA_GRAPH_PROP,
> +				  &prop->graph_obj);
> +	prop->owner = owner;
> +	prop->payload_size = payload_size;
> +	if (payload_size && ptr)
> +		memcpy(prop->payload, ptr, payload_size);
> +	INIT_LIST_HEAD(&prop->props);
> +	return prop;
> +}
> +
> +struct media_prop *media_entity_add_prop(struct media_entity *ent, u32 type,
> +					 const char *name, const void *ptr,
> +					 u32 payload_size)
> +{
> +	struct media_prop *prop;
> +
> +	if (!ent->inited)
> +		media_entity_init(ent);
> +	prop = media_create_prop(&ent->graph_obj, type,
> +				 name, ptr, payload_size);
> +	if (!IS_ERR(prop))
> +		list_add_tail(&prop->list, &ent->props);
> +	return prop;
> +}
> +EXPORT_SYMBOL_GPL(media_entity_add_prop);
> +
> +struct media_prop *media_pad_add_prop(struct media_pad *pad, u32 type,
> +				      const char *name, const void *ptr,
> +				      u32 payload_size)
> +{
> +	struct media_prop *prop = media_create_prop(&pad->graph_obj, type,
> +						    name, ptr, payload_size);
> +
> +	if (!IS_ERR(prop))
> +		list_add_tail(&prop->list, &pad->props);
> +	return prop;
> +}
> +EXPORT_SYMBOL_GPL(media_pad_add_prop);
> +
> +struct media_prop *media_prop_add_prop(struct media_prop *prop, u32 type,
> +				       const char *name, const void *ptr,
> +				       u32 payload_size)
> +{
> +	struct media_prop *subprop = media_create_prop(&prop->graph_obj, type,
> +						       name, ptr, payload_size);
> +
> +	if (!IS_ERR(subprop))
> +		list_add_tail(&subprop->list, &prop->props);
> +	return subprop;
> +}
> +EXPORT_SYMBOL_GPL(media_prop_add_prop);
> +
>  /* -----------------------------------------------------------------------------
>   * Graph traversal
>   */
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 5d05ebf712d0..695acfd3fe9c 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -833,6 +833,270 @@ int media_create_pad_links(const struct media_device *mdev,
>  
>  void __media_entity_remove_links(struct media_entity *entity);
>  
> +/**
> + * media_entity_add_prop() - Add property to entity
> + *
> + * @entity:	entity where to add the property
> + * @type:	property type
> + * @name:	property name
> + * @ptr:	property pointer to payload
> + * @payload_size: property payload size
> + *
> + * Returns the new property on success, or an error pointer on failure.
> + */
> +struct media_prop *media_entity_add_prop(struct media_entity *ent, u32 type,
> +					 const char *name, const void *ptr,
> +					 u32 payload_size);
> +
> +/**
> + * media_pad_add_prop() - Add property to pad
> + *
> + * @pad:	pad where to add the property
> + * @type:	property type
> + * @name:	property name
> + * @ptr:	property pointer to payload
> + * @payload_size: property payload size
> + *
> + * Returns the new property on success, or an error pointer on failure.
> + */
> +struct media_prop *media_pad_add_prop(struct media_pad *pad, u32 type,
> +				      const char *name, const void *ptr,
> +				      u32 payload_size);
> +
> +/**
> + * media_prop() - Add sub-property to property
> + *
> + * @prop:	property where to add the sub-property
> + * @type:	sub-property type
> + * @name:	sub-property name
> + * @ptr:	sub-property pointer to payload
> + * @payload_size: sub-property payload size
> + *
> + * Returns the new property on success, or an error pointer on failure.
> + */
> +struct media_prop *media_prop_add_prop(struct media_prop *prop, u32 type,
> +				       const char *name, const void *ptr,
> +				       u32 payload_size);
> +
> +/**
> + * media_entity_add_prop_group() - Add group property to entity
> + *
> + * @entity:	entity where to add the property
> + * @name:	property name
> + *
> + * Returns the new property on success, or an error pointer on failure.
> + */
> +static inline struct media_prop *
> +media_entity_add_prop_group(struct media_entity *entity, const char *name)
> +{
> +	return media_entity_add_prop(entity, MEDIA_PROP_TYPE_GROUP,
> +				     name, NULL, 0);
> +}

Hmm... group is just a string? On my past comments for patches 1/4 and 2/4
I assumed it would be an u32 array :-)

That's btw why I asked you to add some documentation. That would avoid
reviewers of guessing some things ;-)

Why are you using zero for the payload? At patch 1/4, you said that
only u64 and s64 would have payload_size == 0:

	+ * @payload_size: Property payload size, 0 for U64/S64

One would infer that, for all other types, payload_size would be
a non-zero value.

> +
> +/**
> + * media_entity_add_prop_u64() - Add u64 property to entity
> + *
> + * @entity:	entity where to add the property
> + * @name:	property name
> + * @val:	property value
> + *
> + * Returns 0 on success, or an error on failure.
> + */
> +static inline int media_entity_add_prop_u64(struct media_entity *entity,
> +					    const char *name, u64 val)
> +{
> +	struct media_prop *prop =
> +		media_entity_add_prop(entity, MEDIA_PROP_TYPE_U64,
> +				      name, &val, sizeof(val));
> +
> +	return PTR_ERR_OR_ZERO(prop);
> +}
> +
> +/**
> + * media_entity_add_prop_s64() - Add s64 property to entity
> + *
> + * @entity:	entity where to add the property
> + * @name:	property name
> + * @val:	property value
> + *
> + * Returns 0 on success, or an error on failure.
> + */
> +static inline int media_entity_add_prop_s64(struct media_entity *entity,
> +					    const char *name, s64 val)
> +{
> +	struct media_prop *prop =
> +		media_entity_add_prop(entity, MEDIA_PROP_TYPE_S64,
> +				      name, &val, sizeof(val));
> +
> +	return PTR_ERR_OR_ZERO(prop);
> +}
> +
> +/**
> + * media_entity_add_prop_string() - Add string property to entity
> + *
> + * @entity:	entity where to add the property
> + * @name:	property name
> + * @string:	property string value
> + *
> + * Returns 0 on success, or an error on failure.
> + */
> +static inline int media_entity_add_prop_string(struct media_entity *entity,
> +					       const char *name,
> +					       const char *string)
> +{
> +	struct media_prop *prop =
> +		media_entity_add_prop(entity, MEDIA_PROP_TYPE_STRING,
> +				      name, string, strlen(string) + 1);

Ok, so, you're assuming that, for strings, payload_type will include
the ending '\0' character, and that strings are NUL-terminated.

Please document it, as we usually have NUL-terminated strings OR
LEN + string. Having both is non-trivial.

> +
> +	return PTR_ERR_OR_ZERO(prop);
> +}
> +
> +/**
> + * media_pad_add_prop_group() - Add group property to pad
> + *
> + * @pad:	pad where to add the property
> + * @name:	property name
> + *
> + * Returns the new property on success, or an error pointer on failure.
> + */
> +static inline struct media_prop *media_pad_add_prop_group(struct media_pad *pad,
> +							  const char *name)
> +{
> +	return media_pad_add_prop(pad, MEDIA_PROP_TYPE_GROUP,
> +				  name, NULL, 0);
> +}
> +
> +/**
> + * media_pad_add_prop_u64() - Add u64 property to pad
> + *
> + * @pad:	pad where to add the property
> + * @name:	property name
> + * @val:	property value
> + *
> + * Returns 0 on success, or an error on failure.
> + */
> +static inline int media_pad_add_prop_u64(struct media_pad *pad,
> +					 const char *name, u64 val)
> +{
> +	struct media_prop *prop =
> +		media_pad_add_prop(pad, MEDIA_PROP_TYPE_U64,
> +				   name, &val, sizeof(val));
> +
> +	return PTR_ERR_OR_ZERO(prop);
> +}
> +
> +/**
> + * media_pad_add_prop_s64() - Add s64 property to pad
> + *
> + * @pad:	pad where to add the property
> + * @name:	property name
> + * @val:	property value
> + *
> + * Returns 0 on success, or an error on failure.
> + */
> +static inline int media_pad_add_prop_s64(struct media_pad *pad,
> +					 const char *name, s64 val)
> +{
> +	struct media_prop *prop =
> +		media_pad_add_prop(pad, MEDIA_PROP_TYPE_S64,
> +				   name, &val, sizeof(val));
> +
> +	return PTR_ERR_OR_ZERO(prop);
> +}
> +
> +/**
> + * media_pad_add_prop_string() - Add string property to pad
> + *
> + * @pad:	pad where to add the property
> + * @name:	property name
> + * @string:	property string value
> + *
> + * Returns 0 on success, or an error on failure.
> + */
> +static inline int media_pad_add_prop_string(struct media_pad *pad,
> +					    const char *name,
> +					    const char *string)
> +{
> +	struct media_prop *prop =
> +		media_pad_add_prop(pad, MEDIA_PROP_TYPE_STRING,
> +				   name, string, strlen(string) + 1);
> +
> +	return PTR_ERR_OR_ZERO(prop);
> +}
> +
> +/**
> + * media_prop_add_prop_group() - Add group sub-property to property
> + *
> + * @prop:	property where to add the sub-property
> + * @name:	sub-property name
> + *
> + * Returns the new property on success, or an error pointer on failure.
> + */
> +static inline struct media_prop *
> +media_prop_add_prop_group(struct media_prop *prop, const char *name)
> +{
> +	return media_prop_add_prop(prop, MEDIA_PROP_TYPE_GROUP,
> +				  name, NULL, 0);
> +}
> +
> +/**
> + * media_prop_add_prop_u64() - Add u64 property to property
> + *
> + * @prop:	property where to add the sub-property
> + * @name:	sub-property name
> + * @val:	sub-property value
> + *
> + * Returns 0 on success, or an error on failure.
> + */
> +static inline int media_prop_add_prop_u64(struct media_prop *prop,
> +					  const char *name, u64 val)
> +{
> +	struct media_prop *subprop =
> +		media_prop_add_prop(prop, MEDIA_PROP_TYPE_U64,
> +				    name, &val, sizeof(val));
> +
> +	return PTR_ERR_OR_ZERO(subprop);
> +}
> +
> +/**
> + * media_prop_add_prop_s64() - Add s64 property to property
> + *
> + * @prop:	property where to add the sub-property
> + * @name:	sub-property name
> + * @val:	sub-property value
> + *
> + * Returns 0 on success, or an error on failure.
> + */
> +static inline int media_prop_add_prop_s64(struct media_prop *prop,
> +					  const char *name, s64 val)
> +{
> +	struct media_prop *subprop =
> +		media_prop_add_prop(prop, MEDIA_PROP_TYPE_S64,
> +				    name, &val, sizeof(val));
> +
> +	return PTR_ERR_OR_ZERO(subprop);
> +}
> +
> +/**
> + * media_prop_add_prop_string() - Add string property to property
> + *
> + * @prop:	property where to add the sub-property
> + * @name:	sub-property name
> + * @string:	sub-property string value
> + *
> + * Returns 0 on success, or an error on failure.
> + */
> +static inline int media_prop_add_prop_string(struct media_prop *prop,
> +					     const char *name,
> +					     const char *string)
> +{
> +	struct media_prop *subprop =
> +		media_prop_add_prop(prop, MEDIA_PROP_TYPE_STRING,
> +				    name, string, strlen(string) + 1);
> +
> +	return PTR_ERR_OR_ZERO(subprop);
> +}
> +
>  /**
>   * media_entity_remove_links() - remove all links associated with an entity
>   *



Thanks,
Mauro
