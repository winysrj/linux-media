Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:34262 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757736AbbEWLe1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2015 07:34:27 -0400
Received: by qgez61 with SMTP id z61so22965448qge.1
        for <linux-media@vger.kernel.org>; Sat, 23 May 2015 04:34:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5418c2397b8a8dab54bfbcfe9ed3df1d@hardeman.nu>
References: <20150519203851.GC18036@hardeman.nu>
	<CAKv9HNb=qK18mGj9dOdyqEPvABU8b8aAEmGa1s2NULC4g0KX-Q@mail.gmail.com>
	<20150520182901.GB13624@hardeman.nu>
	<CAKv9HNZdsse=ETkKpZWPN8Z+kLA_aNxpvEtr_WFGp5ZpaZ36dg@mail.gmail.com>
	<20150520204557.GB15223@hardeman.nu>
	<CAKv9HNZEQJkCE3b0OcOGg_o59aYiTwLhQ0f=ji1obcJcG7ePwA@mail.gmail.com>
	<32cae92aa099067315d1a13c7302957f@hardeman.nu>
	<CAKv9HNZ_JjCutG-V+77vu2xMEihbRrYJSr4QR+LESSdrM71+yQ@mail.gmail.com>
	<db6f383689a45d2d9b5346c41e48d535@hardeman.nu>
	<CAKv9HNY5jM-i5i420iu_kcfS2ZsnnMjdED59fxkxH5e5mjYe=Q@mail.gmail.com>
	<20150521194034.GB19532@hardeman.nu>
	<CAKv9HNbsCK_1XbYMgO3Monui9JnHc7knJL3yon9FUMJ_MCLppg@mail.gmail.com>
	<5418c2397b8a8dab54bfbcfe9ed3df1d@hardeman.nu>
