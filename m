Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:44168 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752569AbdBUOaf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 09:30:35 -0500
Subject: Re: [PATCH v9 1/2] Add OV5647 device tree documentation
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
References: <cover.1487334912.git.roliveir@synopsys.com>
 <5a93352142495528dd56d5e281a8ed8ad6404a05.1487334912.git.roliveir@synopsys.com>
 <20170221115746.GF16975@valkosipuli.retiisi.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <vladimir_zapolskiy@mentor.com>,
        <CARLOS.PALMINHA@synopsys.com>, Arnd Bergmann <arnd@arndb.de>,
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
Message-ID: <3d0b775a-e1de-d957-de72-7751e2c59aea@synopsys.com>
Date: Tue, 21 Feb 2017 14:30:16 +0000
MIME-Version: 1.0
In-Reply-To: <20170221115746.GF16975@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for your feedback.

On 2/21/2017 11:57 AM, Sakari Ailus wrote:
> Hi Ramiro,
> 
> On Fri, Feb 17, 2017 at 01:14:15PM +0000, Ramiro Oliveira wrote:
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
>> +- clock-names		: Should be "xclk".
>> +- clock-frequency	: Frequency of the xclk clock.
>> +
>> +The common video interfaces bindings (see video-interfaces.txt) should be
>> +used to specify link to the image data receiver. The OV5647 device
>> +node should contain one 'port' child node with an 'endpoint' subnode.
> 
> The remote-endpoint property in endpoint nodes should be mandatory,
> shouldn't it? Otherwise the sensor isn't connected to anything and hardly
> useful as such. The list of optional endpoint properties is a long one and
> it should be documented here which ones are recognised, either as optional
> or mandatory.
> 

I guess you're right, it should be mandatory, although at the moment I'm not
checking for it's presence in the driver so I'll add it to the driver.

At the moment that's the only property I think it should be mandatory, and I
don't believe I need any optional one.

Do you have a suggestion for any new property I should use?

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
>> +			port {
>> +				camera_1: endpoint {
>> +					remote-endpoint = <&csi1_ep1>;
>> +				};
>> +			};
>> +		};
>> +	};
> 

-- 
Best Regards

Ramiro Oliveira
Ramiro.Oliveira@synopsys.com
