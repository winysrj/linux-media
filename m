Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.133]:53296 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdL0Ak4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Dec 2017 19:40:56 -0500
Reply-To: zhengsq@rock-chips.com
Subject: Re: [PATCH 4/4] [media] dt/bindings: Add bindings for OV2685
To: Rob Herring <robh@kernel.org>
Cc: mchehab@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org
References: <1514211086-13440-1-git-send-email-zhengsq@rock-chips.com>
 <1514211086-13440-4-git-send-email-zhengsq@rock-chips.com>
 <20171226232855.egppgy22ywketxi6@rob-hp-laptop>
From: Shunqian Zheng <zhengsq@rock-chips.com>
Message-ID: <22962a7f-5067-0b9c-0dd0-2de11d8b9ad8@rock-chips.com>
Date: Wed, 27 Dec 2017 08:40:44 +0800
MIME-Version: 1.0
In-Reply-To: <20171226232855.egppgy22ywketxi6@rob-hp-laptop>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rob,

On 2017年12月27日 07:28, Rob Herring wrote:
> On Mon, Dec 25, 2017 at 10:11:26PM +0800, Shunqian Zheng wrote:
>> Add device tree binding documentation for the OV2685 sensor.
>>
>> Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
>> ---
>>   .../devicetree/bindings/media/i2c/ov2685.txt       | 35 ++++++++++++++++++++++
>>   1 file changed, 35 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2685.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov2685.txt b/Documentation/devicetree/bindings/media/i2c/ov2685.txt
>> new file mode 100644
>> index 0000000..c62db9c
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/ov2685.txt
>> @@ -0,0 +1,35 @@
>> +* Omnivision OV2685 MIPI CSI-2 sensor
>> +
>> +Required Properties:
>> +- compatible: should be "ovti,ov2685"
>> +- clocks: reference to the 24M xvclk input clock.
>> +- clock-names: should be "xvclk".
>> +- avdd-supply: Analog voltage supply, 2.8 volts
>> +- dvdd-supply: Digital core voltage supply, 1.2 volts
>> +- reset-gpios: Low active reset gpio
>> +
>> +The device node must contain one 'port' child node for its digital output
>> +video port, in accordance with the video interface bindings defined in
>> +Documentation/devicetree/bindings/media/video-interfaces.txt.
>> +
>> +Example:
>> +	ucam: ov2680@3c {
> camera-sensor@3c
>
>> +		compatible = "ovti,ov2685";
>> +		reg = <0x3c>;
>> +		pinctrl-names = "default";
>> +		pinctrl-0 = <&clk_24m_cam &ucam_rst>;
> Not documented.
The &clk_24m_cam is pin mux on my rk3399. While the &ucam_rst is board 
special pin, I should remove it in Document.

Thanks,

Shunqian

>
>> +
>> +		clocks = <&cru SCLK_TESTCLKOUT1>;
>> +		clock-names = "xvclk";
>> +
>> +		avdd-supply = <&pp2800_cam>;
>> +		dovdd-supply = <&pp1800>;
>> +		reset-gpios = <&gpio2 3 GPIO_ACTIVE_LOW>;
>> +
>> +		port {
>> +			ucam_out: endpoint {
>> +				remote-endpoint = <&mipi_in_ucam>;
>> +				data-lanes = <1>;
>> +			};
>> +		};
>> +	};
>> -- 
>> 1.9.1
>>
>
>
