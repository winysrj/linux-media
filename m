Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:56186 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750945Ab0L3NqN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 08:46:13 -0500
Subject: Re: [PATCH 3/4] [media] ivtv: Add Adaptec Remote Controller
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4D1C8928.1060200@redhat.com>
References: <cover.1293709356.git.mchehab@redhat.com>
	 <20101230094509.2ecbf089@gaivota>
	 <1293713183.2056.31.camel@morgan.silverblock.net>
	 <4D1C8928.1060200@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Dec 2010 08:46:58 -0500
Message-ID: <1293716818.4084.23.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thu, 2010-12-30 at 11:29 -0200, Mauro Carvalho Chehab wrote:
> Em 30-12-2010 10:46, Andy Walls escreveu:
> > On Thu, 2010-12-30 at 09:45 -0200, Mauro Carvalho Chehab wrote:
> > 
> > 
> > 
> >> As we'll remove lirc_i2c from kernel, move the getkey code to ivtv driver, and
> >> use it for AVC2410.
> >>
> >> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> >>
> >> diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
> >> index 6817092..8d1b016 100644
> >> --- a/drivers/media/video/ivtv/ivtv-i2c.c
> >> +++ b/drivers/media/video/ivtv/ivtv-i2c.c
> >> @@ -94,6 +94,7 @@
> >>  #define IVTV_HAUP_INT_IR_RX_I2C_ADDR 	0x18
> >>  #define IVTV_Z8F0811_IR_TX_I2C_ADDR	0x70
> >>  #define IVTV_Z8F0811_IR_RX_I2C_ADDR	0x71
> > [snip]
> > 
> >> @@ -219,7 +252,6 @@ struct i2c_client *ivtv_i2c_new_ir_legacy(struct ivtv *itv)
> >>  		0x1a,	/* Hauppauge IR external - collides with WM8739 */
> >>  		0x18,	/* Hauppauge IR internal */
> >>  		0x71,	/* Hauppauge IR (PVR150) */
> >                   ^^^^
> > BTW, since
> > 
> > a. all ivtv cards that have an IR Rx chip at address 0x71 should be
> > accounted for in ivtv-cards.c
> > b. lirc_i2c is going away
> > c. lirc_zilog should not be probing devices labeled "ir_video"
> > d. ir-kbd-i2c doesn't have defaults for address 0x71
> > 
> > Can you remove the 0x71 case here while you are making changes?
> 
> Sure. Patch enclosed.
> 
> Btw, I think we should remove ivtv_i2c_new_ir_legacy, or rename it.
> The only remaining case there is the standard non-Z8 Hauppauge IR
> I2C decoder.

The "i2c_new_ir" portion of the name means "register a new I2C connected
IR controller".
 
The "_legacy" portion of the name means "probe for an IR device that
might exist".

The ivtv driver only does it for ivtv-cards.c entries that don't mention
any IR device.

I can't remove it, since some deployed cards models still might need it.

For a rename maybe "ivtv_i2c_probe_unlisted_ir()"?

> Thanks,
> Mauro
> 
> -
> 
> commit 615a80d8f744677bc79b33811c5f671fa7fe1976
> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
> Date:   Thu Dec 30 11:25:12 2010 -0200
> 
>     ivtv-i2c: Don't use IR legacy mode for Zilog IR
>     
>     The Zilog IR entries are already handled by IR new code. So,
>     remove its usage from the legacy IR support.
>     
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Looks good.

Acked-by: Andy Walls <awalls@md.metrocast.net>

Regards,
Andy

> diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
> index fb0ac68..d121389 100644
> --- a/drivers/media/video/ivtv/ivtv-i2c.c
> +++ b/drivers/media/video/ivtv/ivtv-i2c.c
> @@ -253,7 +253,6 @@ struct i2c_client *ivtv_i2c_new_ir_legacy(struct ivtv *itv)
>  	const unsigned short addr_list[] = {
>  		0x1a,	/* Hauppauge IR external - collides with WM8739 */
>  		0x18,	/* Hauppauge IR internal */
> -		0x71,	/* Hauppauge IR (PVR150) */
>  		I2C_CLIENT_END
>  	};
>  


