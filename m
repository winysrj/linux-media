Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9G40tOc013298
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 00:01:00 -0400
Received: from nlpi053.prodigy.net (nlpi053.sbcis.sbc.com [207.115.36.82])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9G3xl3M027907
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 23:59:47 -0400
Message-ID: <48F6BC28.9070703@xnet.com>
Date: Wed, 15 Oct 2008 22:59:36 -0500
From: stuart <stuart@xnet.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <48CD6F11.8020900@xnet.com>
	<48F4F552.7060800@xnet.com>	<1224018283.5486.28.camel@pc10.localdom.local>	<200810141854.09820.vanessaezekowitz@gmail.com>
	<1224102756.2683.67.camel@pc10.localdom.local>
In-Reply-To: <1224102756.2683.67.camel@pc10.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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



hermann pitton wrote:
> Hi Vanessa,
> 
> Am Dienstag, den 14.10.2008, 18:54 -0500 schrieb Vanessa Ezekowitz:
>> On Tuesday 14 October 2008 4:04:42 pm hermann pitton wrote:
>>> thanks, I tried to look it up better this time and saw this already at
>>> the linuxtv wiki. Also found a reasonable picture, but not good enough.
>>> At least no 16 pins KS007 so far.
> 
> this needs correction. KS003 and KS007 both have 18 pins and are clearly
> marked with these names. They are on many recent Kworld products.
> 
>> I have sent Hermann some high resolution photos of my Kworld ATSC 120 by direct email.
>>
>> Hermann, feel free to pass these around if you need to; if you need better ones, or you want me to direct my camera to a particular spot on the card, please let me know.
> 
> Thanks, but no luck on the bttv-gallery so far.
> Maybe somebody else saw it already.
> 
> It should be the chip with 20 pins in position U9, unfortunately only
> marked with a green colored spot and connected to the xtal X0 16MHz in
> front of the radio RF input.
> 
> We have an unknown gpio remote controller marked with a grey spot on the
> saa7131e Kworld TV Studio Terminator, but 18 pins and 20MHz clock and
> that smaller grey remote with 36 keys. Usually RM-Kum01 and xtal 4MHz.
> Also one only with a blue spot on Kworld Creator TV MCE 100 Pro and
> remote with 32 keys. (BTW, some rare KS008 is on Cinergy 250 PCI)
> 
> 	case SAA7134_BOARD_KWORLD_TERMINATOR:
> 		ir_codes     = ir_codes_pixelview;
> 		mask_keycode = 0x00001f;
> 		mask_keyup   = 0x000060;
> 		polling      = 50; // ms
> 		break;
> 
> On cx88-input.c all Kworld stuff has that too.
> 
> 		ir->gpio_addr = MO_GP1_IO;
> 		ir->mask_keycode = 0x1f;
> 		ir->mask_keyup = 0x60;
> 
> But you switch already some pins within mask_keycode on MO_GP1_IO.
> Maybe on MO_GP0_IO. Is that gpio0 and gpio2 stuff needed at all in the
> card's entry? If not, but some of the first 8 gpios are connected, might
> be the remote. Needs to have the cx23880 pinning at hand, but seems
> there are no simply visible connections from that green marked chip.
> Maybe worth to try with mask_keycode = 0x0.
> 
> On the other hand, on the backside seem to be two lines from that chip
> more in direction to the tuner. Could hang on i2c there, but can't tell.
> Does any unknown device show up with cx88xx i2c_scan=1?
> 
> For now, known Kworld stuff has various IR controllers with 18 pins.
> It is not one of the newer KS00x i2c devices here and a controller with
> 20 pins and 16MHz clock seems to be new. How many keys/buttons has the
> remote?
> 
> That is not much, but hopefully better than nothing.
> I can't exclude that the controller needs some sort of
> initialization/activation or maybe even uses a new IR protocol,
> but testing in the above directions should not be too much work.
> 
> Cheers,
> Hermann
> 

I looked and found an 8 and 16 pin SMD IC on my kworld 120.  The 16 pin 
device turned out to be a multi-bit A/D converter, not an I2C 
controller.  After reading the above again I believe I understand what 
20 pin device you are talking about.  Just right of the composite video 
input past the Xtl in this photo:
http://c1.neweggimages.com/NeweggImage/productimage/15-260-007-15.jpg
...I'll have to take another look.

The remote for my kworld 120 has 35 keys. (My kworld 110 remote has 
about 45 keys.)

...thanks for your help.




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
