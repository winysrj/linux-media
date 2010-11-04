Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:59248 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab0KDMQZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Nov 2010 08:16:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 04 Nov 2010 13:16:22 +0100
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	<linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] Apple remote support
In-Reply-To: <AANLkTi=c_g7nxCFWsVMYM-tJr68V1iMzhSyJ7=g9VLnR@mail.gmail.com>
References: <20101029031131.GE17238@redhat.com> <20101029031530.GH17238@redhat.com> <4CCAD01A.3090106@redhat.com> <20101029151141.GA21604@redhat.com> <20101029191711.GA12136@hardeman.nu> <20101029192733.GE21604@redhat.com> <20101029195918.GA12501@hardeman.nu> <20101029200937.GG21604@redhat.com> <20101030233617.GA13155@hardeman.nu> <AANLkTimLU1TUn6nY4pr2pWNJp1hviyx=NiXYUQLSQA0e@mail.gmail.com> <20101101215635.GA4808@hardeman.nu> <AANLkTi=c_g7nxCFWsVMYM-tJr68V1iMzhSyJ7=g9VLnR@mail.gmail.com>
Message-ID: <37bb20b43afce52964a95a72a725b0e4@hardeman.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Tue, 2 Nov 2010 16:42:05 -0400, Jarod Wilson <jarod@wilsonet.com>
wrote:
> On Mon, Nov 1, 2010 at 5:56 PM, David Härdeman <david@hardeman.nu>
wrote:
>> On Sat, Oct 30, 2010 at 10:32:14PM -0400, Jarod Wilson wrote:
>>> On Sat, Oct 30, 2010 at 7:36 PM, David Härdeman <david@hardeman.nu>
>>> wrote:
>>> > In that case, one solution would be:
>>> >
>>> > * using the full 32 bit scancode
>>> > * add a module parameter to squash the ID byte to zero
>>> > * default the module parameter to true
>>> > * create a keymap suitable for ID = 0x00
>>> >
>>> > Users who really want to distinguish remotes can then change the
>>> > module
>>> > parameter and generate a keymap for their particular ID. Most others
>>> > will be blissfully unaware of this feature.
>>>
>>> I was thinking something similar but slightly different. I think ID =
>>> 0x00 is a valid ID byte, so I was thinking static int pair_id = -1; to
>>> start out. This would be a stand-alone apple-only decoder, so we'd
>>> look for the apple identifier bytes, bail if not found. We'd also look
>>> at the ID byte, and if pair_id is 0-255, we'd bail if the ID byte
>>> didn't match it. The scancode we'd actually use to match the key table
>>> would be just the one command byte. It seems to make sense in my head,
>>> at least.
>>
>> But you'd lose the ability to support two different remotes with
>> different ID's (if you want different mappings in the keymap).
> 
> Hm, true. How likely are people to want to do that, I wonder?
> 
> So alternatively, rather than a pair_id param, could use a
> check_pair_byte param. If 0, then just & 0xff the pair byte, and have
> 0xff there in the default keymap (using all 32 bits for each code)

Yes, that's what I proposed above :) (just & 0x00 the pair byte)

-- 
David Härdeman
