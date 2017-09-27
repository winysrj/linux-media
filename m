Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22342 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752524AbdI0J65 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 05:58:57 -0400
Date: Wed, 27 Sep 2017 12:58:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org, Daniele Nicolodi <daniele@grinta.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] [media] bt8xx: Use common error handling code in two
 functions
Message-ID: <20170927095829.gsmjep4frlq4tnzd@mwanda>
References: <7ad78087-fdd4-b76b-d770-81b9a55aaabd@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ad78087-fdd4-b76b-d770-81b9a55aaabd@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 25, 2017 at 10:18:29PM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 25 Sep 2017 22:10:17 +0200
> 
> Adjust jump targets so that a bit of exception handling can be better
> reused at the end of these functions.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/media/pci/bt8xx/dst.c    | 19 +++++++++++--------
>  drivers/media/pci/bt8xx/dst_ca.c | 30 +++++++++++++++---------------
>  2 files changed, 26 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/media/pci/bt8xx/dst.c b/drivers/media/pci/bt8xx/dst.c
> index 7166d2279465..1290419aca0b 100644
> --- a/drivers/media/pci/bt8xx/dst.c
> +++ b/drivers/media/pci/bt8xx/dst.c
> @@ -134,17 +134,20 @@ EXPORT_SYMBOL(rdc_reset_state);
>  static int rdc_8820_reset(struct dst_state *state)
>  {
>  	dprintk(3, "Resetting DST\n");
> -	if (dst_gpio_outb(state, RDC_8820_RESET, RDC_8820_RESET, 0, NO_DELAY) < 0) {
> -		pr_err("dst_gpio_outb ERROR !\n");
> -		return -1;
> -	}
> +	if (dst_gpio_outb(state, RDC_8820_RESET, RDC_8820_RESET, 0, NO_DELAY)
> +	    < 0)
> +		goto report_failure;
> +
>  	udelay(1000);
> -	if (dst_gpio_outb(state, RDC_8820_RESET, RDC_8820_RESET, RDC_8820_RESET, DELAY) < 0) {
> -		pr_err("dst_gpio_outb ERROR !\n");
> -		return -1;
> -	}
> +	if (dst_gpio_outb(state, RDC_8820_RESET, RDC_8820_RESET,
> +			  RDC_8820_RESET, DELAY) < 0)
> +		goto report_failure;
>  
>  	return 0;
> +
> +report_failure:
> +	pr_err("dst_gpio_outb ERROR !\n");
> +	return -1;

This code is ugly and this patch doesn't improve it; it just shuffles
it around.

regards,
dan carpenter
