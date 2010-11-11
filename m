Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:44787 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab0KKOGX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Nov 2010 09:06:23 -0500
Message-ID: <4CDBF859.4010909@infradead.org>
Date: Thu, 11 Nov 2010 12:06:17 -0200
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

Fixed:

	http://git.linuxtv.org/mchehab/tmp_rc.git?a=commit;h=b84d81386621b2c56b65f80f9428a516a330b095

(note that I rebased the temporary branch, and that the latest patch on it is incomplete and broken)
