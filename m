Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:47437 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab0KKQAq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Nov 2010 11:00:46 -0500
Message-ID: <4CDC1326.3030502@infradead.org>
Date: Thu, 11 Nov 2010 14:00:38 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/6] rc-core: ir-core to rc-core conversion
References: <20101102201733.12010.30019.stgit@localhost.localdomain> <AANLkTi=z2yU568sEs0RNuQ6gZUzJQeHajTZ_0LeXS-2D@mail.gmail.com> <4CD9FA59.9020702@infradead.org> <33c8487ce0141587f695d9719289467e@hardeman.nu> <4CDA94C6.2010506@infradead.org> <0bda4af059880eb492d921728997958c@hardeman.nu> <4CDAC730.4060303@infradead.org> <20101110220115.GA7302@hardeman.nu> <4CDBF596.6030206@infradead.org> <02f13638ea24016b5b3673b50940a91c@hardeman.nu>
In-Reply-To: <02f13638ea24016b5b3673b50940a91c@hardeman.nu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 11-11-2010 13:19, David Härdeman escreveu:
> On Thu, 11 Nov 2010 11:54:30 -0200, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
>> The bad news is that ir-kbd-i2c also needs the stuff that are inside
>> ir.props (e. g., the IR configuration logic). I wrote and just sent 2
>> patches to the ML with the fix patches, against my media-tree.git,
>> branch staging/for_v2.6.38. For now, only one field
>> of props is used, but other fields there are likely needed for the other
>> places where this driver is used, like the open/close callbacks,
>> allowed_protocols, etc.
>>
>> I don't like the idea of just copying all those config stuff into struct
>> IR_i2c, and then at struct rc_dev,
> 
> Which is the way it is with or without my patch, either a struct
> ir_dev_props or a subset of the former members of that struct are in
> IR_i2c, same data. And right now you would need to have a mix between
> ir_dev_props data and additional ir_dev related data in struct IR_i2c (the
> rc map name is outside of ir_dev_props).
> 
> Note that the patch *removes* > 200 lines of code (without any loss of
> functionality) - and that's because the interface is simplified. Simple is
> good.
> 
>> and then at struct input_dev.
> 
> struct input_dev only gets input_name, input_phys and input_id from struct
> rc_dev, and I did it that way because I didn't want to remove all that
> information from all drivers (and fill input_dev with generic information
> instead).

input_dev fields need to be properly filled, but just duplicating the same
info on both structs and copying from one to the other doesn't seem the better
way. Why not just initialize rc_dev->input_dev fields directly, not duplicating
the data (or having a helper in-lined routine) to initialize those fields?

Ok, but the point is that a driver like ir-kbd-i2c (and other I2C drivers like
lirc-zilog - after ported to rc-core) will require several additional fields
that are added at rc_dev (basically, all fields that are, currently, at 
ir_dev_props structs may be needed by an i2c driver).

> We'll have to readdress that issue once
> multi-input-devs-per-rc-dev functionality is implemented.
> 
>> It is too much data duplication for no good reason.
> 
> And you believe it's an important feature that props used to be a struct
> and that you could pass a pointer (and take care of initializing rc_map)
> instead of initializing a couple of members in rc_dev directly?

Duplicating dozens of fields is not a good idea.

> The use of struct ir_dev_props was a truely bizarre interface. For
> example: setting the props member was optional, and a ir_input_dev struct
> without a props member lacks a driver_type submember.

It were added as optional, to avoid many changes at the drivers, as a way
to speedup drivers porting, but I think that all drivers should properly
initialize the fields there.

> So all codepaths need
> to know what the default driver_type is when props is not set. Not to
> mention the number of oops reports that linux-media has already seen,
> caused by code which didn't check ->props before dereferencing it. That's
> of course a bug in code, but it's a bug caused by a non-intuitive
> interface.
> 
> The new struct is much more straightforward, and your worries about
> additional pain caused by not having a struct ir_dev_props did not
> materialize in any of the changes I did (see for example
> drivers/media/dvb/dvb-usb/dib0700_devices.c which had similar requirements
> to struct IR_i2c).

dvb-usb uses a large struct to device dvb devices, and, due to the
way it were done, every single field at RC should be inititialized,
per device. I don't like the way it is, but I didn't want to delay
the rc_core port on it, due to some discussions about how to re-structure
it to avoid the large amount of data duplication there. So, I just
added the absolute minimum fields there. IMO, we should do later 
a large cleanup on it. Yet, it is different than ir-kdb-i2c, since
since the beginning, the complete IR code is exported on DVB drivers,
while V4L drivers use to export just a few bits of the IR code (up
to seven bits). So, it is not a good example.

A good exercise would be to port lirc-zilog and see what happens.

>> So, I think we should re-think about your patch 6/7.
> 
> What's your suggestion?

One idea could be to initialize rc_dev at the caller drivers, passing
it via platform_data for the I2C drivers.

Also, instead of duplicating input_dev fields, directly initialize them 
inside the drivers, and not at rc-core.

I like the idea of having an inlined function (like usb_fill_control_urb),
to be sure that all mandatory fields are initialized by the drivers.

> 
>> Comments?
> 
> Unsurprisingly, I disagree on the whole re-think part :)

:)

Cheers,
Mauro.
