Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:56642 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab0BDAds (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 19:33:48 -0500
Subject: Re: [PATCH] AVerTV MCE 116 Plus radio
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
In-Reply-To: <4B6844F6.2090404@gmail.com>
References: <20091006080406.GA22207@moon> <20091006081159.GB22207@moon>
	 <20091011010039.GA4726@moon> <1258774767.9080.1.camel@palomino.walls.org>
	 <4B6844F6.2090404@gmail.com>
Content-Type: text/plain
Date: Wed, 03 Feb 2010 19:33:20 -0500
Message-Id: <1265243600.3122.10.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-02-02 at 13:29 -0200, Mauro Carvalho Chehab wrote:
> Hi Andy,
> 
> This patch has never been applied or nacked. From your last comment, it
> seems that you're waiting for Aleksandr Signed-of-by:.
> 
> If this is still the case, I suggest you to wait for a couple days. If he doesn't
> send it, it is safe to add it without his SOB, since it is really a trivial change.

I'd like to look at this one once more.  The extra 50 ms and another
reset may be avoidable.

cx25840-core.c:set_input() gets called for s_frequency so I'd like not
to add 50 ms if not needed.

Regards,
Andy

> Cheers,
> Mauro.
> 
> Andy Walls wrote:
> > On Sun, 2009-10-11 at 04:01 +0300, Aleksandr V. Piskunov wrote:
> >> On Tue, Oct 06, 2009 at 11:11:59AM +0300, Aleksandr V. Piskunov wrote:
> >>> On Tue, Oct 06, 2009 at 11:04:06AM +0300, Aleksandr V. Piskunov wrote:
> >>>> Added FM radio support to Avermedia AVerTV MCE 116 Plus card
> >>>>
> >>> What leaves me puzzled, radio only works ok with ivtv newi2c=1
> >>>
> >>> With default newi2c audio is tinny, metallic, with some strange static.
> >>> Similar problem with pvr-150 was reported years ago, guess issue is still
> >>> unresolved, perhaps something with cx25840..
> >> This particular "tinny" audio problem is definitely I2C speed related, to be
> >> more precise, audio only goes bad if i2c-algo-bit is being run with udelay
> >> less than 15, i.e. i2c bus frequency is higher than 30 KHz.
> >>
> >> So with default udelay=10 or udelay=5 (optimal for IR reciever on that board)
> >> radio goes bad. Running with newi2c=1 is ok, but again it isn't optimal for IR
> >> reciever on AVerTV M116.
> >>
> >> I2C reads/writes to cx25840 themself are ok, verified using register readback
> >> after each write/write4. Problem seems to be that with cx25840 register writes
> >> coming too fast on higher i2c bus speed, switching register 0x808 _from_ 
> >> TV standard autodetection mode (0xff) _to_ FM radio mode (0xf9) leaves chip 
> >> audio detection routine in inconsistent state.
> >>
> >> The only solution I found is to do standard routine (assert_reset + write +
> >> deassert_reset) followed by 50ms delay and another reset.
> >>
> >> Following patch works_for_me, can be improved to only delay/doublereset when
> >> really needed, etc. Andy, could you comment/review?
> > 
> > Aleksandr,
> > 
> > Could you provide your Signed-off-by for this patch?  I'm going to
> > commit it as is.
> > 
> > Thanks,
> > Andy
> > 
> >> diff --git a/linux/drivers/media/video/cx25840/cx25840-core.c b/linux/drivers/media/video/cx25840/cx25840-core.c
> >> --- a/linux/drivers/media/video/cx25840/cx25840-core.c
> >> +++ b/linux/drivers/media/video/cx25840/cx25840-core.c
> >> @@ -626,7 +642,13 @@
> >>  	if (state->radio) {
> >>  		cx25840_write(client, 0x808, 0xf9);
> >>  		cx25840_write(client, 0x80b, 0x00);
> >> -	}
> >> +		/* Double reset cx2384x after setting FM radio mode, helps to
> >> +		   avoid "tinny" audio when ivtv I2C bus is being run on
> >> +		   frequency higher than 30 KHz */
> >> +		cx25840_and_or(client, 0x810, ~0x01, 0);
> >> +		msleep(50);
> >> +		cx25840_and_or(client, 0x810, ~0x01, 1);
> >> +	}	
> >>  	else if (std & V4L2_STD_525_60) {
> >>  		/* Certain Hauppauge PVR150 models have a hardware bug
> >>  		   that causes audio to drop out. For these models the
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

