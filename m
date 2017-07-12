Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:50666 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750993AbdGLTao (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 15:30:44 -0400
Subject: Re: [PATCH 2/4] drm/vc4: prepare for CEC support
To: Eric Anholt <eric@anholt.net>, linux-media@vger.kernel.org
References: <20170711112021.38525-1-hverkuil@xs4all.nl>
 <20170711112021.38525-3-hverkuil@xs4all.nl>
 <87fue1h4ya.fsf@eliezer.anholt.net>
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        boris.brezillon@free-electrons.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4d13e66b-a16b-a271-8978-db5ad67b6b76@xs4all.nl>
Date: Wed, 12 Jul 2017 21:30:40 +0200
MIME-Version: 1.0
In-Reply-To: <87fue1h4ya.fsf@eliezer.anholt.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/07/17 20:42, Eric Anholt wrote:
> Hans Verkuil <hverkuil@xs4all.nl> writes:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> In order to support CEC the hsm clock needs to be enabled in
>> vc4_hdmi_bind(), not in vc4_hdmi_encoder_enable(). Otherwise you wouldn't
>> be able to support CEC when there is no hotplug detect signal, which is
>> required by some monitors that turn off the HPD when in standby, but keep
>> the CEC bus alive so they can be woken up.
>>
>> The HDMI core also has to be enabled in vc4_hdmi_bind() for the same
>> reason.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Ccing Boris, I'd love to see what he thinks of this and if we can do any
> better.
> 
> Hans, is it true that CEC needs to be on always, or could it only be
> enabled when somebody is listening to messages?

It depends. If a valid physical address is read from the EDID (i.e. we are
connected to a display) then CEC has to be on always otherwise you can't receive
messages that the display (or others) send to you. Note that even if there is
no application listening to messages, the CEC framework will still listen to
and process CEC core messages and remote control passthrough messages.

If there is no physical address, for example because the hotplug detect is low,
then that is a special case: some displays will turn off the HPD when in standby,
but CEC still works. Devices can send an Image View On CEC message to wake up such
displays. This is a corner case explicitly allowed by the CEC spec. In my view this
is a hack in the specification just to work around broken displays. But such
displays really exist, unfortunately.

So in that case CEC has to be enabled only when we transmit a message.

This is what the CEC framework does: the adap_enabled callback is called with
true when a physical address is set and with false when the PA goes away. If you
transmit a message while there is no PA then adap_enabled is called with true
right before the transmit and with false when the transmit finished.

Regards,

	Hans

> 
>>  drivers/gpu/drm/vc4/vc4_hdmi.c | 59 +++++++++++++++++++++---------------------
>>  1 file changed, 29 insertions(+), 30 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
>> index ed63d4e85762..e0104f96011e 100644
>> --- a/drivers/gpu/drm/vc4/vc4_hdmi.c
>> +++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
>> @@ -463,11 +463,6 @@ static void vc4_hdmi_encoder_disable(struct drm_encoder *encoder)
>>  	HD_WRITE(VC4_HD_VID_CTL,
>>  		 HD_READ(VC4_HD_VID_CTL) & ~VC4_HD_VID_CTL_ENABLE);
>>  
>> -	HD_WRITE(VC4_HD_M_CTL, VC4_HD_M_SW_RST);
>> -	udelay(1);
>> -	HD_WRITE(VC4_HD_M_CTL, 0);
>> -
>> -	clk_disable_unprepare(hdmi->hsm_clock);
>>  	clk_disable_unprepare(hdmi->pixel_clock);
>>  
>>  	ret = pm_runtime_put(&hdmi->pdev->dev);
>> @@ -509,16 +504,6 @@ static void vc4_hdmi_encoder_enable(struct drm_encoder *encoder)
>>  		return;
>>  	}
>>  
>> -	/* This is the rate that is set by the firmware.  The number
>> -	 * needs to be a bit higher than the pixel clock rate
>> -	 * (generally 148.5Mhz).
>> -	 */
>> -	ret = clk_set_rate(hdmi->hsm_clock, 163682864);
>> -	if (ret) {
>> -		DRM_ERROR("Failed to set HSM clock rate: %d\n", ret);
>> -		return;
>> -	}
>> -
>>  	ret = clk_set_rate(hdmi->pixel_clock,
>>  			   mode->clock * 1000 *
>>  			   ((mode->flags & DRM_MODE_FLAG_DBLCLK) ? 2 : 1));
>> @@ -533,20 +518,6 @@ static void vc4_hdmi_encoder_enable(struct drm_encoder *encoder)
>>  		return;
>>  	}
>>  
>> -	ret = clk_prepare_enable(hdmi->hsm_clock);
>> -	if (ret) {
>> -		DRM_ERROR("Failed to turn on HDMI state machine clock: %d\n",
>> -			  ret);
>> -		clk_disable_unprepare(hdmi->pixel_clock);
>> -		return;
>> -	}
>> -
>> -	HD_WRITE(VC4_HD_M_CTL, VC4_HD_M_SW_RST);
>> -	udelay(1);
>> -	HD_WRITE(VC4_HD_M_CTL, 0);
>> -
>> -	HD_WRITE(VC4_HD_M_CTL, VC4_HD_M_ENABLE);
>> -
>>  	HDMI_WRITE(VC4_HDMI_SW_RESET_CONTROL,
>>  		   VC4_HDMI_SW_RESET_HDMI |
>>  		   VC4_HDMI_SW_RESET_FORMAT_DETECT);
>> @@ -1205,6 +1176,23 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
>>  		return -EPROBE_DEFER;
>>  	}
>>  
>> +	/* This is the rate that is set by the firmware.  The number
>> +	 * needs to be a bit higher than the pixel clock rate
>> +	 * (generally 148.5Mhz).
>> +	 */
>> +	ret = clk_set_rate(hdmi->hsm_clock, 163682864);
>> +	if (ret) {
>> +		DRM_ERROR("Failed to set HSM clock rate: %d\n", ret);
>> +		goto err_put_i2c;
>> +	}
>> +
>> +	ret = clk_prepare_enable(hdmi->hsm_clock);
>> +	if (ret) {
>> +		DRM_ERROR("Failed to turn on HDMI state machine clock: %d\n",
>> +			  ret);
>> +		goto err_put_i2c;
>> +	}
>> +
>>  	/* Only use the GPIO HPD pin if present in the DT, otherwise
>>  	 * we'll use the HDMI core's register.
>>  	 */
>> @@ -1216,7 +1204,7 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
>>  							 &hpd_gpio_flags);
>>  		if (hdmi->hpd_gpio < 0) {
>>  			ret = hdmi->hpd_gpio;
>> -			goto err_put_i2c;
>> +			goto err_unprepare_hsm;
>>  		}
>>  
>>  		hdmi->hpd_active_low = hpd_gpio_flags & OF_GPIO_ACTIVE_LOW;
>> @@ -1224,6 +1212,14 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
>>  
>>  	vc4->hdmi = hdmi;
>>  
>> +	/* HDMI core must be enabled. */
>> +	if (!(HD_READ(VC4_HD_M_CTL) & VC4_HD_M_ENABLE)) {
>> +		HD_WRITE(VC4_HD_M_CTL, VC4_HD_M_SW_RST);
>> +		udelay(1);
>> +		HD_WRITE(VC4_HD_M_CTL, 0);
>> +
>> +		HD_WRITE(VC4_HD_M_CTL, VC4_HD_M_ENABLE);
>> +	}
> 
> I'm wondering if there's any impact from leaving VC4_HD_M_ENABLE on
> while the HDMI power domain is off.  I don't quite understand the role
> of the power domain, and I've fired off an email internally to check if
> there are any experts on this hardware still around.
> 
