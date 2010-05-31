Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab0EaWbl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 18:31:41 -0400
Message-ID: <4C0438CE.4090801@redhat.com>
Date: Mon, 31 May 2010 19:31:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Subject: Re: ir-core multi-protocol decode and mceusb
References: <AANLkTinpzNYueEczjxdjAo3IgToM42NwkHhm97oz2Koj@mail.gmail.com>	 <1275136793.2260.18.camel@localhost>	 <AANLkTil0U5s1UQiwiRRvvJOpEYbZwHpFG7NAkm7JJIEi@mail.gmail.com>	 <1275163295.17477.143.camel@localhost>	 <AANLkTilsB6zTMwJjBdRwwZChQdH5KdiOeb5jFcWvyHSu@mail.gmail.com>	 <4C02700A.9040807@redhat.com>	 <AANLkTimYjc0reLHV6RtGFIMFz1bbjyZiTYGj1TcacVzT@mail.gmail.com>	 <AANLkTik_-6Z12G8rz0xkjbLkpWvfRHorGtD_LbsPr_11@mail.gmail.com>	 <1275308142.2227.16.camel@localhost>  <4C0408A9.4040904@redhat.com>	 <1275334699.2261.45.camel@localhost>  <4C042310.4090603@redhat.com> <1275342342.2260.37.camel@localhost>
In-Reply-To: <1275342342.2260.37.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 31-05-2010 18:45, Andy Walls escreveu:
> On Mon, 2010-05-31 at 17:58 -0300, Mauro Carvalho Chehab wrote:

>> I may be wrong (since we didn't write any TX support), but I think that a
>> rc_set_tx_parameters() wouldn't be necessary, as I don't see why the driver will
>> change the parameters after registering, and without any userspace request.
> 
> Yes, my intent was to handle a user space request to change the
> transmitter setup parameters to handle the protocol.
> 
> I also don't want to worry about having to code in kernel parameter
> tables for any bizzare protocol userspace may know about.

Makes sense.
> 
> 
>> If we consider that some userspace sysfs nodes will allow changing some parameters,
>> then the better is to have a callback function call, passed via the registering function,
>> that will allow calling a function inside the driver to change the TX parameters.
>>
>> For example, something like:
>>
>> struct rc_tx_props {
>> ...
>> 	int	(*change_protocol)(...);
>> ...
>> };
>>
>>
>> rc_register_tx(..., struct rc_tx_props *props)
> 
> A callback is likely needed.  I'm not sure I would have chosen the name
> change_protocol(), because transmitter parameters can be common between
> protocols (at least RC-5 and RC-6 can be supported with one set of
> parameters), or not match any existing in-kernel protocol.  As long as
> it is flexible enough to change individual transmitter parameters
> (modulated/baseband, carrier freq, duty cycle, etc.) it will be fine.

I just used this name as an example, as the same name exists on RX.

Depending on how we code the userspace API, we may use just one set_parameters
function, or a set of per-attribute changes.

In other words, if we implement severa sysfs nodes to change several parameters,
maybe it makes sense to have several callbacks. Another alternative would be
to have a "commit" sysfs node to apply a set of parameters at once. 

> Currently LIRC userspace changes Tx parameters using an ioctl().  It
> asks the hardware to change transmitter parameters, because the current
> model is that the transmitters don't need to know about protocols. (LIRC
> userspace knows the parameters of the protocol it wants to use, so the
> driver's don't have too).
> 
> 
> I notice IR Rx also has a change_protocol() callback that is not
> currently in use.  

It is used only by em28xx, where the hardware decoder can work either with
RC-5 or NEC (newer chips also support RC-6, but this is currently not
implemented).

> If sending raw pulses to userspace, it would be also
> nice to expose that callback so userspace could set the receiver
> parameters.

Raw pulse transmission is probably the easiest case. Probably, there's nothing
or a very few things that might need adjustments.

> 
> 
> Regards,
> Andy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

