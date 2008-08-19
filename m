Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.hauppauge.com ([167.206.143.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1KVQtC-00009h-5h
	for linux-dvb@linuxtv.org; Tue, 19 Aug 2008 15:04:48 +0200
Message-ID: <48AAC4D4.7000005@linuxtv.org>
Date: Tue, 19 Aug 2008 09:04:20 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Tim Lucas <lucastim@gmail.com>
References: <e32e0e5d0808181946w7e852dc7tef2df349b2f538f0@mail.gmail.com>	
	<48AA3A3C.2050906@linuxtv.org>	
	<e32e0e5d0808182037v2a11d8f6peecc9ca6d4f0725e@mail.gmail.com>
	<e32e0e5d0808182311h4680e692hd8e5a566a6de03f4@mail.gmail.com>
In-Reply-To: <e32e0e5d0808182311h4680e692hd8e5a566a6de03f4@mail.gmail.com>
Cc: linux dvb <linux-dvb@linuxtv.org>, stev391@email.com
Subject: Re: [linux-dvb] DViCO Fusion HDTV7 Dual Express
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

I hereby ignore your top-quoted email -- please do not top quote.

Tim Lucas wrote:
> I tried the advice of both of the replies that I got below.  I get the
> following in dmesg.
>
> [   31.078478] cx23885 driver version 0.0.1 loaded
> [   31.078777] ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16
> [   31.078782] ACPI: PCI Interrupt 0000:08:00.0[A] -> Link [APC6] -> GSI 16
> (level, low) -> IRQ 21
> [   31.078795] CORE cx23885[0]: subsystem: 18ac:d618, board: DViCO
> FusionHDTV7 Dual Express [card=10,autodetected]
> [   31.180458] cx23885[0]: i2c bus 0 registered
> [   31.180480] cx23885[0]: i2c bus 1 registered
> [   31.180499] cx23885[0]: i2c bus 2 registered
> [   31.207377] cx23885[0]: cx23885 based dvb card
> [   31.243077] cx23885[0]: frontend initialization failed
> [   31.243080] cx23885_dvb_register() dvb_register failed err = -1
> [   31.243081] cx23885_dev_setup() Failed to register dvb on VID_C
> [   31.243085] cx23885_dev_checkrevision() Hardware revision = 0xb0
> [   31.243091] cx23885[0]/0: found at 0000:08:00.0, rev: 2, irq: 21,
> latency: 0, mmio: 0xfd800000
>
> Originally a friend helped me by getting setting up the system to look for
> the old dvico fusion 5 card.
> I put
>
> options cx23885 card=4
>
> in /etc/modprobe.d/options.  The system would recognize that I had a card
> with two feeds, but I could get channels on the scan.  I commented out this
> line and then tried installing the deb package, but lost support of the
> card.
> I tried installing from source, but that didn't help.  I tried installing
> the firmware as recommended, but it still didn't help.
> At some point it recognized only one feed, still couldn't get channels on
> the scan.  Then I lost the card completely.  I admit that I just started
> trying suggestions and was probably not systematic enough.  I may need to
> scrap the install and start over.  Since the box is new, that is not a big
> deal.  It probably wouldn't take very long to reinstall.
>
> I have some questions.  Will there be support for both tuners?  The old
> driver seemed to support 2, so I would hope the new one would too.  Will
> this card not work with analog channels or has support just not been written
> yet?  If I do have analog channels, what should the settings be?  Would one
> of those digital converter boxes make it a digital signal? (That is probably
> a dumb question, but this is not really my area.)
>
> Thanks for all of your help.
>
>      --Tim
>
> ----------------------------------------------------------------------------------------------------------------------------------------------
>
> Tim,
>
> The support that I added in was for a the DViCO DVB-T Dual Express, not the
> FusionHDTV7.
>
> However there may be good news for you...
> If your card is the FusionHDTV7 Dual Express there is support for this card
> in the main tree (only one DVB tuner at the moment). This may not help you
> as you stated that you needed analog support.
>
> The easiest way for you to get the newest DVB drivers is to go to this
> webpage:
> http://martinpitt.wordpress.com/2008/06/10/packaged-dvb-t-drivers-for-ubuntu
> -804/
>
> You may need to install some firmware as well (you can tell if you need to
> get the firmware by an error message in the syslog [accessed by typing
> "dmesg" in a terminal], this error will only show up after you try to scan
> or tune to a channel.  If you need firmware goto:
> http://www.steventoth.net/linux/xc5000/
> and follow the instructions inside the files (extract.sh and readme.txt).
>
> Give that a go then come back, with any issues to the mailing list.
>
> Perhaps you could create a wiki page on: http://linuxtv.org/wiki/index.php
> with all the relevant information on it, for an example checkout:
> http://linuxtv.org/wiki/index.php/DViCO_FusionHDTV_DVB-T_Dual_Express
> And if you do make the page, update this page while you are at it:
> http://linuxtv.org/wiki/index.php/DViCO
> and also: http://linuxtv.org/wiki/index.php/ATSC_PCIe_Cards
>
> Regards,
>
> Stephen.
>
>
> On Mon, Aug 18, 2008 at 8:37 PM, Tim Lucas <lucastim@gmail.com> wrote:
>
>   
>> Thank you for the help.  I am familiar with mercurial, so I should be able
>> to figure it out.
>>
>>
>> On Mon, Aug 18, 2008 at 8:13 PM, Michael Krufky <mkrufky@linuxtv.org>wrote:
>>
>>     
>>> Tim Lucas wrote:
>>>       
>>>> I apologize if this is outside the scope of the list and would
>>>>         
>>> appreciate
>>>       
>>>> any help I could get offline if that makes more sense.
>>>> I have been searching online for support for this card and it looks
>>>>         
>>> there
>>>       
>>>> may be support now or coming soon. I am running mythbuntu 8.04 which
>>>>         
>>> does
>>>       
>>>> not yet include support for this card.  I am a linux novice so I was
>>>> wondering if you could help me add the appropriate files that will add
>>>> support for the card.  I am a linux novice (I'm good at apt-get install,
>>>>         
>>> but
>>>       
>>>> no so much at building my own kernel) so I may need a little bit of hand
>>>> holding.  Any help
>>>> you could provide would be appreciated.
>>>>
>>>>
>>>>
>>>> Side question.  I thought I might have seen something about only support
>>>>         
>>> for
>>>       
>>>> digital on this card, not analog.  I am in an apartment complex that
>>>>         
>>> uses an
>>>       
>>>> antiquated (very large) satellite system.  It is listed with schedules
>>>> direct, but I am not sure if it is digital or analog.
>>>>         
>>> FusionHDTV7 Dual Express is supported in the v4l-dvb mercurial tree,
>>> hosted on linuxtv.org.
>>> See http://linuxtv.org/repo for info about installing the driver into
>>> your running kernel.
>>>
>>> Support for the card will be available out-of-the-box in the unreleased
>>> kernel 2.6.27
>>>
>>> -Mike
>>>
>>>       
>>
>> --
>> --Tim
>>
>>     
>
>
>
>   


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
