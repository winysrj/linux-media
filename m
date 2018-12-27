Return-Path: <SRS0=HJwa=PE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1592AC43387
	for <linux-media@archiver.kernel.org>; Thu, 27 Dec 2018 00:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D38D3214D8
	for <linux-media@archiver.kernel.org>; Thu, 27 Dec 2018 00:51:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="BcWgCGAU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbeL0Ava (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 26 Dec 2018 19:51:30 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35464 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727697AbeL0Ava (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Dec 2018 19:51:30 -0500
Received: by mail-lj1-f195.google.com with SMTP id x85-v6so15017954ljb.2
        for <linux-media@vger.kernel.org>; Wed, 26 Dec 2018 16:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=uH/pa7SFbafKjIu7Tgwhca4U1gxNiGLmaZb2brlO4XY=;
        b=BcWgCGAUTyl21MebFT1YNOvIF3YmpJj5ghIPyMj5YbxQ/yfkVtDTwRkkMGk/vKv+CV
         j09MivrDQ/mUuh3P6/NmR47edxp7oGRFpToy8R69kp6RGFk7WoN7zdgmkS+Zenc7CeHN
         EdKdjVoRbzY2wJlSALgGp03NOJEDk7dVdPFU6PqP0SH3qktbuVKBn28/1c/Hy+MSRFEz
         Hy4aIcQF8A095NttKzrulpmoBhr+UT7ywOOIi6uR7Cg5MXB9RnChzhB3ajtIT5+uQh1z
         HBP4heE3RosypR6XwBSrvy0GxA5agkrQc3H0LB06Bsa7SIMkV4BwhOD1MUbAMXjAxqgs
         36rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=uH/pa7SFbafKjIu7Tgwhca4U1gxNiGLmaZb2brlO4XY=;
        b=aTRR43i6xNNvPmtwk4Tw1EZakbqu+IXm5NcSQaHA73RXdOujfchhIOfvnoebkCVzJ0
         DhpUdeKz07hCj5v0ytzOrBUDcNx7efmHUW1h4WxqNgj8XvwDtma6UNUEAxqk+qawuAut
         XATU+do421BJn8I3uLHBYqmTdilb4Lf89eIu/tyeCxV/YOB7im5UTaNpAVam29/Y2Tqa
         qI9ItMkSEdttIEDiNLbI9CAqm6hea5jgzVFM0hgiw8c711rHOlmeTHCaILNkfMiZeFdD
         z18879kO3c/HP86d//H3wGrUUpifghXB5z29l4WzllSFWigUZAKkusTMAensU8enILB2
         JqHQ==
X-Gm-Message-State: AJcUukfDlAe5vSVqcEbWPWbsHFVdKBL5F9nmHDGh+NMy+YyjgxzG4gqG
        tPwDHHtgkgkrbIs4onklN0RUYg==
X-Google-Smtp-Source: ALg8bN7VuBZMGPFgoBb6HMtblr60AV2Gq0iL5eTtj5mhwpEnb9PgKU7CiwXqfXVH8Vrxb8uGeX/TIg==
X-Received: by 2002:a2e:89d7:: with SMTP id c23-v6mr4910848ljk.0.1545871887182;
        Wed, 26 Dec 2018 16:51:27 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id m10-v6sm7747503ljj.34.2018.12.26.16.51.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Dec 2018 16:51:26 -0800 (PST)
Date:   Thu, 27 Dec 2018 01:51:25 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Steve Longerbeam <slongerbeam@gmail.com>
Cc:     linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "open list:MEDIA DRIVERS FOR RENESAS - VIN" 
        <linux-renesas-soc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] media: rcar-vin: Allow independent VIN link
 enablement
Message-ID: <20181227005125.GK19796@bigcity.dyn.berto.se>
References: <20181225232725.15935-1-slongerbeam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181225232725.15935-1-slongerbeam@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Steve,

Thanks for your patch.

On 2018-12-25 15:27:25 -0800, Steve Longerbeam wrote:
> There is a block of code in rvin_group_link_notify() that prevents
> enabling a link to a VIN node if any entity in the media graph is
> in use. This prevents enabling a VIN link even if there is an in-use
> entity somewhere in the graph that is independent of the link's
> pipeline.
> 
> For example, the code block will prevent enabling a link from
> the first rcar-csi2 receiver to a VIN node even if there is an
> enabled link somewhere far upstream on the second independent
> rcar-csi2 receiver pipeline.

Unfortunately this is by design and needed due to the hardware design.  
The different VIN endpoints shares a configuration register which 
controls the routing from the CSI-2 receivers to the VIN (register name 
CHSEL). Modifying the CHSEL register which is what happens when a link 
is enabled/disabled can have side effects on running streams even if 
they are not shown to be dependent in the media graph.

There is a CHSEL register in VIN0 which controls the routing from all 
CSI-2 receivers to VIN0-3 and a CHSEL register in VIN4 which controls 
the same for VIN4-7.

> 
> If this code block is meant to prevent modifying a link if the
> link is actively involved in streaming, there is already such a
> check in __media_entity_setup_link() that verifies the stream_count
> of the link's source and sink entities are both zero.

For the reason above the check in __media_entity_setup_link() is not 
enough :-( This register sharing is my least favorite thing about the 
VIN on Gen3 and forces the driver to become more complex as all VIN 
instances needs to know about each other and interact.

> 
> Remove the code block so that VIN node links can be enabled even if
> there are other independent in-use entities.

There is room for some improvement in this area disregarding the odd 
hardware design. It *could* be allowed to change a link terminating in  
VIN4-7 even if there is a stream running for one or more in VIN0-3.

I would be interested to test such a patch but to allow any link change 
which is allowed by __media_entity_setup_link() is unfortunately not 
possible, as I understand it. Maybe someone more clever then me can find 
ways to unlock even more then just the split between VIN0-3 and VIn4-7.

In essence the CHSEL register can not be changed if it's involved in a 
running pipeline even if the end result would be that the running 
pipeline would look the same. This is possible as there are multiple 
CHSEL settings where the same source is connected to a specific VIN 
while other members of the "subgroup of VINs" (e.g. VIN0-3) is routed to 
something else for the two CHSEL settings.

> 
> Fixes: c0cc5aef31 ("media: rcar-vin: add link notify for Gen3")
> 
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index f0719ce24b97..b2c9a876969e 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -116,7 +116,6 @@ static int rvin_group_link_notify(struct media_link *link, u32 flags,
>  						struct rvin_group, mdev);
>  	unsigned int master_id, channel, mask_new, i;
>  	unsigned int mask = ~0;
> -	struct media_entity *entity;
>  	struct video_device *vdev;
>  	struct media_pad *csi_pad;
>  	struct rvin_dev *vin = NULL;
> @@ -131,11 +130,6 @@ static int rvin_group_link_notify(struct media_link *link, u32 flags,
>  	    !is_media_entity_v4l2_video_device(link->sink->entity))
>  		return 0;
>  
> -	/* If any entity is in use don't allow link changes. */
> -	media_device_for_each_entity(entity, &group->mdev)
> -		if (entity->use_count)
> -			return -EBUSY;
> -
>  	mutex_lock(&group->lock);
>  
>  	/* Find the master VIN that controls the routes. */
> -- 
> 2.17.1
> 

-- 
Regards,
Niklas Söderlund
