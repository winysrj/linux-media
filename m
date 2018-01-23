Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:41847 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752290AbeAWNO2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Jan 2018 08:14:28 -0500
Date: Tue, 23 Jan 2018 13:14:25 +0000
From: Sean Young <sean@mess.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] media: lirc: Fix uninitialized variable in
 ir_lirc_transmit_ir()
Message-ID: <20180123131425.sghf77ivdd6weqsf@gofer.mess.org>
References: <20180110093623.z5kqrsnu72stchu5@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180110093623.z5kqrsnu72stchu5@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 10, 2018 at 12:36:23PM +0300, Dan Carpenter wrote:
> The "txbuf" is uninitialized when we call ir_raw_encode_scancode() so
> this failure path would lead to a crash.

Thanks for reporting this issue, however I'm afraid that the issue has
already been resolved:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg123672.html

and:

https://git.linuxtv.org/media_tree.git/commit/?id=8d25e15d94a2d7b60c28d3a30e4e0e780cab2056

Many thanks,

Sean


> 
> Fixes: a74b2bff5945 ("media: lirc: do not pass ERR_PTR to kfree")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
> index fae42f120aa4..5efe9cd2309a 100644
> --- a/drivers/media/rc/lirc_dev.c
> +++ b/drivers/media/rc/lirc_dev.c
> @@ -295,7 +295,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
>  		ret = ir_raw_encode_scancode(scan.rc_proto, scan.scancode,
>  					     raw, LIRCBUF_SIZE);
>  		if (ret < 0)
> -			goto out_kfree;
> +			goto out_free_raw;
>  
>  		count = ret;
>  
> @@ -366,6 +366,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
>  	return n;
>  out_kfree:
>  	kfree(txbuf);
> +out_free_raw:
>  	kfree(raw);
>  out_unlock:
>  	mutex_unlock(&dev->lock);
