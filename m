Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:35503 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbcEQPRD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2016 11:17:03 -0400
Received: by mail-lb0-f178.google.com with SMTP id ww9so7198487lbc.2
        for <linux-media@vger.kernel.org>; Tue, 17 May 2016 08:17:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACvgo50i0Y=TJNCvX+c2m8u8ai2p30EbaU1u3xBmQYBZGWH5UA@mail.gmail.com>
References: <1462806459-8124-1-git-send-email-benjamin.gaignard@linaro.org>
	<1462806459-8124-4-git-send-email-benjamin.gaignard@linaro.org>
	<CACvgo50i0Y=TJNCvX+c2m8u8ai2p30EbaU1u3xBmQYBZGWH5UA@mail.gmail.com>
Date: Tue, 17 May 2016 17:17:01 +0200
Message-ID: <CA+M3ks6V8x+x90kfuNW3Nic7o3EcGayCeHZa9nLi=jCcFed2qQ@mail.gmail.com>
Subject: Re: [PATCH v7 3/3] SMAF: add fake secure module
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: Emil Velikov <emil.l.velikov@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
	ML dri-devel <dri-devel@lists.freedesktop.org>,
	Zoltan Kuscsik <zoltan.kuscsik@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Cc Ma <cc.ma@mediatek.com>,
	Pascal Brand <pascal.brand@linaro.org>,
	Joakim Bech <joakim.bech@linaro.org>,
	Dan Caprita <dan.caprita@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-05-17 1:10 GMT+02:00 Emil Velikov <emil.l.velikov@gmail.com>:
> Hi Benjamin,
>
> On 9 May 2016 at 16:07, Benjamin Gaignard <benjamin.gaignard@linaro.org> wrote:
>> This module is allow testing secure calls of SMAF.
>>
> "Add fake secure module" does sound like something not (m)any people
> want to hear ;-)
> Have you considered calling it 'dummy', 'test' or similar ?

"test" is better name, I will change to that

>
>
>> --- /dev/null
>> +++ b/drivers/smaf/smaf-fakesecure.c
>> @@ -0,0 +1,85 @@
>> +/*
>> + * smaf-fakesecure.c
>> + *
>> + * Copyright (C) Linaro SA 2015
>> + * Author: Benjamin Gaignard <benjamin.gaignard@linaro.org> for Linaro.
>> + * License terms:  GNU General Public License (GPL), version 2
>> + */
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +#include <linux/smaf-secure.h>
>> +
>> +#define MAGIC 0xDEADBEEF
>> +
>> +struct fake_private {
>> +       int magic;
>> +};
>> +
>> +static void *smaf_fakesecure_create(void)
>> +{
>> +       struct fake_private *priv;
>> +
>> +       priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> Missing ENOMEM handling ?
>
>> +       priv->magic = MAGIC;
>> +
>> +       return priv;
>> +}
>> +
>> +static int smaf_fakesecure_destroy(void *ctx)
>> +{
>> +       struct fake_private *priv = (struct fake_private *)ctx;
> You might want to flesh this cast into a (inline) helper and use it throughout ?
>
>
> ... and that is all. Hope these were useful, or at the very least not
> utterly wrong, suggestions :-)
>
>
> Regards,
> Emil
>
> P.S. From a quick look userspace has some subtle bugs/odd practises.
> Let me know if you're interested in my input.

Your advices are welcome for userspace too

Thanks
Benjamin



-- 
Benjamin Gaignard

Graphic Working Group

Linaro.org │ Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
