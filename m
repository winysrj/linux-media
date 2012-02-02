Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54743 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab2BBX2r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 18:28:47 -0500
Received: by eaah12 with SMTP id h12so1246944eaa.19
        for <linux-media@vger.kernel.org>; Thu, 02 Feb 2012 15:28:46 -0800 (PST)
Message-ID: <4F2B1C2B.5080602@gmail.com>
Date: Fri, 03 Feb 2012 00:28:43 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Andy Furniss <andyqos@ukfsn.org>, linux-media@vger.kernel.org
Subject: Re: PCTV 290e page allocation failure
References: <4F2AC7BF.4040006@ukfsn.org>	<4F2ADDCB.4060200@gmail.com>	<CAGoCfiyTHNkr3gNAZUefeZN88-5Vd9SEyGUeFjYO-ddG1WqgzA@mail.gmail.com>	<4F2B16DF.3040400@gmail.com> <CAGoCfiybOLL2Owz2KaPG2AuMueHYKmN18A8tQ7WXVkhTuRobZQ@mail.gmail.com>
In-Reply-To: <CAGoCfiybOLL2Owz2KaPG2AuMueHYKmN18A8tQ7WXVkhTuRobZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 03/02/2012 00:12, Devin Heitmueller ha scritto:
> On Thu, Feb 2, 2012 at 6:06 PM, Gianluca Gennari <gennarone@gmail.com> wrote:
>> Il 02/02/2012 20:07, Devin Heitmueller ha scritto:
>> Hi Devin,
>> thanks for the explanation. The CPU is MIPS based (not ARM) but I guess
>> there is not much of a difference from this point of view.
>> As I mentioned in my first reply, I never had this kind of errors when I
>> was using a dvb-usb USB stick. Now I'm trying to replicate the problem
>> with a Terratec Hybrid XS (em28xx-dvb + zl10353 + xc2028), and so far
>> I've stressed it for a few hours without problems. We will see in a day
>> or two if I can make it fail in the same way.
> 
> I'm pretty sure this will happen under MIPS as well.  That said, you
> will typically hit this condition if you stop streaming and then
> restart it several hours into operation.  In other words, make sure
> you're not just watching/streaming video for a few hours and thinking
> you're stressing the particular use case.  You need to stop/start to
> hit it.

Yes, I've been switching between the mediaplayer (playing some 1080p mkv
file to stress the memory) and the USB tuner, but so far so good.
But I need to run the test longer to draw some conclusion.

> I haven't looked that closely at dvb_usb's memory allocation strategy.
>  Perhaps it allocates the memory up front, or perhaps it doesn't
> demand coherent memory (something which will work on x86 and maybe
> MIPS, but will cause an immediate panic on ARM).
> 
> I've run into this issue myself on an embedded target with em28xx and
> ARM.  I plan on hacking a fix to statically allocate the buffers at
> driver init, but I cannot imagine that being a change that would be
> accepted into the upstream kernel.

If you have some patch that you want to share, I will be happy to test it.

> It probably makes sense to figure out whether MIPS requires coherent
> memory like ARM does.  If it doesn't then you can probably just hack
> your copy of the em28xx driver to not ask for coherent memory.  If it
> does require coherent memory, then you'll probably need to allocate
> the memory up front.
> 

Interesting suggestion. I have really no idea if MIPS really requires
coherent memory in this case. I may try to hack it and see what happens.

Thank you very much for the detailed explanation.

Regards,
Gianluca

> Cheers,
> 
> Devin
> 

