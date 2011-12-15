Return-path: <linux-media-owner@vger.kernel.org>
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:36313
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932500Ab1LOKSY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 05:18:24 -0500
Message-ID: <4EE9C95F.2090308@compulab.co.il>
Date: Thu, 15 Dec 2011 12:18:07 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
MIME-Version: 1.0
To: martin@neutronstar.dyndns.org
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
	Hiremath Vaibhav <hvaibhav@ti.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] arm: omap3evm: Add support for an MT9M032 based camera
 board.
References: <1323825934-13320-1-git-send-email-martin@neutronstar.dyndns.org> <4EE86CF7.1010002@compulab.co.il> <1323886442.815408.21905@localhost>
In-Reply-To: <1323886442.815408.21905@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/14/11 20:14, martin@neutronstar.dyndns.org wrote:
> On Wed, Dec 14, 2011 at 11:31:35AM +0200, Igor Grinberg wrote:
>> Hi Martin,
>>
>> On 12/14/11 03:25, Martin Hostettler wrote:
>>> Adds board support for an MT9M032 based camera to omap3evm.
>>>
>>> Signed-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>
>>> ---
>>>  arch/arm/mach-omap2/Makefile                |    3 +-
>>>  arch/arm/mach-omap2/board-omap3evm-camera.c |  155 +++++++++++++++++++++++++++
>>>  arch/arm/mach-omap2/board-omap3evm.c        |    4 +
>>>  3 files changed, 161 insertions(+), 1 deletions(-)
>>>  create mode 100644 arch/arm/mach-omap2/board-omap3evm-camera.c
>>>
>>> Changes in V3
>>>  * Added missing copyright and attribution.
>>>  * switched to gpio_request_array for gpio init.
>>>  * removed device_initcall and added call to omap3_evm_camera_init into omap3_evm_init
>>>
>>> Changes in V2:
>>>  * ported to current mainline
>>>  * Style fixes
>>>  * Fix error handling
>>>

[...]

>>> +/**
>>> + * omap3evm_set_mux - Sets mux to enable signal routing to
>>> + *                           different peripherals present on new EVM board
>>> + * @mux_id: enum, mux id to enable
>>> + *
>>> + * Returns 0 for success or a negative error code
>>> + */
>>> +static int omap3evm_set_mux(enum omap3evmdc_mux mux_id)
>>> +{
>>> +	/* Set GPIO6 = 1 */
>>> +	gpio_set_value_cansleep(EVM_TWL_GPIO_BASE + 6, 1);
>>> +	gpio_set_value_cansleep(EVM_TWL_GPIO_BASE + 2, 0);
>>> +
>>> +	switch (mux_id) {
>>> +	case MUX_TVP5146:
>>> +		gpio_set_value_cansleep(EVM_TWL_GPIO_BASE + 2, 0);
>>> +		gpio_set_value(nCAM_VD_SEL, 1);
>>> +		break;
>>> +
>>> +	case MUX_CAMERA_SENSOR:
>>> +		gpio_set_value_cansleep(EVM_TWL_GPIO_BASE + 2, 0);
>>> +		gpio_set_value(nCAM_VD_SEL, 0);
>>> +		break;
>>> +
>>> +	case MUX_EXP_CAMERA_SENSOR:
>>> +		gpio_set_value_cansleep(EVM_TWL_GPIO_BASE + 2, 1);
>>> +		break;
>>> +
>>> +	default:
>>> +		pr_err("omap3evm-camera: Invalid mux id #%d\n", mux_id);
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>
>> I don't really care about that, but I don't see any mux
>> being set in the above function so the name and comments
>> are misleading.
> 
> There's are video muxes on this board that's controlled by various
> gpios. It's not a mux in the omap chip if you've expected to see that.
> 
> As this is an evaluation board it has a bunch of video connectors that 
> the user can choose from for different input devices.

I see... Probably a comment explaining that would not hurt here.

[...]

>>> +
>>> +	omap_mux_init_gpio(nCAM_VD_SEL, OMAP_PIN_OUTPUT);
>>> +	ret = gpio_request_array(setup_gpios, ARRAY_SIZE(setup_gpios));
>>> +	if (ret < 0) {
>>> +		pr_err("omap3evm-camera: Failed to setup camera signal routing.\n");
>>> +		return ret;
>>> +	}
>>
>> It looks like both above calls (gpio_request and mux_init)
>> can be moved to omap3evm_set_mux() function (or a renamed version of it),
>> so all the GPIO stuff will be close to each other instead of requesting
>> in one place and playing with values in another...
> 
> I'd like to keep the one time setup and the theoretically run time switchable
> parts seperate. It doesn't complicate the code and if a brave soul wants to
> connect different camera modules and switch between them it's a more reviewable
> patch from here.

Ok

> 
>>
>>> +	omap3evm_set_mux(MUX_CAMERA_SENSOR);
>>
>> So the plan is to add support for the 3 types,
>> but hard code to only one?
>> Can't this be runtime detected somehow?
> 
> The mux code came from out of tree drivers. I did want to keep enough
> information so someone extending this board code for other setups doesn't have a
> hard time. I can't think of an reliable way to runtime detect what video source
> a specific use case would want. Ideally someone who needs one of the other
> video sources should add a more generic solution here. 

I'm Ok with it, but usually, stuff that is never used stays out...
I think the way it should be is to have a platform driver that uses
a callback to switch between the "muxes" on the extension.

[...]

-- 
Regards,
Igor.
