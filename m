Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:53450 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139AbbEUTkh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 15:40:37 -0400
Date: Thu, 21 May 2015 21:40:34 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Antti =?iso-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	James Hogan <james@albanarts.com>
Subject: Re: [PATCH v3 1/7] rc: rc-ir-raw: Add scancode encoder callback
Message-ID: <20150521194034.GB19532@hardeman.nu>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKv9HNY5jM-i5i420iu_kcfS2ZsnnMjdED59fxkxH5e5mjYe=Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 21, 2015 at 05:22:08PM +0300, Antti Seppälä wrote:
>On 21 May 2015 at 15:30, David Härdeman <david@hardeman.nu> wrote:
>> On 2015-05-21 13:51, Antti Seppälä wrote:
>>>
>>> On 21 May 2015 at 12:14, David Härdeman <david@hardeman.nu> wrote:
>>>>
>>>> I'm talking about ir_raw_encode_scancode() which is entirely broken in
>>>> its
>>>> current state. It will, given more than one enabled protocol, encode a
>>>> scancode to pulse/space events according to the rules of a randomly
>>>> chosen
>>>> protocol. That random selection will be influenced by things like *module
>>>> load order* (independent of the separate fact that passing multiple
>>>> protocols to it is completely bogus in the first place).
>>>>
>>>> To be clear: the same scancode may be encoded differently depending on if
>>>> you've load the nec decoder before or after the rc5 decoder! That kind of
>>>> behavior can't go into a release kernel (Mauro...).
>>>>
>>>
>>> So... if the ir_raw_handler_list is sorted to eliminate the randomness
>>> caused by module load ordering you will be happy (or happier)?
>>
>>
>> No, cause it's a horrible hack. And the caller of ir_raw_handler_list()
>> still has no idea of knowing (given more than one protocol) which protocol a
>> given scancode will be encoded according to.
>>
>
>Okay, so how about "demuxing" the first protocol before handing them
>to encoder callback? Simply something like below:
>
>-               if (handler->protocols & protocols && handler->encode) {
>+               if (handler->protocols & ffs(protocols) && handler->encode) {
>
>Now the behavior is well-defined even when multiple protocols are selected.

Your patchset introduced ir_raw_encode_scancode() as well as the only
two callers of that function:

drivers/media/rc/nuvoton-cir.c
drivers/media/rc/rc-loopback.c

I realize that the sysfs wakeup_protocols file (which bakes several
protocols into one label) makes defining *the* protocol difficult, but
if you're going to add hacks like this, keep them to the sole driver
using the API rather than the core API itself.

That is, change nvt_ir_raw_change_wakeup_protocol() so that it picks a
single protocol, no matter how many are passed to it (the img-ir driver
already sets a precedent here so it wouldn't be an API change to change
to a set of protocols which might be different than what the user
suggested). (Also...yes, that'll make supporting several versions of
e.g. RC6 impossible with the current sysfs code).

Then change both ir_raw_encode_scancode() to take a single protocol enum
and change the *encode function pointer in struct ir_raw_handler to also
take a single protocol enum.

That way encoders won't have to guess (using scanmasks...!?) what
protocol they should encode to.

And Mauro...I strongly suggest you revert all of this encoding stuff
until this has been fixed...it's broken.

>>
>> Useful how?
>
>Keeping dynamically filled lists sorted is a good practice if one
>wishes to achieve determinism in behavior (like running decoders
>always in certain order too).

That's a new "good practice" to me...

-- 
David Härdeman
