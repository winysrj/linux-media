Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:35642 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753141AbdCHMtB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Mar 2017 07:49:01 -0500
Received: by mail-it0-f49.google.com with SMTP id m27so39249780iti.0
        for <linux-media@vger.kernel.org>; Wed, 08 Mar 2017 04:49:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+V-a8umdNxUAfnY97u+UVYYbi5h79ZXymeqcoW-ZKbXwJJPOQ@mail.gmail.com>
References: <1487268481-6127-1-git-send-email-bgolaszewski@baylibre.com> <CA+V-a8umdNxUAfnY97u+UVYYbi5h79ZXymeqcoW-ZKbXwJJPOQ@mail.gmail.com>
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date: Wed, 8 Mar 2017 13:41:07 +0100
Message-ID: <CAMpxmJUpHND0X6VKj9cD+vD2G_jBt_EmHq3k8gz7t1RFoMeuXw@mail.gmail.com>
Subject: Re: [PATCH] media: vpif: use a configurable i2c_adapter_id for vpif display
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@baylibre.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Russell King <linux@armlinux.org.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-03-07 18:12 GMT+01:00 Lad, Prabhakar <prabhakar.csengg@gmail.com>:
> Hi Bartosz,
>
> Thanks for the patch.
>
> On Thu, Feb 16, 2017 at 6:08 PM, Bartosz Golaszewski
> <bgolaszewski@baylibre.com> wrote:
>>
>> The vpif display driver uses a static i2c adapter ID of 1 but on the
>> da850-evm board in DT boot mode the i2c adapter ID is actually 0.
>>
>> Make the adapter ID configurable like it already is for vpif capture.
>>
>> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>> Acked-by: Kevin Hilman <khilman@baylibre.com>
>> ---
>>  arch/arm/mach-davinci/board-da850-evm.c       | 1 +
>>  drivers/media/platform/davinci/vpif_display.c | 2 +-
>>  include/media/davinci/vpif_types.h            | 1 +
>>  3 files changed, 3 insertions(+), 1 deletion(-)
>>
>
> Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>

Thanks!

Sekhar let me know, that this should be picked up by media. Also:
there are still two DT bindings patches for vpif that can be picked up
- Rob Herring acked them.

Thanks,
Bartosz
