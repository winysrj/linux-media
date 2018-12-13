Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3052C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 17:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A55120870
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 17:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544722298;
	bh=w7p6s83hUN7yYV+vBgWJaQro6ETs7Kl7uNy/osFqZF4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=jLH4lQky+Dp4eOaxdOL/7o2zp5q+d4RY8JRWY1EQbqnKG5ik0t89PX9kdehR8kwbx
	 zw4Qgdmzv2jyrgsYfZeJfcAuDYwzmh3EnhYL5rB7B48Y/yJ6f7yFZhTN5VeNWTLUf/
	 yEy5fLP2zdCW+Ek+XpPuShcSEQolp75yFvaBvaw4=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A55120870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbeLMRbh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 12:31:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:35990 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728075AbeLMRbh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 12:31:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Wf8eXhiU1fD9MelKIZOVbkA2ihD4tvWkX0nzeAuz4cY=; b=WYNH4rayKgjU4do6vPwniZzkpT
        RHyVjJJFsGEL6XwASC1/72Rbw/JaS5JU+siI9hXrTvt5GiJRYWftiQ4Q0x8xGueVTQ8KczPadi9LF
        /N4LLzvybJjGLBv4U2hfmXRQoCKTI19MzT7bYKSY2vjY84udFa3FPTaRXbLAY/OGWS2SQO9xB0jot
        bKpCqrsBDXyhyjIyUt3ENNX1fai/EJUq2w06IKGPtB1Idou1FUToWXO54vcqBRWx9N1r2OmL0tRIP
        InC3Cax5quWw66zHq0lAzMO3tS6WFzOxKaqIv3UthZqvXiLQKGTnXJPpQS6txR/oW6ZndWd4iH2cq
        T/r2rYbg==;
Received: from 177.43.150.95.dynamic.adsl.gvt.net.br ([177.43.150.95] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gXUpj-0003cs-RK; Thu, 13 Dec 2018 17:31:36 +0000
Date:   Thu, 13 Dec 2018 15:31:32 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv5 PATCH 4/4] vimc: add property test code
Message-ID: <20181213153132.42ccd4e5@coco.lan>
In-Reply-To: <20181213134113.15247-5-hverkuil-cisco@xs4all.nl>
References: <20181213134113.15247-1-hverkuil-cisco@xs4all.nl>
        <20181213134113.15247-5-hverkuil-cisco@xs4all.nl>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Thu, 13 Dec 2018 14:41:13 +0100
hverkuil-cisco@xs4all.nl escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add properties to entities and pads to be able to test the
> properties API.

Looks OK to me.

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/vimc/vimc-common.c | 50 +++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
> index 867e24dbd6b5..e3d5d4b3b44d 100644
> --- a/drivers/media/platform/vimc/vimc-common.c
> +++ b/drivers/media/platform/vimc/vimc-common.c
> @@ -417,6 +417,7 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
>  			 const unsigned long *pads_flag,
>  			 const struct v4l2_subdev_ops *sd_ops)
>  {
> +	struct media_prop *prop = NULL;
>  	int ret;
>  
>  	/* Allocate the pads */
> @@ -454,6 +455,55 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
>  		goto err_clean_m_ent;
>  	}
>  
> +	ret = media_entity_add_prop_u64(&sd->entity, "u64", ~1);
> +	if (!ret)
> +		ret = media_entity_add_prop_s64(&sd->entity, "s64", -5);
> +	if (!ret)
> +		ret = media_entity_add_prop_string(&sd->entity, "string",
> +						   sd->name);
> +	if (!ret) {
> +		prop = media_entity_add_prop_group(&sd->entity, "empty-group");
> +		ret = PTR_ERR_OR_ZERO(prop);
> +	}
> +	if (!ret) {
> +		prop = media_entity_add_prop_group(&sd->entity, "group");
> +		ret = PTR_ERR_OR_ZERO(prop);
> +	}
> +	if (!ret)
> +		ret = media_prop_add_prop_u64(prop, "u64", 42);
> +	if (!ret)
> +		ret = media_prop_add_prop_s64(prop, "s64", -42);
> +	if (!ret)
> +		ret = media_prop_add_prop_string(prop, "string", "42");
> +	if (!ret)
> +		ret = media_pad_add_prop_u64(&sd->entity.pads[num_pads - 1],
> +					     "u64", ~1);
> +	if (!ret)
> +		ret = media_pad_add_prop_s64(&sd->entity.pads[num_pads - 1],
> +					     "s64", -5);
> +	if (!ret) {
> +		prop = media_pad_add_prop_group(&sd->entity.pads[num_pads - 1],
> +						"group");
> +		ret = PTR_ERR_OR_ZERO(prop);
> +	}
> +	if (!ret)
> +		ret = media_prop_add_prop_u64(prop, "u64", 24);
> +	if (!ret)
> +		ret = media_prop_add_prop_s64(prop, "s64", -24);
> +	if (!ret)
> +		ret = media_pad_add_prop_string(&sd->entity.pads[0],
> +						"string", sd->name);
> +	if (!ret)
> +		ret = media_prop_add_prop_string(prop, "string", "24");
> +	if (!ret) {
> +		prop = media_prop_add_prop_group(prop, "subgroup");
> +		ret = PTR_ERR_OR_ZERO(prop);
> +	}
> +	if (!ret)
> +		ret = media_prop_add_prop_string(prop, "string", "substring");
> +	if (ret)
> +		goto err_clean_m_ent;
> +
>  	return 0;
>  
>  err_clean_m_ent:



Thanks,
Mauro
