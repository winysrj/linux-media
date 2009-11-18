Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:50957
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529AbZKRE7S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 23:59:18 -0500
Subject: Re: KWorld UB435-Q Support
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <829197380911170637h6a7918fcl461c01d70ab20599@mail.gmail.com>
Date: Tue, 17 Nov 2009 23:59:09 -0500
Cc: Robert Cicconetti <grythumn@gmail.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	linux-media@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <FF5F7993-6EC1-4C8E-9730-F85D1DC473D6@wilsonet.com>
References: <15cfa2a50910071839j58026d10we2ccbaeb26527abc@mail.gmail.com> <0C6DEB14-B32A-4A20-B569-16B2A028CE25@wilsonet.com> <15cfa2a50910091827l449f0fb0t2974219b6ea76608@mail.gmail.com> <4B00D91B.1000906@wilsonet.com> <4B00DB5B.10109@wilsonet.com> <409C0215-68B1-4F90-A8E0-EBAF4F02AC1A@wilsonet.com> <4B023AC9.8080403@linuxtv.org> <15cfa2a50911162203w1ad1584bhfdbe0213421abd6a@mail.gmail.com> <C5BCB298-B166-4F9D-998C-EE58C5AF8B78@wilsonet.com> <829197380911170637h6a7918fcl461c01d70ab20599@mail.gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Nov 17, 2009, at 9:37 AM, Devin Heitmueller wrote:

> On Tue, Nov 17, 2009 at 9:15 AM, Jarod Wilson <jarod@wilsonet.com> wrote:
>> On Nov 17, 2009, at 1:03 AM, Robert Cicconetti wrote:
>> 
>>> On Tue, Nov 17, 2009 at 12:55 AM, Michael Krufky <mkrufky@linuxtv.org> wrote:
>>>>>>>>> [ 812.465930] tda18271: performing RF tracking filter calibration
>>>>>>>>> [ 818.572446] tda18271: RF tracking filter calibration complete
>>>>>>>>> [ 818.953946] tda18271: performing RF tracking filter calibration
>>>>>>>>> [ 825.093211] tda18271: RF tracking filter calibration complete
>>>> 
>>>> 
>>>> If you see this happen more than once consecutively, and there is only 1
>>>> silicon tuner present, then it means something very bad is happening, and
>>>> there is a chance of burning out a part.  I still wouldnt not recommend any
>>>> mainline merge until you can prevent this behavior -- I suspect that a GPIO
>>>> reset is being toggled where it shouldnt be, which should be harmless ...
>>>> but until we fix it, we cant be sure what damage might get done...
>>>> 
>>>> The RF tracking filter calibration is a procedure that should only happen
>>>> once while the tuner is powered on -- it should *only* be repeated if the
>>>> tuner indicated that calibration is necessary, and that would only happen
>>>> after a hardware reset.
>>>> 
>>>> This still looks fishy to me...
>> 
>> Agreed. I did manage to dig into this some more last night, something is definitely still awry. 
...
> Hey Jarod,
> 
> I haven't seen your exact GPIO config but I noticed something
> recently:  the em28xx driver runs the dvb_gpio sequence whenever
> starting streaming, not just whenever opening the DVB frontend.  This
> means that if your dvb_gpio definition strobes the tda18271 reset (as
> opposed to just taking it out of reset), then the chip will get reset
> whenever the streaming is started (a real problem if multiple tuning
> attempts are performed without closing the frontend first).
> 
> Mauro seems to think this is intended behavior, although I cannot see
> how this could possibly be correct, especially since the .init()
> callback is not called in that case.  I setup a tree to remove the
> call, but never got far enough into the testing to confirm whether it
> broke any improperly configured boards depending on the incorrect
> behavior.

This tree, I presume.

http://kernellabs.com/hg/~dheitmueller/em28xx-modeswitch/

I just tacked on the very last patch there onto my local tree to test with one of these sticks. Behavior is the same though, and the tda18271 reg dumps look equally bad -- they're all reported 0x00.

> As a test, you might want to check your dvb_gpio config and see if you
> are pulling anything low and then high, and just remove the line that
> sets the pin low and see if the recalibration still occurs.

I'm pretty sure you explained how to do this to me once before on irc, but its been a while, and that knowledge has since leaked out of my brain... Currently, I have:

/*
 * KWorld PlusTV 340U and UB435-Q (ATSC) GPIOs map:
 * EM_GPIO_0 - currently unknown
 * EM_GPIO_1 - LED disable/enable (1 = off, 0 = on)
 * EM_GPIO_2 - currently unknown
 * EM_GPIO_3 - currently unknown
 * EM_GPIO_4 - TDA18271HD tuner (1 = active, 0 = in reset)
 * EM_GPIO_5 - LGDT3304 ATSC/QAM demod (1 = active, 0 = in reset)
 * EM_GPIO_6 - currently unknown
 * EM_GPIO_7 - currently unknown
 */
static struct em28xx_reg_seq kworld_a340_digital[] = {
        /* only diff from default gpio is to keep 1 clear to turn on LED */
        {EM28XX_R08_GPIO,       0x6d,   ~EM_GPIO_4,     10},
        { -1,                   -1,             -1,     -1},
};

I've tried various combinations in here today, all without any significant change in behavior. But I suspect I'm missing something I should be trying. Ah well. Bed time. More poking tomorrow...


-- 
Jarod Wilson
jarod@wilsonet.com



