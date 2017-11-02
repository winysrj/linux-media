Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:55880 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754885AbdKBIPs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Nov 2017 04:15:48 -0400
Received: by mail-lf0-f66.google.com with SMTP id e143so5375124lfg.12
        for <linux-media@vger.kernel.org>; Thu, 02 Nov 2017 01:15:48 -0700 (PDT)
Date: Thu, 2 Nov 2017 09:15:45 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 13/26] media: rcar: fix a debug printk
Message-ID: <20171102081545.GB24132@bigcity.dyn.berto.se>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
 <ef0a1dc7f902c8ed9cc8aa454bd07a8fcda66dfa.1509569763.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ef0a1dc7f902c8ed9cc8aa454bd07a8fcda66dfa.1509569763.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for your patch.

On 2017-11-01 17:05:50 -0400, Mauro Carvalho Chehab wrote:
> Two orthogonal changesets caused a breakage at a printk
> inside rcar. Changeset 859969b38e2e
> ("[media] v4l: Switch from V4L2 OF not V4L2 fwnode API")
> made davinci to use struct fwnode_handle instead of
> struct device_node. Changeset 68d9c47b1679
> ("media: Convert to using %pOF instead of full_name")
> changed the printk to not use ->full_name, but, instead,
> to rely on %pOF.
> 
> With both patches applied, the Kernel will do the wrong
> thing, as warned by smatch:
> 	drivers/media/platform/rcar-vin/rcar-core.c:189 rvin_digital_graph_init() error: '%pOF' expects argument of type 'struct device_node*', argument 4 has type 'void*'
> 
> So, change the logic to actually print the device name
> that was obtained before the print logic.
> 
> Fixes: 68d9c47b1679 ("media: Convert to using %pOF instead of full_name")
> Fixes: 859969b38e2e ("[media] v4l: Switch from V4L2 OF not V4L2 fwnode API")
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 108d776f3265..ce5914f7a056 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -186,8 +186,8 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
>  	if (!vin->digital)
>  		return -ENODEV;
>  
> -	vin_dbg(vin, "Found digital subdevice %pOF\n",
> -		to_of_node(vin->digital->asd.match.fwnode.fwnode));
> +	vin_dbg(vin, "Found digital subdevice %s\n",
> +		to_of_node(vin->digital->asd.match.fwnode.fwnode)->full_name);

For the same reasons as Laurent brings up in patch 14/26 I'm a bit 
sceptical to this change.

>  
>  	vin->notifier.ops = &rvin_digital_notify_ops;
>  	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
> -- 
> 2.13.6
> 

-- 
Regards,
Niklas Söderlund
