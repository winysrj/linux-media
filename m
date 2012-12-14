Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56483 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab2LNPdX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 10:33:23 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so2929141lbb.19
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2012 07:33:22 -0800 (PST)
Message-ID: <50CB46CE.60407@googlemail.com>
Date: Fri, 14 Dec 2012 16:33:34 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Antti Palosaari <crope@iki.fi>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Matthew Gyurgyik <matthew@pyther.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50BFBE39.90901@pyther.net> <50BFC445.6020305@iki.fi> <50BFCBBB.5090407@pyther.net> <50BFECEA.9060808@iki.fi> <50BFFFF6.1000204@pyther.net> <50C11301.10205@googlemail.com> <50C12302.80603@pyther.net> <50C34628.5030407@googlemail.com> <50C34A50.6000207@pyther.net> <50C35AD1.3040000@googlemail.com> <50C48891.2050903@googlemail.com> <50C4A520.6020908@pyther.net> <CAGoCfiwL3pCEr2Ys48pODXqkxrmXSntH+Tf1AwCT+MEgS-_FRw@mail.gmail.com> <50C4BA20.8060003@googlemail.com> <50C4BAFB.60304@googlemail.com> <50C4C525.6020006@googlemail.com> <50C4D011.6010700@pyther.net> <50C60220.8050908@googlemail.com> <CAGoCfizTfZVFkNvdQuuisOugM2BGipYd_75R63nnj=K7E8ULWQ@mail.gmail.com> <50C60772.2010904@googlemail.com> <CAGoCfizmchN0Lg1E=YmcoPjW3PXUsChb3JtDF20MrocvwV6+BQ@mail.gmail.com> <50C6226C.8090302@iki! .fi> <50C636E7.8060003@googlemail.com> <50C64AB0.7020407@iki.fi> <50C79CD6.4060501@googlemail.com> <50C79E9A.3050301@iki.fi> <20121213182336.2cca9da6@redhat.com>
In-Reply-To: <20121213182336.2cca9da6@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 13.12.2012 21:23, schrieb Mauro Carvalho Chehab:
> Em Tue, 11 Dec 2012 22:59:06 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> On 12/11/2012 10:51 PM, Frank Schäfer wrote:
>>> Am 10.12.2012 21:48, schrieb Antti Palosaari:
>>>> On 12/10/2012 09:24 PM, Frank Schäfer wrote:
>>>>> Am 10.12.2012 18:57, schrieb Antti Palosaari:
>>>>> Specification comes here:
>>>>> NEC send always 32 bit, 4 bytes. There is 3 different "sub" protocols:
>>>>>
>>>>> 1) 16bit NEC standard, 1 byte address code, 1 byte key code
>>>>> full 4 byte code: AA BB CC DD
>>>>> where:
>>>>> AA = address code
>>>>> BB = ~address code
>>>>> CC = key code
>>>>> DD = ~key code
>>>>>
>>>>> checksum:
>>>>> AA + BB = 0xff
>>>>> CC + DD = 0xff
>>>>>
>>>>> 2) 24bit NEC extended, 2 byte address code, 1 byte key code
>>>>> full 4 byte code: AA BB CC DD
>>>>> where:
>>>>> AA = address code (MSB)
>>>>> BB = address code (LSB)
>>>>> CC = key code
>>>>> DD = ~key code
>>>>>
>>>>> 3) 32bit NEC full, 4 byte key code
>>>>> full 4 byte code: AA BB CC DD
>>>>> where:
>>>>> AA =
>>>>> BB =
>>>>> CC =
>>>>> DD =
>>>>>
>>>>> I am not sure if there is separate parts for address and key code in
>>>>> case of 32bit NEC. See some existing remote keytables if there is any
>>>>> such table. It is very rare protocol. 1) and 2) are much more common.
>>>>>
>>> Many thanks.
>>> So the problem is, that we have only a single RC_TYPE for all 3 protocol
>>> variants and need a method to distinguish between them, right ?
> This is not actually needed, as it is very easy to distinguish them when
> doing the table lookups. Take a look at v4l-utils, at /utils/keytable/rc_keymaps:
>
> A 16-bits NEC table:
> 	# table kworld_315u, type: NEC
> 	0x6143 KEY_POWER
> 	0x6101 KEY_VIDEO
> 	...

So 0x6143 is not the same as 0x006143 and 0x00006143 ???

And even when assuming that 00 bytes are unused: do you really think the
driver should parse the whole rc map and check all scancodes to find out
which sub-protocol is used ?


> A 24-bits NEC table:
> 	# table pixelview_002t, type: NEC
> 	0x866b13 KEY_MUTE
> 	0x866b12 KEY_POWER2
> 	...
>
> A 32-bits NEC table:
> 	# table tivo, type: NEC
> 	0xa10c900f KEY_MEDIA
> 	0xa10c0807 KEY_POWER2
> 	...
>
> If you see there, there's no way for the Kernel to handle it wrong, as
> there's an implicit rule when dealing with "extended NEC" protocols:
>
> Being the IR code being given by: AA BB CC DD
>
> On a 24-bit NEC table: AA is always different than ~BB, otherwise, it would
> be a 16-bit NEC.

No, if AA != ~BB it can't be 16 bit, but if AA == ~BB, it can still be
16, 24 or 32bit !

> On a 32-bit NEC table: CC is always different than ~DD, otherwise, it would be
> a 24-bit NEC.

Right, if CC != ~DD it must be 32 bit.


So what if we get 52 AD 76 89 from the hardware ? This can be 32, 24 or
16 bit !


Anyway, first we have to GET the bytes from the hardware. That's our
current problem !
And the hardware seems to need a different setup for reg 0x50 for the
different NEC sub protocols.
Which means that the we need to know the sub protocol BEFORE we get any
bytes from the device.

Regards,
Frank


