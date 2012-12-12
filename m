Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45869 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab2LLVZP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Dec 2012 16:25:15 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so811727eek.19
        for <linux-media@vger.kernel.org>; Wed, 12 Dec 2012 13:25:14 -0800 (PST)
Message-ID: <50C8F645.60308@googlemail.com>
Date: Wed, 12 Dec 2012 22:25:25 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Matthew Gyurgyik <matthew@pyther.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50BF3F9A.3020803@iki.fi> <50BFBE39.90901@pyther.net> <50BFC445.6020305@iki.fi> <50BFCBBB.5090407@pyther.net> <50BFECEA.9060808@iki.fi> <50BFFFF6.1000204@pyther.net> <50C11301.10205@googlemail.com> <50C12302.80603@pyther.net> <50C34628.5030407@googlemail.com> <50C34A50.6000207@pyther.net> <50C35AD1.3040000@googlemail.com> <50C48891.2050903@googlemail.com> <50C4A520.6020908@pyther.net> <CAGoCfiwL3pCEr2Ys48pODXqkxrmXSntH+Tf1AwCT+MEgS-_FRw@mail.gmail.com> <50C4BA20.8060003@googlemail.com> <50C4BAFB.60304@googlemail.com> <50C4C525.6020006@googlemail.com> <50C4D011.6010700@pyther.net> <50C60220.8050908@googlemail.com> <CAGoCfizTfZVFkNvdQuuisOugM2BGipYd_75R63nnj=K7E8ULWQ@mail.gmail.com> <50C60772.2010904@googlemail.com> <CAGoCfizmchN0Lg1E=YmcoPjW3PXUsChb3JtDF20MrocvwV6+BQ@mail.gmail.com> <50C6226C.8090302@iki! .fi> <50C636E7.8060003@googlemail.com> <50C64AB0.7020407@iki.fi> <50C79CD6.4060501@googlemail.com> <50C79E9A.3050301@iki.fi>
In-Reply-To: <50C79E9A.3050301@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 11.12.2012 21:59, schrieb Antti Palosaari:
> On 12/11/2012 10:51 PM, Frank Sch�fer wrote:
>> Am 10.12.2012 21:48, schrieb Antti Palosaari:
>>> On 12/10/2012 09:24 PM, Frank Sch�fer wrote:
>>>> Am 10.12.2012 18:57, schrieb Antti Palosaari:
>>>>> On 12/10/2012 06:13 PM, Devin Heitmueller wrote:
>>>>>> On Mon, Dec 10, 2012 at 11:01 AM, Frank Sch�fer
>>>>>>> Adding a new property to the RC profile certainly seems to be the
>>>>>>> cleanest solution.
>>>>>>> Do all protocols have paritiy checking ? Otherwise we could add
>>>>>>> a new
>>>>>>> type RC_TYPE_NEC_NO_PARITY.
>>>>>>> OTOH, introducing a new bitfield in struct rc_map might be usefull
>>>>>>> for
>>>>>>> other flags, too, in the future...
>>>>>>
>>>>>> It's probably also worth mentioning that in that mode the device
>>>>>> reports four bytes, not two.  I guess perhaps if parity is
>>>>>> ignored it
>>>>>> reports the data in some other format?  You will probably have to do
>>>>>> some experimentation there.
>>
>> ...
>>
>>>>>
>>>>> Uh, current em28xx NEC implementation is locked to traditional 16 bit
>>>>> NEC, where is hw checksum used.
>>>>>
>>>>> Implementation should be changed to more general to support 24 and 32
>>>>> bit NEC too. There is multiple drivers doing already that, for
>>>>> example
>>>>> AF9015.
>>>>>
>>>>
>>>> Hmm... are there and documents (, links, books, ...) where I can learn
>>>> more about all those RC protocols ?
>>>
>>> Specification comes here:
>>> NEC send always 32 bit, 4 bytes. There is 3 different "sub" protocols:
>>>
>>> 1) 16bit NEC standard, 1 byte address code, 1 byte key code
>>> full 4 byte code: AA BB CC DD
>>> where:
>>> AA = address code
>>> BB = ~address code
>>> CC = key code
>>> DD = ~key code
>>>
>>> checksum:
>>> AA + BB = 0xff
>>> CC + DD = 0xff
>>>
>>> 2) 24bit NEC extended, 2 byte address code, 1 byte key code
>>> full 4 byte code: AA BB CC DD
>>> where:
>>> AA = address code (MSB)
>>> BB = address code (LSB)
>>> CC = key code
>>> DD = ~key code
>>>
>>> 3) 32bit NEC full, 4 byte key code
>>> full 4 byte code: AA BB CC DD
>>> where:
>>> AA =
>>> BB =
>>> CC =
>>> DD =
>>>
>>> I am not sure if there is separate parts for address and key code in
>>> case of 32bit NEC. See some existing remote keytables if there is any
>>> such table. It is very rare protocol. 1) and 2) are much more common.
>>>
>>
>> Many thanks.
>> So the problem is, that we have only a single RC_TYPE for all 3 protocol
>> variants and need a method to distinguish between them, right ?
>
> Yes, that is. I have said it "million" times I would like to see that
> implemented as a one single 4 byte NEC, but it is currently what it
> is. What I understand David H�rdeman has done some work toward that
> too, but it is not ready.
> See current af9015 driver as example how driver makes decision which
> variant of NEC is used. You will need something similar. Read all 4
> NEC bytes from the hardware and then use driver to make decision which
> variant it is.

Yes, checking for inverted address and key code bytes would be a
possibility...
OTOH it's a kind of hack and I think this issue should be fixed in th rc
core.

A possible solution would be to add three new RC_TYPEs (e.g.
RC_TYPE_NEC_STD, RC_TYPE_NEC_EXT, RC_TYPE_NEC_FULL).
RC_TYPE_NEC can be kept for compatibility but should be marked as
deprecated.

Hmmm... thinking about it for some minutes... Why the hell do we bind rc
maps to protocols ?
A key map consists of pairs of a scan code and the corresponding key
code. But that's common to all protocols, right ?
So why do we restrict a keymap to a specific protocol ?
Ok, rc_type is a bit field, so a key map can be bound to multiple protocols.
But then we can't use it to configure the hardware driver, which is
exactly out problem here...

> I am quite sure em28xx hardware supports reading all 4 bytes, but if
> not, you will need to do some other tricks.

Yes, reading 4 bytes form the hardware seems to supported.

Devin, how does it works with reg 0x50=0x01 ?
Have I understood you right that it means the 32bit NEC protocol variant
is used ?
Can the key code be read as usual from regs 0x52-0x55 ?
Any changes in reg 0x51 ?
And for that matter - what's the meaning of bit 1 in reg 0x50 ? ;)

Regards,
Frank

>
> regards
> Antti
>

