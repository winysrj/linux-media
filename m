Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:44910 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab0KKNyh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Nov 2010 08:54:37 -0500
Message-ID: <4CDBF596.6030206@infradead.org>
Date: Thu, 11 Nov 2010 11:54:30 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
CC: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/6] rc-core: ir-core to rc-core conversion
References: <20101102201733.12010.30019.stgit@localhost.localdomain> <AANLkTi=z2yU568sEs0RNuQ6gZUzJQeHajTZ_0LeXS-2D@mail.gmail.com> <4CD9FA59.9020702@infradead.org> <33c8487ce0141587f695d9719289467e@hardeman.nu> <4CDA94C6.2010506@infradead.org> <0bda4af059880eb492d921728997958c@hardeman.nu> <4CDAC730.4060303@infradead.org> <20101110220115.GA7302@hardeman.nu>
In-Reply-To: <20101110220115.GA7302@hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 10-11-2010 20:01, David Härdeman escreveu:
> On Wed, Nov 10, 2010 at 02:24:16PM -0200, Mauro Carvalho Chehab wrote:
>> Em 10-11-2010 11:06, David Härdeman escreveu:
>>> On Wed, 10 Nov 2010 10:49:10 -0200, Mauro Carvalho Chehab
>>> <mchehab@infradead.org> wrote:
>>
>>>> So, I'll try to merge the pending patches from your tree. I'll let you
>>>> know if I have any problems.
>>>
>>> Sounds good. Thanks.
>>
>> David/Jarod,
>>
>> I pushed the merged patches at the tmp_rc tree:
>>
>> 	http://git.linuxtv.org/mchehab/tmp_rc.git
>>
>> Please test and give me some feedback. It ended that the rc function renaming patch
>> (6/7) broke both mceusb (due to TX changes) and cx231xx-input (a new driver from me,
>> for some devices that uses a crappy i2c uP, instead of the excellent in-cx231xx
>> IR support).
>>
>> I did no tests at all, except for compilation. So, I need your feedback
>> if the patches didn't actually break anything.
> 
> So far I've noticed that this patch:
> [media] rc-core: convert winbond-cir
> 
> removed the old winbond-cir.c file but doesn't add one in the
> drivers/media/rc/ directory.
> 
Weird... it seems that i forgot to add the new file on my tree. I think I know why...
there are two files from kernel tree that got deleted during the build time. So, I had
to manually revert and re-do the commit. I suspect that there's something bad with
those two files at -rc1...

Anyway, my rebase to the patch that created the rc_register_device() functions
were not ok, as it broke cx231xx-input (a new IR driver added before your series).
While debugging the reason, I discovered some problems at the original patch. I just
sent an update for it.

The bad news is that ir-kbd-i2c also needs the stuff that are inside ir.props (e. g.,
the IR configuration logic). I wrote and just sent 2 patches to the ML with the fix
patches, against my media-tree.git, branch staging/for_v2.6.38. For now, only one field
of props is used, but other fields there are likely needed for the other places
where this driver is used, like the open/close callbacks, allowed_protocols, etc.

I don't like the idea of just copying all those config stuff into struct IR_i2c, and
then at struct rc_dev, and then at struct input_dev. It is too much data duplication
for no good reason.

So, I think we should re-think about your patch 6/7.

Comments?
Mauro


