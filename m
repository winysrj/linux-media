Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:34463
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbZKPElS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2009 23:41:18 -0500
Message-ID: <4B00D91B.1000906@wilsonet.com>
Date: Sun, 15 Nov 2009 23:46:19 -0500
From: Jarod Wilson <jarod@wilsonet.com>
MIME-Version: 1.0
To: Robert Cicconetti <grythumn@gmail.com>
CC: linux-media@vger.kernel.org, Mike Krufky <mkrufky@linuxtv.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: Re: KWorld UB435-Q Support
References: <15cfa2a50910071839j58026d10we2ccbaeb26527abc@mail.gmail.com>	 <0C6DEB14-B32A-4A20-B569-16B2A028CE25@wilsonet.com> <15cfa2a50910091827l449f0fb0t2974219b6ea76608@mail.gmail.com>
In-Reply-To: <15cfa2a50910091827l449f0fb0t2974219b6ea76608@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/09/2009 09:27 PM, Robert Cicconetti wrote:
> On Wed, Oct 7, 2009 at 10:08 PM, Jarod Wilson<jarod@wilsonet.com>  wrote:
>> On Oct 7, 2009, at 9:39 PM, Robert Cicconetti wrote:
>>> Okay... I built the tip of the archive linked above. It works with my
>>> UB435-Q fairly well, built against 2.6.28-15-generic #52-Ubuntu SMP
>>> x86_64. I've been able to stream QAM256 content for several hours
>>> reliably. Mythfrontend works somewhat... it'll tune the initial
>>> channel, but fails afterward. I suspect it is timing out while waiting
>>> for the RF tracking filter calibration... it adds about 6 seconds to
>>> every tuning operation.
>>>
>>> [  812.465930] tda18271: performing RF tracking filter calibration
>>> [  818.572446] tda18271: RF tracking filter calibration complete
>>> [  818.953946] tda18271: performing RF tracking filter calibration
>>> [  825.093211] tda18271: RF tracking filter calibration complete
>>>
>>> Any suggestions? Further data needed?
>>
>> Nothing off the top of my head, no. But I've got a UB435-Q of my own now,
>> sitting on my desk waiting for me to poke at it... Not sure when I'll have
>> time to actually poke at it though. :\
>
> A little further poking yields that RF_CAL_OK in EP1 is 0, which is
> why it keeps recalibrating.
>
> I've commented out the part of the code that recalibrates if RF_CAL_OK
> is 0; EP1 always seems to be c6... and now mythfrontend is happy. :)
>
> This is not a long term solution, but as ugly hacks go it was pretty
> straight forward. :)

Finally got around to poking at this again. Forward-ported the patches 
to the current v4l-dvb tip, and gave 'em a spin with my own UB435-Q, as 
well as a 340U that Doug gave me when he was in town a bit ago. Both are 
working just fine with my QAM feed here at the house, albeit with the 
same lengthy delay when changing channels you (Robert) mentioned. At a 
glance, I was hoping simply setting rf_cal_on_startup for the 
card-specific tda18271_config would remove the delay, but neither a 0 or 
a 1 seems to particularly help with tuning delays. Hoping maybe Mike has 
an idea on this part...

In related news, I actually managed to get my original 340U with the C1 
tuner to work briefly as well, and with the same code, no tuning delays. 
Seems either the PCB is cracked or the usb connector is just that bad, 
and it only works when positioned just so...

-- 
Jarod Wilson
jarod@wilsonet.com
