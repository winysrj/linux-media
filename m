Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:57054 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750778AbdEaGkr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 02:40:47 -0400
Subject: Re: [RFC PATCH 6/7] drm: add support for DisplayPort
 CEC-Tunneling-over-AUX
To: Clint Taylor <clinton.a.taylor@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
Cc: Jani Nikula <jani.nikula@intel.com>,
        intel-gfx@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
References: <20170525150626.29748-1-hverkuil@xs4all.nl>
 <20170525150626.29748-7-hverkuil@xs4all.nl>
 <20170526071856.v6sj4yv2vj5x73aq@phenom.ffwll.local>
 <439ee1fd-8c2b-01ab-7b70-93d827ab30e7@intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0aa0ef0d-690d-7fc3-5571-6883fe59ec95@xs4all.nl>
Date: Wed, 31 May 2017 08:40:42 +0200
MIME-Version: 1.0
In-Reply-To: <439ee1fd-8c2b-01ab-7b70-93d827ab30e7@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/31/2017 01:57 AM, Clint Taylor wrote:
> 
> 
> On 05/26/2017 12:18 AM, Daniel Vetter wrote:
>> On Thu, May 25, 2017 at 05:06:25PM +0200, Hans Verkuil wrote:
>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> This adds support for the DisplayPort CEC-Tunneling-over-AUX
>>> feature that is part of the DisplayPort 1.3 standard.
>>>
>>> Unfortunately, not all DisplayPort/USB-C to HDMI adapters with a
>>> chip that has this capability actually hook up the CEC pin, so
>>> even though a CEC device is created, it may not actually work.
>>>
>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>> ---
>>>    drivers/gpu/drm/Kconfig      |   3 +
>>>    drivers/gpu/drm/Makefile     |   1 +
>>>    drivers/gpu/drm/drm_dp_cec.c | 196 +++++++++++++++++++++++++++++++++++++++++++
>>>    include/drm/drm_dp_helper.h  |  24 ++++++
>>>    4 files changed, 224 insertions(+)
>>>    create mode 100644 drivers/gpu/drm/drm_dp_cec.c
>>>
>>> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
>>> index 78d7fc0ebb57..dd771ce8a3d0 100644
>>> --- a/drivers/gpu/drm/Kconfig
>>> +++ b/drivers/gpu/drm/Kconfig
>>> @@ -120,6 +120,9 @@ config DRM_LOAD_EDID_FIRMWARE
>>>    	  default case is N. Details and instructions how to build your own
>>>    	  EDID data are given in Documentation/EDID/HOWTO.txt.
>>>    
>>> +config DRM_DP_CEC
>>> +	bool
>> We generally don't bother with a Kconfig for every little bit in drm, not
>> worth the trouble (yes I know there's some exceptions, but somehow they're
>> all from soc people). Just smash this into the KMS_HELPER one and live is
>> much easier for drivers. Also allows you to drop the dummy inline
>> functions.
> All of the functions like cec_register_adapter() require
> CONFIG_MEDIA_CEC_SUPPORT.
> This will add a new dependency to the DRM drivers. All instances of
> CONFIG_DRM_DP_CEC should be changed to CONFIG_MEDIA_CEC_SUPPORT so drm
> can still be used without the media CEC drivers.

This has changed in the next version. I realized the same thing and there
are CEC core patches pending for 4.12 to solve this.

I plan on posting a new patch series for this later this week, and that
will include those patches for 4.12 so it is easier to test this.

Regards,

	Hans
