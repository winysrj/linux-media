Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35912 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbdAMXLN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jan 2017 18:11:13 -0500
Subject: Re: [PATCH v3 06/24] ARM: dts: imx6-sabrelite: add OV5642 and OV5640
 camera sensors
To: Philipp Zabel <p.zabel@pengutronix.de>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-7-git-send-email-steve_longerbeam@mentor.com>
 <1484309021.31475.29.camel@pengutronix.de>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <1bb64209-7c58-fe10-3db9-c5b8103eda90@gmail.com>
Date: Fri, 13 Jan 2017 15:04:30 -0800
MIME-Version: 1.0
In-Reply-To: <1484309021.31475.29.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/13/2017 04:03 AM, Philipp Zabel wrote:
> Am Freitag, den 06.01.2017, 18:11 -0800 schrieb Steve Longerbeam:
>> Enables the OV5642 parallel-bus sensor, and the OV5640 MIPI CSI-2 sensor.
>> Both hang off the same i2c2 bus, so they require different (and non-
>> default) i2c slave addresses.
>>
>> The OV5642 connects to the parallel-bus mux input port on ipu1_csi0_mux.
>>
>> The OV5640 connects to the input port on the MIPI CSI-2 receiver on
>> mipi_csi. It is set to transmit over MIPI virtual channel 1.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> ---
>>   arch/arm/boot/dts/imx6dl-sabrelite.dts   |   5 ++
>>   arch/arm/boot/dts/imx6q-sabrelite.dts    |   6 ++
>>   arch/arm/boot/dts/imx6qdl-sabrelite.dtsi | 118 +++++++++++++++++++++++++++++++
>>   3 files changed, 129 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/imx6dl-sabrelite.dts b/arch/arm/boot/dts/imx6dl-sabrelite.dts
>> index 0f06ca5..fec2524 100644
>> --- a/arch/arm/boot/dts/imx6dl-sabrelite.dts
>> +++ b/arch/arm/boot/dts/imx6dl-sabrelite.dts
>> @@ -48,3 +48,8 @@
>>   	model = "Freescale i.MX6 DualLite SABRE Lite Board";
>>   	compatible = "fsl,imx6dl-sabrelite", "fsl,imx6dl";
>>   };
>> +
>> +&ipu1_csi1_from_ipu1_csi1_mux {
>> +	data-lanes = <0 1>;
>> +	clock-lanes = <2>;
>> +};
>> diff --git a/arch/arm/boot/dts/imx6q-sabrelite.dts b/arch/arm/boot/dts/imx6q-sabrelite.dts
>> index 66d10d8..9e2d26d 100644
>> --- a/arch/arm/boot/dts/imx6q-sabrelite.dts
>> +++ b/arch/arm/boot/dts/imx6q-sabrelite.dts
>> @@ -52,3 +52,9 @@
>>   &sata {
>>   	status = "okay";
>>   };
>> +
>> +&ipu1_csi1_from_mipi_vc1 {
>> +	data-lanes = <0 1>;
>> +	clock-lanes = <2>;
>> +};
>> +
>> diff --git a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
>> index 795b5a5..bca9fed 100644
>> --- a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
>> +++ b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
>> @@ -39,6 +39,8 @@
>>    *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
>>    *     OTHER DEALINGS IN THE SOFTWARE.
>>    */
>> +
>> +#include <dt-bindings/clock/imx6qdl-clock.h>
>>   #include <dt-bindings/gpio/gpio.h>
>>   #include <dt-bindings/input/input.h>
>>   
>> @@ -96,6 +98,15 @@
>>   		};
>>   	};
>>   
>> +	mipi_xclk: mipi_xclk {
>> +		compatible = "pwm-clock";
>> +		#clock-cells = <0>;
>> +		clock-frequency = <22000000>;
>> +		clock-output-names = "mipi_pwm3";
>> +		pwms = <&pwm3 0 45>; /* 1 / 45 ns = 22 MHz */
>> +		status = "okay";
>> +	};
>> +
>>   	gpio-keys {
>>   		compatible = "gpio-keys";
>>   		pinctrl-names = "default";
>> @@ -220,6 +231,22 @@
>>   	};
>>   };
>>   
>> +&ipu1_csi0_from_ipu1_csi0_mux {
>> +	bus-width = <8>;
>> +	data-shift = <12>; /* Lines 19:12 used */
>> +	hsync-active = <1>;
>> +	vync-active = <1>;
>> +};
>> +
>> +&ipu1_csi0_mux_from_parallel_sensor {
>> +	remote-endpoint = <&ov5642_to_ipu1_csi0_mux>;
>> +};
>> +
>> +&ipu1_csi0 {
>> +	pinctrl-names = "default";
>> +	pinctrl-0 = <&pinctrl_ipu1_csi0>;
>> +};
>> +
>>   &audmux {
>>   	pinctrl-names = "default";
>>   	pinctrl-0 = <&pinctrl_audmux>;
>> @@ -299,6 +326,52 @@
>>   	pinctrl-names = "default";
>>   	pinctrl-0 = <&pinctrl_i2c2>;
>>   	status = "okay";
>> +
>> +	ov5640: camera@40 {
>> +		compatible = "ovti,ov5640";
>> +		pinctrl-names = "default";
>> +		pinctrl-0 = <&pinctrl_ov5640>;
>> +		clocks = <&mipi_xclk>;
>> +		clock-names = "xclk";
>> +		reg = <0x40>;
>> +		xclk = <22000000>;
> This is superfluous, you can use clk_get_rate on mipi_xclk.

This property is actually there to tell the driver what to set the
rate to, with clk_set_rate(). So you are saying it would be better
to set the rate in the device tree and the driver should only
retrieve the rate?

Steve

