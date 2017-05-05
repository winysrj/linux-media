Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:34209 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751837AbdEENEP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 May 2017 09:04:15 -0400
Subject: Re: [PATCH 6/8] omapdrm: hdmi4: refcount hdmi_power_on/off_core
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-media@vger.kernel.org
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-7-hverkuil@xs4all.nl>
 <15b0996c-5756-19ac-7393-11c245417ce4@ti.com>
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <74eac79b-39f8-a6f0-8d70-70c8db6450eb@xs4all.nl>
Date: Fri, 5 May 2017 15:04:07 +0200
MIME-Version: 1.0
In-Reply-To: <15b0996c-5756-19ac-7393-11c245417ce4@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/28/17 13:30, Tomi Valkeinen wrote:
> On 14/04/17 13:25, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> The hdmi_power_on/off_core functions can be called multiple times:
>> when the HPD changes and when the HDMI CEC support needs to power
>> the HDMI core.
>>
>> So use a counter to know when to really power on or off the HDMI core.
>>
>> Also call hdmi4_core_powerdown_disable() in hdmi_power_on_core() to
>> power up the HDMI core (needed for CEC).
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/gpu/drm/omapdrm/dss/hdmi4.c | 12 +++++++++++-
>>  1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4.c b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
>> index 4a164dc01f15..e371b47ff6ff 100644
>> --- a/drivers/gpu/drm/omapdrm/dss/hdmi4.c
>> +++ b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
>> @@ -124,14 +124,19 @@ static int hdmi_power_on_core(struct omap_dss_device *dssdev)
>>  {
>>  	int r;
>>  
>> +	if (hdmi.core.core_pwr_cnt++)
>> +		return 0;
>> +
> 
> How's the locking between the CEC side and the DRM side? Normally these
> functions are protected with the DRM modesetting locks, but CEC doesn't
> come from there. We have the hdmi.lock, did you check that it's held
> when CEC side calls shared functions?

Yes, the hdmi_power_on/off_core functions are all called from other functions
with the hdmi.lock taken. The CEC code calls those higher level functions
(hdmi4_core_enable/disable).

> 
>>  	r = regulator_enable(hdmi.vdda_reg);
>>  	if (r)
>> -		return r;
>> +		goto err_reg_enable;
>>  
>>  	r = hdmi_runtime_get();
>>  	if (r)
>>  		goto err_runtime_get;
>>  
>> +	hdmi4_core_powerdown_disable(&hdmi.core);
> 
> I'd like to have the powerdown_disable as a separate patch.

Will do.

> Also, now
> that you call it here, I believe it can be dropped from hdmi4_configure().

I was a bit scared of messing with that function. But if you say it can
be removed, then who am I to argue? :-)

> 
> Hmm, but in hdmi4_configure we call hdmi_core_swreset_assert() before
> hdmi4_core_powerdown_disable(). I wonder what exactly that does, and
> whether we end up resetting also the CEC parts when we change the videomode.

Good one. I'll attempt to check this.

Regards,

	Hans

> 
>  Tomi
> 