Date: Sat, 23 May 2015 14:34:26 +0300
Message-ID: <CAKv9HNbGAta3BDSk=xjsviUuqMP7TBGtf4PhdfNn8B7N-Gz_dg@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] rc: rc-ir-raw: Add scancode encoder callback
From: =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>
To: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	James Hogan <james@albanarts.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22 May 2015 at 13:33, David Härdeman <david@hardeman.nu> wrote:
> On 2015-05-22 07:27, Antti Seppälä wrote:
>>
>> On 21 May 2015 at 22:40, David Härdeman <david@hardeman.nu> wrote:
>>>
>>> On Thu, May 21, 2015 at 05:22:08PM +0300, Antti Seppälä wrote:
>>>>
>>>> On 21 May 2015 at 15:30, David Härdeman <david@hardeman.nu> wrote:
>>>>>
>>>>> On 2015-05-21 13:51, Antti Seppälä wrote:
>>>>>>
>>>>>>
>>>>>> On 21 May 2015 at 12:14, David Härdeman <david@hardeman.nu> wrote:
>>>>>>>
>>>>>>>
>>>>>>> I'm talking about ir_raw_encode_scancode() which is entirely broken
>>>>>>> in
>>>>>>> its
>>>>>>> current state. It will, given more than one enabled protocol, encode
>>>>>>> a
>>>>>>> scancode to pulse/space events according to the rules of a randomly
>>>>>>> chosen
>>>>>>> protocol. That random selection will be influenced by things like
>>>>>>> *module
>>>>>>> load order* (independent of the separate fact that passing multiple
>>>>>>> protocols to it is completely bogus in the first place).
>>>>>>>
>>>>>>> To be clear: the same scancode may be encoded differently depending
>>>>>>> on if
>>>>>>> you've load the nec decoder before or after the rc5 decoder! That
>>>>>>> kind of
>>>>>>> behavior can't go into a release kernel (Mauro...).
>>>>>>>
>>>>>>
>>>>>> So... if the ir_raw_handler_list is sorted to eliminate the randomness
>>>>>> caused by module load ordering you will be happy (or happier)?
>>>>>
>>>>>
>>>>>
>>>>> No, cause it's a horrible hack. And the caller of ir_raw_handler_list()
>>>>> still has no idea of knowing (given more than one protocol) which
>>>>> protocol a
>>>>> given scancode will be encoded according to.
>>>>>
>>>>
>>>> Okay, so how about "demuxing" the first protocol before handing them
>>>> to encoder callback? Simply something like below:
>>>>
>>>> -               if (handler->protocols & protocols && handler->encode) {
>>>> +               if (handler->protocols & ffs(protocols) &&
>>>> handler->encode) {
>>>>
>>>> Now the behavior is well-defined even when multiple protocols are
>>>> selected.
>>>
>>>
>>> Your patchset introduced ir_raw_encode_scancode() as well as the only
>>> two callers of that function:
>>>
>>> drivers/media/rc/nuvoton-cir.c
>>> drivers/media/rc/rc-loopback.c
>>>
>>> I realize that the sysfs wakeup_protocols file (which bakes several
>>> protocols into one label) makes defining *the* protocol difficult, but
>>> if you're going to add hacks like this, keep them to the sole driver
>>> using the API rather than the core API itself.
>>>
>>> That is, change nvt_ir_raw_change_wakeup_protocol() so that it picks a
>>> single protocol, no matter how many are passed to it (the img-ir driver
>>> already sets a precedent here so it wouldn't be an API change to change
>>> to a set of protocols which might be different than what the user
>>> suggested). (Also...yes, that'll make supporting several versions of
>>> e.g. RC6 impossible with the current sysfs code).
>>>
>>
>> I think that approach too is far from perfect as it leaves us with
>> questions such as: How do we let the user know what variant of
>> protocol the label "rc-6" really means? If in nvt we hardcode it to
>> mean RC6-0-16 and a new driver cames along which chooses
>> RC_TYPE_RC6_6A_24 how do we tell the user that the implementations
>> differ? What if the scancode that was fed was really RC_TYPE_RC6_MCE?
>
>
> I never claimed it was perfect.
>
> For another (short-term, per-driver) solution, see the winbond-cir driver.
>

Heh, funny you should mention that... Back in late 2013/early 2014 I
submitted a patch for nuvoton which was modeled after winbond-cir. The
feedback from that could be summarized as:
 - Scancodes should be used instead of raw pulse/spaces (the initial
version of the patch worked without encoding)
 - Encoders should be generalized for others to use them too
 - Sysfs -api should be used instead of module parameters

So the suggestions were a pretty much the exact opposite of what
winbond-cir does.

>> If only there were a sysfs api to set the exact variant life would be
>> simpler...
>
>
> Yes, and your patches made it harder to get to a sane solution.
>
>>> Then change both ir_raw_encode_scancode() to take a single protocol enum
>>> and change the *encode function pointer in struct ir_raw_handler to also
>>> take a single protocol enum.
>>>
>>> That way encoders won't have to guess (using scanmasks...!?) what
>>> protocol they should encode to.
>>>
>>> And Mauro...I strongly suggest you revert all of this encoding stuff
>>> until this has been fixed...it's broken.
>>>
>>
>> Let me shortly recap the points made so far about the encoding stuff:
>>
>> * If user enables multiple wakeup_protocols then the first matching
>> one will be used to do the encoding. "First" being the module that was
>> loaded first.
>
>
> That in itself would be a good enough reason to revert the patches.
>
>> * Currently the encoders use heuristics to determine the intended
>> protocol variant from the scancode that was fed and from the length of
>> the scanmask. This causes the programmer using the encoder to not know
>> which exact variant will be used (until after the encoding is done
>> when the information can be made available if needed).
>
>
> First, "currently" implies that the heuristics can later be changed. They
> can't once this becomes part of a released kernel (not without breaking the
> kernel API).
>
> Second, how do you plan to pass the information about the chosen protocol
> back to userspace? And what is userspace supposed to do with the
> information?

I don't plan to pass that information anywhere because there is no use
case for it. Anyways that is besides the point.

> * Userspace: please set the hardware to wake up if this RC6 mode0 command is
> received
> * Kernel: sure...I've set the hardware to wake up if a RC6 mode6a command is
> received
> * Userspace: WTF?
>
> Is the next step to go buy a new remote which matches what the kernel told
> you?
>
> Third, that the scanmask is suddenly used to determine the meaning of a
> scancode is in itself an API break.
>
> Fourth, the "programmer" is not the problem. The problem is the user(space).
> A user who writes e.g. a RC6-something wakeup scancode has no way of knowing
> according to which protocol the scancode will be interpreted. Meaning that
> even if:
>
> * the user knows he has a remote control in his hand which generates RC6
> mode0 commands; and
> * he limits the wake protocols to "rc6"; and
> * he writes the correct scancode to sysfs
>
> then he still can't know that the hardware is correctly configured. And that
> might change depending on things like scanmask heuristics, module load order
> and the phase of the moon.
>
>> The way current
>> sysfs api works using heuristics was a design choice since we don't
>> have a better way to specify the protocol variant.
>>
>> Hope I didn't miss anything?
>
>
> You missed that once this goes in the API is going to be next to impossible
> to fix.
>
>> So yeah.. The code isn't "broken" in a sense that it wouldn't work.
>
>
> It's entirely broken in the sense that a user has no idea of knowing if the
> hardware has been properly configured to wake the computer or not. It's just
> as broken as the connect() system call would be if it randomly rewrote the
> destination address passed by the user, optionally connected, and most of
> the time returned zero independently of the result.
>

I think you may be misunderstanding the sysfs api or at least the
connect() analogue here as well as the userspace-kernelspace example
above are actually not how the api works. Remember that userspace does
not know about the protocol variants.
Let me try to use your example and work-out how it really goes:
* Userspace: please set the hardware to wake up if the scancode
0x800f040c is received. I know this is RC6 scancode because it came
from the rc-6 decoder but I don't know the variant (and I don't really
care)
* Kernel: Ok (btw. based on the length of the scancode and the
bit-pattern in the front I've determined this to be rc6-mce type
scancode and encoded it accordingly)
* Userspace: Got it

