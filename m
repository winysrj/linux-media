Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17746 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbaCKNio (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 09:38:44 -0400
Message-id: <531F11DD.5040300@samsung.com>
Date: Tue, 11 Mar 2014 14:38:37 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
	mark.rutland@arm.com, galak@codeaurora.org,
	kyungmin.park@samsung.com, kgene.kim@samsung.com,
	a.hajda@samsung.com
Subject: Re: [PATCH v6 03/10] Documentation: devicetree: Update Samsung FIMC DT
 binding
References: <1394122819-9582-1-git-send-email-s.nawrocki@samsung.com>
 <1394122819-9582-4-git-send-email-s.nawrocki@samsung.com>
 <1608087.RUCeTiNcRR@avalon>
In-reply-to: <1608087.RUCeTiNcRR@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your review.

On 11/03/14 13:30, Laurent Pinchart wrote:
[...]
>> ---
>>  .../devicetree/bindings/media/samsung-fimc.txt     |   34 ++++++++++++-----
>>  1 file changed, 26 insertions(+), 8 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> b/Documentation/devicetree/bindings/media/samsung-fimc.txt index
>> 96312f6..dbd4020 100644
>> --- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> +++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> @@ -32,6 +32,21 @@ way around.
>>
>>  The 'camera' node must include at least one 'fimc' child node.
>>
>> +Optional properties:
>> +
>> +- #clock-cells: from the common clock bindings
>> (../clock/clock-bindings.txt),
>> +  must be 1. A clock provider is associated with the 'camera' node and it
>> should
>> +  be referenced by external sensors that use clocks provided by the SoC on
>> +  CAM_*_CLKOUT pins. The clock specifier cell stores an index of a clock.
>> +  The indices are 0, 1 for CAM_A_CLKOUT, CAM_B_CLKOUT clocks respectively.
>> +
>> +- clock-output-names: from the common clock bindings, should contain names
>> of
>> +  clocks registered by the camera subsystem corresponding to CAM_A_CLKOUT,
>> +  CAM_B_CLKOUT output clocks respectively.
> 
> Wouldn't it be better to document the "cam_mclk_a" and "cam_mclk_b" names 
> explicitly ? Or do you expect different names to be used in different DT files 
> ? And as they correspond to the CAM_A_CLKOUT and CAM_B_CLKOUT pins, shouldn't 
> they be named "cam_a_clkout" and "cam_b_clkout" ?

Basically I could use fixed names for these clocks, I just wanted to keep
a possibility to override them in dts to avoid any possible clock name
collisions, rather than keep a list of different names per SoC in the driver. 
Right now fixed names could also be used for all SoCs I'm aware of, 
nevertheless I would prefer to keep the clock-output-names property.
"cam_a_clkout", "cam_b_clkout" may be indeed better names, I'll change
that.

>> +Note: #clock-cells and clock-output-names are mandatory properties if
>> external
>> +image sensor devices reference 'camera' device node as a clock provider.
>> +
> 
> What's the reason not to make them always mandatory ? Backward compatibility 
> only ? If so wouldn't it make sense to document the properties as mandatory 
> from now on, and treating them as optional in the driver for backward 
> compatibility ?

Yes, it's for backwards compatibility only. It may be a good idea to just 
document them as required, since this is how the device is expected to be 
described in DT from now. I'll just make these a required properties, 
the driver already handles them as optional.

>>  'fimc' device nodes
>>  -------------------
>>
>> @@ -97,8 +112,8 @@ Image sensor nodes
>>  The sensor device nodes should be added to their control bus controller
>> (e.g. I2C0) nodes and linked to a port node in the csis or the
>> parallel-ports node, using the common video interfaces bindings, defined in
>> video-interfaces.txt.
>> -The implementation of this bindings requires clock-frequency property to be
>> -present in the sensor device nodes.
>> +An optional clock-frequency property needs to be present in the sensor
>> device
>> +nodes. Default value when this property is not present is 24 MHz.
> 
> This bothers me. Having the FIMC driver read the clock-frequence property from 
> the sensor DT nodes feels like a layering violation. Shouldn't the sensor 
> drivers call clk_set_rate() explicitly instead ?

It is supposed to do so, after this whole patch series. So the camera
controller driver will not need such properties. What do you think about
removing this sentence altogether ?

>>  Example:
>>
>> @@ -114,7 +129,7 @@ Example:
>>  			vddio-supply = <...>;
>>
>>  			clock-frequency = <24000000>;
>> -			clocks = <...>;
>> +			clocks = <&camera 1>;
>>  			clock-names = "mclk";
>>
>>  			port {
>> @@ -135,7 +150,7 @@ Example:
>>  			vddio-supply = <...>;
>>
>>  			clock-frequency = <24000000>;
>> -			clocks = <...>;
>> +			clocks = <&camera 0>;
>>  			clock-names = "mclk";
>>
>>  			port {
>> @@ -149,12 +164,15 @@ Example:
>>
>>  	camera {
>>  		compatible = "samsung,fimc", "simple-bus";
>> -		#address-cells = <1>;
>> -		#size-cells = <1>;
>> -		status = "okay";
>> -
>> +		clocks = <&clock 132>, <&clock 133>;
>> +		clock-names = "sclk_cam0", "sclk_cam1";
> 
> The documentation mentions that clock-names must contain "sclk_cam0", 
> "sclk_cam1", "pxl_async0", "pxl_async1". Are the last two optional ? If so I 
> think you should clarify the description of the clock-names property. This can 
> be done in a separate patch.

"pxl_async0", "pxl_async1" are mandatory, I'll add them also into
this example dts.

>> +		#clock-cells = <1>;
>> +		clock-output-names = "cam_mclk_a", "cam_mclk_b";
>>  		pinctrl-names = "default";
>>  		pinctrl-0 = <&cam_port_a_clk_active>;
>> +		status = "okay";
>> +		#address-cells = <1>;
>> +		#size-cells = <1>;
>>
>>  		/* parallel camera ports */
>>  		parallel-ports {

--
Regards,
Sylwester
