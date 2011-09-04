Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:49028 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab1IDApM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Sep 2011 20:45:12 -0400
Message-ID: <4E62CA12.8020805@infradead.org>
Date: Sat, 03 Sep 2011 21:45:06 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: DiBxxxx: fixes for 3.1/3.0
References: <alpine.LRH.2.00.1108031728090.30199@pub2.ifh.de>
In-Reply-To: <alpine.LRH.2.00.1108031728090.30199@pub2.ifh.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-08-2011 12:33, Patrick Boettcher escreveu:
> Hi Mauro,

Thanks for the patches!

> Would you please pull from
> 
> git://linuxtv.org/pb/media_tree.git for_v3.0
> 
> for the following to changesets:
> 
> [media] dib0700: protect the dib0700 buffer access

> -static uint16_t dib0070_read_reg(struct dib0070_state *state, u8 reg)
> +static u16 dib0070_read_reg(struct dib0070_state *state, u8 reg)
>  {
> +	u16 ret;
> +
> +	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
> +		dprintk("could not acquire lock");
> +		return 0;

Returning 0 doesn't seem right for me. IMO, it should be return -EAGAIN
or -EINTR (which is, incidentally, what mutex_lock_interruptible() will 
return).

The same applies to the similar parts of the code, at the read and write
routines.

> [media] DiBcom: protect the I2C bufer access
> 
> ?
> 
> Those two changesets are fixing the remaining problems regarding the dma-on-stack-buffer-fix applied for the first time in 2.6.39, IIRC.
> 
> They should go to stable 3.0 (as they are in my tree) and they can be cherry-picked to 3.1.
> 
> We are preparing the same thing for 2.6.39 as the patches don't apply cleanly.
> 
> Thanks to Javier Marcet for his help during the debug-phase.
> 
> thanks and best regards,
> -- 
> 
> Patrick Boettcher - Kernel Labs
> http://www.kernellabs.com/
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

