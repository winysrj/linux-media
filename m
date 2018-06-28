Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:55042 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S964885AbeF1Hgk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 03:36:40 -0400
Subject: Re: [PATCHv6 1/3] drm: add support for DisplayPort
 CEC-Tunneling-over-AUX
To: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Sean Paul <seanpaul@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Carlos Santa <carlos.santa@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180612111831.58210-1-hverkuil@xs4all.nl>
 <20180612111831.58210-2-hverkuil@xs4all.nl>
 <20180627175712.GH20518@intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c770ecf9-b2ab-8bf5-0143-c79310cdb26b@xs4all.nl>
Date: Thu, 28 Jun 2018 09:36:32 +0200
MIME-Version: 1.0
In-Reply-To: <20180627175712.GH20518@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/27/2018 07:57 PM, Ville Syrjälä wrote:
> On Tue, Jun 12, 2018 at 01:18:29PM +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> This adds support for the DisplayPort CEC-Tunneling-over-AUX
>> feature that is part of the DisplayPort 1.3 standard.
>>
>> Unfortunately, not all DisplayPort/USB-C to HDMI adapters with a
>> chip that has this capability actually hook up the CEC pin, so
>> even though a CEC device is created, it may not actually work.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/gpu/drm/Kconfig         |  10 +
>>  drivers/gpu/drm/Makefile        |   1 +
>>  drivers/gpu/drm/drm_dp_cec.c    | 423 ++++++++++++++++++++++++++++++++
>>  drivers/gpu/drm/drm_dp_helper.c |   1 +
>>  include/drm/drm_dp_helper.h     |  56 +++++
>>  5 files changed, 491 insertions(+)
>>  create mode 100644 drivers/gpu/drm/drm_dp_cec.c
>>

<snip>

>> +/*
>> + * When the EDID is unset because the HPD went low, then the CEC DPCD registers
>> + * typically can no longer be read (true for a DP-to-HDMI adapter since it is
>> + * powered by the HPD). However, some displays toggle the HPD off and on for a
>> + * short period for one reason or another, and that would cause the CEC adapter
>> + * to be removed and added again, even though nothing else changed.
>> + *
>> + * This module parameter sets a delay in seconds before the CEC adapter is
>> + * actually unregistered. Only if the HPD does not return within that time will
>> + * the CEC adapter be unregistered.
> 
> And whatever is trying to do cec is happy with the dpcd accesses
> failing during that time?

Correct. If there is no HPD, then the CEC adapter won't attempt to access dpcd.
And even if it does (e.g. if the HPD goes away in the middle of setting up a
transmit), that will just return an error.

> 
>> + *
>> + * If it is set to 0, then the CEC adapter will never be unregistered for as
>> + * long as the connector remains registered.
>> + *
>> + * Note that for integrated HDMI branch devices that support CEC the DPCD
>> + * registers remain available even if the HPD goes low since it is not powered
>> + * by the HPD. In that case the CEC adapter will never be unregistered during
>> + * the life time of the connector. At least, this is the theory since I do not
>> + * have hardware with an integrated HDMI branch device that supports CEC.
>> + */
>> +static unsigned int drm_dp_cec_unregister_delay = 1;
>> +module_param(drm_dp_cec_unregister_delay, uint, 0600);
>> +MODULE_PARM_DESC(drm_dp_cec_unregister_delay, "CEC unregister delay in seconds, 0 == never unregister");
>> +
>> +static int drm_dp_cec_adap_enable(struct cec_adapter *adap, bool enable)
>> +{
>> +	struct drm_dp_aux *aux = cec_get_drvdata(adap);
>> +	u32 val = enable ? DP_CEC_TUNNELING_ENABLE : 0;
>> +	ssize_t err = 0;
>> +
>> +	err = drm_dp_dpcd_writeb(aux, DP_CEC_TUNNELING_CONTROL, val);
>> +	return (enable && err < 0) ? err : 0;
>> +}
>> +
>> +static int drm_dp_cec_adap_log_addr(struct cec_adapter *adap, u8 addr)
>> +I think I looked at the dpcd detais last time around. {
>> +	struct drm_dp_aux *aux = cec_get_drvdata(adap);
>> +	/* Bit 15 (logical address 15) should always be set */
>> +	u16 la_mask = 1 << CEC_LOG_ADDR_BROADCAST;
>> +	u8 mask[2];
>> +	ssize_t err;
>> +
>> +	if (addr != CEC_LOG_ADDR_INVALID)
>> +		la_mask |= adap->log_addrs.log_addr_mask | (1 << addr);
>> +	mask[0] = la_mask & 0xff;
>> +	mask[1] = la_mask >> 8;
>> +	err = drm_dp_dpcd_write(aux, DP_CEC_LOGICAL_ADDRESS_MASK, mask, 2);
>> +	return (addr != CEC_LOG_ADDR_INVALID && err < 0) ? err : 0;
>> +}
>> +
>> +static int drm_dp_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
>> +				    u32 signal_free_time, struct cec_msg *msg)
> 
> 'msg' could be const perhaps?

