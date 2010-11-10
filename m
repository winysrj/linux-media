Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:59728 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab0KJWBT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 17:01:19 -0500
Date: Wed, 10 Nov 2010 23:01:15 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/6] rc-core: ir-core to rc-core conversion
Message-ID: <20101110220115.GA7302@hardeman.nu>
References: <20101102201733.12010.30019.stgit@localhost.localdomain>
 <AANLkTi=z2yU568sEs0RNuQ6gZUzJQeHajTZ_0LeXS-2D@mail.gmail.com>
 <4CD9FA59.9020702@infradead.org>
 <33c8487ce0141587f695d9719289467e@hardeman.nu>
 <4CDA94C6.2010506@infradead.org>
 <0bda4af059880eb492d921728997958c@hardeman.nu>
 <4CDAC730.4060303@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CDAC730.4060303@infradead.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Nov 10, 2010 at 02:24:16PM -0200, Mauro Carvalho Chehab wrote:
> Em 10-11-2010 11:06, David Härdeman escreveu:
> > On Wed, 10 Nov 2010 10:49:10 -0200, Mauro Carvalho Chehab
> > <mchehab@infradead.org> wrote:
> 
> >> So, I'll try to merge the pending patches from your tree. I'll let you
> >> know if I have any problems.
> > 
> > Sounds good. Thanks.
> 
> David/Jarod,
> 
> I pushed the merged patches at the tmp_rc tree:
> 
> 	http://git.linuxtv.org/mchehab/tmp_rc.git
> 
> Please test and give me some feedback. It ended that the rc function renaming patch
> (6/7) broke both mceusb (due to TX changes) and cx231xx-input (a new driver from me,
> for some devices that uses a crappy i2c uP, instead of the excellent in-cx231xx
> IR support).
> 
> I did no tests at all, except for compilation. So, I need your feedback
> if the patches didn't actually break anything.

So far I've noticed that this patch:
[media] rc-core: convert winbond-cir

removed the old winbond-cir.c file but doesn't add one in the
drivers/media/rc/ directory.

-- 
David Härdeman
