Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:33715 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S971127AbdEZKN0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 06:13:26 -0400
Subject: Re: [RFC PATCH 7/7] drm/i915: add DisplayPort CEC-Tunneling-over-AUX
 support
To: Jani Nikula <jani.nikula@intel.com>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Clint Taylor <clinton.a.taylor@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20170525150626.29748-1-hverkuil@xs4all.nl>
 <20170525150626.29748-8-hverkuil@xs4all.nl> <87h908lydt.fsf@intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8e09433c-1422-b02a-b483-dc3ab21cdb03@xs4all.nl>
Date: Fri, 26 May 2017 12:13:21 +0200
MIME-Version: 1.0
In-Reply-To: <87h908lydt.fsf@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/26/2017 12:13 PM, Jani Nikula wrote:
> On Thu, 25 May 2017, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> @@ -4179,6 +4181,33 @@ intel_dp_check_mst_status(struct intel_dp *intel_dp)
>>  	return -EINVAL;
>>  }
>>  
>> +static bool
>> +intel_dp_check_cec_status(struct intel_dp *intel_dp)
>> +{
>> +	bool handled = false;
>> +
>> +	for (;;) {
>> +		u8 cec_irq;
>> +		int ret;
>> +
>> +		ret = drm_dp_dpcd_readb(&intel_dp->aux,
>> +					DP_DEVICE_SERVICE_IRQ_VECTOR_ESI1,
>> +					&cec_irq);
>> +		if (ret < 0 || !(cec_irq & DP_CEC_IRQ))
>> +			return handled;
>> +
>> +		cec_irq &= ~DP_CEC_IRQ;
>> +		drm_dp_cec_irq(&intel_dp->aux);
>> +		handled = true;
>> +
>> +		ret = drm_dp_dpcd_writeb(&intel_dp->aux,
>> +					 DP_DEVICE_SERVICE_IRQ_VECTOR_ESI1,
>> +					 cec_irq);
>> +		if (ret < 0)
>> +			return handled;
>> +	}
> 
> DP sinks suck. Please add a limit to the loop.

Good to know. I wondered about that.

Regards,

	Hans