No, this is a cec adapter callback, so I can't change the prototype unless I
change it for all CEC drivers. It should be const though, you are right about
that.

<snip>

>> +/*
>> + * A new EDID is set. If there is no CEC adapter, then create one. If
>> + * there was a CEC adapter, then check if the CEC adapter properties
>> + * were unchanged and just update the CEC physical address. Otherwise
>> + * unregister the old CEC adapter and create a new one.
>> + */
>> +void drm_dp_cec_set_edid(struct drm_dp_aux *aux, struct edid *edid)
> 
> 'edid' can be const.

Agreed.

<snip>

>> +/*
>> + * The EDID disappeared (likely because of the HPD going down).
>> + */
>> +void drm_dp_cec_unset_edid(struct drm_dp_aux *aux)
>> +{
>> +	mutex_lock(&aux->cec_mutex);
>> +	if (!aux->cec_adap)
>> +		goto unlock;
>> +	cec_phys_addr_invalidate(aux->cec_adap);
>> +	/*
>> +	 * We're done if we want to keep the CEC device
>> +	 * (drm_dp_cec_unregister_delay is 0) or if the DPCD still indicates
>> +	 * the CEC capability (expected for an integrated HDMI branch device).
>> +	 */
>> +	if (!drm_dp_cec_unregister_delay || drm_dp_cec_cap(aux, NULL))
>> +		goto unlock;
> 
> The drm_dp_cec_unregister_delay semantics seem a bit unnatural to me.
> I think ==0 -> no delay, <0 -> infinite delay would make more sense.
> Although we already have the exact opposite with the vblank_offdelay for
> some historical reason :(

I've changed it to:

0 = no delay
< 1000 = delay for that many seconds (default is 1)
>= 1000 = never unregister

> 
>> +
>> +	cancel_delayed_work_sync(&aux->cec_unregister_work);
> 
> This looks like a potential deadlock to me.

Yeah, fixed this.

> 
>> +	if (aux->cec_adap) {
>> +		/* sanity check */
>> +		if (drm_dp_cec_unregister_delay > 600)
>> +			drm_dp_cec_unregister_delay = 600;
>> +		/*
>> +		 * Unregister the CEC adapter after drm_dp_cec_unregister_delay
>> +		 * seconds. This to debounce short HPD off-and-on cycles from
>> +		 * displays.
>> +		 */
>> +		schedule_delayed_work(&aux->cec_unregister_work,
>> +				      drm_dp_cec_unregister_delay * HZ);
>> +	}
>> +unlock:
>> +	mutex_unlock(&aux->cec_mutex);
>> +}
>> +EXPORT_SYMBOL(drm_dp_cec_unset_edid);
>> @@ -1120,6 +1123,26 @@ struct drm_dp_aux {
>>  	 * @i2c_defer_count: Counts I2C DEFERs, used for DP validation.
>>  	 */
>>  	unsigned i2c_defer_count;
>> +	/**
>> +	 * @cec_mutex: mutex protecting the cec_ fields
>> +	 */
>> +	struct mutex cec_mutex;
>> +	/**
>> +	 * @cec_adap: the CEC adapter for CEC-Tunneling-over-AUX support.
>> +	 */
>> +	struct cec_adapter *cec_adap;
>> +	/**
>> +	 * @cec_name: name of the CEC adapter
>> +	 */
>> +	const char *cec_name;
>> +	/**
>> +	 * @cec_parent: parent device of the CEC adapter
>> +	 */
>> +	struct device *cec_parent;
>> +	/**
>> +	 * @cec_unregister_work: unregister the CEC adapter
>> +	 */
>> +	struct delayed_work cec_unregister_work;
> 
> 'struct { ... } cec;' could be a decent idea here.

I agree, changed this.

> 
> I think I looked at the dpcd detais last time around so I'll not bother
> this time around with that. Apart from the possible deadlock I think
> this is looking pretty good.

Thanks! I'll post a v7 with these changes.

Regards,

	Hans
