Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38931 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751062AbeEPSxI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 14:53:08 -0400
Received: by mail-wm0-f68.google.com with SMTP id f8-v6so4260655wmc.4
        for <linux-media@vger.kernel.org>; Wed, 16 May 2018 11:53:08 -0700 (PDT)
Subject: Re: [Intel-gfx] [PATCH v2 2/5] drm/i915: hdmi: add CEC notifier to
 intel_hdmi
To: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: airlied@linux.ie, hans.verkuil@cisco.com, lee.jones@linaro.org,
        olof@lixom.net, seanpaul@google.com, sadolfsson@google.com,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, fparent@baylibre.com,
        felixe@google.com, bleung@google.com, darekm@google.com,
        linux-media@vger.kernel.org
References: <1526395342-15481-1-git-send-email-narmstrong@baylibre.com>
 <1526395342-15481-3-git-send-email-narmstrong@baylibre.com>
 <20180515153521.GB23723@intel.com>
 <aff8c86f-b282-c901-5ef5-c5ee334aeedc@baylibre.com>
 <e0f99123-1463-c082-122e-67cf0d106e25@baylibre.com>
 <20180516140720.GD23723@intel.com>
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <8d1abe8f-e18c-9557-6dae-1a82de29375c@baylibre.com>
Date: Wed, 16 May 2018 20:53:04 +0200
MIME-Version: 1.0
In-Reply-To: <20180516140720.GD23723@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ville,

On 16/05/2018 16:07, Ville Syrjälä wrote:
> On Wed, May 16, 2018 at 09:40:17AM +0200, Neil Armstrong wrote:
>> On 16/05/2018 09:31, Neil Armstrong wrote:
>>> Hi Ville,
>>>
>>> On 15/05/2018 17:35, Ville Syrjälä wrote:
>>>> On Tue, May 15, 2018 at 04:42:19PM +0200, Neil Armstrong wrote:
>>>>> This patchs adds the cec_notifier feature to the intel_hdmi part
>>>>> of the i915 DRM driver. It uses the HDMI DRM connector name to differentiate
>>>>> between each HDMI ports.
>>>>> The changes will allow the i915 HDMI code to notify EDID and HPD changes
>>>>> to an eventual CEC adapter.
>>>>>
>>>>> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
>>>>> ---
>>>>>  drivers/gpu/drm/i915/Kconfig      |  1 +
>>>>>  drivers/gpu/drm/i915/intel_drv.h  |  2 ++
>>>>>  drivers/gpu/drm/i915/intel_hdmi.c | 12 ++++++++++++
>>>>>  3 files changed, 15 insertions(+)
>>>>>
>>>
>>> [..]
>>>
>>>>>  }
>>>>>  
>>>>> @@ -2031,6 +2037,8 @@ static void chv_hdmi_pre_enable(struct intel_encoder *encoder,
>>>>>  
>>>>>  static void intel_hdmi_destroy(struct drm_connector *connector)
>>>>>  {
>>>>> +	if (intel_attached_hdmi(connector)->notifier)
>>>>> +		cec_notifier_put(intel_attached_hdmi(connector)->notifier);
>>>>>  	kfree(to_intel_connector(connector)->detect_edid);
>>>>>  	drm_connector_cleanup(connector);
>>>>>  	kfree(connector);
>>>>> @@ -2358,6 +2366,10 @@ void intel_hdmi_init_connector(struct intel_digital_port *intel_dig_port,
>>>>>  		u32 temp = I915_READ(PEG_BAND_GAP_DATA);
>>>>>  		I915_WRITE(PEG_BAND_GAP_DATA, (temp & ~0xf) | 0xd);
>>>>>  	}
>>>>> +
>>>>> +	intel_hdmi->notifier = cec_notifier_get_conn(dev->dev, connector->name);
>>>>
>>>> What are we doing with the connector name here? Those are not actually
>>>> guaranteed to be stable, and any change in the connector probe order
>>>> may cause the name to change.
>>>
>>> The i915 driver can expose multiple HDMI connectors, but each connected will
>>> have a different EDID and CEC physical address, so we will need a different notifier
>>> for each connector.
>>>
>>> The connector name is DRM dependent, but user-space actually uses this name for
>>> operations, so I supposed it was kind of stable.
>>>
>>> Anyway, is there another stable id/name/whatever that can be used to make a name to
>>> distinguish the HDMI connectors ?
>>
>> Would "HDMI %c", port_name(port) be OK to use ?
> 
> Yeah, something like seems like a reasonable approach. That does mean
> we have to be a little careful with changing enum port or port_name()
> in the future, but I guess we could just add a small function to
> generated the name/id specifically for this thing.
> 
> We're also going to have to think what to do with enum port and
> port_name() on ICL+ though. There we won't just have A-F but also
> TC1-TC<n>. Hmm. Looks like what we have for those ports in our
> codebase ATM is a bit wonky since we haven't even changed
> port_name() to give us the TC<n> type names.
> 
> Also we might not want "HDMI" in the identifier since the physical
> port is not HDMI specific. There are different things we could call
> these but I think we could just go with a generic "Port A-F" and
> "Port TC1-TC<n>" approach. I think something like that should work
> fine for current and upcoming hardware. And in theory that could
> then be used for other things as well which need a stable
> identifier.
> 
> Oh, and now I recall that input subsystem at least has some kind
> of "physical path" property on devices. So I guess what we're
> dicussing is a somewhat similar idea. I think input drivers
> generally include the pci/usb/etc. device in the path as well.
> Even though we currently only ever have the one pci device it
> would seem like decent idea to include that information in our
> identifiers as well. Or what do you think?
> 

Thanks for the clarifications !

Having a "Port <id>" will be great indeed, no need to specify HDMI since
only HDMI connectors will get a CEC notifier anyway.

The issue is that port_name() returns a character, which is lame.
Would it be acceptable to introduce a :

const char *port_identifier(struct drm_i915_private *dev_priv,
			    enum port port)
{
	char *id = devm_kzalloc(dev_priv->drm->dev, 16, GFP_KERNEL);

	if (id)
		return NULL;

	snprintf("Port %c", port_name(port));

	return id;
}

and use the result of this for the cec_notifier connector name ?

Neil
