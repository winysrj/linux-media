Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:4732 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbZKQFzf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 00:55:35 -0500
Message-ID: <4B023AC9.8080403@linuxtv.org>
Date: Tue, 17 Nov 2009 00:55:21 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: linux-media@vger.kernel.org,
	Robert Cicconetti <grythumn@gmail.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: Re: KWorld UB435-Q Support
References: <15cfa2a50910071839j58026d10we2ccbaeb26527abc@mail.gmail.com>	 <0C6DEB14-B32A-4A20-B569-16B2A028CE25@wilsonet.com> <15cfa2a50910091827l449f0fb0t2974219b6ea76608@mail.gmail.com> <4B00D91B.1000906@wilsonet.com> <4B00DB5B.10109@wilsonet.com> <409C0215-68B1-4F90-A8E0-EBAF4F02AC1A@wilsonet.com>
In-Reply-To: <409C0215-68B1-4F90-A8E0-EBAF4F02AC1A@wilsonet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jarod Wilson wrote:
> On Nov 15, 2009, at 11:55 PM, Jarod Wilson wrote:
> 
>> On 11/15/2009 11:46 PM, Jarod Wilson wrote:
>>> On 10/09/2009 09:27 PM, Robert Cicconetti wrote:
>>>> On Wed, Oct 7, 2009 at 10:08 PM, Jarod Wilson<jarod@wilsonet.com> wrote:
>>>>> On Oct 7, 2009, at 9:39 PM, Robert Cicconetti wrote:
>>>>>> Okay... I built the tip of the archive linked above. It works with my
>>>>>> UB435-Q fairly well, built against 2.6.28-15-generic #52-Ubuntu SMP
>>>>>> x86_64. I've been able to stream QAM256 content for several hours
>>>>>> reliably. Mythfrontend works somewhat... it'll tune the initial
>>>>>> channel, but fails afterward. I suspect it is timing out while waiting
>>>>>> for the RF tracking filter calibration... it adds about 6 seconds to
>>>>>> every tuning operation.
>>>>>>
>>>>>> [ 812.465930] tda18271: performing RF tracking filter calibration
>>>>>> [ 818.572446] tda18271: RF tracking filter calibration complete
>>>>>> [ 818.953946] tda18271: performing RF tracking filter calibration
>>>>>> [ 825.093211] tda18271: RF tracking filter calibration complete
>>>>>>
>>>>>> Any suggestions? Further data needed?
>>>>> Nothing off the top of my head, no. But I've got a UB435-Q of my own
>>>>> now,
>>>>> sitting on my desk waiting for me to poke at it... Not sure when I'll
>>>>> have
>>>>> time to actually poke at it though. :\
>>>> A little further poking yields that RF_CAL_OK in EP1 is 0, which is
>>>> why it keeps recalibrating.
>>>>
>>>> I've commented out the part of the code that recalibrates if RF_CAL_OK
>>>> is 0; EP1 always seems to be c6... and now mythfrontend is happy. :)
>>>>
>>>> This is not a long term solution, but as ugly hacks go it was pretty
>>>> straight forward. :)
>>> Finally got around to poking at this again. Forward-ported the patches
>>> to the current v4l-dvb tip
>> Meant to include this:
>>
>> http://wilsonet.com/jarod/junk/kworld-a340-20091115/
>>
>>> , and gave 'em a spin with my own UB435-Q, as
>>> well as a 340U that Doug gave me when he was in town a bit ago. Both are
>>> working just fine with my QAM feed here at the house, albeit with the
>>> same lengthy delay when changing channels you (Robert) mentioned. At a
>>> glance, I was hoping simply setting rf_cal_on_startup for the
>>> card-specific tda18271_config would remove the delay, but neither a 0 or
>>> a 1 seems to particularly help with tuning delays. Hoping maybe Mike has
>>> an idea on this part...
>>>
>>> In related news, I actually managed to get my original 340U with the C1
>>> tuner to work briefly as well, and with the same code, no tuning delays.
>>> Seems either the PCB is cracked or the usb connector is just that bad,
>>> and it only works when positioned just so...
>> I'll give all three sticks I've got here a quick spin with an OTA signal tomorrow too. But I think I'm not seeing any significant reason to not move forward with trying to get this code finally merged.
> 
> All three check out with an OTA signal as well. I'll try to poke at the tuning delay thing a bit more tonight, but I'm inclined to send off formal patches Real Soon Now.
> 


Jarod,

I havent had time to review this entire email thread yet... but:

 >>>>> [ 812.465930] tda18271: performing RF tracking filter calibration
 >>>>> [ 818.572446] tda18271: RF tracking filter calibration complete
 >>>>> [ 818.953946] tda18271: performing RF tracking filter calibration
 >>>>> [ 825.093211] tda18271: RF tracking filter calibration complete


If you see this happen more than once consecutively, and there is only 1 
silicon tuner present, then it means something very bad is happening, 
and there is a chance of burning out a part.  I still wouldnt not 
recommend any mainline merge until you can prevent this behavior -- I 
suspect that a GPIO reset is being toggled where it shouldnt be, which 
should be harmless ... but until we fix it, we cant be sure what damage 
might get done...

The RF tracking filter calibration is a procedure that should only 
happen once while the tuner is powered on -- it should *only* be 
repeated if the tuner indicated that calibration is necessary, and that 
would only happen after a hardware reset.

This still looks fishy to me...

-Mike
