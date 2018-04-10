Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34964 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751490AbeDJQe3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 12:34:29 -0400
MIME-Version: 1.0
In-Reply-To: <20180409090649.GX20945@w540>
References: <1523116090-13101-1-git-send-email-akinobu.mita@gmail.com>
 <1523116090-13101-6-git-send-email-akinobu.mita@gmail.com> <20180409090649.GX20945@w540>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Wed, 11 Apr 2018 01:34:08 +0900
Message-ID: <CAC5umyherpizqmFCK-mwMkHMVvjEABSMG3ktLfgS74irN2Of0w@mail.gmail.com>
Subject: Re: [PATCH 5/6] media: ov772x: add device tree binding
To: jacopo mondi <jacopo@jmondi.org>
Cc: linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-04-09 18:06 GMT+09:00 jacopo mondi <jacopo@jmondi.org>:
> Hi Akinobu,
>
> On Sun, Apr 08, 2018 at 12:48:09AM +0900, Akinobu Mita wrote:
>> This adds a device tree binding documentation for OV7720/OV7725 sensor.
>
> Please use as patch subject
> media: dt-bindings:

OK.

>>
>> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> ---
>>  .../devicetree/bindings/media/i2c/ov772x.txt       | 36 ++++++++++++++++++++++
>>  MAINTAINERS                                        |  1 +
>>  2 files changed, 37 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov772x.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov772x.txt b/Documentation/devicetree/bindings/media/i2c/ov772x.txt
>> new file mode 100644
>> index 0000000..9b0df3b
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/ov772x.txt
>> @@ -0,0 +1,36 @@
>> +* Omnivision OV7720/OV7725 CMOS sensor
>> +
>
> Could you please provide a brief description of the sensor (supported
> resolution and formats is ok)

OK.

>> +Required Properties:
>> +- compatible: shall be one of
>> +     "ovti,ov7720"
>> +     "ovti,ov7725"
>> +- clocks: reference to the xclk input clock.
>> +- clock-names: shall be "xclk".
>> +
>> +Optional Properties:
>> +- rstb-gpios: reference to the GPIO connected to the RSTB pin, if any.
>> +- pwdn-gpios: reference to the GPIO connected to the PWDN pin, if any.
>
> As a general note:
> This is debated, and I'm not enforcing it, but please consider using
> generic names for GPIOs with common functions. In this case
> "reset-gpios" and "powerdown-gpios". Also please indicate the GPIO
> active level in bindings description.
>
> For this specific driver:
> The probe routine already looks for a GPIO named 'pwdn', so I guess
> the DT bindings should use the same name. Unless you're willing to
> change it in the board files that register it (Migo-R only in mainline) and
> use the generic 'powerdown' name for both. Either is fine with me.

I'll prepare anothre patch that renames the GPIO names to generic one in
this driver and Mingo-R board file.

> There is no support for the reset GPIO in the driver code, it
> supports soft reset only. Either ditch it from bindings or add support
> for it in driver's code.

Doesn't that reset GPIO exist in current ov772x driver code, does it?
