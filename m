Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:34138 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbbFMXtQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Jun 2015 19:49:16 -0400
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH 1/2] rc-core: use the full 32 bits for NEC scancodes
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Sun, 14 Jun 2015 01:49:15 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20150520202411.GA15223@hardeman.nu>
References: <20150406112204.23209.27664.stgit@zeus.muc.hardeman.nu>
 <20150406112308.23209.85627.stgit@zeus.muc.hardeman.nu>
 <20150514175739.45ee6fd7@recife.lan> <20150520202411.GA15223@hardeman.nu>
Message-ID: <85c7ca29abcc18a8e5fbefb4838e21ab@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2015-05-20 22:24, David Härdeman wrote:
> On Thu, May 14, 2015 at 05:57:39PM -0300, Mauro Carvalho Chehab wrote:
>> Em Mon, 06 Apr 2015 13:23:08 +0200
>> David Härdeman <david@hardeman.nu> escreveu:
....
>>> +static inline enum rc_type guess_protocol(struct rc_dev *rdev)
>>> +{
>>> +	struct rc_map *rc_map = &rdev->rc_map;
>>> +
>>> +	if (hweight64(rdev->enabled_protocols) == 1)
>>> +		return rc_bitmap_to_type(rdev->enabled_protocols);
>>> +	else if (hweight64(rdev->allowed_protocols) == 1)
>>> +		return rc_bitmap_to_type(rdev->allowed_protocols);
>>> +	else
>>> +		return rc_map->rc_type;
>>> +}
> 
> ^^^^
> This function is the most important one to understand in order to
> understand how the heuristics work...
> 
>>> +
>>> +/**
>>> + * to_nec32() - helper function to try to convert misc NEC scancodes 
>>> to NEC32
>>> + * @orig:	original scancode
>>> + * @return:	NEC32 scancode
>>> + *
>>> + * This helper routine is used to provide backwards compatibility.
>>> + */
>>> +static u64 to_nec32(u64 orig)
>>> +{
>>> +	u8 b3 = (u8)(orig >> 16);
>>> +	u8 b2 = (u8)(orig >>  8);
>>> +	u8 b1 = (u8)(orig >>  0);
>>> +
>>> +	if (orig <= 0xffff)
>>> +		/* Plain old NEC */
>>> +		return b2 << 24 | ((u8)~b2) << 16 |  b1 << 8 | ((u8)~b1);
>>> +	else if (orig <= 0xffffff)
>>> +		/* NEC extended */
>>> +		return b3 << 24 | b2 << 16 |  b1 << 8 | ((u8)~b1);
>>> +	else
>>> +		/* NEC32 */
>>> +		return orig;
>>> +}
>>> +
>>> +/**
>>>   * ir_setkeycode() - set a keycode in the scancode->keycode table
>>>   * @idev:	the struct input_dev device descriptor
>>>   * @scancode:	the desired scancode
>>> @@ -349,6 +392,9 @@ static int ir_setkeycode(struct input_dev *idev,
>>>  		if (retval)
>>>  			goto out;
>>> 
>>> +		if (guess_protocol(rdev) == 0
>>> +			scancode = to_nec32(scancode);
>> 
>> This function can be called from userspace. I can't see how this would 
>> do
>> the right thing if more than one protocol is enabled.
>> 
>>> +
>>>  		index = ir_establish_scancode(rdev, rc_map, scancode, true);
>>>  		if (index >= rc_map->len) {
>>>  			retval = -ENOMEM;
>>> @@ -389,7 +435,10 @@ static int ir_setkeytable(struct rc_dev *dev,
>>> 
>>>  	for (i = 0; i < from->size; i++) {
>>>  		index = ir_establish_scancode(dev, rc_map,
>>> -					      from->scan[i].scancode, false);
>>> +					      from->rc_type == RC_TYPE_NEC ?
>>> +					      to_nec32(from->scan[i].scancode) :
>>> +					      from->scan[i].scancode,
>>> +					      false);
>>>  		if (index >= rc_map->len) {
>>>  			rc = -ENOMEM;
>>>  			break;
>>> @@ -463,6 +512,8 @@ static int ir_getkeycode(struct input_dev *idev,
>>>  		if (retval)
>>>  			goto out;
>>> 
>>> +		if (guess_protocol(rdev) == RC_TYPE_NEC)
>>> +			scancode = to_nec32(scancode);
>> 
>> This also can be called from userspace. It should not return different
>> scancodes for the same mapping if just NEC is enabled or if more 
>> protocols
>> are enabled.
> 
> There is no way to do this in a 100% backwards compatible way, that's
> why the patch description uses the word "heuristics".
> 
> I've tried different approaches (such as introducing and using a
> kernel-internal RC_TYPE_ANY protocol for legacy ioctl() calls) but none
> of them solve the problem 100%.
> 
> The current API is also broken, but in a different way. If you set a
> scancode <-> keycode mapping right now using the current ioctl()s, you
> can get different results with the exact same mapping but with 
> different
> RX hardware (which defeats the whole idea of having a kernel API for
> remote controls...) even though there is enough information to do the
> right thing (one example is already given in the patch comments)...that
> is BAD.
> 
> The heuristics can also get it wrong...in slightly different situations
> (e.g. if you load a hardware driver that supports nec and rc-5, but has
> a rc-5 default keymap, then enable both nec and rc-5 from userspace, 
> and
> finally set keymap entries using nec scancodes...in which case they'll
> be interpreted as rc-5 keymap scancodes).
> 
> So, we trade one kind of breakage for another...but the alternative 
> kind
> that I'm proposing here at least paves the way for the updated ioctls
> which solve the ambiguity.
> 
> And distributions can make sure to ship updated userspace tools 
> together
> with an updated kernel (configuration tool updates together with kernel
> updates is one of those "special" cases that e.g. LWN covers every now
> and then).
> 
> I'm not saying the situation is ideal. But at least I'm trying to fix 
> it
> once and for all.
> 
> Do you have a better solution in mind other than to simply keep 
> throwing
> away all protocol information and ignoring scancode overlaps and
> inconsistencies?

It wasn't a rhetorical question...this is an issue that needs to be 
fixed one way or another...do you have a better solution in mind?


