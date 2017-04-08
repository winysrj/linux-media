Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:46956 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752520AbdDHK5y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 8 Apr 2017 06:57:54 -0400
Subject: Re: [RFC PATCH 3/3] encoder-tpd12s015: keep the ls_oe_gpio on while
 the phys_addr is valid
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-media@vger.kernel.org
References: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
 <1461922746-17521-4-git-send-email-hverkuil@xs4all.nl>
 <5731C7D2.4090807@ti.com> <5b6f679c-69dd-78be-a398-30aa4b4da1db@xs4all.nl>
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a5692a6e-e923-96e8-3491-6c50ce99eebf@xs4all.nl>
Date: Sat, 8 Apr 2017 12:57:47 +0200
MIME-Version: 1.0
In-Reply-To: <5b6f679c-69dd-78be-a398-30aa4b4da1db@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/08/2017 12:11 PM, Hans Verkuil wrote:
> Hi Tomi,
> 
> On 05/10/2016 01:36 PM, Tomi Valkeinen wrote:
>> Hi Hans,
>>
>> On 29/04/16 12:39, Hans Verkuil wrote:
>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> As long as there is a valid physical address in the EDID and the omap
>>> CEC support is enabled, then we keep ls_oe_gpio on to ensure the CEC
>>> signal is passed through the tpd12s015.
>>>
>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>> Suggested-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
>>> ---
>>>  drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c | 13 ++++++++++++-
>>>  1 file changed, 12 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c b/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c
>>> index 916a899..efbba23 100644
>>> --- a/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c
>>> +++ b/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c
>>> @@ -16,6 +16,7 @@
>>>  #include <linux/platform_device.h>
>>>  #include <linux/gpio/consumer.h>
>>>  
>>> +#include <media/cec-edid.h>
>>>  #include <video/omapdss.h>
>>>  #include <video/omap-panel-data.h>
>>>  
>>> @@ -65,6 +66,7 @@ static void tpd_disconnect(struct omap_dss_device *dssdev,
>>>  		return;
>>>  
>>>  	gpiod_set_value_cansleep(ddata->ct_cp_hpd_gpio, 0);
>>> +	gpiod_set_value_cansleep(ddata->ls_oe_gpio, 0);
>>>  
>>>  	dst->src = NULL;
>>>  	dssdev->dst = NULL;
>>> @@ -142,6 +144,7 @@ static int tpd_read_edid(struct omap_dss_device *dssdev,
>>>  {
>>>  	struct panel_drv_data *ddata = to_panel_data(dssdev);
>>>  	struct omap_dss_device *in = ddata->in;
>>> +	bool valid_phys_addr = 0;
>>>  	int r;
>>>  
>>>  	if (!gpiod_get_value_cansleep(ddata->hpd_gpio))
>>> @@ -151,7 +154,15 @@ static int tpd_read_edid(struct omap_dss_device *dssdev,
>>>  
>>>  	r = in->ops.hdmi->read_edid(in, edid, len);
>>>  
>>> -	gpiod_set_value_cansleep(ddata->ls_oe_gpio, 0);
>>> +#ifdef CONFIG_OMAP2_DSS_HDMI_CEC
>>> +	/*
>>> +	 * In order to support CEC this pin should remain high
>>> +	 * as long as the EDID has a valid physical address.
>>> +	 */
>>> +	valid_phys_addr =
>>> +		cec_get_edid_phys_addr(edid, r, NULL) != CEC_PHYS_ADDR_INVALID;
>>> +#endif
>>> +	gpiod_set_value_cansleep(ddata->ls_oe_gpio, valid_phys_addr);
>>>  
>>>  	return r;
>>>  }
>>
>> I think this works, but... Maybe it would be cleaner to have the LS_OE
>> enabled if a cable is connected. That's actually what we had earlier,
>> but I removed that due to a race issue:
>>
>> a87a6d6b09de3118e5679c2057b99b7791b7673b ("OMAPDSS: encoder-tpd12s015:
>> Fix race issue with LS_OE"). Now, with CEC, there's need to have LS_OE
>> enabled even after reading the EDID, so I think it's better to go back
>> to the old model (after fixing the race issue, of course =).
> 
> So, this is a bit of a blast from the past since the omap4 CEC development
> has been on hold for almost a year. But I am about to resume my work on this
> now that the CEC framework was merged.
> 
> The latest code is here, if you are interested:
> 
> https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=panda-cec
> 
> It's pretty much unchanged from the version I posted a year ago, just rebased.
> 
> But before I continue with this I have one question for you. First some
> background:
> 
> There is a special corner case (and I wasn't aware of that a year ago!) where
> it is allowed to send a CEC message when there is *no HPD*.
> 
> The reason is that some displays turn off the hotplug detect pin when they go
> into standby or when another input is active. The only way to communicate with
> such displays is via CEC.
> 
> The problem is that without a HPD there is no EDID and basically no way for an
> HDMI transmitter to detect that something is connected at all, unless you are
> using CEC.
> 
> What this means is that if we want to implement this on the omap4 the CEC support
> has to be on all the time.
> 
> We have seen modern displays that behave like this, so this is a real issue. And
> this corner case is specifically allowed by the CEC specification: the Poll,
> Image/Text View On and the Active Source messages can be sent to a TV even when
> there is no HPD in order to turn on the display if it was in standby and to make
> us the active input.
> 
> The CEC framework in the kernel supports this starting with 4.12 (this code is
> in the panda-cec branch above).
> 
> If this *can't* be supported by the omap4, then I will likely have to add a CEC
> capability to signal to the application that this specific corner case is not
> supported.

FYI: I've just added support for this to the panda-cec branch. CEC on the omap4
now works again, but you can't send CEC messages as long as there is no valid
physical address.

Regards,

	Hans

> 
> I just did some tests with omap4 and I my impression is that this can't be
> supported: when the HPD goes away it seems like most/all of the HDMI blocks are
> all powered off and any attempt to even access the CEC registers will fail.
> 
> Changing this looks to be non-trivial if not impossible.
> 
> Can you confirm that that isn't possible? If you think this can be done, then
> I'd appreciate if you can give me a few pointers.
> 
> Regards,
> 
> 	Hans
> 
