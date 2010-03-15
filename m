Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:65346 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab0CODza (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Mar 2010 23:55:30 -0400
Received: by bwz1 with SMTP id 1so2567428bwz.21
        for <linux-media@vger.kernel.org>; Sun, 14 Mar 2010 20:55:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <74fd948d1003140806tc32b263y634405b60bd10cd0@mail.gmail.com>
References: <74fd948d1003031535r1785b36dq4cece00f349975af@mail.gmail.com>
	 <829197381003031548n703f0bf9sb44ce3527501c5c0@mail.gmail.com>
	 <74fd948d1003031700h187dbfd0v3f54800e652569b@mail.gmail.com>
	 <829197381003031706g1011f442hcc4be40ae2e79a47@mail.gmail.com>
	 <4B8F347E.2010206@gmail.com>
	 <74fd948d1003040314y2fc911f2k97b1d6fb66bdc0b9@mail.gmail.com>
	 <829197381003041139j7300bc7cg1281aff59e5a60b@mail.gmail.com>
	 <74fd948d1003041244s513dce3s69567cb9dbe31ae1@mail.gmail.com>
	 <829197381003041252m7b547e2ehced781c59c1c6edc@mail.gmail.com>
	 <74fd948d1003140806tc32b263y634405b60bd10cd0@mail.gmail.com>
Date: Sun, 14 Mar 2010 23:55:29 -0400
Message-ID: <829197381003142055r271fefcbs8c5e5ea97e47c585@mail.gmail.com>
Subject: Re: Excessive rc polling interval in dvb_usb_dib0700 causes
	interference with USB soundcard
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 14, 2010 at 11:06 AM, Pedro Ribeiro <pedrib@gmail.com> wrote:
> Hi Devin,
>
> after some through investigation I found that your patch solves the
> continuous interference.
>
> However, I have a second problem. It is also interference but appears
> to be quite random, by which I mean it is not at a fixed interval,
> sometimes it happens past 10 seconds, other times past 30 seconds,
> other times 2 to 5 seconds.
>
> One thing is sure - it only happens when I'm actually streaming from
> the DVB adapter. If I just plug it in, there is no interference. But
> when I start vdr (for example) the interference starts.
>
> The DVB adapter and the sound card are not sharing irq's or anything
> like that, and there is no system freeze when the interference
> happens. I also thought it was either my docking bay or power supply,
> but definitely it isn't.
>
> Any idea what can this be?
>
> Thank you for your help,
> Pedro

Hello Pedro,

Could you describe in more detail what you mean by "interference"?  Do
you mean that you get corrupted audio for short bursts?  Or do you
mean the audio is dropping out for periods of time?  Can you elaborate
on how long the problem occurs for, and how often it occurs?  For
example, do you get corrupted audio for 1 second at a time every ten
or fifteen seconds?

This is a USB audio device, correct?  Are both devices on the same USB
bus?  Is there a USB hub involved?

It's also possible that this is just a general latency problem - where
the CPU becomes too busy, it does not service the sound card often
enough and PCM data is being dropped.  Have you tried running "top"?
What does your CPU utilization look like when you are experiencing the
problem?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
