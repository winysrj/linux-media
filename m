Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:47602 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab0KKUfF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Nov 2010 15:35:05 -0500
Date: Thu, 11 Nov 2010 21:35:01 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/6] rc-core: ir-core to rc-core conversion
Message-ID: <20101111203501.GA8276@hardeman.nu>
References: <AANLkTi=z2yU568sEs0RNuQ6gZUzJQeHajTZ_0LeXS-2D@mail.gmail.com>
 <4CD9FA59.9020702@infradead.org>
 <33c8487ce0141587f695d9719289467e@hardeman.nu>
 <4CDA94C6.2010506@infradead.org>
 <0bda4af059880eb492d921728997958c@hardeman.nu>
 <4CDAC730.4060303@infradead.org>
 <20101110220115.GA7302@hardeman.nu>
 <4CDBF596.6030206@infradead.org>
 <02f13638ea24016b5b3673b50940a91c@hardeman.nu>
 <4CDC1326.3030502@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CDC1326.3030502@infradead.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Nov 11, 2010 at 02:00:38PM -0200, Mauro Carvalho Chehab wrote:
>Em 11-11-2010 13:19, David Härdeman escreveu:
>> On Thu, 11 Nov 2010 11:54:30 -0200, Mauro Carvalho Chehab
>> <mchehab@infradead.org> wrote:
>>> The bad news is that ir-kbd-i2c also needs the stuff that are inside
>>> ir.props (e. g., the IR configuration logic). I wrote and just sent 2
>>> patches to the ML with the fix patches, against my media-tree.git,
>>> branch staging/for_v2.6.38. For now, only one field
>>> of props is used, but other fields there are likely needed for the other
>>> places where this driver is used, like the open/close callbacks,
>>> allowed_protocols, etc.
>>>
>>> I don't like the idea of just copying all those config stuff into struct
>>> IR_i2c, and then at struct rc_dev,
>> 
>> Which is the way it is with or without my patch, either a struct
>> ir_dev_props or a subset of the former members of that struct are in
>> IR_i2c, same data. And right now you would need to have a mix between
>> ir_dev_props data and additional ir_dev related data in struct IR_i2c (the
>> rc map name is outside of ir_dev_props).
>> 
>> Note that the patch *removes* > 200 lines of code (without any loss of
>> functionality) - and that's because the interface is simplified. Simple is
>> good.
>> 
>>> and then at struct input_dev.
>> 
>> struct input_dev only gets input_name, input_phys and input_id from struct
>> rc_dev, and I did it that way because I didn't want to remove all that
>> information from all drivers (and fill input_dev with generic information
>> instead).
>
>input_dev fields need to be properly filled, but just duplicating the same
>info on both structs and copying from one to the other doesn't seem the better
>way. Why not just initialize rc_dev->input_dev fields directly, not duplicating
>the data (or having a helper in-lined routine) to initialize those fields?

The data is not duplicated, input_name and input_phys are passed around
as pointers.

And the reason it looks the way it does is, again, that
multiple-input-devices-per-rc-device will be broken if drivers fiddle
with the input_dev directly. Not to mention it's a layering violation to
expect rc drivers to also know about the underlying input devices.

(Yes, you could say that input_name, input_phys and input_id are
layering violations as well, but they are not an equally problematic
violation and they're a stopgap measure).

>Ok, but the point is that a driver like ir-kbd-i2c (and other I2C drivers like
>lirc-zilog - after ported to rc-core) will require several additional fields
>that are added at rc_dev (basically, all fields that are, currently, at 
>ir_dev_props structs may be needed by an i2c driver).

I don't think it's a problem. Making rc-core ir-kbd-i2c friendly is
putting the cart before the horse, ir-kbd-i2c is but one user of rc-core
(and I also doubt that you'll actually need to duplicate all members,
i2c hardware is too basic to need all bells and whistles of rc-core).

>>> It is too much data duplication for no good reason.
>> 
>> And you believe it's an important feature that props used to be a struct
>> and that you could pass a pointer (and take care of initializing rc_map)
>> instead of initializing a couple of members in rc_dev directly?
>
>Duplicating dozens of fields is not a good idea.

Duplicating dozens of fields is a perfectly good idea if the other ideas
are worse. The reason why code duplication is usually bad is that there
are several implementations of the same function, each slightly
different and some likely to be missed if new features are added to one
of them. Here the duplication only exists in headers, not in actual
code, and only comes into play if e.g. a callback function signature is
changed.

Say that the signature of a callback function in struct
ir_dev_props/rc_dev was changed in a patch.

With the struct ir_dev_props scenario, you'd need to change one line in
ir-core.h (change the function signature in struct ir_dev_props) and one
line in each and every one of 30 or so different drivers (31 lines
changed).

After my patch, you'd need to change one line in ir-core.h (change the
function signature in struct ir_dev_props) and one line in each and
every one of 30 or so different drivers + a one line change to files
like ir-kbd-i2c.h which have a duplicate definition of the callback
function (say...34 lines changed?).

Not a big deal. And in both scenarios, the compiler will warn you about
each and every necessary change.

(Talking of duplication, having every driver do an identical kzalloc(),
check if kzalloc succeeds, additional error path, and kfree() in the
unregister phase for the ir_dev_props struct is also duplication. *Some*
duplication is unavoidable).

>> The use of struct ir_dev_props was a truely bizarre interface. For
>> example: setting the props member was optional, and a ir_input_dev struct
>> without a props member lacks a driver_type submember.
>
>It were added as optional, to avoid many changes at the drivers, as a way
>to speedup drivers porting, but I think that all drivers should properly
>initialize the fields there.

It's still a bizarre interface no matter why it was originally added.

>> The new struct is much more straightforward, and your worries about
>> additional pain caused by not having a struct ir_dev_props did not
>> materialize in any of the changes I did (see for example
>> drivers/media/dvb/dvb-usb/dib0700_devices.c which had similar
>> requirements to struct IR_i2c).
>
>dvb-usb uses a large struct to device dvb devices, and, due to the
>way it were done, every single field at RC should be inititialized,
>per device. I don't like the way it is, but I didn't want to delay
>the rc_core port on it, due to some discussions about how to re-structure
>it to avoid the large amount of data duplication there. So, I just
>added the absolute minimum fields there. IMO, we should do later 
>a large cleanup on it. Yet, it is different than ir-kdb-i2c, since
>since the beginning, the complete IR code is exported on DVB drivers,
>while V4L drivers use to export just a few bits of the IR code (up
>to seven bits). So, it is not a good example.
>
>A good exercise would be to port lirc-zilog and see what happens.

I had a quick look at lirc-zilog and I doubt it would be a good
candidate to integrate with ir-kbd-i2c.c (I assume that's what you were
implying?). Which code from ir-kbd-i2c would it actually be using?

>> What's your suggestion?
>
>One idea could be to initialize rc_dev at the caller drivers, passing
>it via platform_data for the I2C drivers.

Having a subsystem mucking around in a struct embedded as part of the
platform data of a higher level driver sounds iffy. You'll never (for
example) be able to const'ify platform_data...

>Also, instead of duplicating input_dev fields, directly initialize them 
>inside the drivers, and not at rc-core.

Won't work for the reasons explained above.

>I like the idea of having an inlined function (like
>usb_fill_control_urb), to be sure that all mandatory fields are
>initialized by the drivers.

I like the idea of having a function, let's call it
rc_register_device(), which makes sure that all mandatory fields are
initialized by the drivers :)

-- 
David Härdeman
