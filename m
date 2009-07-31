Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:42196 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbZGaVko (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2009 17:40:44 -0400
Date: Fri, 31 Jul 2009 23:40:46 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: emagick@magic.ms
Cc: linux-media@vger.kernel.org
Subject: Re: Patch for  stack/DMA problems in Cinergy T2 drivers (2)
Message-ID: <20090731214046.GA28139@linuxtv.org>
References: <4A735330.1000406@magic.ms>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A735330.1000406@magic.ms>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 31, 2009 at 10:25:20PM +0200, emagick@magic.ms wrote:
> Here's a patch for cinergyT2-core.c:
> 
> --- a/drivers/media/dvb/dvb-usb/cinergyT2-fe.c	2009-06-10 05:05:27.000000000 +0200
> +++ b/drivers/media/dvb/dvb-usb/cinergyT2-fe.c	2009-07-31 22:02:48.000000000 +0200
> @@ -146,66 +146,103 @@
>  					fe_status_t *status)
>  {
>  	struct cinergyt2_fe_state *state = fe->demodulator_priv;
> -	struct dvbt_get_status_msg result;
> -	u8 cmd[] = { CINERGYT2_EP1_GET_TUNER_STATUS };
> +	struct dvbt_get_status_msg *result;
> +	static const u8 cmd0[] = { CINERGYT2_EP1_GET_TUNER_STATUS };
> +        u8 *cmd;
>  	int ret;
> 
> -	ret = dvb_usb_generic_rw(state->d, cmd, sizeof(cmd), (u8 *)&result,
> -			sizeof(result), 0);
> -	if (ret < 0)
> +        cmd = kmalloc(sizeof(cmd0), GFP_KERNEL);
> +        if (!cmd) return -ENOMEM;
> +        memcpy(cmd, cmd0, sizeof(cmd0));
> +        result = kmalloc(sizeof(*result), GFP_KERNEL);
> +        if (!result) {
> +                kfree(cmd);
> +                return -ENOMEM;
> +        }
> +	ret = dvb_usb_generic_rw(state->d, cmd, sizeof(cmd0), (u8 *)result,
> +			sizeof(*result), 0);
> +        kfree(cmd);
> +	if (ret < 0) {
> +                kfree(result);
>  		return ret;
> +        }

There is a fair amount of code duplication.  A better aproach would
be to allocate buffers once in cinergyt2_fe_attach()
(add them to struct cinergyt2_fe_state).

And please observe http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches
