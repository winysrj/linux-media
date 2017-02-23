Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35191 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751165AbdBWGiQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Feb 2017 01:38:16 -0500
Received: by mail-wm0-f50.google.com with SMTP id v186so161839214wmd.0
        for <linux-media@vger.kernel.org>; Wed, 22 Feb 2017 22:37:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKMK7uHsPizi3hCj4r9fw=kK1g5iy+oB7+CPO+uH-WQpXDBaFg@mail.gmail.com>
References: <CGME20170221132114eucas1p2e527d5b5516494ba54aa91f48b3e227f@eucas1p2.samsung.com>
 <1487683261-2655-1-git-send-email-m.szyprowski@samsung.com>
 <917aff70-64f7-7224-a015-0e77951bbc1d@vodafone.de> <dbcfe0d9-cdc3-e715-2535-0a2b7ffec3a5@samsung.com>
 <ac1ddfe4-1667-bdb0-c4da-35c8cf85fbed@samsung.com> <ef70688e-35a5-00a5-44e0-575bc18d1752@vodafone.de>
 <CAKMK7uHsPizi3hCj4r9fw=kK1g5iy+oB7+CPO+uH-WQpXDBaFg@mail.gmail.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 23 Feb 2017 12:07:12 +0530
Message-ID: <CAO_48GHbXo9Fv56vcUrAMTMU4-gjHqehbd6LXntMLdSs=2vZxw@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: add support for compat ioctl
To: Daniel Vetter <daniel@ffwll.ch>
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek,

On 23 February 2017 at 00:37, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Tue, Feb 21, 2017 at 4:08 PM, Christian K=C3=B6nig
> <deathsimple@vodafone.de> wrote:
>> Am 21.02.2017 um 15:55 schrieb Marek Szyprowski:
>>>
>>> Dear All,
>>>
>>> On 2017-02-21 15:37, Marek Szyprowski wrote:
>>>>
>>>> Hi Christian,
>>>>
>>>> On 2017-02-21 14:59, Christian K=C3=B6nig wrote:
>>>>>
>>>>> Am 21.02.2017 um 14:21 schrieb Marek Szyprowski:
>>>>>>
>>>>>> Add compat ioctl support to dma-buf. This lets one to use
>>>>>> DMA_BUF_IOCTL_SYNC
>>>>>> ioctl from 32bit application on 64bit kernel. Data structures for bo=
th
>>>>>> 32
>>>>>> and 64bit modes are same, so there is no need for additional
>>>>>> translation
>>>>>> layer.
>>>>>
>>>>>
>>>>> Well I might be wrong, but IIRC compat_ioctl was just optional and if
>>>>> not specified unlocked_ioctl was called instead.
>>>>>
>>>>> If that is true your patch wouldn't have any effect at all.
>>>>
>>>>
>>>> Well, then why I got -ENOTTY in the 32bit test app for this ioctl on
>>>> 64bit ARM64 kernel without this patch?
>>>>
>>>
>>> I've checked in fs/compat_ioctl.c, I see no fallback in
>>> COMPAT_SYSCALL_DEFINE3,
>>> so one has to provide compat_ioctl callback to have ioctl working with
>>> 32bit
>>> apps.
>>
>>
>> Then my memory cheated on me.
>>
>> In this case the patch is Reviewed-by: Christian K=C3=B6nig
>> <christian.koenig@amd.com>.
>

Thanks much for spotting this!

> Since you have commit rights for drm-misc, care to push this to
> drm-misc-next-fixes pls? Also I think this warrants a cc: stable,
> clearly an obvious screw-up in creating this api on our side :( So
> feel free to smash my ack on the patch.
>
Daniel, Christian,

I saw this just now, so if Christian hasn't already pulled it into
drm-misc-next-fixes, I'll give it a stab.

> Thanks, Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

Best,
Sumit.

--=20
Thanks and regards,

Sumit Semwal
Linaro Mobile Group - Kernel Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
