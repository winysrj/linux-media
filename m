Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:45732
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbZKQOPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 09:15:03 -0500
Subject: Re: KWorld UB435-Q Support
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <15cfa2a50911162203w1ad1584bhfdbe0213421abd6a@mail.gmail.com>
Date: Tue, 17 Nov 2009 09:15:06 -0500
Cc: Michael Krufky <mkrufky@linuxtv.org>, linux-media@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <C5BCB298-B166-4F9D-998C-EE58C5AF8B78@wilsonet.com>
References: <15cfa2a50910071839j58026d10we2ccbaeb26527abc@mail.gmail.com> <0C6DEB14-B32A-4A20-B569-16B2A028CE25@wilsonet.com> <15cfa2a50910091827l449f0fb0t2974219b6ea76608@mail.gmail.com> <4B00D91B.1000906@wilsonet.com> <4B00DB5B.10109@wilsonet.com> <409C0215-68B1-4F90-A8E0-EBAF4F02AC1A@wilsonet.com> <4B023AC9.8080403@linuxtv.org> <15cfa2a50911162203w1ad1584bhfdbe0213421abd6a@mail.gmail.com>
To: Robert Cicconetti <grythumn@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Nov 17, 2009, at 1:03 AM, Robert Cicconetti wrote:

> On Tue, Nov 17, 2009 at 12:55 AM, Michael Krufky <mkrufky@linuxtv.org> wrote:
>>>>>>> [ 812.465930] tda18271: performing RF tracking filter calibration
>>>>>>> [ 818.572446] tda18271: RF tracking filter calibration complete
>>>>>>> [ 818.953946] tda18271: performing RF tracking filter calibration
>>>>>>> [ 825.093211] tda18271: RF tracking filter calibration complete
>> 
>> 
>> If you see this happen more than once consecutively, and there is only 1
>> silicon tuner present, then it means something very bad is happening, and
>> there is a chance of burning out a part.  I still wouldnt not recommend any
>> mainline merge until you can prevent this behavior -- I suspect that a GPIO
>> reset is being toggled where it shouldnt be, which should be harmless ...
>> but until we fix it, we cant be sure what damage might get done...
>> 
>> The RF tracking filter calibration is a procedure that should only happen
>> once while the tuner is powered on -- it should *only* be repeated if the
>> tuner indicated that calibration is necessary, and that would only happen
>> after a hardware reset.
>> 
>> This still looks fishy to me...

Agreed. I did manage to dig into this some more last night, something is definitely still awry. Here's a dmesg dump with some extra debug spew added in key spots:

...
em28xx driver loaded
tda18271 4-0060: creating new instance
TDA18271HD/C2 detected @ 4-0060
tda18271: R_EP1 is 0xce
cal is not initialized (cal_initialized=false)...
tda18271: performing RF tracking filter calibration
tda18271: RF tracking filter calibration complete (0xde)
DVB: registering new adapter (em28xx #0)
DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3304 VSB/QAM Frontend)...
em28xx #0: Successfully loaded em28xx-dvb
Em28xx: Initialized (Em28xx dvb Extension) extension

1st tuning attempt

tda18271: R_EP1 is 0x00
cal is not initialized (cal_initialized=true)...
tda18271: performing RF tracking filter calibration
tda18271: RF tracking filter calibration complete (0x00)
tda18271: R_EP1 is 0x00
cal is not initialized (cal_initialized=true)...
tda18271: performing RF tracking filter calibration
tda18271: RF tracking filter calibration complete (0x00)

2nd tuning attempt

tda18271: R_EP1 is 0x00
cal is not initialized (cal_initialized=true)...
tda18271: performing RF tracking filter calibration
tda18271: RF tracking filter calibration complete (0x00)
tda18271: R_EP1 is 0x00
cal is not initialized (cal_initialized=true)...
tda18271: performing RF tracking filter calibration
tda18271: RF tracking filter calibration complete (0x00)

I'll try tweaking the GPIO reset mask and whatnot, definitely does seem like something's getting reset that shouldn't, because you can clearly see that cal *was* initialized, then R_EP1 got zeroed out.

> It happened at every tuning operation, and made mythfrontend unhappy
> (unable to tune after the first channel). I disabled the check for
> RF_CAL_OK which triggered the recalibration, and mythfrontend worked.

Yeah, tuning is much quicker here if I skip that check as well, but its definitely not the proper fix.

> The stick has been plugged in for a few months, so presumably would've
> caught on fire by now if it was going to. It would be nice if the
> tuning delay went away, though.. it still takes ~6 seconds to switch
> frequencies.

Wait, it still takes that long with the check gone? I didn't poke for very long with the check disabled, mostly focusing on trying to figure out why things are going haywire.

> I have not yet compiled and tested the lastest patches from Jarod.

Really shouldn't be any difference from what you've got, they're just rebased to the latest v4l-dvb tree.

-- 
Jarod Wilson
jarod@wilsonet.com



