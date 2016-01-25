Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46299 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358AbcAYRHC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 12:07:02 -0500
Date: Mon, 25 Jan 2016 15:06:54 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] [media] xc5000: Faster result reporting in
 xc_load_fw_and_init_tuner()
Message-ID: <20160125150654.7ada12ac@recife.lan>
In-Reply-To: <56818B7B.8040801@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
	<56818B7B.8040801@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 28 Dec 2015 20:20:27 +0100
SF Markus Elfring <elfring@users.sourceforge.net> escreveu:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 28 Dec 2015 20:10:30 +0100
> 
> This issue was detected by using the Coccinelle software.
> 
> Split the previous if statement at the end so that each final log statement
> will eventually be performed by a direct jump to these labels.
> * report_failure
> * report_success
> 
> A check repetition can be excluded for the variable "ret" at the end then.
> 
> 
> Apply also two recommendations from the script "checkpatch.pl".
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/media/tuners/xc5000.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
> index e6e5e90..1360677 100644
> --- a/drivers/media/tuners/xc5000.c
> +++ b/drivers/media/tuners/xc5000.c
> @@ -1166,7 +1166,7 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe, int force)
>  
>  		ret = xc5000_fwupload(fe, desired_fw, fw);
>  		if (ret != 0)
> -			goto err;
> +			goto report_failure;
>  
>  		msleep(20);
>  
> @@ -1229,18 +1229,16 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe, int force)
>  		/* Default to "CABLE" mode */
>  		ret = xc_write_reg(priv, XREG_SIGNALSOURCE, XC_RF_MODE_CABLE);
>  		if (!ret)
> -			break;
> +			goto report_success;
>  		printk(KERN_ERR "xc5000: can't set to cable mode.");

It sounds worth to avoid adding a goto here.

>  	}
>  
> -err:
> -	if (!ret)
> -		printk(KERN_INFO "xc5000: Firmware %s loaded and running.\n",
> -		       desired_fw->name);
> -	else
> -		printk(KERN_CONT " - too many retries. Giving up\n");
> -
> +report_failure:
> +	pr_cont(" - too many retries. Giving up\n");
>  	return ret;
> +report_success:
> +	pr_info("xc5000: Firmware %s loaded and running.\n", desired_fw->name);
> +	return 0;
>  }
>  
>  static void xc5000_do_timer_sleep(struct work_struct *timer_sleep)
