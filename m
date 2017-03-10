Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:50234 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935866AbdCJJiV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 04:38:21 -0500
Subject: Re: [PATCHv3 01/15] ov7670: document device tree bindings
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <20170306145616.38485-1-hverkuil@xs4all.nl>
 <20170306145616.38485-2-hverkuil@xs4all.nl>
 <20170309180142.GO3220@valkosipuli.retiisi.org.uk>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <581f1c07-5056-67d0-0035-96fbee273f44@xs4all.nl>
Date: Fri, 10 Mar 2017 10:38:17 +0100
MIME-Version: 1.0
In-Reply-To: <20170309180142.GO3220@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/17 19:01, Sakari Ailus wrote:
> Hi Hans,
> 
> On Mon, Mar 06, 2017 at 03:56:02PM +0100, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add binding documentation and add that file to the MAINTAINERS entry.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  .../devicetree/bindings/media/i2c/ov7670.txt       | 44 ++++++++++++++++++++++
>>  MAINTAINERS                                        |  1 +
>>  2 files changed, 45 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7670.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov7670.txt b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
>> new file mode 100644
>> index 000000000000..6d9c90dff7a7
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
>> @@ -0,0 +1,44 @@
>> +* Omnivision OV7670 CMOS sensor
>> +
>> +The Omnivision OV7670 sensor supports multiple resolutions output, such as
>> +CIF, SVGA, UXGA. It also can support the YUV422/420, RGB565/555 or raw RGB
>> +output formats.
>> +
>> +Required Properties:
>> +- compatible: should be "ovti,ov7670"
>> +- clocks: reference to the xclk input clock.
>> +- clock-names: should be "xclk".
>> +
>> +Optional Properties:
>> +- reset-gpios: reference to the GPIO connected to the resetb pin, if any.
>> +  Active is low.
>> +- powerdown-gpios: reference to the GPIO connected to the pwdn pin, if any.
>> +  Active is high.
>> +
>> +The device node must contain one 'port' child node for its digital output
>> +video port, in accordance with the video interface bindings defined in
>> +Documentation/devicetree/bindings/media/video-interfaces.txt.
>> +
>> +Example:
>> +
>> +	i2c1: i2c@f0018000 {
>> +		ov7670: camera@21 {
>> +			compatible = "ovti,ov7670";
>> +			reg = <0x21>;
>> +			pinctrl-names = "default";
>> +			pinctrl-0 = <&pinctrl_pck0_as_isi_mck &pinctrl_sensor_power &pinctrl_sensor_reset>;
>> +			reset-gpios = <&pioE 11 GPIO_ACTIVE_LOW>;
>> +			powerdown-gpios = <&pioE 13 GPIO_ACTIVE_HIGH>;
>> +			clocks = <&pck0>;
>> +			clock-names = "xclk";
>> +			assigned-clocks = <&pck0>;
>> +			assigned-clock-rates = <25000000>;
>> +
>> +			port {
>> +				ov7670_0: endpoint {
>> +					remote-endpoint = <&isi_0>;
>> +					bus-width = <8>;
> 
> Didn't I previously request to specify which of the standardised properties
> are relevant for the device (and which ones are required and which are
> optional)? If I didn't, I'm doing that now. :-)
> 
> E.g. the omap3isp driver documentation looks like this:
> 
> Documentation/devicetree/bindings/media/ti,omap3isp.txt

I did document this in the atmel-isi bindings.

The real issue here is that bus-width is simply ignored by the ov7670 driver,
so it likely can be removed from the example in this document.

I clearly state the required and optional properties in this document, it is
just the example that is out-dated.

Regards,

	Hans

> 
>> +				};
>> +			};
>> +		};
>> +	};
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 83a42ef1d1a7..93500928ca4f 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -9273,6 +9273,7 @@ L:	linux-media@vger.kernel.org
>>  T:	git git://linuxtv.org/media_tree.git
>>  S:	Maintained
>>  F:	drivers/media/i2c/ov7670.c
>> +F:	Documentation/devicetree/bindings/media/i2c/ov7670.txt
>>  
>>  ONENAND FLASH DRIVER
>>  M:	Kyungmin Park <kyungmin.park@samsung.com>
> 
