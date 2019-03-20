Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 139BCC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 15:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D741B2184E
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 15:23:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="Huz7Nlx7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfCTPXG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 11:23:06 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40152 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbfCTPXG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 11:23:06 -0400
Received: by mail-lf1-f66.google.com with SMTP id u68so2194262lff.7
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 08:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=a3FOAK9e9PnAOhZ0rOyXDZedWzJNUMU8zuBJwLF9u7E=;
        b=Huz7Nlx7Hbq8uWVhdqP/Oa+J0B7pSzVaBAvvBIaOaUrVvUcC6vzIJUhSlOw8pjjnxo
         oD5AlE0sW81SkK2WFPMU29+xKrlVLTWdZtXOOvg1FbYSFSa34a4ggKELK81bjpe55SPZ
         24I2sp5omFXGY+7jJYx1rc0bGNaV5ZsPiUCa1bigdtNQejGNVrPcOYN84tDAwRLmOEic
         mJx+0sMbYI81tjXGMvVPGXnNxyxHMESTCQddmSKx1rAK7DvzCcEu4qDNkyrp9pVSZ2v2
         xjCD3KD8OrRMuVe4KT+yQJpuvLQmhaWdJv2N23zpywizdJW++uEUob9+sfDeaFnoPeuy
         NHdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=a3FOAK9e9PnAOhZ0rOyXDZedWzJNUMU8zuBJwLF9u7E=;
        b=KKf6wfzVbvH+/Bypy/OgxhDUgdNBFg6R7kkDiFWCAMAdzX4Nhk+bnl0yILxczGCxVU
         2HK4DfAzpPtTQ2vEBEzDNYnV2SJAM/vV2k2PPpsF/wAcns81xzjtslOQtQ0lxfedGbR+
         e0KAdPRbrimPcV1TmOOzljsRRC4ISVFD53p7dMdlzq90by6WvvQXygfCFrdtkk4Sfmr3
         V+Orj/PiGkVaDbcYa9GJHgViuNY0G4B22r3rqdx1RwLd0leBF+MQ3l6wh2QaBVdiG9wu
         RecDhWfCvYRY43gYYu5DsqfTw0a+04NABqgQVdLn3kUlJvBlmK6bxkEwFmCVUgZDBJuc
         IbRQ==
X-Gm-Message-State: APjAAAVkfziEzjrFFbvMzlmzRZrD4TX0exNMN/VIaGqAQPdV3WqfgaZD
        rla57ypUkgDQ4Tb3WiqLGg7Z99+K3no=
X-Google-Smtp-Source: APXvYqzVYD7N0URKHBi63PpVA4mGmc2GFynyFr/K0cYGvMdS6CY+KB4ZhkBj4j/oN0qv5svQQ0zm0w==
X-Received: by 2002:a19:7105:: with SMTP id m5mr16682194lfc.154.1553095383824;
        Wed, 20 Mar 2019 08:23:03 -0700 (PDT)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id x76sm393462ljb.17.2019.03.20.08.23.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Mar 2019 08:23:02 -0700 (PDT)
Date:   Wed, 20 Mar 2019 16:23:02 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [RFC v1.1 1/8] v4l2-async: Use endpoint node, not device node,
 for fwnode match
Message-ID: <20190320152302.GL26015@bigcity.dyn.berto.se>
References: <20190318191653.7197-2-sakari.ailus@linux.intel.com>
 <20190319130200.1709-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190319130200.1709-1-sakari.ailus@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

Thanks for your work.

On 2019-03-19 15:02:00 +0200, Sakari Ailus wrote:
[snip]
> diff --git a/drivers/media/platform/rcar_drif.c 
> b/drivers/media/platform/rcar_drif.c
> index c417ff8f6fe5..39da118f882a 100644
> --- a/drivers/media/platform/rcar_drif.c
> +++ b/drivers/media/platform/rcar_drif.c
> @@ -1222,7 +1222,8 @@ static int rcar_drif_parse_subdevs(struct rcar_drif_sdr *sdr)
>  	if (!ep)
>  		return 0;
>  
> -	fwnode = fwnode_graph_get_remote_port_parent(ep);
> +	notifier->subdevs[notifier->num_subdevs] = &sdr->ep.asd;
> +	fwnode = fwnode_graph_get_remote_endpoint(ep);
>  	if (!fwnode) {
>  		dev_warn(sdr->dev, "bad remote port parent\n");
>  		fwnode_handle_put(ep);

I tried the branch you referred to in your cover letter but this driver 
fails to compile for me. Looking at struct v4l2_async_notifier it has 
neither a 'subdevs' nor 'num_subdevs' members so I might be missing a 
dependency. However looking at the change it seems different from what 
you do for other drivers, is this a typo?

-- 
Regards,
Niklas Söderlund
