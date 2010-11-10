Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:26475 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793Ab0KJNZG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 08:25:06 -0500
Date: Wed, 10 Nov 2010 14:24:11 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hong Liu <hong.liu@intel.com>, Alan Cox <alan@linux.intel.com>,
	Anantha Narayanan <anantha.narayanan@intel.com>,
	Andres Salomon <dilinger@queued.net>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH] i2c: Remove obsolete cleanup for clientdata
Message-ID: <20101110142411.6badf9d9@endymion.delvare>
In-Reply-To: <1289392100-32668-1-git-send-email-w.sang@pengutronix.de>
References: <1289392100-32668-1-git-send-email-w.sang@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Wolfram,

On Wed, 10 Nov 2010 13:28:19 +0100, Wolfram Sang wrote:
> A few new i2c-drivers came into the kernel which clear the clientdata-pointer
> on exit. This is obsolete meanwhile, so fix it and hope the word will spread.

Thanks for actively tracking these.

> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> ---
> 
> Like last time I suggest to collect acks from the driver authors and merge it
> vie Jean's i2c-tree.
> 
>  drivers/media/video/imx074.c          |    2 --
>  drivers/media/video/ov6650.c          |    2 --
>  drivers/misc/apds9802als.c            |    1 -
>  drivers/staging/olpc_dcon/olpc_dcon.c |    3 ---
>  4 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/video/imx074.c b/drivers/media/video/imx074.c
> index 380e459..27b5dfd 100644
> --- a/drivers/media/video/imx074.c
> +++ b/drivers/media/video/imx074.c
> @@ -451,7 +451,6 @@ static int imx074_probe(struct i2c_client *client,
>  	ret = imx074_video_probe(icd, client);
>  	if (ret < 0) {
>  		icd->ops = NULL;
> -		i2c_set_clientdata(client, NULL);
>  		kfree(priv);
>  		return ret;
>  	}
> @@ -468,7 +467,6 @@ static int imx074_remove(struct i2c_client *client)
>  	icd->ops = NULL;
>  	if (icl->free_bus)
>  		icl->free_bus(icl);
> -	i2c_set_clientdata(client, NULL);
>  	client->driver = NULL;

This statement seems equally unneeded, maybe you could remove it too?

Unless you want to provide a separate patch for this, as there are 5
other drivers doing the same.

-- 
Jean Delvare
