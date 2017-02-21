Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.60.111]:46404 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbdBUUNZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 15:13:25 -0500
Subject: Re: [PATCH v9 1/2] Add OV5647 device tree documentation
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>
References: <cover.1487334912.git.roliveir@synopsys.com>
 <5a93352142495528dd56d5e281a8ed8ad6404a05.1487334912.git.roliveir@synopsys.com>
 <dd33c7bc-e6f7-c234-c3c6-6cc4c7353c68@mentor.com>
CC: <CARLOS.PALMINHA@synopsys.com>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lars-Peter Clausen" <lars@metafoo.de>,
        Mark Rutland <mark.rutland@arm.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Rob Herring <robh+dt@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Message-ID: <a2887a9a-0317-eb89-b971-9b238a214459@synopsys.com>
Date: Tue, 21 Feb 2017 20:13:16 +0000
MIME-Version: 1.0
In-Reply-To: <dd33c7bc-e6f7-c234-c3c6-6cc4c7353c68@mentor.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vladimir,

Thank you for your feedback

On 2/21/2017 3:58 PM, Vladimir Zapolskiy wrote:
> Hi Ramiro,
> 
> On 02/17/2017 03:14 PM, Ramiro Oliveira wrote:
>> Create device tree bindings documentation.
>>
>> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
>> Acked-by: Rob Herring <robh@kernel.org>
>> ---
>>  .../devicetree/bindings/media/i2c/ov5647.txt       | 35 ++++++++++++++++++++++
>>  1 file changed, 35 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5647.txt b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
>> new file mode 100644
>> index 000000000000..31956426d3b9
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
>> @@ -0,0 +1,35 @@
>> +Omnivision OV5647 raw image sensor
>> +---------------------------------
>> +
>> +OV5647 is a raw image sensor with MIPI CSI-2 and CCP2 image data interfaces
>> +and CCI (I2C compatible) control bus.
>> +
>> +Required properties:
>> +
>> +- compatible		: "ovti,ov5647".
>> +- reg			: I2C slave address of the sensor.
>> +- clocks		: Reference to the xclk clock.
> 
> Is "xclk" clock a pixel clock or something else?
> 

It's an external oscillator.

>> +- clock-names		: Should be "xclk".
> 
> You can remove this property, because there is only one source clock.
> 

Ok.

>> +- clock-frequency	: Frequency of the xclk clock.
> 
> And after the last updates in the driver this property can be removed as well.
> 

But I'm still using clk_get_rate in the driver, if I remove the frequency here
the probing will fail.

>> +
>> +The common video interfaces bindings (see video-interfaces.txt) should be
>> +used to specify link to the image data receiver. The OV5647 device
>> +node should contain one 'port' child node with an 'endpoint' subnode.
>> +
>> +Example:
>> +
>> +	i2c@2000 {
>> +		...
>> +		ov: camera@36 {
>> +			compatible = "ovti,ov5647";
>> +			reg = <0x36>;
>> +			clocks = <&camera_clk>;
>> +			clock-names = "xclk";
>> +			clock-frequency = <25000000>;
> 
> When you remove two unused properties, please don't forget to update the
> example.
> 

Ok.

>> +			port {
>> +				camera_1: endpoint {
>> +					remote-endpoint = <&csi1_ep1>;
>> +				};
>> +			};
>> +		};
>> +	};
>>
> 
> --
> With best wishes,
> Vladimir
> 

-- 
Best Regards

Ramiro Oliveira
Ramiro.Oliveira@synopsys.com
