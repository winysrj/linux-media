Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36835 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753182AbdEDPW0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 May 2017 11:22:26 -0400
MIME-Version: 1.0
In-Reply-To: <20170504144503.GY7456@valkosipuli.retiisi.org.uk>
References: <20170427224203.14611-1-niklas.soderlund+renesas@ragnatech.se>
 <20170427224203.14611-17-niklas.soderlund+renesas@ragnatech.se> <20170504144503.GY7456@valkosipuli.retiisi.org.uk>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 4 May 2017 17:22:23 +0200
Message-ID: <CAMuHMdUFwOYsC-iYY7D0EYuTeXsGeQ7btyqt-T8_LF3zZ7k_jg@mail.gmail.com>
Subject: Re: [PATCH v4 16/27] rcar-vin: add functions to manipulate Gen3 CHSEL value
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Fukawa <tomoharu.fukawa.eb@renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thu, May 4, 2017 at 4:45 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
>> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
>> @@ -16,6 +16,7 @@
>>
>>  #include <linux/delay.h>
>>  #include <linux/interrupt.h>
>> +#include <linux/pm_runtime.h>
>>
>>  #include <media/videobuf2-dma-contig.h>
>>
>> @@ -1240,3 +1241,45 @@ int rvin_dma_probe(struct rvin_dev *vin, int irq)
>>
>>       return ret;
>>  }
>> +
>> +/* -----------------------------------------------------------------------------
>> + * Gen3 CHSEL manipulation
>> + */
>> +
>> +int rvin_set_chsel(struct rvin_dev *vin, u8 chsel)
>> +{
>> +     u32 ifmd;
>> +
>> +     pm_runtime_get_sync(vin->dev);
>
> Can this fail? Just wondering.

In theory, yes.
In practice, no, unless the system is completely broken.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
