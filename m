Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.dibcom.eu ([84.37.95.87]:53575 "EHLO mail.dibcom.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab1IEIqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2011 04:46:17 -0400
From: Olivier Grenie <Olivier.Grenie@dibcom.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Mon, 5 Sep 2011 10:11:38 +0200
Subject: RE: DiBxxxx: fixes for 3.1/3.0
Message-ID: <57C38DA176A0A34A9B9F3CCCE33D3C4A0160DC65B0D7@FRPAR1CL009.coe.adi.dibcom.com>
References: <alpine.LRH.2.00.1108031728090.30199@pub2.ifh.de>,<4E62CA12.8020805@infradead.org>
In-Reply-To: <4E62CA12.8020805@infradead.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,
I agree with you but when I wrote this patch, my concern was  that the read register function (dib0070_read_reg) returns a u16 and so I could not propagate the error. That's why I decided to return 0 and not change the API. But if you have a better idea, I will have no problem to implement it.

For the write register function (dib0070_write_reg), in case of problem with the mutex lock, an error code is returned.

The same idea is true for the whole patch.

regards,
Olivier

________________________________________
From: linux-media-owner@vger.kernel.org [linux-media-owner@vger.kernel.org] On Behalf Of Mauro Carvalho Chehab [mchehab@infradead.org]
Sent: Sunday, September 04, 2011 2:45 AM
To: Patrick Boettcher
Cc: Linux Media Mailing List
Subject: Re: DiBxxxx: fixes for 3.1/3.0

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
> +     u16 ret;
> +
> +     if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
> +             dprintk("could not acquire lock");
> +             return 0;

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

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

CONFIDENTIAL NOTICE: The contents of this message, including any attachments, are confidential and are intended solely for the use of the person or entity to whom the message was addressed. If you are not the intended recipient of this message, please be advised that any dissemination, distribution, or use of the contents of this message is strictly prohibited. If you received this message in error, please notify the sender. Please also permanently delete all copies of the original message and any attached documentation. Thank you.
