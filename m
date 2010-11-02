Return-path: <mchehab@gaivota>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64597 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab0KBUmG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Nov 2010 16:42:06 -0400
Received: by ywc21 with SMTP id 21so2045804ywc.19
        for <linux-media@vger.kernel.org>; Tue, 02 Nov 2010 13:42:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101101215635.GA4808@hardeman.nu>
References: <20101029031131.GE17238@redhat.com>
	<20101029031530.GH17238@redhat.com>
	<4CCAD01A.3090106@redhat.com>
	<20101029151141.GA21604@redhat.com>
	<20101029191711.GA12136@hardeman.nu>
	<20101029192733.GE21604@redhat.com>
	<20101029195918.GA12501@hardeman.nu>
	<20101029200937.GG21604@redhat.com>
	<20101030233617.GA13155@hardeman.nu>
	<AANLkTimLU1TUn6nY4pr2pWNJp1hviyx=NiXYUQLSQA0e@mail.gmail.com>
	<20101101215635.GA4808@hardeman.nu>
Date: Tue, 2 Nov 2010 16:42:05 -0400
Message-ID: <AANLkTi=c_g7nxCFWsVMYM-tJr68V1iMzhSyJ7=g9VLnR@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] Apple remote support
From: Jarod Wilson <jarod@wilsonet.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Mon, Nov 1, 2010 at 5:56 PM, David Härdeman <david@hardeman.nu> wrote:
> On Sat, Oct 30, 2010 at 10:32:14PM -0400, Jarod Wilson wrote:
>> On Sat, Oct 30, 2010 at 7:36 PM, David Härdeman <david@hardeman.nu> wrote:
>> > In that case, one solution would be:
>> >
>> > * using the full 32 bit scancode
>> > * add a module parameter to squash the ID byte to zero
>> > * default the module parameter to true
>> > * create a keymap suitable for ID = 0x00
>> >
>> > Users who really want to distinguish remotes can then change the module
>> > parameter and generate a keymap for their particular ID. Most others
>> > will be blissfully unaware of this feature.
>>
>> I was thinking something similar but slightly different. I think ID =
>> 0x00 is a valid ID byte, so I was thinking static int pair_id = -1; to
>> start out. This would be a stand-alone apple-only decoder, so we'd
>> look for the apple identifier bytes, bail if not found. We'd also look
>> at the ID byte, and if pair_id is 0-255, we'd bail if the ID byte
>> didn't match it. The scancode we'd actually use to match the key table
>> would be just the one command byte. It seems to make sense in my head,
>> at least.
>
> But you'd lose the ability to support two different remotes with
> different ID's (if you want different mappings in the keymap).

Hm, true. How likely are people to want to do that, I wonder?

So alternatively, rather than a pair_id param, could use a
check_pair_byte param. If 0, then just & 0xff the pair byte, and have
0xff there in the default keymap (using all 32 bits for each code) or
just don't make it part of the scancode and use 24 bits. If
check_pair_byte = 1, pass the pair byte along unmodified, using all 32
bits for the scancode. Would also require the user to add the
remote-specific 32-bit codes though. But we're moving towards keymaps
being uploaded from userspace anyway, so perhaps that's not a big
deal. Would rather avoid the default keymap having 256 entries for
every key for every pair id variant.

-- 
Jarod Wilson
jarod@wilsonet.com
