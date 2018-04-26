Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:46422 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753207AbeDZQSP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 12:18:15 -0400
MIME-Version: 1.0
In-Reply-To: <2085532.oxbmo4GB4v@avalon>
References: <1524412577-14419-1-git-send-email-akinobu.mita@gmail.com>
 <CAC5umyiG+=nFyj31XQBNnwH_Ts130xWymH-kCinEoRDu3iFbWQ@mail.gmail.com>
 <CAC5umyj1m18UgKjWYfhFhz0mj0N2_koATU3bev81FiOYgk6AZQ@mail.gmail.com> <2085532.oxbmo4GB4v@avalon>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Fri, 27 Apr 2018 01:17:55 +0900
Message-ID: <CAC5umyhR=VKxhtQwegceczvQyjpV5zaJ-E8+RscTuveS=9Em+g@mail.gmail.com>
Subject: Re: [PATCH v3 01/11] media: dt-bindings: ov772x: add device tree binding
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-04-26 7:40 GMT+09:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Mita-san,
>
> On Wednesday, 25 April 2018 19:19:11 EEST Akinobu Mita wrote:
>> 2018-04-24 0:54 GMT+09:00 Akinobu Mita <akinobu.mita@gmail.com>:
>> > 2018-04-23 18:17 GMT+09:00 Laurent Pinchart:
>> >> On Sunday, 22 April 2018 18:56:07 EEST Akinobu Mita wrote:
>> >>> This adds a device tree binding documentation for OV7720/OV7725 sensor.
>> >>>
>> >>> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
>> >>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> >>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> >>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>> >>> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>> >>> Cc: Rob Herring <robh+dt@kernel.org>
>> >>> Reviewed-by: Rob Herring <robh@kernel.org>
>> >>> Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
>> >>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> >>> ---
>> >>> * v3
>> >>> - Add Reviewed-by: lines
>> >>>
>> >>>  .../devicetree/bindings/media/i2c/ov772x.txt       | 42 +++++++++++++++
>> >>>  MAINTAINERS                                        |  1 +
>> >>>  2 files changed, 43 insertions(+)
>> >>>  create mode 100644
>> >>>  Documentation/devicetree/bindings/media/i2c/ov772x.txt
>> >>>
>> >>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov772x.txt
>> >>> b/Documentation/devicetree/bindings/media/i2c/ov772x.txt new file mode
>> >>> 100644
>> >>> index 0000000..b045503
>> >>> --- /dev/null
>> >>> +++ b/Documentation/devicetree/bindings/media/i2c/ov772x.txt
>> >>> @@ -0,0 +1,42 @@
>> >>> +* Omnivision OV7720/OV7725 CMOS sensor
>> >>> +
>> >>> +The Omnivision OV7720/OV7725 sensor supports multiple resolutions
>> >>> output,
>> >>> +such as VGA, QVGA, and any size scaling down from CIF to 40x30. It also
>> >>> can +support the YUV422, RGB565/555/444, GRB422 or raw RGB output
>> >>> formats. +
>> >>> +Required Properties:
>> >>> +- compatible: shall be one of
>> >>> +     "ovti,ov7720"
>> >>> +     "ovti,ov7725"
>> >>> +- clocks: reference to the xclk input clock.
>> >>> +- clock-names: shall be "xclk".
>> >>
>> >> As there's a single clock we could omit clock-names, couldn't we ?
>> >
>> > Sounds good.
>> >
>> > I'll prepare another patch that replaces the clock consumer ID argument
>> > of clk_get() from "xclk" to NULL, and remove the above line in this
>> > bindings.
>>
>> I thought it's easy to do.  However, there is a non-DT user
>> (arch/sh/boards/mach-migor/setup.c) that defines a clock with "xclk" ID.
>>
>> This can be resolved by retrying clk_get() with NULL if no entry
>> with "xclk".  But should we do so or leave as is?
>
> How about patching the board code to register the clock alias with
>
>         clk_add_alias(NULL, "0-0021", "video_clk", NULL);

Sounds good.

But I'm a bit worried about whether clk_add_alias() can be called with
alias == NULL.  I couldn't find such use case.

Probably Jacopo can verify whether it works or not with v4 patchset.
