Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:37199 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754560AbdHZMMg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 08:12:36 -0400
MIME-Version: 1.0
In-Reply-To: <20170826085942.78e0d222@vento.lan>
References: <1503742812-16139-1-git-send-email-bhumirks@gmail.com> <20170826085942.78e0d222@vento.lan>
From: Bhumika Goyal <bhumirks@gmail.com>
Date: Sat, 26 Aug 2017 17:42:34 +0530
Message-ID: <CAOH+1jH0BUgoyJK7=QUQcBMpqYf+W0TeMyJ+T2JSyxzY2Ha8fQ@mail.gmail.com>
Subject: Re: [PATCH 00/10] [media] platform: make video_device const
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, mchehab@kernel.org,
        hverkuil@xs4all.nl, Jonathan Corbet <corbet@lwn.net>,
        Kyungmin Park <kyungmin.park@samsung.com>, kamil@wypas.org,
        a.hajda@samsung.com, bparrot@ti.com, linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 26, 2017 at 5:29 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Em Sat, 26 Aug 2017 15:50:02 +0530
> Bhumika Goyal <bhumirks@gmail.com> escreveu:
>
>> Make make video_device const.
>>
>> Bhumika Goyal (10):
>>   [media] cx88: make video_device const
>>   [media] dt3155: make video_device const
>>   [media]: marvell-ccic: make video_device const
>>   [media] mx2-emmaprp: make video_device const
>>   [media]: s5p-g2d: make video_device const
>>   [media]: ti-vpe:  make video_device const
>>   [media] via-camera: make video_device const
>>   [media]: fsl-viu: make video_device const
>>   [media] m2m-deinterlace: make video_device const
>>   [media] vim2m: make video_device const
>>
>>  drivers/media/pci/cx88/cx88-blackbird.c         | 2 +-
>>  drivers/media/pci/dt3155/dt3155.c               | 2 +-
>>  drivers/media/platform/fsl-viu.c                | 2 +-
>>  drivers/media/platform/m2m-deinterlace.c        | 2 +-
>>  drivers/media/platform/marvell-ccic/mcam-core.c | 2 +-
>>  drivers/media/platform/mx2_emmaprp.c            | 2 +-
>>  drivers/media/platform/s5p-g2d/g2d.c            | 2 +-
>>  drivers/media/platform/ti-vpe/cal.c             | 2 +-
>>  drivers/media/platform/ti-vpe/vpe.c             | 2 +-
>>  drivers/media/platform/via-camera.c             | 2 +-
>>  drivers/media/platform/vim2m.c                  | 2 +-
>
> Please, don't do one such cleanup patch per file. Instead, group
> it per subdirectory, e. g. on e patch for:
>         drivers/media/platform/
>
> and another one for:
>         drivers/media/pci/
>
> That makes a lot easier to review and apply.
>

Okay, I will keep this in mind. Should I send a v2 for both the series?

Thanks,
Bhumika

> Thanks,
> Mauro
