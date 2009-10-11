Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:49969 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290AbZJKMEE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Oct 2009 08:04:04 -0400
Subject: Re: [PATCH] AVerTV MCE 116 Plus radio
From: Andy Walls <awalls@radix.net>
To: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
Cc: ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
In-Reply-To: <20091011010039.GA4726@moon>
References: <20091006080406.GA22207@moon> <20091006081159.GB22207@moon>
	 <20091011010039.GA4726@moon>
Content-Type: text/plain
Date: Sun, 11 Oct 2009 08:05:35 -0400
Message-Id: <1255262735.3151.16.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-10-11 at 04:01 +0300, Aleksandr V. Piskunov wrote:
> On Tue, Oct 06, 2009 at 11:11:59AM +0300, Aleksandr V. Piskunov wrote:
> > On Tue, Oct 06, 2009 at 11:04:06AM +0300, Aleksandr V. Piskunov wrote:
> > > Added FM radio support to Avermedia AVerTV MCE 116 Plus card
> > > 
> > 
> > What leaves me puzzled, radio only works ok with ivtv newi2c=1
> > 
> > With default newi2c audio is tinny, metallic, with some strange static.
> > Similar problem with pvr-150 was reported years ago, guess issue is still
> > unresolved, perhaps something with cx25840..
> 
> This particular "tinny" audio problem is definitely I2C speed related, to be
> more precise, audio only goes bad if i2c-algo-bit is being run with udelay
> less than 15, i.e. i2c bus frequency is higher than 30 KHz.
> 
> So with default udelay=10 or udelay=5 (optimal for IR reciever on that board)
> radio goes bad. Running with newi2c=1 is ok, but again it isn't optimal for IR
> reciever on AVerTV M116.
> 
> I2C reads/writes to cx25840 themself are ok, verified using register readback
> after each write/write4. Problem seems to be that with cx25840 register writes
> coming too fast on higher i2c bus speed, switching register 0x808 _from_ 
> TV standard autodetection mode (0xff) _to_ FM radio mode (0xf9) leaves chip 
> audio detection routine in inconsistent state.
> 
> The only solution I found is to do standard routine (assert_reset + write +
> deassert_reset) followed by 50ms delay and another reset.
> 
> Following patch works_for_me, can be improved to only delay/doublereset when
> really needed, etc. Andy, could you comment/review?

Aleksandr,

I will when I get time.  This past week and next few weeks are very busy
for me for personal (non-linux) reasons.  I'll try to get caught up with
the patches I still have to rework and then look at this.

Obviously, your patch is fairly straightforward and looks OK.  I just
haven't checked for any implications.  The "general" tinny audio problem
with the CX25840 on ivtv boards is *always* resolved with an audio
microcontroller reset.

The problem is the microcontroller may restart its detection loop and
tinny audio may return.  Can you run FM radio for a long time (a day ?),
and see if it ever goes back to tinny audio?

Regards,
Andy

> 
> diff --git a/linux/drivers/media/video/cx25840/cx25840-core.c b/linux/drivers/media/video/cx25840/cx25840-core.c
> --- a/linux/drivers/media/video/cx25840/cx25840-core.c
> +++ b/linux/drivers/media/video/cx25840/cx25840-core.c
> @@ -626,7 +642,13 @@
>  	if (state->radio) {
>  		cx25840_write(client, 0x808, 0xf9);
>  		cx25840_write(client, 0x80b, 0x00);
> -	}
> +		/* Double reset cx2384x after setting FM radio mode, helps to
> +		   avoid "tinny" audio when ivtv I2C bus is being run on
> +		   frequency higher than 30 KHz */
> +		cx25840_and_or(client, 0x810, ~0x01, 0);
> +		msleep(50);
> +		cx25840_and_or(client, 0x810, ~0x01, 1);
> +	}	
>  	else if (std & V4L2_STD_525_60) {
>  		/* Certain Hauppauge PVR150 models have a hardware bug
>  		   that causes audio to drop out. For these models the
> 

