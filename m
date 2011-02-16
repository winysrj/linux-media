Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44916 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1BPQdo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 11:33:44 -0500
Received: by ewy5 with SMTP id 5so524059ewy.19
        for <linux-media@vger.kernel.org>; Wed, 16 Feb 2011 08:33:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110215221857.GB3327@redhat.com>
References: <AANLkTi=jkLGgZDH6XytL1MEE7w5SckZjXoGPhFSCo40b@mail.gmail.com>
	<20110215220433.GA3327@redhat.com>
	<20110215221857.GB3327@redhat.com>
Date: Wed, 16 Feb 2011 11:33:42 -0500
Message-ID: <AANLkTinxCddEK2Ce3k42O3105fi8WqjzV3TDFqDO6WaR@mail.gmail.com>
Subject: Re: IR for remote control not working for Hauppauge WinTV-HVR-1150 (SAA7134)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: Fernando Laudares Camargos <fernando.laudares.camargos@gmail.com>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Feb 15, 2011 at 5:18 PM, Jarod Wilson <jarod@redhat.com> wrote:
> On Tue, Feb 15, 2011 at 05:04:33PM -0500, Jarod Wilson wrote:
>> First off, video4linux-list is dead, you want linux-media (added to cc).
>>
>> On Tue, Feb 15, 2011 at 06:27:29PM -0200, Fernando Laudares Camargos wrote:
>> > Hello,
>> >
>> > I have a Hauppauge WinTV-HVR-1150 (model 67201) pci tv tuner working
>> > (video and audio) under Ubuntu 10.10 and kernel 2.6.35-25. But the IR
>> > sensor is not being detected and no input device is being created at
>> > /proc/bus/input.
>
> Reading over the code some more, I don't see dev->has_remote set for the
> HVR1150, so it appears the IR receiver on that hardware isn't actually yet
> supported, so the patch I was thinking of may not help here. I failed to
> notice the part where you said no input device was being created, that
> patch only mattered if you were getting an rc input device created.

I looked at this a few months ago.  The IR isn't supported at all on
that board.  It's basically an IR receiver diode tied directly
directly to a GPIO, and it relies on interrupt edge timing to compute
the codes.

I played with it for a couple of hours and couldn't get it working.
It needs some TLC from somebody who actually has the board.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
