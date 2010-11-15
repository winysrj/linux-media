Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:46606 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885Ab0KOSjW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 13:39:22 -0500
Date: Mon, 15 Nov 2010 19:39:17 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Apple remote support
Message-ID: <20101115183917.GA30458@hardeman.nu>
References: <20101030233617.GA13155@hardeman.nu>
 <AANLkTimLU1TUn6nY4pr2pWNJp1hviyx=NiXYUQLSQA0e@mail.gmail.com>
 <20101101215635.GA4808@hardeman.nu>
 <AANLkTi=c_g7nxCFWsVMYM-tJr68V1iMzhSyJ7=g9VLnR@mail.gmail.com>
 <37bb20b43afce52964a95a72a725b0e4@hardeman.nu>
 <AANLkTimAx+D745-VxoUJ25ii+=Dm6rHb8OXs9_D69S1W@mail.gmail.com>
 <20101104193823.GA9107@hardeman.nu>
 <4CD30CE5.5030003@redhat.com>
 <da4aa0687909ae3843c682fbf446e452@hardeman.nu>
 <AANLkTin1Lu9cdnLeVfA8NDQFWkKzb6k+yCiSBqq6Otz6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin1Lu9cdnLeVfA8NDQFWkKzb6k+yCiSBqq6Otz6@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Nov 14, 2010 at 11:11:47PM -0500, Jarod Wilson wrote:
>Well, here's what I sent along on Friday:
>
>https://patchwork.kernel.org/patch/321592/
>
>Gives us support for using the full 32-bit codes right now w/o having
>to change any tables yet, but does require a modparam to skip the
>checksum checks, unless its an apple remote which we already know the
>vendor bytes for. I do think I'm ultimately leaning towards just doing
>the full 32 bits for all nec extended though -- optionally, we might
>include a modparam to *enable* the checksum check for those that want
>strict compliance (but I'd still say use the full 32 bits). The only
>issue I see with going to the full 32 right now is that we have all
>these nec tables with only 24 bits, and we don't know ... oh, wait,
>no, nevermind... We *do* know the missing 8 bits, since they have to
>fulfill the checksum check for command ^ not_command. So yeah, I'd say
>32-bit scancodes for all nec extended, don't enforce the checksum by
>default with a module option (or sysfs knob) to enable checksum
>compliance.

32 bit scancodes for *all* NEC, not only NEC extended. The "strict"
check will still be provided, just that it's done as part of the
keytable lookup.

-- 
David Härdeman
