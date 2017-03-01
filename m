Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:36743 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbdCAA4E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 19:56:04 -0500
Received: by mail-ot0-f196.google.com with SMTP id i1so2796332ota.3
        for <linux-media@vger.kernel.org>; Tue, 28 Feb 2017 16:54:29 -0800 (PST)
Subject: Re: [PATCH v4 24/36] [media] add Omnivision OV5640 sensor driver
To: Rob Herring <robh@kernel.org>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-25-git-send-email-steve_longerbeam@mentor.com>
 <20170227144539.3la2veztkurhwa2p@rob-hp-laptop>
Cc: mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <7fcea7e2-b684-9824-a46d-46b5e250a728@gmail.com>
Date: Tue, 28 Feb 2017 16:43:59 -0800
MIME-Version: 1.0
In-Reply-To: <20170227144539.3la2veztkurhwa2p@rob-hp-laptop>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/27/2017 06:45 AM, Rob Herring wrote:
> On Wed, Feb 15, 2017 at 06:19:26PM -0800, Steve Longerbeam wrote:
>> This driver is based on ov5640_mipi.c from Freescale imx_3.10.17_1.0.0_beta
>> branch, modified heavily to bring forward to latest interfaces and code
>> cleanup.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> ---
>>   .../devicetree/bindings/media/i2c/ov5640.txt       |   43 +
> Please split to separate commit.

Done.

>
>>   drivers/media/i2c/Kconfig                          |    7 +
>>   drivers/media/i2c/Makefile                         |    1 +
>>   drivers/media/i2c/ov5640.c                         | 2109 ++++++++++++++++++++
>>   4 files changed, 2160 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5640.txt
>>   create mode 100644 drivers/media/i2c/ov5640.c
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5640.txt b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
>> new file mode 100644
>> index 0000000..4607bbe
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
>> @@ -0,0 +1,43 @@
>> +* Omnivision OV5640 MIPI CSI-2 sensor
>> +
>> +Required Properties:
>> +- compatible: should be "ovti,ov5640"
>> +- clocks: reference to the xclk input clock.
>> +- clock-names: should be "xclk".
>> +- DOVDD-supply: Digital I/O voltage supply, 1.8 volts
>> +- AVDD-supply: Analog voltage supply, 2.8 volts
>> +- DVDD-supply: Digital core voltage supply, 1.5 volts
>> +
>> +Optional Properties:
>> +- reset-gpios: reference to the GPIO connected to the reset pin, if any.
>> +- pwdn-gpios: reference to the GPIO connected to the pwdn pin, if any.
> Use powerdown-gpios here as that is a somewhat standard name.

Done.

>
> Both need to state what is the active state.

Done.

Steve
