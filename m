Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54582 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab0KOELs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 23:11:48 -0500
Received: by iwn10 with SMTP id 10so6216911iwn.19
        for <linux-media@vger.kernel.org>; Sun, 14 Nov 2010 20:11:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <da4aa0687909ae3843c682fbf446e452@hardeman.nu>
References: <20101029191711.GA12136@hardeman.nu>
	<20101029192733.GE21604@redhat.com>
	<20101029195918.GA12501@hardeman.nu>
	<20101029200937.GG21604@redhat.com>
	<20101030233617.GA13155@hardeman.nu>
	<AANLkTimLU1TUn6nY4pr2pWNJp1hviyx=NiXYUQLSQA0e@mail.gmail.com>
	<20101101215635.GA4808@hardeman.nu>
	<AANLkTi=c_g7nxCFWsVMYM-tJr68V1iMzhSyJ7=g9VLnR@mail.gmail.com>
	<37bb20b43afce52964a95a72a725b0e4@hardeman.nu>
	<AANLkTimAx+D745-VxoUJ25ii+=Dm6rHb8OXs9_D69S1W@mail.gmail.com>
	<20101104193823.GA9107@hardeman.nu>
	<4CD30CE5.5030003@redhat.com>
	<da4aa0687909ae3843c682fbf446e452@hardeman.nu>
Date: Sun, 14 Nov 2010 23:11:47 -0500
Message-ID: <AANLkTin1Lu9cdnLeVfA8NDQFWkKzb6k+yCiSBqq6Otz6@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] Apple remote support
From: Jarod Wilson <jarod@wilsonet.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Nov 5, 2010 at 9:27 AM, David Härdeman <david@hardeman.nu> wrote:
> On Thu, 04 Nov 2010 15:43:33 -0400, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 04-11-2010 15:38, David Härdeman escreveu:
>>> On Thu, Nov 04, 2010 at 11:54:25AM -0400, Jarod Wilson wrote:
>>>> Okay, so we seem to be in agreement for an approach to handling this.
>>>> I'll toss something together implementing that RSN... Though I talked
>>>> with Mauro about this a bit yesterday here at LPC, and we're thinking
>>>> maybe we slide this support back over into the nec decoder and make it
>>>> a slightly more generic "use full 32 bits" NEC variant we look for
>>>> and/or enable/disable somehow. I've got another remote here, for a
>>>> Motorola cable box, which is NEC-ish, but always fails decode w/a
>>>> checksum error ("got 0x00000000", iirc), which may also need to use
>>>> the full 32 bits somehow... Probably a very important protocol variant
>>>> to support, particularly once we have native transmit support, as its
>>>> used by plenty of cable boxes on the major carriers here in the US.
>>>
>>> I've always found the "checksum" tests in the NEC decoder to be
>>> unnecessary so I'm all for using a 32 bit scancode in all cases (and
>>> still using a module param to squash the ID byte of apple remotes,
>>> defaulting to "yes").
>>>
>> This means changing all existing NEC tables to have 32 bits, and add
>> the "redundant" information on all of them.
>
> Yep (though we should use macros to generate scancodes)
>
>> It doesn't seem a good idea
>> to me to add a penalty for those NEC tables that follow the standard.
>
> Which penalty?
>
> Using a 32 bit scancode won't affect keytable size or lookup speed.
>
> In some corner cases, additional keytable lookups will be performed for
> decoded scancodes which would otherwise be deemed "invalid", but at the
> time that decision can be made, most of the processing (reading timing
> events from hardware, handing them to decoders, decoding them) has already
> been done.
>
> If you're referring to the pain caused by changing existing keytables
> (thereby breaking custom keytables), I think it's inevitable. Throwing away
> information is not a good solution.
>
> As this subsystem progresses, there's going to be more and more reports of
> remotes which, intentionally or unintentionally, do not follow the NEC
> "standard" (I use that word in the most liberal sense). Using the full 32
> bits allows us to support them without any module parameters or code
> changes.
>
> Which solution do you suggest?

Well, here's what I sent along on Friday:

https://patchwork.kernel.org/patch/321592/

Gives us support for using the full 32-bit codes right now w/o having
to change any tables yet, but does require a modparam to skip the
checksum checks, unless its an apple remote which we already know the
vendor bytes for. I do think I'm ultimately leaning towards just doing
the full 32 bits for all nec extended though -- optionally, we might
include a modparam to *enable* the checksum check for those that want
strict compliance (but I'd still say use the full 32 bits). The only
issue I see with going to the full 32 right now is that we have all
these nec tables with only 24 bits, and we don't know ... oh, wait,
no, nevermind... We *do* know the missing 8 bits, since they have to
fulfill the checksum check for command ^ not_command. So yeah, I'd say
32-bit scancodes for all nec extended, don't enforce the checksum by
default with a module option (or sysfs knob) to enable checksum
compliance.

-- 
Jarod Wilson
jarod@wilsonet.com
