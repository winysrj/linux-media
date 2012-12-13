Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:43964 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab2LMQCI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Dec 2012 11:02:08 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so1921230lag.19
        for <linux-media@vger.kernel.org>; Thu, 13 Dec 2012 08:02:07 -0800 (PST)
Message-ID: <50C9FC0A.4020402@googlemail.com>
Date: Thu, 13 Dec 2012 17:02:18 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Matthew Gyurgyik <matthew@pyther.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50BFCBBB.5090407@pyther.net> <50BFECEA.9060808@iki.fi> <50BFFFF6.1000204@pyther.net> <50C11301.10205@googlemail.com> <50C12302.80603@pyther.net> <50C34628.5030407@googlemail.com> <50C34A50.6000207@pyther.net> <50C35AD1.3040000@googlemail.com> <50C48891.2050903@googlemail.com> <50C4A520.6020908@pyther.net> <CAGoCfiwL3pCEr2Ys48pODXqkxrmXSntH+Tf1AwCT+MEgS-_FRw@mail.gmail.com> <50C4BA20.8060003@googlemail.com> <50C4BAFB.60304@googlemail.com> <50C4C525.6020006@googlemail.com> <50C4D011.6010700@pyther.net> <50C60220.8050908@googlemail.com> <CAGoCfizTfZVFkNvdQuuisOugM2BGipYd_75R63nnj=K7E8ULWQ@mail.gmail.com> <50C60772.2010904@googlemail.com> <CAGoCfizmchN0Lg1E=YmcoPjW3PXUsChb3JtDF20MrocvwV6+BQ@mail.gmail.com> <50C6226C.8090302@iki! .fi> <50C636E7.8060003@googlemail.com> <50C64AB0.7020407@iki.fi> <50C79CD6.4060501@googlemail.com> <50C79E9A.3050301@iki.fi> <50C8F645.60308@googlemail.com> <50C8F86F.2090503@googlemail.com> <50C9EF9B.6060409@iki.fi>
In-Reply-To: <50C9EF9B.6060409@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 13.12.2012 16:09, schrieb Antti Palosaari:
> On 12/12/2012 11:34 PM, Frank Schäfer wrote:
>> Am 12.12.2012 22:25, schrieb Frank Schäfer:
>>
>> ...
>>> Am 11.12.2012 21:59, schrieb Antti Palosaari:
>>>> See current af9015 driver as example how driver makes decision which
>>>> variant of NEC is used. You will need something similar. Read all 4
>>>> NEC bytes from the hardware and then use driver to make decision which
>>>> variant it is.
>>> Yes, checking for inverted address and key code bytes would be a
>>> possibility...
>>
>> The problem here is of course, that we have to configure the device
>> first.
>> So we need to know the protocol variant before getting any bytes from
>> the device...
>
> No, you now don't see the point correctly. If you read 4 byte "full
> NEC" code from the hardware, you will not need to know which variant
> it is for configure hardware. 4 byte, full NEC, presents all the
> variants.
>
> Think it like NEC code is always 4 byte long as lower layer. All NEC
> remotes sends 4 byte codes regardless which variant. In receiver side,
> after decoding there is also 4 byte always. Variants are done very
> upper layer after decoding.
>
> Let me take some existing examples:
> ------------------
> rc-trekstor.c:    { 0x0084, KEY_0 },
> This is actually 1 byte NEC, which is device id == 0.
> 4 byte real code is: 00 ff 84 7b
> ------------------
> rc-terratec-slim-2.c:    { 0x800d, KEY_0 },
> This is normal, traditional, oldest, most common, 2 byte NEC.
> 4 byte real code is: 80 7f 0d f2
> ------------------
> rc-terratec-slim.c:    { 0x02bd09, KEY_0 },
> Extended NEC, quite common, 3 byte NEC.
> 4 byte real code is: 02 bd 09 f6
> ------------------
> rc-tivo.c:    { 0xa10c8c03, KEY_NUMERIC_0 },
> "full" NEC, 4 byte NEC.
> Not very common, but coming slowly more popular.
> 4 byte real code is: a1 0c 8c 03
>
>
> As you can see all NEC variants could be presented as 4 byte NEC. Even
> the "one byte NEC", which comes in that case (rc-trekstor.c) "00 ff 84
> 7b" as 4 byte real notation.

Sure, we always get 4 bytes from the hardware.
But there must be a difference on the hardware level, otherwise the
em2874 wouldn't use different values for reg 0x50 (and Matthew should
see messages for ALL keys).

Regards,
Frank

>
>
> regards
> Antti
>

