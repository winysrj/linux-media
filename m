Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:41387 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762825AbdLSMup (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 07:50:45 -0500
MIME-Version: 1.0
In-Reply-To: <20171219092246.3usg5mdyi27ivqlq@valkosipuli.retiisi.org.uk>
References: <20171211013146.2497-1-wenyou.yang@microchip.com>
 <20171211013146.2497-3-wenyou.yang@microchip.com> <20171219092246.3usg5mdyi27ivqlq@valkosipuli.retiisi.org.uk>
From: Fabio Estevam <festevam@gmail.com>
Date: Tue, 19 Dec 2017 10:50:44 -0200
Message-ID: <CAOMZO5BHSJv01SwZ2YNtGZTjMtOuOktET43qriK2fQ+jhE2TDA@mail.gmail.com>
Subject: Re: [PATCH v9 2/2] media: i2c: Add the ov7740 image sensor driver
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Philippe Ombredanne <pombredanne@nexb.com>
Cc: Wenyou Yang <wenyou.yang@microchip.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh+dt@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Songjun Wu <songjun.wu@microchip.com>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tue, Dec 19, 2017 at 7:22 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> On Mon, Dec 11, 2017 at 09:31:46AM +0800, Wenyou Yang wrote:
>> The ov7740 (color) image sensor is a high performance VGA CMOS
>> image snesor, which supports for output formats: RAW RGB and YUV
>> and image sizes: VGA, and QVGA, CIF and any size smaller.
>>
>> Signed-off-by: Songjun Wu <songjun.wu@microchip.com>
>> Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
>
> Applied with this diff:
>
> diff --git a/drivers/media/i2c/ov7740.c b/drivers/media/i2c/ov7740.c
> index 0308ba437bbb..041a77039d70 100644
> --- a/drivers/media/i2c/ov7740.c
> +++ b/drivers/media/i2c/ov7740.c
> @@ -1,5 +1,7 @@
> -// SPDX-License-Identifier: GPL-2.0
> -// Copyright (c) 2017 Microchip Corporation.
> +/*
> + * SPDX-License-Identifier: GPL-2.0
> + * Copyright (c) 2017 Microchip Corporation.
> + */

The original version is the recommended format for the SPDX identifier.
