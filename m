Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:47051 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750992AbeEPHbX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 03:31:23 -0400
Received: by mail-qt0-f195.google.com with SMTP id m16-v6so3769146qtg.13
        for <linux-media@vger.kernel.org>; Wed, 16 May 2018 00:31:22 -0700 (PDT)
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
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <aff8c86f-b282-c901-5ef5-c5ee334aeedc@baylibre.com>
Date: Wed, 16 May 2018 09:31:16 +0200
MIME-Version: 1.0
In-Reply-To: <20180515153521.GB23723@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ville,

On 15/05/2018 17:35, Ville Syrjälä wrote:
> On Tue, May 15, 2018 at 04:42:19PM +0200, Neil Armstrong wrote:
>> This patchs adds the cec_notifier feature to the intel_hdmi part
>> of the i915 DRM driver. It uses the HDMI DRM connector name to differentiate
>> between each HDMI ports.
>> The changes will allow the i915 HDMI code to notify EDID and HPD changes
>> to an eventual CEC adapter.
>>
>> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
>> ---
>>  drivers/gpu/drm/i915/Kconfig      |  1 +
>>  drivers/gpu/drm/i915/intel_drv.h  |  2 ++
>>  drivers/gpu/drm/i915/intel_hdmi.c | 12 ++++++++++++
>>  3 files changed, 15 insertions(+)
>>

[..]

>>  }
>>  
>> @@ -2031,6 +2037,8 @@ static void chv_hdmi_pre_enable(struct intel_encoder *encoder,
>>  
>>  static void intel_hdmi_destroy(struct drm_connector *connector)
>>  {
>> +	if (intel_attached_hdmi(connector)->notifier)
>> +		cec_notifier_put(intel_attached_hdmi(connector)->notifier);
>>  	kfree(to_intel_connector(connector)->detect_edid);
>>  	drm_connector_cleanup(connector);
>>  	kfree(connector);
>> @@ -2358,6 +2366,10 @@ void intel_hdmi_init_connector(struct intel_digital_port *intel_dig_port,
>>  		u32 temp = I915_READ(PEG_BAND_GAP_DATA);
>>  		I915_WRITE(PEG_BAND_GAP_DATA, (temp & ~0xf) | 0xd);
>>  	}
>> +
>> +	intel_hdmi->notifier = cec_notifier_get_conn(dev->dev, connector->name);
> 
> What are we doing with the connector name here? Those are not actually
> guaranteed to be stable, and any change in the connector probe order
> may cause the name to change.

The i915 driver can expose multiple HDMI connectors, but each connected will
have a different EDID and CEC physical address, so we will need a different notifier
for each connector.

The connector name is DRM dependent, but user-space actually uses this name for
operations, so I supposed it was kind of stable.

Anyway, is there another stable id/name/whatever that can be used to make a name to
distinguish the HDMI connectors ?

Neil

> 
>> +	if (!intel_hdmi->notifier)
>> +		DRM_DEBUG_KMS("CEC notifier get failed\n");
>>  }
>>  
>>  void intel_hdmi_init(struct drm_i915_private *dev_priv,
>> -- 
>> 2.7.4
>>
>> _______________________________________________
>> Intel-gfx mailing list
>> Intel-gfx@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
> 
