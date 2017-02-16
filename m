Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32916 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751826AbdBPKvQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 05:51:16 -0500
Received: by mail-wm0-f67.google.com with SMTP id v77so2486015wmv.0
        for <linux-media@vger.kernel.org>; Thu, 16 Feb 2017 02:51:15 -0800 (PST)
Subject: Re: [GIT PULL FOR v4.11] MediaTek JPEG encoder
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <0e07065d-9e0a-6ce7-9b39-197b04f4f67c@xs4all.nl>
 <20170213100042.7f3772ea@vento.lan>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Rick Chang <rick.chang@mediatek.com>
From: Matthias Brugger <matthias.bgg@gmail.com>
Message-ID: <b92f1991-2f06-586b-2329-4756d7f3daff@gmail.com>
Date: Thu, 16 Feb 2017 11:51:13 +0100
MIME-Version: 1.0
In-Reply-To: <20170213100042.7f3772ea@vento.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 13/02/17 13:00, Mauro Carvalho Chehab wrote:
> Em Mon, 13 Feb 2017 11:52:07 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>
>> Hi Mauro,
>>
>> This adds the MediaTek JPEG encoder to the media subsystem.
>>
>> This patch https://patchwork.linuxtv.org/patch/38645/ needs to go through
>> Matthias Brugger,
>
> Why? It seems easier to just merge it via media tree, as it doesn't
> seem to be dependent of anything else.
>
> IMHO, the better would be if Matthias would ack to merge it via
> the media tree. On the other hand, it is just a documentation path.
> It wouldn't hurt if merged for 4.11, even if the remaining patches
> go for 4.12.
>

Sorry for the late answer:
I'm fine with merging it through your tree. Any patches on dts/dtsi 
files should go through mine, but for the bindings it's fine (and make 
sense) to take them through the driver subsystem maintainers tree.

Regards,
Matthias

>> so you need to coordinate with him for which kernel this
>> driver will be merged. This pull request is for 4.11, but since it is so
>> late in the cycle I can understand if this slips to 4.12.
>>
>> In any case, this should be coordinated.
>
> It is too late for 4.11. We close our merge window by -rc6, in
> order to give janitors some time to check if everything is ok.
>
> Also, unfortunately I won't have any time this week to review
> this patchset.
>
> So, let's not rush it and merge it after 4.11-rc1, for 4.12.
>
> Regards,
> Mauro
>
>>
>> Regards,
>>
>> 	Hans
>>
>> The following changes since commit 9eeb0ed0f30938f31a3d9135a88b9502192c18dd:
>>
>>   [media] mtk-vcodec: fix build warnings without DEBUG (2017-02-08 12:08:20 -0200)
>>
>> are available in the git repository at:
>>
>>   git://linuxtv.org/hverkuil/media_tree.git for-v4.11e
>>
>> for you to fetch changes up to 0f492f30d15aec43248fbdd4d6ceea8f495f4457:
>>
>>   vcodec: mediatek: Add Maintainers entry for Mediatek JPEG driver (2017-02-13 11:35:29 +0100)
>>
>> ----------------------------------------------------------------
>> Rick Chang (3):
>>       dt-bindings: mediatek: Add a binding for Mediatek JPEG Decoder
>>       vcodec: mediatek: Add Mediatek JPEG Decoder Driver
>>       vcodec: mediatek: Add Maintainers entry for Mediatek JPEG driver
>>
>>  Documentation/devicetree/bindings/media/mediatek-jpeg-decoder.txt |   37 +
>>  MAINTAINERS                                                       |    7 +
>>  drivers/media/platform/Kconfig                                    |   15 +
>>  drivers/media/platform/Makefile                                   |    2 +
>>  drivers/media/platform/mtk-jpeg/Makefile                          |    2 +
>>  drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c                   | 1306 +++++++++++++++++++++++++++++++++
>>  drivers/media/platform/mtk-jpeg/mtk_jpeg_core.h                   |  139 ++++
>>  drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.c                     |  417 +++++++++++
>>  drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.h                     |   91 +++
>>  drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.c                  |  160 ++++
>>  drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.h                  |   25 +
>>  drivers/media/platform/mtk-jpeg/mtk_jpeg_reg.h                    |   58 ++
>>  12 files changed, 2259 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/mediatek-jpeg-decoder.txt
>>  create mode 100644 drivers/media/platform/mtk-jpeg/Makefile
>>  create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
>>  create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.h
>>  create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.c
>>  create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.h
>>  create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.c
>>  create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.h
>>  create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_reg.h
>
>
>
> Thanks,
> Mauro
>
