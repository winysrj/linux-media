Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36379 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753128AbdGMPrT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 11:47:19 -0400
Received: by mail-it0-f68.google.com with SMTP id k3so7905078ita.3
        for <linux-media@vger.kernel.org>; Thu, 13 Jul 2017 08:47:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170713153842.xupjvsf2nfkvtkyy@valkosipuli.retiisi.org.uk>
References: <ea42b2bdf113f7c2533c83986657647934b4e839.1499859983.git.mchehab@s-opensource.com>
 <20170713153842.xupjvsf2nfkvtkyy@valkosipuli.retiisi.org.uk>
From: Javier Martinez Canillas <javier@dowhile0.org>
Date: Thu, 13 Jul 2017 17:47:12 +0200
Message-ID: <CABxcv=nKHs6nFvbNdwMxsGjbj-JpHAOXd1Lt8FCXk3RHjCZgwA@mail.gmail.com>
Subject: Re: [PATCH] media: vimc: cleanup a few warnings
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Helen Koike <helen.koike@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 13, 2017 at 5:38 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:

[snip]

>>
>> -static const struct platform_device_id vimc_sen_driver_ids[] = {
>> +static const __maybe_unused
>> +struct platform_device_id vimc_sen_driver_ids[] = {
>>       {
>>               .name           = VIMC_SEN_DRV_NAME,
>>       },
>
> Shouldn't these be set to the corresponding driver structs' id_table
> fields? Or do I miss something...?
>

Agreed, the real problem is that the .id_table is not set for these
drivers. The match only works because the platform subsystem fallbacks
to the driver's name if an .id_table isn't defined:

http://elixir.free-electrons.com/linux/latest/source/drivers/base/platform.c#L964

Best regards,
Javier
