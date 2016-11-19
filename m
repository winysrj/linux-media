Return-path: <linux-media-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40008 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752851AbcKSWc3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Nov 2016 17:32:29 -0500
Date: Sat, 19 Nov 2016 22:32:24 +0000
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Sean Young <sean@mess.org>
Subject: Re: [PATCH v2] [media] cx88: make checkpatch.pl happy
Message-ID: <20161119223224.GB11418@dell-m4800.home>
References: <451cfbe8b2a968992c49edac0fad57a6425caad6.1479590802.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <451cfbe8b2a968992c49edac0fad57a6425caad6.1479590802.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for your hard work at beautification of this driver :)
>From reviewing the diff over v1, it looks good.

Also thanks for deep explanations you gave me for my comments.

On Sat, Nov 19, 2016 at 07:27:30PM -0200, Mauro Carvalho Chehab wrote:
> 
> Suggested-by: Andrey Utkin <andrey_utkin@fastmail.com>
> Fixes: 65bc2fe86e66 ("[media] cx88: convert it to use pr_foo() macros")
> Fixes: 7b61ba8ff838 ("[media] cx88: make checkpatch happier")
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---

Reviewed-by: Andrey Utkin <andrey_utkin@fastmail.com>

> --- a/drivers/media/pci/cx88/cx88-input.c
> +++ b/drivers/media/pci/cx88/cx88-input.c
> @@ -62,11 +62,15 @@ static int ir_debug;
>  module_param(ir_debug, int, 0644);	/* debug level [IR] */
>  MODULE_PARM_DESC(ir_debug, "enable debug messages [IR]");
>  
> -#define ir_dprintk(fmt, arg...)	if (ir_debug) \
> -	printk(KERN_DEBUG "%s IR: " fmt, ir->core->name, ##arg)
> +#define ir_dprintk(fmt, arg...)	do {					\
> +	if (ir_debug)							\
> +		printk(KERN_DEBUG "%s IR: " fmt, ir->core->name, ##arg);\
> +} while (0)

Oh ok, so when the patch is applied, the backslash doesn't stand out, it
just looks this way in the diff.
