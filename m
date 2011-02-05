Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:39910 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253Ab1BEXpd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Feb 2011 18:45:33 -0500
Subject: Re: [PATCH] cx25840: fix probing of cx2583x chips
From: Andy Walls <awalls@md.metrocast.net>
To: Sven Barth <pascaldragon@googlemail.com>
Cc: LMML <linux-media@vger.kernel.org>
In-Reply-To: <4D4DC6DF.7020101@googlemail.com>
References: <4D4DC6DF.7020101@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Feb 2011 18:45:28 -0500
Message-ID: <1296949528.24258.0.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-02-05 at 22:53 +0100, Sven Barth wrote:
> Fix the probing of cx2583x chips, because two controls were clustered 
> that are not created for these chips.
> 
> This regression was introduced in 2.6.36.
> 
> Signed-off-by: Sven Barth <pascaldragon@googlemail.com>

Acked-by: Andy Walls <awalls@md.metrocast.net>


> diff -aur linux-2.6.37/drivers/media/video/cx25840/cx25840-core.c 
> linux-2.6.37-patched/drivers/media/video/cx25840/cx25840-core.c
> --- linux-2.6.37/drivers/media/video/cx25840/cx25840-core.c	2011-01-05 
> 00:50:19.000000000 +0000
> +++ linux-2.6.37-patched/drivers/media/video/cx25840/cx25840-core.c 
> 2011-02-05 15:58:27.733325238 +0000
> @@ -2031,7 +2031,8 @@
>   		kfree(state);
>   		return err;
>   	}
> -	v4l2_ctrl_cluster(2, &state->volume);
> +	if (!is_cx2583x(state))
> +		v4l2_ctrl_cluster(2, &state->volume);
>   	v4l2_ctrl_handler_setup(&state->hdl);
> 
>   	cx25840_ir_probe(sd);


