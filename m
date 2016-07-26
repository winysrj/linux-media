Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:35093 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbcGZGFX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2016 02:05:23 -0400
Received: by mail-lf0-f54.google.com with SMTP id f93so142995041lfi.2
        for <linux-media@vger.kernel.org>; Mon, 25 Jul 2016 23:05:22 -0700 (PDT)
Date: Tue, 26 Jul 2016 08:05:20 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
	<niklas.soderlund@ragnatech.se>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] rcar-vin: add R-Car gen2 fallback compatibility string
Message-ID: <20160726060519.GB17189@bigcity.dyn.berto.se>
References: <2381051.RUpesOs1q9@wasted.cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2381051.RUpesOs1q9@wasted.cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-07-25 22:19:33 +0300, Sergei Shtylyov wrote:
> Such fallback string is present in the 'soc_camera' version of the R-Car VIN
> driver, so need  to add it here as well...
> 
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

Acked-by: Niklas S�derlund <niklas.soderlund+renesas@ragnatech.se>

> 
> ---
> This patch is against the 'media_tree.git' repo's 'master' branch.
> This patch conflicts with Niklas Soderlund's former patch "[media] rcar-vin:
> add  Gen2 and Gen3 fallback compatibility strings"), I got his consent about
> splitting the gen2 part  of that patch to a separate patch...
> 
>  drivers/media/platform/rcar-vin/rcar-core.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: media_tree/drivers/media/platform/rcar-vin/rcar-core.c
> ===================================================================
> --- media_tree.orig/drivers/media/platform/rcar-vin/rcar-core.c
> +++ media_tree/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -209,6 +209,7 @@ static const struct of_device_id rvin_of
>  	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
>  	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
>  	{ .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
> +	{ .compatible = "renesas,rcar-gen2-vin", .data = (void *)RCAR_GEN2 },
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(of, rvin_of_id_table);
> 

-- 
Regards,
Niklas S�derlund
