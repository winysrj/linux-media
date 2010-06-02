Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:39545 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758035Ab0FBRWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jun 2010 13:22:42 -0400
Received: by wwb28 with SMTP id 28so3082165wwb.19
        for <linux-media@vger.kernel.org>; Wed, 02 Jun 2010 10:22:40 -0700 (PDT)
Date: Wed, 2 Jun 2010 19:22:36 +0200
From: Davor Emard <davoremard@gmail.com>
To: semiRocket <semirocket@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Compro Videomate T750F Vista digital+analog support
Message-ID: <20100602172224.GA15872@emard.lan>
References: <AANLkTikbpZ0LM5rK70abVuJS27j0lT7iZs12DrSKB9wI@mail.gmail.com>
 <op.vcfoxwnq3xmt7q@crni>
 <20100509173243.GA8227@z60m>
 <op.vcga9rw2ndeod6@crni>
 <20100509231535.GA6334@z60m>
 <op.vcsntos43xmt7q@crni>
 <op.vc551isrndeod6@crni>
 <20100530234817.GA17135@emard.lan>
 <20100531075214.GA17456@lipa.lan>
 <op.vdn7g9nj3xmt7q@crni>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.vdn7g9nj3xmt7q@crni>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> >HI!
> >
> >I just went to compro website and have seen that *f cards
> >have some identical MCE-alike but also slightly different remotes,
> >so we have to invent some better names to distinguish between
> >them (compro itself might have some names for them)
> >
> Tested your new patch with Gerd's input-events utility. input-events
> is reporting wrong key (KEY_MIN_INTERESTING) for KEY_MUTE, not sure
> why.

HI! Is at least tuner (and loading of the firmware) working now without 
preinitialization with windows?

About remote keys:
My evtest in debian is outdated (probably also your input-events). 
Not only it doesn't support all KEY_*s but also for some existing keys it 
reports the wrong names (like KEY_MIN_INTERESTING). 

Try it with xev, at least MUTE should work correctly there (reports XF86AudioMute).
However KEY_NUMERIC_* won't be recognized by xev because X11 doesn't map
them to anything by default

However only the input layer keycodes matter, we can ignore it's name interpreted 
by some application (every app may name it different or even wrong...).

The tools should be compiled against latest /usr/include/linux/input.h
and have all new key names there (and corrected some existing names).

My intention was to map remote key pictograms to most appropriate
event in latest kernel's input.h, avoiding PC keyboard ambiguity as
much as I can.

Because in the kernel they have expanded input.h with a number of new keys to 
better cover MCE remotes and new media keyboards, so you get those ??? for
old apps but the keycode numbers should still be correct according to the 
kernel's input layer. input layer Applications map key events to the keycode 
numbers, and have freedom to give any name to the key.

The KEY_PREVIOUS and KEY_NEXT are actually keys for prev page and
next page on the keyboard, used for scrolling text. PREVIOUSSONG 
NEXTSIONG are used to skip to songs and are also expanded to skipping
to video DVD chapters, so I thought they are more appropriate for the
remote pictograms "|<" ">|" at VCR key group. I wanted to avoid ambiguity
between keyboard events and remote, however I still have KEY_ENTER
and KEY_BACKSPACE and the cursors, which is in ambiguity to the
normal keyboard - any idea what to replace them with in MCE style?

I have no issue of mapping all current keys to VDR. If you have any real issue of
mapping keys to some other TV view application or to the linux console or X11, 
feel free to change them and suggest a patch

d.
