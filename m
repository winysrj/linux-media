Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56630 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab0ISTKN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 15:10:13 -0400
Received: by ewy23 with SMTP id 23so1408721ewy.19
        for <linux-media@vger.kernel.org>; Sun, 19 Sep 2010 12:10:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7u86hyrdbdphf9wmevbnab4n.1284911677723@email.android.com>
References: <7u86hyrdbdphf9wmevbnab4n.1284911677723@email.android.com>
Date: Sun, 19 Sep 2010 15:10:11 -0400
Message-ID: <AANLkTinB+zE67UOaqEGkuHhy0RXYX9Ziyr_smOLcn7w5@mail.gmail.com>
Subject: Re: HVR 1600 Distortion
From: Josh Borke <joshborke@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Sep 19, 2010 at 11:54 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> Try a DTV STB or VCR with an RF out on channel 3.  Your card might not be bad.
>
> Your signal looks overdriven from the new MPEG you sent.  I'll discuss more when I'm not typing on my smartphone's tiny little keyboard.
>
> R,
> Andy
>
> Josh Borke <joshborke@gmail.com> wrote:
>
>>On Sat, Sep 18, 2010 at 11:06 PM, Devin Heitmueller
>><dheitmueller@kernellabs.com> wrote:
>>> On Sat, Sep 18, 2010 at 9:09 PM, Josh Borke <joshborke@gmail.com> wrote:
>>>> It could be the tuner card, it is over 2 years old...Why would the
>>>> analog tuner stop functioning while the digital tuner continues to
>>>> work?  Is it because the analog portion goes through a different set
>>>> of chips?
>>>
>>> Yes, the analog portion of the card has a completely separate tuner
>>> and demodulator.
>>>
>>> Don't get me wrong, it's possible that this is a driver issue, but
>>> given Andy has the exact same can tuner on his board it probably makes
>>> sense for you to do a sanity test of the hardware before any more time
>>> is spent investigating the software.
>>>
>>> Cheers,
>>>
>>> Devin
>>>
>>> --
>>> Devin J. Heitmueller - Kernel Labs
>>> http://www.kernellabs.com
>>>
>>
>>I plugged it in to a windows machine and it has the same effect :(
>>I'm going to say the card is fubar and I'll need to find a
>>replacement.
>>
>>Thanks for the help everyone!
>>
>>-josh
>>--
>>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I tried with the output from a SNES (most convenient thing) and it
comes out with the same distortion :(

Thanks,
-josh
