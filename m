Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:41548 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751401AbeDXQL3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 12:11:29 -0400
Received: by mail-wr0-f194.google.com with SMTP id g21-v6so23056126wrb.8
        for <linux-media@vger.kernel.org>; Tue, 24 Apr 2018 09:11:28 -0700 (PDT)
References: <20180419110056.10342-1-rui.silva@linaro.org> <20180419110056.10342-2-rui.silva@linaro.org> <CAOMZO5CHOcjctMDcbPBU1-1JkcxbL+JWrgfDtnt8dXLtMFCZBg@mail.gmail.com>
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
In-reply-to: <CAOMZO5CHOcjctMDcbPBU1-1JkcxbL+JWrgfDtnt8dXLtMFCZBg@mail.gmail.com>
Date: Tue, 24 Apr 2018 17:11:26 +0100
Message-ID: <m3po2oeg9d.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,
On Tue 24 Apr 2018 at 15:53, Fabio Estevam wrote:
> Hi Rui,
>
> On Thu, Apr 19, 2018 at 8:00 AM, Rui Miguel Silva 
> <rui.silva@linaro.org> wrote:
>> Add device tree binding documentation for the OV2680 camera 
>> sensor.
>>
>> Reviewed-by: Rob Herring <robh@kernel.org>
>> CC: devicetree@vger.kernel.org
>> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>> ---
>>  .../devicetree/bindings/media/i2c/ov2680.txt  | 40 
>>  +++++++++++++++++++
>>  1 file changed, 40 insertions(+)
>>  create mode 100644 
>>  Documentation/devicetree/bindings/media/i2c/ov2680.txt
>>
>> diff --git 
>> a/Documentation/devicetree/bindings/media/i2c/ov2680.txt 
>> b/Documentation/devicetree/bindings/media/i2c/ov2680.txt
>> new file mode 100644
>> index 000000000000..0e29f1a113c0
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/ov2680.txt
>> @@ -0,0 +1,40 @@
>> +* Omnivision OV2680 MIPI CSI-2 sensor
>> +
>> +Required Properties:
>> +- compatible: should be "ovti,ov2680".
>> +- clocks: reference to the xvclk input clock.
>> +- clock-names: should be "xvclk".
>
> You missed to pass the camera power supplies as required 
> properties:

Urgh, yes, you are right, I will add this.

---
Cheers,
	Rui

>
> DOVDD-supply
> AVDD-supply
> DVDD-supply