So no changing anything behind users back or not leading to
misconfigured hardware AFAICT.

> I can't really believe we're still debating *if* this code should stay in
> it's present form.
>

Of course we end up having a discussion when it looks like we
undestand the code/api behavior differently and my goal is obviously
to know what/how/where/when the code is "broken" to determine if it is
true and if it can be fixed :)

>> It's more a question of what we want the api to look like.
>
>
> And if the current version is part of a released kernel we can never fix it.
>
> Look, there are fundamental issues right now in rc-core in that the only way
> a scancode can have any meaning is in a protocol-scancode tuple (single
> protocol, of course) and that information is missing in many places. That's
> something I'm trying to fix (see the updated set/get keytable ioctls for
> example) and Mauro seems to mostly want to forget about. Fixing it is
> probably going to be impossible without API breaks. Your code encodes more
> of that crap right in the core of rc-core and will require even more API
> breaks.
>

I'm sorry that the encoding functionality clashes with your intentions
of improving the rc-core. I guess Mauro likes encoders more than
improving rc-core fundamentals :)
Kidding aside the fact that this series got merged might suggest that
you and Mauro don't necessarily share the same views about the future
and possible api breaks of rc-core.

Tell you what, I'll agree to reverting the series. In exchange I would
hope that you and Mauro mutually agree and let me know on:
 - What are the issues that need to be fixed in the encoding series
prefarably with how to fix them (e.g. module load order ambiquity,
whether a new api is needed, or switching to a more limited
functionality is desired like you suggested then so be it etc.)
 - When is a good chance to re-submit the series (e.g. after
ioctl/scancode/whatever api break is done or some pending series is
merged or some other core refactoring work is finished etc.)

Deal?

-- 
Antti
