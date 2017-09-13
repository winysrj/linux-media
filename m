Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:33407 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751123AbdIMPyw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 11:54:52 -0400
Subject: Re: [PATCH] [media] s3c-camif: fix out-of-bounds array access
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sylwester Nawrocki <snawrocki@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "moderated list:ARM/SAMSUNG EXYNOS ARM ARCHITECTURES"
        <linux-samsung-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <ce741db2-dc57-7d23-90bc-319411006861@samsung.com>
Date: Wed, 13 Sep 2017 17:54:45 +0200
MIME-version: 1.0
In-reply-to: <CAK8P3a2CDqgaqZiopJJOB6WsTgQEB49sz7=7izmFfaBOgG5_xA@mail.gmail.com>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <CGME20170913092551epcas1p4f84e118f364f605cb5cc6b8b669ac095@epcas1p4.samsung.com>
        <20170912200932.3634089-1-arnd@arndb.de>
        <4355b20a-504c-4e83-92c8-049e6c6d6a5f@samsung.com>
        <CAK8P3a2CDqgaqZiopJJOB6WsTgQEB49sz7=7izmFfaBOgG5_xA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/13/2017 04:03 PM, Arnd Bergmann wrote:
> On Wed, Sep 13, 2017 at 11:25 AM, Sylwester Nawrocki
> <s.nawrocki@samsung.com>  wrote:
>> On 09/12/2017 10:09 PM, Arnd Bergmann wrote:
>>>    {
>>>        const struct s3c_camif_variant *variant = camif->variant;
>>>        const struct vp_pix_limits *pix_lim;
>>> -     int i = ARRAY_SIZE(camif_mbus_formats);
>>>
>>>        /* FIXME: constraints against codec or preview path ? */
>>>        pix_lim = &variant->vp_pix_limits[VP_CODEC];
>>>
>>> -     while (i-- >= 0)
>>> -             if (camif_mbus_formats[i] == mf->code)
>>> -                     break;
>>> -
>>> -     mf->code = camif_mbus_formats[i];
>>
>> Interesting finding... the function needs to ensure mf->code is set
>> to one of supported values by the driver, so instead of removing
>> how about changing the above line to:
>>
>>          if (i < 0)
>>                  mf->code = camif_mbus_formats[0];
>>
>> ?
> That would still have one of the two out-of-bounds accesses;-)

Ah, indeed :/

> maybe this
> 
> for (i = 0; i < ARRAY_SIZE(camif_mbus_formats); i++)
>          if (camif_mbus_formats[i] == mf->code)
>                 break;
> 
> if (i == ARRAY_SIZE(camif_mbus_formats))
>         mf->code = camif_mbus_formats[0];

Yes, it should work that way.

-- 
Thanks,
Sylwester
