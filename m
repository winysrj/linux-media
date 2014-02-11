Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-081.synserver.de ([212.40.185.81]:1044 "EHLO
	smtp-out-003.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751071AbaBKMVv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 07:21:51 -0500
Message-ID: <52FA15E4.50001@metafoo.de>
Date: Tue, 11 Feb 2014 13:21:56 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Hans Verkuil <hansverk@cisco.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 45/47] adv7604: Add DT support
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com> <1391618558-5580-46-git-send-email-laurent.pinchart@ideasonboard.com> <52F9EBF7.5020000@xs4all.nl> <2643485.CLBhVGBayq@avalon> <52FA140F.9060200@cisco.com>
In-Reply-To: <52FA140F.9060200@cisco.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/11/2014 01:14 PM, Hans Verkuil wrote:
>
>
> On 02/11/14 13:08, Laurent Pinchart wrote:
>> Hi Hans,
>>
>> On Tuesday 11 February 2014 10:23:03 Hans Verkuil wrote:
>>> On 02/05/14 17:42, Laurent Pinchart wrote:
>>>> Parse the device tree node to populate platform data.
>>>>
>>>> Cc: devicetree@vger.kernel.org
>>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>> ---
>>>>
>>>>   .../devicetree/bindings/media/i2c/adv7604.txt      |  56 ++++++++++++
>>>>   drivers/media/i2c/adv7604.c                        | 101 ++++++++++++++--
>>>>   2 files changed, 143 insertions(+), 14 deletions(-)
>>>>   create mode 100644
>>>>   Documentation/devicetree/bindings/media/i2c/adv7604.txt
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
>>>> b/Documentation/devicetree/bindings/media/i2c/adv7604.txt new file mode
>>>> 100644
>>>> index 0000000..0845c50
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
>>>> @@ -0,0 +1,56 @@
>>>> +* Analog Devices ADV7604/11 video decoder with HDMI receiver
>>>> +
>>>> +The ADV7604 and ADV7611 are multiformat video decoders with an integrated
>>>> HDMI +receiver. The ADV7604 has four multiplexed HDMI inputs and one
>>>> analog input, +and the ADV7611 has one HDMI input and no analog input.
>>>> +
>>>> +Required Properties:
>>>> +
>>>> +  - compatible: Must contain one of the following
>>>> +    - "adi,adv7604" for the ADV7604
>>>> +    - "adi,adv7611" for the ADV7611
>>>> +
>>>> +  - reg: I2C slave address
>>>> +
>>>> +  - hpd-gpios: References to the GPIOs that control the HDMI hot-plug
>>>> +    detection pins, one per HDMI input. The active flag indicates the
>>>> GPIO
>>>> +    level that enables hot-plug detection.
>>>> +
>>>> +Optional Properties:
>>>> +
>>>> +  - reset-gpios: Reference to the GPIO connected to the device's reset
>>>> pin. +
>>>> +  - adi,default-input: Index of the input to be configured as default.
>>>> Valid +    values are 0..5 for the ADV7604 and 0 for the ADV7611.
>>>> +
>>>> +  - adi,disable-power-down: Boolean property. When set forces the device
>>>> to +    ignore the power-down pin. The property is valid for the ADV7604
>>>> only as +    the ADV7611 has no power-down pin.
>>>> +
>>>> +  - adi,disable-cable-reset: Boolean property. When set disables the HDMI
>>>> +    receiver automatic reset when the HDMI cable is unplugged.
>>>> +
>>>> +Example:
>>>> +
>>>> +	hdmi_receiver@4c {
>>>> +		compatible = "adi,adv7611";
>>>> +		reg = <0x4c>;
>>>> +
>>>> +		reset-gpios = <&ioexp 0 GPIO_ACTIVE_LOW>;
>>>> +		hpd-gpios = <&ioexp 2 GPIO_ACTIVE_HIGH>;
>>>> +
>>>> +		adi,default-input = <0>;
>>>> +
>>>> +		#address-cells = <1>;
>>>> +		#size-cells = <0>;
>>>> +
>>>> +		port@0 {
>>>> +			reg = <0>;
>>>> +		};
>>>> +		port@1 {
>>>> +			reg = <1>;
>>>> +			hdmi_in: endpoint {
>>>> +				remote-endpoint = <&ccdc_in>;
>>>> +			};
>>>> +		};
>>>> +	};
>>>> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
>>>> index e586c1c..cd8a2dc 100644
>>>> --- a/drivers/media/i2c/adv7604.c
>>>> +++ b/drivers/media/i2c/adv7604.c
>>>> @@ -32,6 +32,7 @@
>>>>
>>>>   #include <linux/i2c.h>
>>>>   #include <linux/kernel.h>
>>>>   #include <linux/module.h>
>>>>
>>>> +#include <linux/of_gpio.h>
>>>>
>>>>   #include <linux/slab.h>
>>>>   #include <linux/v4l2-dv-timings.h>
>>>>   #include <linux/videodev2.h>
>>>>
>>>> @@ -2641,13 +2642,83 @@ static const struct adv7604_chip_info
>>>> adv7604_chip_info[] = {>
>>>>   	},
>>>>
>>>>   };
>>>>
>>>> +static struct i2c_device_id adv7604_i2c_id[] = {
>>>> +	{ "adv7604", (kernel_ulong_t)&adv7604_chip_info[ADV7604] },
>>>> +	{ "adv7611", (kernel_ulong_t)&adv7604_chip_info[ADV7611] },
>>>> +	{ }
>>>> +};
>>>> +MODULE_DEVICE_TABLE(i2c, adv7604_i2c_id);
>>>> +
>>>> +static struct of_device_id adv7604_of_id[] = {
>>>> +	{ .compatible = "adi,adv7604", .data = &adv7604_chip_info[ADV7604] },
>>>> +	{ .compatible = "adi,adv7611", .data = &adv7604_chip_info[ADV7611] },
>>>> +	{ }
>>>> +};
>>>> +MODULE_DEVICE_TABLE(of, adv7604_of_id);
>>>> +
>>>> +static int adv7604_parse_dt(struct adv7604_state *state)
>>>
>>> Put this under #ifdef CONFIG_OF.
>>
>> #ifdef CONFIG_OF has been discouraged. I'll add an IS_ENABLED(CONFIG_OF) to
>> condition the call of adv7604_parse_dt() and let the compiler optimize the
>> function out, but I've been recommended to fix compilation errors instead of
>> using conditional compilation.
>>
>>> It fails to compile if CONFIG_OF is not set (as it is in my case since this
>>> driver is used with a PCIe card).
>>
>> What's the compilation failure ?
>
> drivers/media/i2c/adv7604.c: In function ‘adv7604_parse_dt’:
> drivers/media/i2c/adv7604.c:2671:48: warning: dereferencing ‘void *’ pointer [enabled by default]
>    state->info = of_match_node(adv7604_of_id, np)->data;
>                                                  ^
> drivers/media/i2c/adv7604.c:2671:48: error: request for member ‘data’ in something not a structure or union
> make[3]: *** [drivers/media/i2c/adv7604.o] Error 1

That looks like a bug in the stubbed out version of of_match_node(). It 
should be a inline function with a return type, rather than a macro.

- Lars
