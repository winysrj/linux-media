Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:39422 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbaCaNyE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 09:54:04 -0400
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH 10/11] [RFC] rc-core: use the full 32 bits for NEC  scancodes
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Mon, 31 Mar 2014 15:54:02 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: James Hogan <james.hogan@imgtec.com>, linux-media@vger.kernel.org,
	jarod@redhat.com, sean@mess.org
In-Reply-To: <20140331101507.4f34c0ee@samsung.com>
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu>
 <20140329161136.13234.733.stgit@zeus.muc.hardeman.nu>
 <5339390B.6030709@imgtec.com> <4af025b742df648556360db390351166@hardeman.nu>
 <20140331091433.0f232179@samsung.com>
 <6b18c58fc8eef47b081583ab316bb000@hardeman.nu>
 <20140331101507.4f34c0ee@samsung.com>
Message-ID: <54e5a3e2631023ae36226333ff8f09e1@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-03-31 15:15, Mauro Carvalho Chehab wrote:
> Em Mon, 31 Mar 2014 14:58:10 +0200
> David Härdeman <david@hardeman.nu> escreveu:
>> On 2014-03-31 14:14, Mauro Carvalho Chehab wrote:
>>> The 24 or 32 bits variation is actually a violation of the NEC
>>> protocol.
>> 
>> Violation is a misnomer. NEC created the 24 bit version, it's an
>> extension. Many companies (such as your employer :)) have created
>> further variations.
> 
> I'm fine if you call it as an extension, but the original NEC _is_
> 16 bits, and most drivers are compliant with it.
> 
> We should not break what's working.

You're misrepresenting the proposed changes now.

I'm trying to fixup the scancode handling in the best way possible, I'm 
not willfully breaking anything.

Some things are inconsistent right now between the drivers, in such a 
situation when driver A says "first X then Y" and driver B says "first Y 
then X" the situation is:

a) already "broken"; and

b) can't be fixed without introducing "breakage" of a different kind to 
either A or B

>>> Well, changing the NEC decoders to always send a 32 bits code has
>>> several issues:
>>> 
>>> 1) It makes the normal NEC protocol as an exception, and not as a
>>>    rule;
>> 
>> It's not an exception. I just makes all 32 bits explicit.
> 
> Well, if all drivers but one only have 16 or 24 bits tables, this is
> an exception.

Not really. 32 bits are transmitted no matter what you call the 
protocol. I'm proposing storing those 32 bits in the scancode<->keycode 
table. Not what I'd call an exception (this particular point starts to 
feel a bit off-topic though so I think we can drop it).

>> And the lack of that explicit information currently makes the scancode
>> ambiguous. Right now if I give you a NEC scancode of 0xff00 (like we
>> give to userspace with the EV_SCAN event), you can't tell what it
>> means...it could, for example, be a 32 bit code of 0x0000ff00...

You didn't answer this part. It's actually one of the biggest reasons 
for introducing the full scancode everywhere.

>> > 2) It breaks all in-kernel tables for 16 bits and 24 bits NEC.
>> >    As already said, currently, there's just one driver using 32
>> >    bits NEC, and just for one IR type (RC_MAP_TIVO);
>> 
>> No, the proposed patch doesn't break all in-kernel tables. The 
>> in-kernel
>> tables are converted on the fly to NEC32 when loaded.
> 
> That's messy. We should either change everything in Kernelspace to
> 32 bits or keep as is.

No problem, I could respin the patch to also patch the keytables (which 
is what I did first), but I'll wait until we've agreed on something).

> If such emulation is needed, it should be only for userspace tables.
> 
>> > 3) It causes regressions to userspace, as userspace tables won't
>> >    work anymore;
>> 
>> I know it may cause troubles for userspace, however:
>> 
>> a) You've already accepted patches that change the scancode format of
>> the NEC decoder within the last few weeks so you've already set the
>> stage for the same kind of trouble (even if I agree with James on 
>> parts
>> of that patch)
> 
> If I let this pass, we should revert it before it reaches upstream.
> 
> What patch caused regressions?

18bc17448147e93f31cc9b1a83be49f1224657b2, since it changes the scancode 
it'll break userspace keytables, it's mentioned in patch 4/11 in my 
patchset.

>> b) The current code is broken as well...using the same remote will
>> generate different scancodes depending on the driver (even if the old
>> and new hardware *can* receive the full scancode), meaning that your
>> keytable will suddenly stop working if you change HW. That's bad.
> 
> On the devices I have here, it is not broken. Let's fix it where this
> is broken, and not use it as an excuse to break even more things.

Whether the hardware you happen to have agrees is beside the point?

>>> (btw, the get_key_beholdm6xx() function at saa7134 driver seems
>>> to be wrong, as the keytables for behold device has the address of
>>> this vendor mapped as 0x6b86).
>> 
>> I know, I've already identified and fixed that problem in a separate
>> patch that's posted to the list. And it will also break out-of-kernel
>> user-defined keymaps. Any inconsistency is a no-win situation. And we
>> *do* have inconsistencies right now.
> 
> Yes. That's one of the reasons why this was not fixed yet (and the 
> other
> one is that I don't have any of such device in hands, in order to be
> sure that this is not another vendor that, by coincidence, has address
> 0x6b86).

I know we can't be 100% sure, but the byte order in the driver itself 
also supports the notion that the address bytes have been reversed.

>>> The way those codes are handled inside each in-hardware NEC
>>> decoder are different. I've seen all those alternatives:
>>> 
>>> a) the full 24-bits code is received by the driver;
>>> b) some hardware will simply discard the MSB of the address;
>>> c) a few hardware will discard the entire keycode, as the
>>>    checksum bytes won't match.
>> 
>> I know there's a lot of variety, another example is drivers that 
>> discard
>> (possibly after matching address) everything but the "command" part of
>> the scancode. That should not be used as an excuse not to try to make
>> the behavior as consistent as possible. After all...that's the point 
>> of
>> a common API.
> 
> It should be consistent, and it should be able to support the existing
> hardware.

Yes, I agree, but I'm not sure what your point is? Existing hardware 
doesn't lose support with my patches?

>>> The devices from the 0x866b manufacturer is used by a wide range
>>> of devices that can do either (a) or (b).
>>> 
>>> Well, as the to_nec32() doesn't know the original keycode, it
>>> would map an address like 0x866b as 0x946b, with is wrong, and
>>> won't match the corresponding NEC table.
>> 
>> Yes, if the hardware throws away information, rc-core will sometime
>> generate a scancode which does not match the real one.
>> 
>> As you say:
>> 
>> if the actual remote control transmits: 0x866b01fe
>> and the hardware truncates it to:       0x..6b01fe
>> then rc-core would convert back to:     0x946b01fe
>> 
>> And that could be fixed with a scanmask for that driver (0xffffff)?
> 
> I think you're meaning 0x0000ffff, right?

Why 0x0000ffff?....the example I gave suggested HW which throws away one 
byte, meaning the last three bytes (0x6b01fe) remain valid?

>> (We could also expose the scanmask to userspace so it knows which part
>> of the scancode it can trust...)
> 
> Yes, we could do it, but the current userspace should keep working.
> Eventually, that means to add some backward compat code there, in order
> to preserve the behavior with current tables.

Not sure what you're suggesting?

Regards,
David

