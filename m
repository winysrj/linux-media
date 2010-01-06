Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:38826 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab0AFP4u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jan 2010 10:56:50 -0500
Received: by fxm25 with SMTP id 25so10828171fxm.21
        for <linux-media@vger.kernel.org>; Wed, 06 Jan 2010 07:56:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1262680804.26250.10.camel@wi-289.weiss.local>
References: <1262680804.26250.10.camel@wi-289.weiss.local>
Date: Wed, 6 Jan 2010 10:56:46 -0500
Message-ID: <829197381001060756q59916baakc178d60f7116181d@mail.gmail.com>
Subject: Re: em28xx: New device request and tvp5150 distortion issues when
	capturing from vcr
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Michael_R=FCttgers?= <ich@michael-ruettgers.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, devin.heitmueller@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 5, 2010 at 3:40 AM, Michael Rüttgers
<ich@michael-ruettgers.de> wrote:
> Hello,
>
> a year ago I bought a device named "Hama Video Editor", which was not
> (and is not yet) supported by the em28xx driver.
> So I played around with the card parameter and got the device basically
> working with card=38.
> Basically working means, that I had a distortion when capturing old
> VHS-Tapes from my old vcr.
>
> The problem can be seen here:
> http://www.michael-ruettgers.de/em28xx/test.avi
>
> A few weeks ago I started tracking down the reason for this issue with
> the help of Devin.
> Wondering, that the device works perfectly in Windows, I compared the
> i2c commands, that programmed the register of the tvp5150 in Windows.
>
> Finally I got the device working properly, setting the "TV/VCR" option
> in the register "Operation Mode Controls Register" at address 02h
> manually to "Automatic mode determined by the internal detection
> circuit. (default)":
>
> 000109:  OUT: 000000 ms 107025 ms 40 02 00 00 b8 00 02 00 >>>  02 00
>
> After programming this register, the distortion issue disappeared.
>
> So my conclusion was, that the TV/VCR detection mode is forced to
> TV-mode in the em28xx, which could have been verified by a look into the
> debug output using the parameter reg_debug=1:
>
> OUT: 40 02 00 00 b8 00 02 00 >>> 02 30
>
> Bit 4, 5 are used for setting the TV/VCR mode:
>
> Description in the Spec:
>> TV/VCR mode
>>   00 = Automatic mode determined by the internal detection circuit.
> (default)
>>   01 = Reserved
>>   10 = VCR (nonstandard video) mode
>>   11 = TV (standard video) mode
>> With automatic detection enabled, unstable or nonstandard syncs on the
> input video forces the detector into the VCR
>> mode. This turns off the comb filters and turns on the chroma trap
> filter.
>
> Thus far the tvp5150 distortion issues when capturing from vcr.

Mauro,

I have been working with Michael on this issue and I did some research
into the history of this issue, and it seems like you introduced code
in rev 2900 which turns off the auto mode and forces the tvp5150 into
"TV mode" if using a composite input:

http://linuxtv.org/hg/v4l-dvb/rev/e6c585a76c77

Could you provide any information on the rationale for this decision?
I would think that having it in auto mode would be the appropriate
default (which is what the Windows driver does), and then you would
force it to either TV or VCR mode only if absolutely necessary.

The comb filter only gets disabled if the auto mode actually concludes
the device should be in VCR mode.  Hence, there shouldn't be any
downside to having it in auto mode unless you have some reason to
believe the detection code is faulty or error-prone.

We can add a modprobe option to allow the user to force it into one
mode or the other, if someone finds a case where the detection logic
has issues.  But forcing it into one particular mode by default
doesn't seem like the right approach.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
