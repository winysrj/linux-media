Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:45914 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934279AbdIYL4B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 07:56:01 -0400
Subject: Re: [PATCHv4 3/3] drm/i915: add DisplayPort CEC-Tunneling-over-AUX
 support
To: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
References: <20170916141726.4921-1-hverkuil@xs4all.nl>
 <20170916141726.4921-4-hverkuil@xs4all.nl> <20170918130531.GW4914@intel.com>
 <24562161-6303-501b-fb28-25ee741e4bf5@xs4all.nl>
 <20170918143646.GB4914@intel.com>
 <d3cd40cc-1f91-29f5-fafa-f2bf0982916a@xs4all.nl>
 <20170918154929.GD4914@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a9c745ba-9bb7-684a-2dc2-60c91826997e@xs4all.nl>
Date: Mon, 25 Sep 2017 13:55:57 +0200
MIME-Version: 1.0
In-Reply-To: <20170918154929.GD4914@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ville,

On 18/09/17 17:49, Ville Syrjälä wrote:
> On Mon, Sep 18, 2017 at 05:26:43PM +0200, Hans Verkuil wrote:
>> On 09/18/2017 04:36 PM, Ville Syrjälä wrote:
>>> On Mon, Sep 18, 2017 at 04:07:41PM +0200, Hans Verkuil wrote:
>>>> Hi Ville,
>>>>
>>>> On 09/18/2017 03:05 PM, Ville Syrjälä wrote:
>>>>> On Sat, Sep 16, 2017 at 04:17:26PM +0200, Hans Verkuil wrote:
>>>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>>>
>>>>>> Implement support for this DisplayPort feature.
>>>>>>
>>>>>> The cec device is created whenever it detects an adapter that
>>>>>> has this feature. It is only removed when a new adapter is connected
>>>>>> that does not support this. If a new adapter is connected that has
>>>>>> different properties than the previous one, then the old cec device is
>>>>>> unregistered and a new one is registered to replace the old one.
>>>>>>
>>>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>>>> Tested-by: Carlos Santa <carlos.santa@intel.com>
>>>>>> ---
>>>>>>  drivers/gpu/drm/i915/intel_dp.c | 18 ++++++++++++++----
>>>>>>  1 file changed, 14 insertions(+), 4 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
>>>>>> index 64fa774c855b..fdb853d2c458 100644
>>>>>> --- a/drivers/gpu/drm/i915/intel_dp.c
>>>>>> +++ b/drivers/gpu/drm/i915/intel_dp.c
>>>>>> @@ -32,6 +32,7 @@
>>>>>>  #include <linux/notifier.h>
>>>>>>  #include <linux/reboot.h>
>>>>>>  #include <asm/byteorder.h>
>>>>>> +#include <media/cec.h>
>>>>>>  #include <drm/drmP.h>
>>>>>>  #include <drm/drm_atomic_helper.h>
>>>>>>  #include <drm/drm_crtc.h>
>>>>>> @@ -1449,6 +1450,7 @@ static void intel_aux_reg_init(struct intel_dp *intel_dp)
>>>>>>  static void
>>>>>>  intel_dp_aux_fini(struct intel_dp *intel_dp)
>>>>>>  {
>>>>>> +	cec_unregister_adapter(intel_dp->aux.cec_adap);
>>>>>>  	kfree(intel_dp->aux.name);
>>>>>>  }
>>>>>>  
>>>>>> @@ -4587,6 +4589,7 @@ intel_dp_set_edid(struct intel_dp *intel_dp)
>>>>>>  	intel_connector->detect_edid = edid;
>>>>>>  
>>>>>>  	intel_dp->has_audio = drm_detect_monitor_audio(edid);
>>>>>> +	cec_s_phys_addr_from_edid(intel_dp->aux.cec_adap, edid);
>>>>>>  }
>>>>>>  
>>>>>>  static void
>>>>>> @@ -4596,6 +4599,7 @@ intel_dp_unset_edid(struct intel_dp *intel_dp)
>>>>>>  
>>>>>>  	kfree(intel_connector->detect_edid);
>>>>>>  	intel_connector->detect_edid = NULL;
>>>>>> +	cec_phys_addr_invalidate(intel_dp->aux.cec_adap);
>>>>>>  
>>>>>>  	intel_dp->has_audio = false;
>>>>>>  }
>>>>>> @@ -4616,13 +4620,17 @@ intel_dp_long_pulse(struct intel_connector *intel_connector)
>>>>>>  	intel_display_power_get(to_i915(dev), intel_dp->aux_power_domain);
>>>>>>  
>>>>>>  	/* Can't disconnect eDP, but you can close the lid... */
>>>>>> -	if (is_edp(intel_dp))
>>>>>> +	if (is_edp(intel_dp)) {
>>>>>>  		status = edp_detect(intel_dp);
>>>>>> -	else if (intel_digital_port_connected(to_i915(dev),
>>>>>> -					      dp_to_dig_port(intel_dp)))
>>>>>> +	} else if (intel_digital_port_connected(to_i915(dev),
>>>>>> +						dp_to_dig_port(intel_dp))) {
>>>>>>  		status = intel_dp_detect_dpcd(intel_dp);
>>>>>> -	else
>>>>>> +		if (status == connector_status_connected)
>>>>>> +			drm_dp_cec_configure_adapter(&intel_dp->aux,
>>>>>> +				     intel_dp->aux.name, dev->dev);
>>>>>
>>>>> This is cluttering up the code a bit. Maybe do this call somewhere
>>>>> around the intel_dp_configure_mst() call instead since that seems to be
>>>>> the place where we start to do changes to externally visible state.
>>>>>
>>>>> Actually, do we want to register cec adapters for MST devices?
>>>>>
>>>>> And shouldn't we call this regardless of the connector state so that
>>>>> the cec adapter gets unregistered when the device is disconnected?
>>>>
>>>> This hasn't (AFAIK) anything to do with MST. This is in a branch device (i.e.
>>>> a DP to HDMI adapter).
>>>
>>> You are now potentiall registering the CEC adapter to the immediately
>>> upstream MST device (ie. the one that we talk to over the normal AUX stuff),
>>> but kms will consider that paticular connector as disconnected, and
>>> instead only sinks downstream of that device may have connected connectors
>>> associated with them. Presumably the CEC towards that device goes
>>> nowhere, and instead we'd have to talk to the remote branch devices
>>> somewhere downstream.
>>>
>>> Thus my question whether we want to potentially register the CEC adapter
>>> to the immediately upstream MST device or not. I would imagine not, and
>>> thus the call should perhaps be moved past the 'is_mst? -> disconnected'
>>> checks.
>>
>> Ah, now I see what you mean. Sorry, I misunderstood you earlier. I can
>> certainly move it down. But an MST device would never set the CEC capability
>> in the DPCD, would it?
> 
> It might. You don't even have to drive it as an MST device if you don't
> want to, or you source device might not even be capable of MST in which
> case you have not choice but to drive it in SST mode.

