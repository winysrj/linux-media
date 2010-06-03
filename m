Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab0FCOb1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jun 2010 10:31:27 -0400
Message-ID: <4C07BCBD.3050407@redhat.com>
Date: Thu, 03 Jun 2010 11:31:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org
Subject: Re: ir-core multi-protocol decode and mceusb
References: <AANLkTinpzNYueEczjxdjAo3IgToM42NwkHhm97oz2Koj@mail.gmail.com>	<1275136793.2260.18.camel@localhost>	<AANLkTil0U5s1UQiwiRRvvJOpEYbZwHpFG7NAkm7JJIEi@mail.gmail.com>	<1275163295.17477.143.camel@localhost>	<AANLkTilsB6zTMwJjBdRwwZChQdH5KdiOeb5jFcWvyHSu@mail.gmail.com>	<4C02700A.9040807@redhat.com>	<AANLkTimYjc0reLHV6RtGFIMFz1bbjyZiTYGj1TcacVzT@mail.gmail.com>	<AANLkTik_-6Z12G8rz0xkjbLkpWvfRHorGtD_LbsPr_11@mail.gmail.com>	<1275308142.2227.16.camel@localhost>	<4C0408A9.4040904@redhat.com>	<1275334699.2261.45.camel@localhost>	<4C042310.4090603@redhat.com>	<1275342342.2260.37.camel@localhost>	<4C0438CE.4090801@redhat.com>	<AANLkTimAjriy1hlysvlAOxMPodp_lw2MZGcLl1D5oR9h@mail.gmail.com> <AANLkTinDQF0bvaItVelPncSDTNeXfo4OxpZG9ssEJy4f@mail.gmail.com>
In-Reply-To: <AANLkTinDQF0bvaItVelPncSDTNeXfo4OxpZG9ssEJy4f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-06-2010 03:27, Jarod Wilson escreveu:
> On Tue, Jun 1, 2010 at 1:22 AM, Jarod Wilson <jarod@wilsonet.com> wrote:
>> On Mon, May 31, 2010 at 6:31 PM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>> Em 31-05-2010 18:45, Andy Walls escreveu:
>>>> On Mon, 2010-05-31 at 17:58 -0300, Mauro Carvalho Chehab wrote:
>>>
>>>>> I may be wrong (since we didn't write any TX support), but I think that a
>>>>> rc_set_tx_parameters() wouldn't be necessary, as I don't see why the driver will
>>>>> change the parameters after registering, and without any userspace request.
>>>>
>>>> Yes, my intent was to handle a user space request to change the
>>>> transmitter setup parameters to handle the protocol.
>>>>
>>>> I also don't want to worry about having to code in kernel parameter
>>>> tables for any bizzare protocol userspace may know about.
>>>
>>> Makes sense.
>>>>
>>>>
>>>>> If we consider that some userspace sysfs nodes will allow changing some parameters,
>>>>> then the better is to have a callback function call, passed via the registering function,
>>>>> that will allow calling a function inside the driver to change the TX parameters.
>>>>>
>>>>> For example, something like:
>>>>>
>>>>> struct rc_tx_props {
>>>>> ...
>>>>>      int     (*change_protocol)(...);
>>>>> ...
>>>>> };
>>>>>
>>>>>
>>>>> rc_register_tx(..., struct rc_tx_props *props)
>>>>
>>>> A callback is likely needed.  I'm not sure I would have chosen the name
>>>> change_protocol(), because transmitter parameters can be common between
>>>> protocols (at least RC-5 and RC-6 can be supported with one set of
>>>> parameters), or not match any existing in-kernel protocol.  As long as
>>>> it is flexible enough to change individual transmitter parameters
>>>> (modulated/baseband, carrier freq, duty cycle, etc.) it will be fine.
>>>
>>> I just used this name as an example, as the same name exists on RX.
>>>
>>> Depending on how we code the userspace API, we may use just one set_parameters
>>> function, or a set of per-attribute changes.
>>>
>>> In other words, if we implement severa sysfs nodes to change several parameters,
>>> maybe it makes sense to have several callbacks. Another alternative would be
>>> to have a "commit" sysfs node to apply a set of parameters at once.
>>>
>>>> Currently LIRC userspace changes Tx parameters using an ioctl().  It
>>>> asks the hardware to change transmitter parameters, because the current
>>>> model is that the transmitters don't need to know about protocols. (LIRC
>>>> userspace knows the parameters of the protocol it wants to use, so the
>>>> driver's don't have too).
>>
>> The list of transmit-related ioctls implemented in the lirc_mceusb driver:
>>
>> - LIRC_SET_TRANSMITTER_MASK -- these devices have two IR tx outputs,
>> default is to send the signal out both, but you can also select just a
>> specific one (i.e., two set top boxes, only want to send command to
>> one or the other of them).
>>
>> - LIRC_GET_SEND_MODE -- get current transmit mode
>>
>> - LIRC_SET_SEND_MODE -- set current transmit mode
>>
>> - LIRC_SET_SEND_CARRIER -- set the transmit carrier freq
>>
>> - LIRC_GET_FEATURE -- get both the send and receive capabilities of the device
>>
>>
>>>> I notice IR Rx also has a change_protocol() callback that is not
>>>> currently in use.
>>>
>>> It is used only by em28xx, where the hardware decoder can work either with
>>> RC-5 or NEC (newer chips also support RC-6, but this is currently not
>>> implemented).
>>
>> The imon driver also implements change_protocol for the current-gen
>> devices, which are capable of decoding either mce remote signals or
>> the native imon remote signals. I was originally thinking I'd need to
>> implement change_protocol for the mceusb driver, but its ultimately a
>> no-op, since the hardware doesn't give a damn (and there's a note
>> somewhere that mentions its only relevant for hardware decode devices
>> that need to be put into a specific mode). Although, on something like
>> the mceusb driver, change_protocol *could* be wired up to mark only
>> the desired protocol enabled -- which might reduce complexity for
>> ir-keytable when loading a new keymap. (I went with a rather simple
>> approach for marking only the desired decoder enabled at initial
>> keymap load time which won't help here -- patch coming tomorrow for
>> that).
>>
>>>> If sending raw pulses to userspace, it would be also
>>>> nice to expose that callback so userspace could set the receiver
>>>> parameters.
>>>
>>> Raw pulse transmission is probably the easiest case. Probably, there's nothing
>>> or a very few things that might need adjustments.
>>
>> Transmitter mask, carrier frequency and a repeat count are the things
>> I can see needing to set regularly. From experience, at least with
>> motorola set top box hardware, you need to send a given signal 2-3
>> times, not just once, for the hardware to pick it up. There's a
>> min_repeat parameter in lirc config files only used on the transmit
>> side of the house to specify how many repeats of each blasted signal
>> to send.
> 
> I keep bouncing between two machines, so I finally got smart(ish) and
> pushed a working git tree to have both push and pull from.
> 
> http://git.wilsonet.com/linux-2.6-ir-wip.git/
> 
> Just pushed 3 patches with which I can now transmit IR via an mceusb
> device. I've only added three callbacks to ir_dev_props, the rest of
> the magic is done in mceusb.c and ir-lirc-codec.c.

