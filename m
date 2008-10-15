Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9FKeLTc024867
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 16:40:21 -0400
Received: from mail-in-16.arcor-online.net (mail-in-16.arcor-online.net
	[151.189.21.56])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9FKe8jF009616
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 16:40:08 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
In-Reply-To: <200810141854.09820.vanessaezekowitz@gmail.com>
References: <48CD6F11.8020900@xnet.com> <48F4F552.7060800@xnet.com>
	<1224018283.5486.28.camel@pc10.localdom.local>
	<200810141854.09820.vanessaezekowitz@gmail.com>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 22:32:36 +0200
Message-Id: <1224102756.2683.67.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: KWorld 120 IR control?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Vanessa,

Am Dienstag, den 14.10.2008, 18:54 -0500 schrieb Vanessa Ezekowitz:
> On Tuesday 14 October 2008 4:04:42 pm hermann pitton wrote:
> > thanks, I tried to look it up better this time and saw this already at
> > the linuxtv wiki. Also found a reasonable picture, but not good enough.
> > At least no 16 pins KS007 so far.

this needs correction. KS003 and KS007 both have 18 pins and are clearly
marked with these names. They are on many recent Kworld products.

> I have sent Hermann some high resolution photos of my Kworld ATSC 120 by direct email.
> 
> Hermann, feel free to pass these around if you need to; if you need better ones, or you want me to direct my camera to a particular spot on the card, please let me know.

Thanks, but no luck on the bttv-gallery so far.
Maybe somebody else saw it already.

It should be the chip with 20 pins in position U9, unfortunately only
marked with a green colored spot and connected to the xtal X0 16MHz in
front of the radio RF input.

We have an unknown gpio remote controller marked with a grey spot on the
saa7131e Kworld TV Studio Terminator, but 18 pins and 20MHz clock and
that smaller grey remote with 36 keys. Usually RM-Kum01 and xtal 4MHz.
Also one only with a blue spot on Kworld Creator TV MCE 100 Pro and
remote with 32 keys. (BTW, some rare KS008 is on Cinergy 250 PCI)

	case SAA7134_BOARD_KWORLD_TERMINATOR:
		ir_codes     = ir_codes_pixelview;
		mask_keycode = 0x00001f;
		mask_keyup   = 0x000060;
		polling      = 50; // ms
		break;

On cx88-input.c all Kworld stuff has that too.

		ir->gpio_addr = MO_GP1_IO;
		ir->mask_keycode = 0x1f;
		ir->mask_keyup = 0x60;

But you switch already some pins within mask_keycode on MO_GP1_IO.
Maybe on MO_GP0_IO. Is that gpio0 and gpio2 stuff needed at all in the
card's entry? If not, but some of the first 8 gpios are connected, might
be the remote. Needs to have the cx23880 pinning at hand, but seems
there are no simply visible connections from that green marked chip.
Maybe worth to try with mask_keycode = 0x0.

On the other hand, on the backside seem to be two lines from that chip
more in direction to the tuner. Could hang on i2c there, but can't tell.
Does any unknown device show up with cx88xx i2c_scan=1?

For now, known Kworld stuff has various IR controllers with 18 pins.
It is not one of the newer KS00x i2c devices here and a controller with
20 pins and 16MHz clock seems to be new. How many keys/buttons has the
remote?

That is not much, but hopefully better than nothing.
I can't exclude that the controller needs some sort of
initialization/activation or maybe even uses a new IR protocol,
but testing in the above directions should not be too much work.

Cheers,
Hermann


 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
