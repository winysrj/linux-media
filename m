Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:43714 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756328AbeDFOQs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2018 10:16:48 -0400
Received: by mail-qk0-f194.google.com with SMTP id v2so1292013qkh.10
        for <linux-media@vger.kernel.org>; Fri, 06 Apr 2018 07:16:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180406111537.04375bdf@vento.lan>
References: <cover.1522949748.git.mchehab@s-opensource.com>
 <24a526280e4eb319147908ccab786e2ebc8f8076.1522949748.git.mchehab@s-opensource.com>
 <CAK8P3a1a7r1FNhpRHJfyzRNHgNHOzcK1wkerYb+BR_RjWNkOUQ@mail.gmail.com>
 <20180406064718.2cdb69ea@vento.lan> <CAK8P3a2FQapAqxOMJNe9oBs8kBXsd7TCdsNon5Gvab3Y8LLKSA@mail.gmail.com>
 <20180406111537.04375bdf@vento.lan>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 6 Apr 2018 16:16:46 +0200
Message-ID: <CAK8P3a1aO99P7RWErJRS22QQdJ6wJNgZptHOaTFx7_2NvQ1vvA@mail.gmail.com>
Subject: Re: [PATCH 05/16] media: fsl-viu: allow building it with COMPILE_TEST
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Geliang Tang <geliangtang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 6, 2018 at 4:15 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Em Fri, 6 Apr 2018 11:51:16 +0200
> Arnd Bergmann <arnd@arndb.de> escreveu:
>
>> On Fri, Apr 6, 2018 at 11:47 AM, Mauro Carvalho Chehab
>> <mchehab@s-opensource.com> wrote:
>>
>> > [PATCH] media: fsl-viu: allow building it with COMPILE_TEST
>> >
>> > There aren't many things that would be needed to allow it
>> > to build with compile test.
>> >
>> > Add the needed bits.
>> >
>> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>>
>> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>
> Actually, in order to avoid warnings with smatch, the COMPILE_TEST
> macros should be declared as:
>
> +#define out_be32(v, a) iowrite32be(a, (void __iomem *)v)
> +#define in_be32(a)     ioread32be((void __iomem *)a)

I would just add the correct annotations, I think they've always been missing.
2 patches coming in a few minutes.

      Arnd
