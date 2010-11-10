Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:45220 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab0KJNG1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 08:06:27 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 10 Nov 2010 14:06:24 +0100
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@wilsonet.com>, <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/6] rc-core: ir-core to rc-core conversion
In-Reply-To: <4CDA94C6.2010506@infradead.org>
References: <20101102201733.12010.30019.stgit@localhost.localdomain> <AANLkTi=z2yU568sEs0RNuQ6gZUzJQeHajTZ_0LeXS-2D@mail.gmail.com> <4CD9FA59.9020702@infradead.org> <33c8487ce0141587f695d9719289467e@hardeman.nu> <4CDA94C6.2010506@infradead.org>
Message-ID: <0bda4af059880eb492d921728997958c@hardeman.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 10 Nov 2010 10:49:10 -0200, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Em 10-11-2010 07:24, David Härdeman escreveu:
>> Not sure if you used the most recent version of patch 4/6 or not.
>> 
>> If you used the most recent, it's based on 2.6.37-rc1 upstream which
has
>> both the large-input-scancodes patches as well as two important
bugfixes
>> to ir-keytable.c, so since your staging/for_v2.6.38 is based on 2.6.36
>> plus the staging/for_v2.6.37-rc1 branch, it won't apply.
> 
> Gah! Yeah, my tree is based on 2.6.36, but we need to be based on
.37-rc1.
> I'll merge .37-rc1.

I think/hope my patches will apply with little to no fuzz once you've done
that.

>> My name used to be UTF-8 encoded in winbond-cir, and it was changed
>> upstream (not by me), so I'm not going to revert it.
> 
> Patchwork handles very badly charset encodings, due to Python. I sent
> several
> patches for it to fix several problems I noticed there.
> Basically, Python kills any script if the an invalid character is
inserted
> on a string. E. g., if your emailer says that the email is encoded as
> UTF-8, and
> a non-UTF-8 character is found on any part of the email, the script will
> die, as
> it will try to write the email contents on some vars. 
> 
> Due to that, a patch/email with an invalid character on his 
> charset will be silently discarded by patchwork, as the script will die.

Not much I can do there :)

> I suspect that your emailer might be doing some bad things also, as I
need 
> to manually fix your author's name every time. In general the SOB on
your
> emails have one encoding, while the From: has another encoding.

I didn't know that, I'll have a look. I'm guessing that both iso88591-1
and utf-8 encodings are used.

> So, I'll try to merge the pending patches from your tree. I'll let you
> know if I have any problems.

Sounds good. Thanks.

-- 
David Härdeman
