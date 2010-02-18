Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47982 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442Ab0BRUJe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2010 15:09:34 -0500
MIME-Version: 1.0
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40169C5C9B5@dlee06.ent.ti.com>
References: <4B714E15.4020909@gmail.com> <A69FA2915331DC488A831521EAE36FE40169C5C9B5@dlee06.ent.ti.com>
From: roel kluin <roel.kluin@gmail.com>
Date: Thu, 18 Feb 2010 21:02:19 +0100
Message-ID: <25e057c01002181202v346f488bk571d099f679fea83@mail.gmail.com>
Subject: Re: [PATCH] video_device: don't free_irq() an element past array
	vpif_obj.dev[] and fix test
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>-      if (!std_info)
>>+      if (!std_info->stdid)
>>               return -1;
>>
> This is a NACK. We shouldn't check for stdid since the function is supposed
> to update std_info. So just remove
>
> if (!std_info)
>        return -1;

I don't see how std_info could get updated. consider the loop in case
std_info->stdid equals 0:

        for (index = 0; index < ARRAY_SIZE(ch_params); index++) {
                config = &ch_params[index];

(config is a local variable)

                if (config->stdid & std_info->stdid) {

This fails for every index if std_info->stdid equals 0.

                        memcpy(std_info, config, sizeof(*config));
                        break;
                }
        }

So we always reach this with index == ARRAY_SIZE(ch_params)

        if (index == ARRAY_SIZE(ch_params))
                return -1;

So we could have returned -1 earlier.

> I am okay with the below change. So please re-submit the patch with the
> above change and my ACK.
>
> Thanks
>
> Murali
>

>>+      if (k == VPIF_DISPLAY_MAX_DEVICES)
>>+              k = VPIF_DISPLAY_MAX_DEVICES - 1;

actually I think this is still not right. shouldn't it be be

k = VPIF_DISPLAY_MAX_DEVICES - 1;

> are you using this driver in your project?

No, I just found this in the code.

Thanks, Roel
