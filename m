Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.hauppauge.com ([167.206.143.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1KVZJU-0002Ev-HD
	for linux-dvb@linuxtv.org; Wed, 20 Aug 2008 00:04:30 +0200
Message-ID: <48AB4353.4030809@linuxtv.org>
From: mkrufky@linuxtv.org
To: stev391@email.com
Date: Tue, 19 Aug 2008 18:04:03 -0400
MIME-Version: 1.0
Cc: lucastim@gmail.com, linux-dvb@linuxtv.org
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

stev391@email.com wrote:
>> ----- Original Message -----
>> From: "Michael Krufky" <mkrufky@linuxtv.org>
>> To: stev391@email.com
>> Subject: Re: [linux-dvb] DViCO Fusion HDTV7 Dual Express
>> Date: Tue, 19 Aug 2008 09:08:55 -0400
>>
>>
>>
>>     
>>>> Tim,
>>>>
>>>> The support that I added in was for a the DViCO DVB-T Dual Express, not
the
>>>> FusionHDTV7.
>>>>
>>>> However there may be good news for you...
>>>> If your card is the FusionHDTV7 Dual Express there is support for this
card
>>>> in the main tree (only one DVB tuner at the moment). This may not help
you
>>>> as you stated that you needed analog support.
>>>>
>>>> The easiest way for you to get the newest DVB drivers is to go to this
>>>> webpage:
>>>>
http://martinpitt.wordpress.com/2008/06/10/packaged-dvb-t-drivers-for-ubuntu
>>>> -804/
>>>>
>>>> You may need to install some firmware as well (you can tell if you need
to
>>>> get the firmware by an error message in the syslog [accessed by typing
>>>> "dmesg" in a terminal], this error will only show up after you try to
scan
>>>> or tune to a channel.  If you need firmware goto:
>>>> http://www.steventoth.net/linux/xc5000/
>>>> and follow the instructions inside the files (extract.sh and
readme.txt).
>>>>
>>>> Give that a go then come back, with any issues to the mailing list.
>>>>
>>>> Perhaps you could create a wiki page on:
http://linuxtv.org/wiki/index.php
>>>> with all the relevant information on it, for an example checkout:
>>>> http://linuxtv.org/wiki/index.php/DViCO_FusionHDTV_DVB-T_Dual_Express
>>>> And if you do make the page, update this page while you are at it:
>>>> http://linuxtv.org/wiki/index.php/DViCO
>>>> and also: http://linuxtv.org/wiki/index.php/ATSC_PCIe_Cards
>>>>
>>>> Regards,
>>>>
>>>> Stephen.
>>>>
>>>>
>>>> On Mon, Aug 18, 2008 at 8:37 PM, Tim Lucas <lucastim@gmail.com> wrote:
>>>>
>>>>
>>>>         
>>>>> Thank you for the help.  I am familiar with mercurial, so I should be
able
>>>>> to figure it out.
>>>>>
>>>>>
>>>>> On Mon, Aug 18, 2008 at 8:13 PM, Michael Krufky
<mkrufky@linuxtv.org>wrote:
>>>>>
>>>>>
>>>>>           
>>>>>> Tim Lucas wrote:
>>>>>>
>>>>>>             
>>>>>>> I apologize if this is outside the scope of the list and would
>>>>>>>
>>>>>>>               
>>>>>> appreciate
>>>>>>
>>>>>>             
>>>>>>> any help I could get offline if that makes more sense.
>>>>>>> I have been searching online for support for this card and it looks
>>>>>>>
>>>>>>>               
>>>>>> there
>>>>>>
>>>>>>             
>>>>>>> may be support now or coming soon. I am running mythbuntu 8.04 which
>>>>>>>
>>>>>>>               
>>>>>> does
>>>>>>
>>>>>>             
>>>>>>> not yet include support for this card.  I am a linux novice so I was
>>>>>>> wondering if you could help me add the appropriate files that will
add
>>>>>>> support for the card.  I am a linux novice (I'm good at apt-get
install,
>>>>>>>
>>>>>>>               
>>>>>> but
>>>>>>
>>>>>>             
>>>>>>> no so much at building my own kernel) so I may need a little bit of
hand
>>>>>>> holding.  Any help
>>>>>>> you could provide would be appreciated.
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Side question.  I thought I might have seen something about only
support
>>>>>>>
>>>>>>>               
>>>>>> for
>>>>>>
>>>>>>             
>>>>>>> digital on this card, not analog.  I am in an apartment complex that
>>>>>>>
>>>>>>>               
>>>>>> uses an
>>>>>>
>>>>>>             
>>>>>>> antiquated (very large) satellite system.  It is listed with
schedules
>>>>>>> direct, but I am not sure if it is digital or analog.
>>>>>>>
>>>>>>>               
>>>>>> is setting up the wrong demodulators for this card
>>>>>> FusionHDTV7 Dual Express is supported in the v4l-dvb mercurial tree,
>>>>>> hosted on linuxtv.org.
>>>>>> See http://linuxtv.org/repo for info about installing the driver into
>>>>>> your running kernel.
>>>>>>
>>>>>> Support for the card will be available out-of-the-box in the
unreleased
>>>>>> kernel 2.6.27
>>>>>>
>>>>>> -Mike
>>>>>>
>>>>>>
>>>>>>             
>> stev391@email.com wrote:
>>     
>>>> ----- Original Message -----
>>>> From: "Tim Lucas" <lucastim@gmail.com>
>>>> To: "Michael Krufky" <mkrufky@linuxtv.org>, stev391@email.com, "linux
>>>>         
>> dvb" <linux-dvb@linuxtv.org>
>>     
>>>> Subject: Re: [linux-dvb] DViCO Fusion HDTV7 Dual Express
>>>> Date: Mon, 18 Aug 2008 23:11:58 -0700
>>>>
>>>>
>>>> I tried the advice of both of the replies that I got below.  I get the
>>>> following in dmesg.
>>>>
>>>> [   31.078478] cx23885 driver version 0.0.1 loaded
>>>> [   31.078777] ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16
>>>> [   31.078782] ACPI: PCI Interrupt 0000:08:00.0[A] -> Link [APC6] ->
>>>>         
>> GSI 16
>>     
>>>> (level, low) -> IRQ 21
>>>> [   31.078795] CORE cx23885[0]: subsystem: 18ac:d618, board: DViCO
>>>> FusionHDTV7 Dual Express [card=10,autodetected]
>>>> [   31.180458] cx23885[0]: i2c bus 0 registered
>>>> [   31.180480] cx23885[0]: i2c bus 1 registered
>>>> [   31.180499] cx23885[0]: i2c bus 2 registered
>>>> [   31.207377] cx23885[0]: cx23885 based dvb card
>>>> [   31.243077] cx23885[0]: frontend initialization failed
>>>> [   31.243080] cx23885_dvb_register() dvb_register failed err = -1
>>>> [   31.243081] cx23885_dev_setup() Failed to register dvb on VID_C
>>>> [   31.243085] cx23885_dev_checkrevision() Hardware revision = 0xb0
>>>> [   31.243091] cx23885[0]/0: found at 0000:08:00.0, rev: 2, irq: 21,
>>>> latency: 0, mmio: 0xfd800000
>>>>
>>>> Originally a friend helped me by getting setting up the system to
>>>>         
>> look for
>>     
>>>> the old dvico fusion 5 card.
>>>> I put
>>>>
>>>> options cx23885 card=4
>>>>
>>>> in /etc/modprobe.d/options.  The system would recognize that I had a
card
>>>> with two feeds, but I could get channels on the scan.  I commented
>>>>         
>> out this
>>     
>>>> line and then tried installing the deb package, but lost support of the
>>>> card.
>>>> I tried installing from source, but that didn't help.  I tried
installing
>>>> the firmware as recommended, but it still didn't help.
>>>> At some point it recognized only one feed, still couldn't get channels
on
>>>> the scan.  Then I lost the card completely.  I admit that I just
started
>>>> trying suggestions and was probably not systematic enough.  I may need
to
>>>> scrap the install and start over.  Since the box is new, that is not
>>>>         
>> a big
>>     
>>>> deal.  It probably wouldn't take very long to reinstall.
>>>>
>>>> I have some questions.  Will there be support for both tuners?  The old
>>>> driver seemed to support 2, so I would hope the new one would too.
Will
>>>> this card not work with analog channels or has support just not been
>>>>         
>> written
>>     
>>>> yet?  If I do have analog channels, what should the settings be?
>>>>         
>> Would one
>>     
>>>> of those digital converter boxes make it a digital signal? (That is
>>>>         
>> probably
>>     
>>>> a dumb question, but this is not really my area.)
>>>>
>>>> Thanks for all of your help.
>>>>
>>>>       --Tim
>>>>
>>>>
>>>>         
>>
----------------------------------------------------------------------------
------------------------------------------------------------------
>>
>>
>>
>>     
>>> Tim,
>>>
>>> Can you take a high resolution photo of the card and create a wiki page
with this card?
>>> Also provide a list of the chips (as on the card), for example cx23885.
I mainly want to now 
>>> the demodulators that are in use on the card as the driver has two
possible paths in the code 
>>> depending on which demodulator is installed. Which one is it: S5H1411 or
S5H1409 or something 
>>> else? From the low resolution photos on the DViCO site there should be
two of these chips 
>>> roughly in the middle of the card side by side.
>>>
>>>       
>> It doesnt matter -- I have both versions of this board, the 1409 and the
>> 1411 version.
>>
>> The boards are identical, other than the newer demodulator.
>>
>> Both boards are supported.  Both frontend paths are supported.
>>
>> You need to use the v4l-dvb mercurial *tip* for full support.  Older
>> revisions will only support one tuner.
>>
>> You also need the xc5000 firmware placed into the correct location
>> (usually /lib/firmware)
>>
>> I added support for these boards and they are both running fine in my
>> mythtv-backend for digital atsc and qam recordings.
>>
>> Regards,
>>
>> Mike
>>     
>
> Tim,
>
> Since Mike has these cards I let him help you out, sorry if I have
confused you. 
>
> I have just checked the package that i referenced as well and it is indeed
missing the proper support required for your card.

Stephen,

Feel free to continue helping him -- I just stated the facts ...  There 
is no need for any photos or any kind of research in order to support 
this board -- I already have been there and done that -- it's already 
fully supported.

--EXCEPT for analog.

He needs to use hg tip if he wants digital to work.

...meanwhile, he needs analog, because he's using some internal analog 
video network.  I think he's screwed.  Sorry, tim.

If you want to use the board to receive ATSC digital television from the 
air, or Clear QAM Annex-B digital cable, then you're golden.

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
