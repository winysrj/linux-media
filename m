Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail4.aster.pl ([212.76.33.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Daniel.Perzynski@aster.pl>) id 1LAWjH-0001K1-4v
	for linux-dvb@linuxtv.org; Wed, 10 Dec 2008 22:36:23 +0100
From: "Daniel Perzynski" <Daniel.Perzynski@aster.pl>
To: "'Devin Heitmueller'" <devin.heitmueller@gmail.com>
References: <-2195289716128877320@unknownmsgid>
	<412bdbff0812101321la03034cwc193959e9e9e6767@mail.gmail.com>
In-Reply-To: <412bdbff0812101321la03034cwc193959e9e9e6767@mail.gmail.com>
Date: Wed, 10 Dec 2008 22:36:13 +0100
Message-ID: <001301c95b0f$5315e270$f941a750$@Perzynski@aster.pl>
MIME-Version: 1.0
Content-Language: en-us
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Fw: Re: Avermedia A312 wiki page
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

-----Original Message-----
From: Devin Heitmueller [mailto:devin.heitmueller@gmail.com] 
Sent: Wednesday, December 10, 2008 10:22 PM
To: Daniel Perzynski
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Fw: Re: Avermedia A312 wiki page

On Wed, Dec 10, 2008 at 4:00 PM, Daniel Perzynski
<Daniel.Perzynski@aster.pl> wrote:
> Hi Devin,
>
> Which repository should I use then?
> I do understand that USB bridge (CY7C68013A) has to be activated.
> As far as I'm aware that bridge is supported in v4l-dvb drivers but not as
a
> standalone module but rather as a part of other 'main' modules like cx88.
> The question is if my components are generally supported why are not
> recognized during modprobe 'modulename' process?
> Maybe I have to modify the source and add USB id of my card to certain
> modules?
>
> I would like to start with analog first.
>
> Regards,
>
> -----Original Message-----
> From: Devin Heitmueller [mailto:devin.heitmueller@gmail.com]
> Sent: Monday, December 08, 2008 11:22 PM
> To: daniel. perzynski
> Cc: linux-dvb@linuxtv.org
> Subject: Re: [linux-dvb] Fw: Re: Avermedia A312 wiki page
>
> On Mon, Dec 8, 2008 at 5:10 PM, daniel. perzynski
> <daniel.perzynski@aster.pl> wrote:
>> Hi,
>>
>> I'm asking again for more help as I haven't received any response to
>> my previous e-mail pasted below. I've tried to run
>> SniffUSB-x64-2.0.0006.zip but is not working under vista :( I've also
>> found that card is using merlinb.rom and merlinc.rom (they are listed
>> in device manager in windows vista)
>>> I've tried to load all v4l modules (one by one) in 2.6.27.4 kernel -
>>> nothing in syslog :( I've then compiled and tried to load lgdt330x,
>>> cx25840,tuner-xc2028 and
>>> wm8739 from http://linuxtv.org/hg/v4l-dvb mercurial repository -
>>> nothing in syslog :(
>>>
>>> At the end I've used http://linuxtv.org/hg/v4l-dvb-experimental
>>> repository and when doing:
>>>
>>> insmod em28xx_cx25843, I've received :) Nov 30 21:43:54 h3xu5
>>> cx25843.c: starting probe for adapter SMBus
>>> I801
>>> adapter at 1200 (0x40004)
>>> Nov 30 21:43:54 h3xu5 cx25843.c: detecting cx25843 client on address
>>> 0x88
>>>
>>> It is a small progress and I need even more help here. There is a
>>> question if I'm doing everything right? Do I need to load the modules
>>> with parameters? Why I need to do next to help in creation of working
>>> solution for that A312 card?
>>
>> Regards,
>
> Hello Daniel,
>
> Don't use http://linuxtv.org/hg/v4l-dvb-experimental, that's a very old
> repository.
>
> Just loading the modules does nothing.  They won't do anything unless they
> know about your hardware.
>
> I would start with the bridge:  CY7C68013A
>
> You need to get the bridge working before you can get any of the
peripherals
> working (such as the lgdt3304 demod, the 3028 tuner, or the cx25843
> decoder).
>
> Once you have the bridge working, you can set the GPIOs to bring the other
> chips out of reset and then do i2c enumeration and device registration.
>
> Do you plan on doing analog support first or digital?
>
> Devin
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller

> Hello Daniel,

> Please don't top post - it's a violation of list policy.

> You should use the v4l-dvb repository as your base.  The other
> repositories are temporary clones of that repository that developers
> used (or are using) to develop support for some new chipset.

> You need to put your USB ID into the driver for the ez-usb fx2 driver,
> so that driver will know to associate with your device.

> Despite the various chips being supported, you still need to tell the
> driver that your device contains these chips.  This is done by
> registering your device's USB ID in the bridge driver, and then having
> a profile within the bridge driver that tells the kernel which other
> chips are used in your product.  This is the same regardless of
> whether you're talking about a USB bridge like the Cyprus or a device
> that includes a PCI bridge like the cx88.

> Let's look at an example:  The HVR-950:

> The HVR-950 includes an em2883 USB bridge, an xc3028 tuner, a tvp5150
> analog decoder, and an lgdt3303 digital demodulator.  In order to make
> that work, you would add an entry to em28xx-cards.c including the
> hvr-950's USB ID, and in the device profile you would indicate that it
> contains the tvp5150 and xc3028.  You would also have to configure any
> GPIOs so that the em2883 can bring the other chips out of reset.  For
> digital support, you would need to change em28xx-dvb.c to indicate
> that the HVR-950 contains an lgdt3303 and provide the required
> configuration parameters for how that chip is wired up in that
> product.

> For your product, you need to do basically the same thing.
>
> -- 
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller

Hi,

Sorry for top post :(

What is the name of the source file for ez-usb fx2 driver (to which as I
understand I have to add my USB device id)?
'For your product, you need to do basically the same thing' - do you want me
to add information about my card and its 
device profile to em28xx-cards.c for analog TV and to em28xx-dvb.c for
Digital?

Regards,



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
