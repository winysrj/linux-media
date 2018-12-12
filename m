Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7504C04EB8
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 09:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DB2A2084E
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 09:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544605467;
	bh=oen1LWNsWvT2KaD2EHpztLq0nE+rikE8oasWP1e2LTE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=CodcV8XrKzHM3T6uetJrtPgtXPfEnF3OX7Up0rzFW/VSoGD4SAJoZff8m3GukLWwJ
	 XyQt9AOybovgdgPGLw5988ZAUapGlP7arleATiMxdVTJwkxCgrtzRSgwwRTzmZjYld
	 TYP5thN3bAn135IKRLAEJtVwvpefZ5kuQD15IX/0=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DB2A2084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbeLLJE0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 04:04:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:56768 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbeLLJEY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 04:04:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GesKsrl1tO5FPLkhlNxtg9PvKqXbKb8dGhd9c6XXP04=; b=hqvW3eByIHaYqSjcLqdbXeO7xD
        eyZUsPFURBU+PT+RxDvPVTmwUIgeEUexPXcdtX9Bu0kAp0uhXyOlqw8Xf/J8Pzo1D9Rq/ptou6HFW
        nlDcS58CszizvdTR4iIrEodYWSMxEXjJ52xPQ9KejWUe0VLpHfxoOqwStsWpxkWHHELhzGO8TTUXJ
        kbx2XI37oOtHZ2Z7RixVomPcIB77jpIM5w+rWbANQfhCzfVHhnEg8mwtXtRbUZ7BvbrMnCidP285f
        6ep+HCllAy9YCxInf0XiB4d8s1rja6Ptj0y8Y0LpjmyWBdvtqLzo+f9NoVNW7uMlufGzQXifQ5iwn
        ZE0tNeEQ==;
Received: from [177.159.254.7] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gX0RL-0006vc-4F; Wed, 12 Dec 2018 09:04:23 +0000
Date:   Wed, 12 Dec 2018 07:04:19 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv4 PATCH 3/3] vimc: add property test code
Message-ID: <20181212070419.314cb613@coco.lan>
In-Reply-To: <20181121154024.13906-4-hverkuil@xs4all.nl>
References: <20181121154024.13906-1-hverkuil@xs4all.nl>
        <20181121154024.13906-4-hverkuil@xs4all.nl>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 21 Nov 2018 16:40:24 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add properties to entities and pads to be able to test the
> properties API.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/vimc/vimc-common.c | 50 +++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
> index dee1b9dfc4f6..2f70e4e64790 100644
> --- a/drivers/media/platform/vimc/vimc-common.c
> +++ b/drivers/media/platform/vimc/vimc-common.c
> @@ -415,6 +415,7 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
>  			 const unsigned long *pads_flag,
>  			 const struct v4l2_subdev_ops *sd_ops)
>  {
> +	struct media_prop *prop = NULL;
>  	int ret;
>  
>  	/* Allocate the pads */
> @@ -452,6 +453,55 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
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

Sounds OK to me.

Thanks,
Mauro