I really don't think it can set the CEC capability but I will have to dig
deeper into the spec to be 100% certain of that.

<snip>

>>>> I know doing this here is not ideal, but I have not found another way and I am
>>>> not even certain if it is possible at all, it might be intrinsic to how DP works.
>>>> I do not consider myself a DP expert, though.
>>>>
>>>> So this is how it works now, e.g. on my Intel NUC and a USB-C to HDMI adapter:
>>>>
>>>> 1) I connect the adapter (no HDMI connected yet): nothing happens.
>>>> 2) I connect the HDMI cable to the adapter: drm_dp_cec_configure_adapter is called and
>>>>    it detects the CEC capability in the DPCD. It now creates the CEC device.
>>>> 3) I disconnect the HDMI cable: the physical address of the CEC device is invalidated,
>>>>    but the CEC device is not removed.
>>>> 4) I disconnect the adapter: nothing happens.
>>>> 5) I reconnect the adapter: nothing happens.
>>>> 6) I reconnect the HDMI cable: drm_dp_cec_configure_adapter is called and it checks the
>>>>    DPCD. If the capabilities are unchanged, then it will continue to use the registered
>>>>    CEC device. If the capabilities have changed (i.e. the adapter is apparently a
>>>>    different one), then the CEC device is unregistered and a new one is created, provided
>>>>    that the new adapter supports CEC, of course.
>>>>
>>>> The bottom-line is that I cannot tell the difference between disconnecting the adapter
>>>> and disconnecting the HDMI cable to the adapter.
>>>>
>>>> Another consideration is that CEC applications (i.e. HTPCs) do not expect the CEC device
>>>> to disappear when you disconnect either the HDMI cable or the adapter. Even though the
>>>> CEC device is strictly speaking associated with the adapter, from the point of view of
>>>> the user there is no difference between disconnecting an HDMI cable from an adapter, or
>>>> disconnecting the adapter itself. So there is a good argument to be made to only unregister
>>>> the CEC device when a different (or no) adapter is detected the next time the HPD goes high.
>>>
>>> Should we just register a CEC adapter always then? Seems rather
>>> inconsistent to do it only when a CEC capable device gets plugged in but
>>> then leave it lingering around when the device gets disconnected.
>>
>> I thought about that, but that would clutter /dev with lots of non-functioning CEC
>> device nodes. CEC only becomes available if you have an HDMI adapter that actually
>> supports this. Most do not. And of course if you connect to a display using a DP
>> cable (i.e. without an HDMI adapter), then it is obviously not supported either.
>>
>> Another problem is that if you switch between adapters with different CEC capabilities,
>> then there is no way to signal that to userspace in the CEC API, and I don't think
>> that would be a good idea at all anyway.
>>
>> Having experimented with this for some time now I found that this is a good compromise
>> that fits how this is used in practice.
> 
> But what you have means userspace will still have to be prepared for the
> adapter to disappear at any point, so I don't really see what we gain by
> deferring the unregistration.

There are two situations: one is that the DP-to-HDMI adapter is integrated in
the hardware (such as on an Intel NUC with an HDMI output). In this case keeping the
cec device is exactly what you want.

The second situation is that the adapter is a separate dongle that can be
removed. Now keeping the cec device is almost always what you want, unless
the user is trying different adapters with different capabilities. In that
case CEC devices can indeed be unregistered. But you really have different
hardware in that case.

BTW, I've just tested a USB-C to dual DP MST hub and connecting a DP-to-HDMI
adapter with CEC support to see what happens, and the cec device did not
come up. So I need to do a bit more digging to understand why not. Since I
have a conference this week and am on vacation next week this might take some
time before I get around to it.

Regards,

	Hans
