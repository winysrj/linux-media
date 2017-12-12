Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f173.google.com ([74.125.82.173]:46816 "EHLO
        mail-ot0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751542AbdLLOVs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 09:21:48 -0500
MIME-Version: 1.0
In-Reply-To: <20171212104530.46ac4ffe@vento.lan>
References: <20171211120612.3775893-1-arnd@arndb.de> <1513020868.3036.0.camel@perches.com>
 <CAOcJUbyARps1CeRFvLau3w-rBvn2QLbsY2PHGymbpUyuFCJ2HA@mail.gmail.com>
 <CAK8P3a01sOsWSw4t-x6rv+9pzbfhZtEMc6iwV54Xq-48h6CN=Q@mail.gmail.com>
 <1513078952.3036.36.camel@perches.com> <20171212104530.46ac4ffe@vento.lan>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 12 Dec 2017 15:21:47 +0100
Message-ID: <CAK8P3a2=FG-cO5G0S5xssrEcX-rmem2xS-SDsaLOGfYmcHWGBQ@mail.gmail.com>
Subject: Re: [PATCH] tuners: tda8290: reduce stack usage with kasan
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Joe Perches <joe@perches.com>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 12, 2017 at 1:45 PM, Mauro Carvalho Chehab
<mchehab@kernel.org> wrote:
> Em Tue, 12 Dec 2017 03:42:32 -0800
> Joe Perches <joe@perches.com> escreveu:
>
>> > I actually thought about marking them 'const' here before sending
>> > (without noticing the changelog text) and then ran into what must
>> > have led me to drop the 'const' originally: tuner_i2c_xfer_send()
>> > takes a non-const pointer. This can be fixed but it requires
>> > an ugly cast:
>>
>> Casting away const is always a horrible hack.
>>
>> Until it could be changed, my preference would
>> be to update the changelog and perhaps add to
>> the changelog the reason why it can not be const
>> as detailed below.
>>
>> ie: xfer_send and xfer_xend_recv both take a
>>     non-const unsigned char *

Ok.

> Perhaps, on a separate changeset, we could change I2C routines to
> accept const unsigned char pointers. This is unrelated to tda8290
> KASAN fixes. So, it should go via I2C tree, and, once accepted
> there, we can change V4L2 drivers (and other drivers) accordingly.

I don't see how that would work unfortunately. i2c_msg contains
a pointer to the data, and that is used for both input and output,
including arrays like

        struct i2c_msg msgs[] = {
                {
                        .addr = dvo->slave_addr,
                        .flags = 0,
                        .len = 1,
                        .buf = &addr,
                },
                {
                        .addr = dvo->slave_addr,
                        .flags = I2C_M_RD,
                        .len = 1,
                        .buf = val,
                }
        };

that have one constant output pointer and one non-constant
input pointer. We could add an anonymous union for 'buf'
to make that two separate pointers, but that's barely any
better than the cast, and it would break the named initializers
in the example above, at least on older compilers. Adding
a second pointer to i2c_msg would add a bit of bloat and
also require tree-wide changes or ugly hacks.

       Arnd
