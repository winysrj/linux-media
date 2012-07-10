Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57136 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab2GJD6m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2012 23:58:42 -0400
Received: by obbuo13 with SMTP id uo13so21542757obb.19
        for <linux-media@vger.kernel.org>; Mon, 09 Jul 2012 20:58:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOkj578ou_hTpEhMwwk05T97_SCZ-+mP346KXH-rbGusLWCvGg@mail.gmail.com>
References: <CAOkj578ou_hTpEhMwwk05T97_SCZ-+mP346KXH-rbGusLWCvGg@mail.gmail.com>
Date: Mon, 9 Jul 2012 23:58:41 -0400
Message-ID: <CAGoCfiztN3LdC=gOfC5PviSiYTf0ec19TO=cEAfsidMC7Lxi6Q@mail.gmail.com>
Subject: Re: Any program that creates captions from pixel data?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Tim Stowell <stowellt@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 9, 2012 at 11:19 PM, Tim Stowell <stowellt@gmail.com> wrote:
> Hello,
>
> I'm trying to create a bitmap image such that when output via a
> composite port it will translate into captions, very similar to this:
> http://al.robotfuzz.com/generating-teletext-in-software/ except NTSC.
> I have some ideas but wanted to check if anyone had tried something
> similar as Google didn't turn up much, thanks!

I don't know if this is related to your previous thread about VBI
capture on em28xx, but if so I can tell you that you can probably
pretty easily "pass through" the VBI data as a graphical waveform if
that is your goal.  The only difference between the data provided via
raw VBI capture and the standard image data is that the chroma is
stripped out (every other byte in a YUYV sequence).

If your goal is to generate the waveform from scratch, I haven't seen
any software to do that but it would be pretty trivial to write
(probably a couple hundred lines of code).  You just need to read the
EIA-608 spec and understand how the byte pairs are represented in the
waveform.  You should also look more closely at the zvbi source code -
it has the ability to create a "dummy source" which if I recall
actually can work with osc (meaning it can generate the waveform
internally).  You would have to hack up the code to connect the parts
and extract the actual image data.

It's probably also worth mentioning that much of this is dependent on
the output device you are using.   Many devices don't actually let you
put data into the VBI area just by including it in the image data.
You typically have to use special APIs that are specific to the
platform.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
