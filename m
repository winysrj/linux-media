Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:57410 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934939AbdEZKeh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 06:34:37 -0400
Subject: Re: [RFC PATCH 6/7] drm: add support for DisplayPort
 CEC-Tunneling-over-AUX
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Jani Nikula <jani.nikula@intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
References: <20170525150626.29748-1-hverkuil@xs4all.nl>
 <20170525150626.29748-7-hverkuil@xs4all.nl>
 <20170526071856.v6sj4yv2vj5x73aq@phenom.ffwll.local>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <914a2100-800e-d2aa-7c28-3d53f50596d6@xs4all.nl>
Date: Fri, 26 May 2017 12:34:32 +0200
MIME-Version: 1.0
In-Reply-To: <20170526071856.v6sj4yv2vj5x73aq@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/26/2017 09:18 AM, Daniel Vetter wrote:
> On Thu, May 25, 2017 at 05:06:25PM +0200, Hans Verkuil wrote:
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
>>  drivers/gpu/drm/Kconfig      |   3 +
>>  drivers/gpu/drm/Makefile     |   1 +
>>  drivers/gpu/drm/drm_dp_cec.c | 196 +++++++++++++++++++++++++++++++++++++++++++
>>  include/drm/drm_dp_helper.h  |  24 ++++++
>>  4 files changed, 224 insertions(+)
>>  create mode 100644 drivers/gpu/drm/drm_dp_cec.c
>>
>> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
>> index 78d7fc0ebb57..dd771ce8a3d0 100644
>> --- a/drivers/gpu/drm/Kconfig
>> +++ b/drivers/gpu/drm/Kconfig
>> @@ -120,6 +120,9 @@ config DRM_LOAD_EDID_FIRMWARE
>>  	  default case is N. Details and instructions how to build your own
>>  	  EDID data are given in Documentation/EDID/HOWTO.txt.
>>  
>> +config DRM_DP_CEC
>> +	bool
> 
> We generally don't bother with a Kconfig for every little bit in drm, not
> worth the trouble (yes I know there's some exceptions, but somehow they're
> all from soc people). Just smash this into the KMS_HELPER one and live is
> much easier for drivers. Also allows you to drop the dummy inline
> functions.

For all other CEC implementations I have placed it under a config option. The
reason is that 1) CEC is an optional feature of HDMI and you may not actually
want it, and 2) enabling CEC also pulls in the cec module.

I still think turning this into a drm config option makes sense. This would
replace the i915 config option I made in the next patch, i.e. this config option
is moved up one level.

Your choice, though.

> The other nitpick: Pls kernel-doc the functions exported to drivers, and
> then pull them into Documentation/gpu/drm-kms-helpers.rst, next to the
> existing DP helper section.

Will do.

BTW, do you know if it is possible to detect when a DP-to-HDMI adapter is
connected as I discussed in my cover letter? That's my main open question
for this patch series.

Regarding the other thing I discussed in the cover letter about detecting if
the CEC pin is really hooked up: I think I shouldn't try to be smart. Yes, I
can try to poll for a TV, but that doesn't really say anything about whether
CEC is working or not since the TV itself may not have enabled CEC (actually
quite common).

One alternative might be to poll and, if no TV is detected, call dev_info to
let the user know that either there is no CEC-enabled TV, or the CEC pin isn't
connected.

I'm not sure if that helps the user or not.

Regards,

	Hans

> 
> Thanks, Daniel
