Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:42084 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab0KLMDN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 07:03:13 -0500
Date: Fri, 12 Nov 2010 13:03:08 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 0/6] rc-core: ir-core to rc-core conversion
Message-ID: <20101112120308.GA14033@hardeman.nu>
References: <33c8487ce0141587f695d9719289467e@hardeman.nu>
 <4CDA94C6.2010506@infradead.org>
 <0bda4af059880eb492d921728997958c@hardeman.nu>
 <4CDAC730.4060303@infradead.org>
 <20101110220115.GA7302@hardeman.nu>
 <4CDBF596.6030206@infradead.org>
 <02f13638ea24016b5b3673b50940a91c@hardeman.nu>
 <4CDC1326.3030502@infradead.org>
 <20101111203501.GA8276@hardeman.nu>
 <AANLkTinjBOdnYfs=+HVxjaurbwEA33U2YwE0=bdz_Zto@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinjBOdnYfs=+HVxjaurbwEA33U2YwE0=bdz_Zto@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Nov 11, 2010 at 06:40:42PM -0500, Jarod Wilson wrote:
>On Thu, Nov 11, 2010 at 3:35 PM, David Härdeman <david@hardeman.nu> wrote:
>> On Thu, Nov 11, 2010 at 02:00:38PM -0200, Mauro Carvalho Chehab wrote:
>>>I like the idea of having an inlined function (like
>>>usb_fill_control_urb), to be sure that all mandatory fields are
>>>initialized by the drivers.
>>
>> I like the idea of having a function, let's call it
>> rc_register_device(), which makes sure that all mandatory fields are
>> initialized by the drivers :)
>
>rc_register_device(rc, name, phys, id); to further prevent duplicate
>struct members? :)

As I said before, that won't work with multiple input devices per rc
dev. And it's a poorly designed API (IMHO) which expects you to set a
few properties in a struct and then add a few more via a function call.

Notes wrt. a future multi-input support:

First, realize that the name/phys/id of an input device is primarily
used to distinguish them from each other in user-space. Which means
having a shared name/phys/id triplet for all input devices belonging to
one rc device only makes them pointless.

So, I think we'll want something similar to name/phys/id, but for the rc
device (can be exported via sysfs). Input name/phys/id can then be
derived from the rc device for each input subdev (or name could perhaps
be set to some user-friendly description of the actual remote control by
whichever user-space tool loads the corresponding keymap).

Example:
rc_dev->name = "FooBar IR-Masta 2000"
rc_dev->phys = "PNP0BAR/rc0"
(would be available from /sys/class/rc/rc0/{name|phys})

/* Not set by the driver, available with lsinput */
rc_dev->input_devs[0]->name = "FooBar IR-Masta 2000 Remote 1"
rc_dev->input_devs[0]->phys = "PNP0BAR/rc0/input0"
rc_dev->input_devs[0]->id.bustype = BUS_RC;
rc_dev->input_devs[1]->name = "FooBar IR-Masta 2000 Remote 2"
rc_dev->input_devs[1]->phys = "PNP0BAR/rc0/input1"
rc_dev->input_devs[1]->id.bustype = BUS_RC;

(Just an example, don't overanalyse the details)

As you see, the rc_dev->input_name/phys/id is just a stopgap measure for
now, and I certainly don't think future development will be helped by
moving any input related fields up to the rc_register_device() level
when they should instead go further "down".

>I still really like this interface change, even if its going to cause
>short-term issues for i2c devices. I think we just extend this as
>needed to handle the i2c bits.

Agreed.

-- 
David Härdeman
