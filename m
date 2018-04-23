Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33827 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755496AbeDWPyd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 11:54:33 -0400
MIME-Version: 1.0
In-Reply-To: <6602935.FYsd3sRonc@avalon>
References: <1524412577-14419-1-git-send-email-akinobu.mita@gmail.com>
 <1524412577-14419-2-git-send-email-akinobu.mita@gmail.com> <6602935.FYsd3sRonc@avalon>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Tue, 24 Apr 2018 00:54:12 +0900
Message-ID: <CAC5umyiG+=nFyj31XQBNnwH_Ts130xWymH-kCinEoRDu3iFbWQ@mail.gmail.com>
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

2018-04-23 18:17 GMT+09:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Mita-san,
>
> On Sunday, 22 April 2018 18:56:07 EEST Akinobu Mita wrote:
>> This adds a device tree binding documentation for OV7720/OV7725 sensor.
>>
>> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Reviewed-by: Rob Herring <robh@kernel.org>
>> Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> ---
>> * v3
>> - Add Reviewed-by: lines
>>
>>  .../devicetree/bindings/media/i2c/ov772x.txt       | 42 +++++++++++++++++++
>>  MAINTAINERS                                        |  1 +
>>  2 files changed, 43 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov772x.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov772x.txt
>> b/Documentation/devicetree/bindings/media/i2c/ov772x.txt new file mode
>> 100644
>> index 0000000..b045503
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/ov772x.txt
>> @@ -0,0 +1,42 @@
>> +* Omnivision OV7720/OV7725 CMOS sensor
>> +
>> +The Omnivision OV7720/OV7725 sensor supports multiple resolutions output,
>> +such as VGA, QVGA, and any size scaling down from CIF to 40x30. It also can
>> +support the YUV422, RGB565/555/444, GRB422 or raw RGB output formats.
>> +
>> +Required Properties:
>> +- compatible: shall be one of
>> +     "ovti,ov7720"
>> +     "ovti,ov7725"
>> +- clocks: reference to the xclk input clock.
>> +- clock-names: shall be "xclk".
>
> As there's a single clock we could omit clock-names, couldn't we ?

Sounds good.

I'll prepare another patch that replaces the clock consumer ID argument
of clk_get() from "xclk" to NULL, and remove the above line in this
bindings.
