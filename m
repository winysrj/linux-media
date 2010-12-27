Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:38001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430Ab0L0LwG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 06:52:06 -0500
Message-ID: <4D187D96.5060303@redhat.com>
Date: Mon, 27 Dec 2010 09:50:46 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?TWFyaXVzeiBCaWHFgm/FhGN6eWs=?= <manio@skyboo.net>
CC: linux-media@vger.kernel.org
Subject: Re: ir-core: nec protocol problem
References: <4D17816B.2050500@skyboo.net>
In-Reply-To: <4D17816B.2050500@skyboo.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 26-12-2010 15:54, Mariusz Białończyk escreveu:
> Hello,
> Maybe you could give me some tip for issue i found with ir-core.
> I am using cx88 chipset for ir-decoding.
> The problem is that sometimes the key is wrong handled (especially
> when the remote is long from the receiver), for instance:
> I am pressing "1" on remote, then after some time i am pressing
> "2" but instead i've got repeat key of "1" again.
> When looking at debug logs i can see that "key startup sequence"
> is omitted and only a back of ir code (the repeat) is handled
> as a repeat. Maybe I'm not clear, so i'll try to explain like this:
> As far as I know pressing the buttons on remote with NEC protocol
> generates two things:
> 1. key code (I'll call it "code header")
> 2. repeat code
> 
> And the problem is when ir-core is receiving it like this:
> 1. key code of "1"
> 2. repeat code
> 3. key code of "2" - this is wrong decoded
> 4. repeat code - and here it repeats "1", not "2"
> 
> I think it's a problem with NEC protocol. My point is that
> it should NOT do "repeat code" in case when "code header" was not
> decoded, and especially if the repeat code is after some period of
> time after the "key header" (and even after ir_keyup event).
> In the other words - I think it is better to have no event instead
> of wrong repeat key event (which i does *NOT* press), at least I
> know than, that I need to press the key again.
> I am attaching you debug logs with comments inside.
> What do you think about it? Maybe it is fixed now? (i am using
> 2.6.36 kernel with one patch which ported my cx88 driver to
> ir-core).

We can't simply discard the repeat code due to some non-decoded stuff,
as it can be some noise, caused, for example, by a fluorescent bulb or
by the sunlight.

That's said, it actually makes sense to have some timeout event that
will disable key repeats if they are not close enough to an IR keydown.

At a first glance, it makes sense to use the ir_keyup timeout also to 
disable the IR repeat for the NEC protocol.

Feel free to propose a patch for it.

Cheers,
Mauro
