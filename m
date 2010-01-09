Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33276 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab0AIUA1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jan 2010 15:00:27 -0500
Message-ID: <4B48E054.7000103@infradead.org>
Date: Sat, 09 Jan 2010 18:00:20 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: =?ISO-8859-1?Q?Michael_R=FCttgers?= <ich@michael-ruettgers.de>,
	linux-media@vger.kernel.org, devin.heitmueller@gmail.com
Subject: Re: em28xx: New device request and tvp5150 distortion issues when
 	capturing from vcr
References: <1262680804.26250.10.camel@wi-289.weiss.local> <829197381001060756q59916baakc178d60f7116181d@mail.gmail.com>
In-Reply-To: <829197381001060756q59916baakc178d60f7116181d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Tue, Jan 5, 2010 at 3:40 AM, Michael Rüttgers
> <ich@michael-ruettgers.de> wrote:
>> Hello,
>>
>> a year ago I bought a device named "Hama Video Editor", which was not
>> (and is not yet) supported by the em28xx driver.
>> So I played around with the card parameter and got the device basically
>> working with card=38.
>> Basically working means, that I had a distortion when capturing old
>> VHS-Tapes from my old vcr.
>>
>> The problem can be seen here:
>> http://www.michael-ruettgers.de/em28xx/test.avi
>>
>> A few weeks ago I started tracking down the reason for this issue with
>> the help of Devin.
>> Wondering, that the device works perfectly in Windows, I compared the
>> i2c commands, that programmed the register of the tvp5150 in Windows.
>>
>> Finally I got the device working properly, setting the "TV/VCR" option
>> in the register "Operation Mode Controls Register" at address 02h
>> manually to "Automatic mode determined by the internal detection
>> circuit. (default)":
>>
>> 000109:  OUT: 000000 ms 107025 ms 40 02 00 00 b8 00 02 00 >>>  02 00
>>
>> After programming this register, the distortion issue disappeared.
>>
>> So my conclusion was, that the TV/VCR detection mode is forced to
>> TV-mode in the em28xx, which could have been verified by a look into the
>> debug output using the parameter reg_debug=1:
>>
>> OUT: 40 02 00 00 b8 00 02 00 >>> 02 30
>>
>> Bit 4, 5 are used for setting the TV/VCR mode:
>>
>> Description in the Spec:
>>> TV/VCR mode
>>>   00 = Automatic mode determined by the internal detection circuit.
>> (default)
>>>   01 = Reserved
>>>   10 = VCR (nonstandard video) mode
>>>   11 = TV (standard video) mode
>>> With automatic detection enabled, unstable or nonstandard syncs on the
>> input video forces the detector into the VCR
>>> mode. This turns off the comb filters and turns on the chroma trap
>> filter.
>>
>> Thus far the tvp5150 distortion issues when capturing from vcr.
> 
> Mauro,
> 
> I have been working with Michael on this issue and I did some research
> into the history of this issue, and it seems like you introduced code
> in rev 2900 which turns off the auto mode and forces the tvp5150 into
> "TV mode" if using a composite input:
> 
> http://linuxtv.org/hg/v4l-dvb/rev/e6c585a76c77
> 
> Could you provide any information on the rationale for this decision?
> I would think that having it in auto mode would be the appropriate
> default (which is what the Windows driver does), and then you would
> force it to either TV or VCR mode only if absolutely necessary.
> 
> The comb filter only gets disabled if the auto mode actually concludes
> the device should be in VCR mode.  Hence, there shouldn't be any
> downside to having it in auto mode unless you have some reason to
> believe the detection code is faulty or error-prone.
> 

This is a very old patch, and I forgot the reasons why. On that time, only
TV were working. I suspect the change were needed in order to get signal
working at Svideo/composite entry on WinTV USB2. Probably, I tested 
Svideo/composite with an old VCR I used for tests on that time.

> We can add a modprobe option to allow the user to force it into one
> mode or the other, if someone finds a case where the detection logic
> has issues.  But forcing it into one particular mode by default
> doesn't seem like the right approach.

A modprobe option would be very bad, IMHO. If the problem is with some
old VCR's, maybe the better is to add a control for it. For example, bttv
driver has one such control:

	V4L2_CID_PRIVATE_VCR_HACK

I agree that it makes sense to keep the autodetect mode on by default, but
tests are needed to validade if this won't break support with other devices.

Cheers,
Mauro.
