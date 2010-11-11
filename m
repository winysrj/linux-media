Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:48264 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab0KKPTq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Nov 2010 10:19:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 11 Nov 2010 16:19:44 +0100
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@wilsonet.com>, <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/6] rc-core: ir-core to rc-core conversion
In-Reply-To: <4CDBF596.6030206@infradead.org>
References: <20101102201733.12010.30019.stgit@localhost.localdomain> <AANLkTi=z2yU568sEs0RNuQ6gZUzJQeHajTZ_0LeXS-2D@mail.gmail.com> <4CD9FA59.9020702@infradead.org> <33c8487ce0141587f695d9719289467e@hardeman.nu> <4CDA94C6.2010506@infradead.org> <0bda4af059880eb492d921728997958c@hardeman.nu> <4CDAC730.4060303@infradead.org> <20101110220115.GA7302@hardeman.nu> <4CDBF596.6030206@infradead.org>
Message-ID: <02f13638ea24016b5b3673b50940a91c@hardeman.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 11 Nov 2010 11:54:30 -0200, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> The bad news is that ir-kbd-i2c also needs the stuff that are inside
> ir.props (e. g., the IR configuration logic). I wrote and just sent 2
> patches to the ML with the fix patches, against my media-tree.git,
> branch staging/for_v2.6.38. For now, only one field
> of props is used, but other fields there are likely needed for the other
> places where this driver is used, like the open/close callbacks,
> allowed_protocols, etc.
> 
> I don't like the idea of just copying all those config stuff into struct
> IR_i2c, and then at struct rc_dev,

Which is the way it is with or without my patch, either a struct
ir_dev_props or a subset of the former members of that struct are in
IR_i2c, same data. And right now you would need to have a mix between
ir_dev_props data and additional ir_dev related data in struct IR_i2c (the
rc map name is outside of ir_dev_props).

Note that the patch *removes* > 200 lines of code (without any loss of
functionality) - and that's because the interface is simplified. Simple is
good.

> and then at struct input_dev.

struct input_dev only gets input_name, input_phys and input_id from struct
rc_dev, and I did it that way because I didn't want to remove all that
information from all drivers (and fill input_dev with generic information
instead). We'll have to readdress that issue once
multi-input-devs-per-rc-dev functionality is implemented.

> It is too much data duplication for no good reason.

And you believe it's an important feature that props used to be a struct
and that you could pass a pointer (and take care of initializing rc_map)
instead of initializing a couple of members in rc_dev directly?

The use of struct ir_dev_props was a truely bizarre interface. For
example: setting the props member was optional, and a ir_input_dev struct
without a props member lacks a driver_type submember. So all codepaths need
to know what the default driver_type is when props is not set. Not to
mention the number of oops reports that linux-media has already seen,
caused by code which didn't check ->props before dereferencing it. That's
of course a bug in code, but it's a bug caused by a non-intuitive
interface.

The new struct is much more straightforward, and your worries about
additional pain caused by not having a struct ir_dev_props did not
materialize in any of the changes I did (see for example
drivers/media/dvb/dvb-usb/dib0700_devices.c which had similar requirements
to struct IR_i2c).

> So, I think we should re-think about your patch 6/7.

What's your suggestion?

> Comments?

Unsurprisingly, I disagree on the whole re-think part :)

-- 
David Härdeman