Nice!

> I'm still not sure
> what sort of non-lirc interface we want for transmitting IR, and we
> don't (yet) have in-kernel IR encoders...

Well, as we don't have any usecase yet, maybe we could just add the lirc
interface for now.

> I see Mauro was scrawling red ink all over the lirc_dev patch
> tonight... ;) 

:)

It was not that serious: just BKL, compat32 and postponing the definition of
the ioctls that aren't yet used.

> I'll try to reply to review comments tomorrow, I'm
> spent! (I know the compat ioctl thing sucks, but changing it breaks
> existing lirc userspace (for 32-bit users, iirc), which I'd like to
> avoid).

If we remove the compat32 stuff and define everything using __u32
instead of unsigned int, this won't break compatibility if both kernespace
and userspace are 32 bits.

The breakage will happen with a 64 bits userspace application, compiled with
the old lirc include.

A re-compilation of the application will solve the issue.

This kind of breakage is more serious where the userspace is provided as
binary only, as the user can't compile it.

I won't bother much about such breakage, since:

1) Currently, lirc is a set of out-of-tree patches. So, the official kernels
are not bound to the lirc interface;

2) After adding lirc-dev in kernel, a new version of lirc should be produced
anyway, properly documenting that lirc-dev shouldn't be compiled with the
newer kernels and eventually changing the build procedures;

3) The kernel-driver aware version of lirc can be indicated as the minimum requirement
for lirc-dev at Documentation/Changes;

4) An older version of lirc will have its own lirc-dev patches. If someone is using
it, the out-of-tree lirc-dev were already used;

5) We can add a way for newer lirc userspace apps to check for the lirc kernelspace
version. This way, we can move the compat32 stuff to userspace during a transitory
period, where people may have been using the new lirc with an older kernel;

6) With compat32 being on userspace, after a  few kernel cycles (or after being sure that
most distros had already applied the in-tree lirc-dev), this compat32 can be removed on 
userspace. As kernelspace user API's are forever, the same won't occur if we
let the patch be applied as-is.

On the other hand, keeping the additional complexity of a compat layer for a new driver
just due to a temporary need of for a transitory period doesn't seem the right thing
to do.

Cheers,
Mauro.
