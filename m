Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:40032 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755433AbeDWPJ6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 11:09:58 -0400
Received: by mail-wr0-f182.google.com with SMTP id v60-v6so42271888wrc.7
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 08:09:58 -0700 (PDT)
References: <20180419110056.10342-1-rui.silva@linaro.org> <20180419110056.10342-2-rui.silva@linaro.org> <CAOMZO5A3+WMu+U5STP-z3qdXnUQN2yTJne2OV9-SrEs70JJyDA@mail.gmail.com>
From: Rui Miguel Silva <rui.silva@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: Rui Miguel Silva <rui.silva@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        "open list\:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 1/2] media: ov2680: dt: Add bindings for OV2680
In-reply-to: <CAOMZO5A3+WMu+U5STP-z3qdXnUQN2yTJne2OV9-SrEs70JJyDA@mail.gmail.com>
Date: Mon, 23 Apr 2018 16:09:55 +0100
Message-ID: <m3wowydkn0.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,
Thanks for the review.

On Mon 23 Apr 2018 at 14:11, Fabio Estevam wrote:
> Hi Rui,
>
> On Thu, Apr 19, 2018 at 8:00 AM, Rui Miguel Silva 
> <rui.silva@linaro.org> wrote:
>
>> +Optional Properties:
>> +- powerdown-gpios: reference to the GPIO connected to the 
>> powerdown pin,
>> +                    if any. This is an active high signal to 
>> the OV2680.
>
> I looked at the OV2680 datasheet and I see a pin called XSHUTDN, 
> which has
> the following description:
>
> XSHUTDN: reset and power down (active low with internal pull 
> down resistor)
>
> So it should be active low, not active high.

Yes, you are correct, I will fix this, and the dts entry.

Thanks.

---
Cheers,
	Rui
