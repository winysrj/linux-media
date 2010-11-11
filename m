Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45995 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab0KKXkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Nov 2010 18:40:43 -0500
Received: by yxt33 with SMTP id 33so88842yxt.19
        for <linux-media@vger.kernel.org>; Thu, 11 Nov 2010 15:40:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101111203501.GA8276@hardeman.nu>
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
	<20101111203501.GA8276@hardeman.nu>
Date: Thu, 11 Nov 2010 18:40:42 -0500
Message-ID: <AANLkTinjBOdnYfs=+HVxjaurbwEA33U2YwE0=bdz_Zto@mail.gmail.com>
Subject: Re: [PATCH 0/6] rc-core: ir-core to rc-core conversion
From: Jarod Wilson <jarod@wilsonet.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Nov 11, 2010 at 3:35 PM, David Härdeman <david@hardeman.nu> wrote:
> On Thu, Nov 11, 2010 at 02:00:38PM -0200, Mauro Carvalho Chehab wrote:
...
>>> struct input_dev only gets input_name, input_phys and input_id from struct
>>> rc_dev, and I did it that way because I didn't want to remove all that
>>> information from all drivers (and fill input_dev with generic information
>>> instead).
>>
>>input_dev fields need to be properly filled, but just duplicating the same
>>info on both structs and copying from one to the other doesn't seem the better
>>way. Why not just initialize rc_dev->input_dev fields directly, not duplicating
>>the data (or having a helper in-lined routine) to initialize those fields?
>
> The data is not duplicated, input_name and input_phys are passed around
> as pointers.
>
> And the reason it looks the way it does is, again, that
> multiple-input-devices-per-rc-device will be broken if drivers fiddle
> with the input_dev directly. Not to mention it's a layering violation to
> expect rc drivers to also know about the underlying input devices.
>
> (Yes, you could say that input_name, input_phys and input_id are
> layering violations as well, but they are not an equally problematic
> violation and they're a stopgap measure).
>
>>Ok, but the point is that a driver like ir-kbd-i2c (and other I2C drivers like
>>lirc-zilog - after ported to rc-core) will require several additional fields
>>that are added at rc_dev (basically, all fields that are, currently, at
>>ir_dev_props structs may be needed by an i2c driver).
>
> I don't think it's a problem. Making rc-core ir-kbd-i2c friendly is
> putting the cart before the horse, ir-kbd-i2c is but one user of rc-core
> (and I also doubt that you'll actually need to duplicate all members,
> i2c hardware is too basic to need all bells and whistles of rc-core).

And just for the record, lirc_zilog probably needs a fairly massive
overhaul, so I'd definitely not worry about it *too* much...

>>> The new struct is much more straightforward, and your worries about
>>> additional pain caused by not having a struct ir_dev_props did not
>>> materialize in any of the changes I did (see for example
>>> drivers/media/dvb/dvb-usb/dib0700_devices.c which had similar
>>> requirements to struct IR_i2c).
>>
>>dvb-usb uses a large struct to device dvb devices, and, due to the
>>way it were done, every single field at RC should be inititialized,
>>per device. I don't like the way it is, but I didn't want to delay
>>the rc_core port on it, due to some discussions about how to re-structure
>>it to avoid the large amount of data duplication there. So, I just
>>added the absolute minimum fields there. IMO, we should do later
>>a large cleanup on it. Yet, it is different than ir-kdb-i2c, since
>>since the beginning, the complete IR code is exported on DVB drivers,
>>while V4L drivers use to export just a few bits of the IR code (up
>>to seven bits). So, it is not a good example.
>>
>>A good exercise would be to port lirc-zilog and see what happens.
>
> I had a quick look at lirc-zilog and I doubt it would be a good
> candidate to integrate with ir-kbd-i2c.c (I assume that's what you were
> implying?). Which code from ir-kbd-i2c would it actually be using?

On the receive side, lirc_zilog was pretty similar to lirc_i2c, which
we dropped entirely, as ir-kbd-i2c handles receive just fine for all
the relevant rx-only devices lirc_i2c worked with. So in theory,
ir-kbd-i2c might want to just grow tx support, but I think I'm more
inclined to make it a new stand-alone rx and tx capable driver.

>>> What's your suggestion?
>>
>>One idea could be to initialize rc_dev at the caller drivers, passing
>>it via platform_data for the I2C drivers.
>
> Having a subsystem mucking around in a struct embedded as part of the
> platform data of a higher level driver sounds iffy. You'll never (for
> example) be able to const'ify platform_data...
>
>>Also, instead of duplicating input_dev fields, directly initialize them
>>inside the drivers, and not at rc-core.
>
> Won't work for the reasons explained above.
>
>>I like the idea of having an inlined function (like
>>usb_fill_control_urb), to be sure that all mandatory fields are
>>initialized by the drivers.
>
> I like the idea of having a function, let's call it
> rc_register_device(), which makes sure that all mandatory fields are
> initialized by the drivers :)

rc_register_device(rc, name, phys, id); to further prevent duplicate
struct members? :)

I still really like this interface change, even if its going to cause
short-term issues for i2c devices. I think we just extend this as
needed to handle the i2c bits. That said, I haven't really looked all
that closely at how much that entails...

-- 
Jarod Wilson
jarod@wilsonet.com
