Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36121 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761123AbdEZLdq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 07:33:46 -0400
Received: by mail-io0-f195.google.com with SMTP id f102so1070928ioi.3
        for <linux-media@vger.kernel.org>; Fri, 26 May 2017 04:33:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <914a2100-800e-d2aa-7c28-3d53f50596d6@xs4all.nl>
References: <20170525150626.29748-1-hverkuil@xs4all.nl> <20170525150626.29748-7-hverkuil@xs4all.nl>
 <20170526071856.v6sj4yv2vj5x73aq@phenom.ffwll.local> <914a2100-800e-d2aa-7c28-3d53f50596d6@xs4all.nl>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Fri, 26 May 2017 13:33:44 +0200
Message-ID: <CAKMK7uFopWB6=WbaQtHeR43V0Bd5c6=T=7DtXFrEQYL7J5frzw@mail.gmail.com>
Subject: Re: [RFC PATCH 6/7] drm: add support for DisplayPort CEC-Tunneling-over-AUX
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jani Nikula <jani.nikula@intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 26, 2017 at 12:34 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
>>> index 78d7fc0ebb57..dd771ce8a3d0 100644
>>> --- a/drivers/gpu/drm/Kconfig
>>> +++ b/drivers/gpu/drm/Kconfig
>>> @@ -120,6 +120,9 @@ config DRM_LOAD_EDID_FIRMWARE
>>>        default case is N. Details and instructions how to build your own
>>>        EDID data are given in Documentation/EDID/HOWTO.txt.
>>>
>>> +config DRM_DP_CEC
>>> +    bool
>>
>> We generally don't bother with a Kconfig for every little bit in drm, not
>> worth the trouble (yes I know there's some exceptions, but somehow they're
>> all from soc people). Just smash this into the KMS_HELPER one and live is
>> much easier for drivers. Also allows you to drop the dummy inline
>> functions.
>
> For all other CEC implementations I have placed it under a config option. The
> reason is that 1) CEC is an optional feature of HDMI and you may not actually
> want it, and 2) enabling CEC also pulls in the cec module.
>
> I still think turning this into a drm config option makes sense. This would
> replace the i915 config option I made in the next patch, i.e. this config option
> is moved up one level.
>
> Your choice, though.

If there is a CEC option already, can we just reuse that one? I.e.
when it's enabled, we compile the drm dp cec helpers, if it's not, you
get the pile of dummy functions. drm_dp_cec.c should still be part of
drm_kms_helper.ko though I think (since the dp aux stuff is in there
anyway, doesn't make sense to split it).

I'm still not sold on Kconfig proliferation for optional features
(have one for the driver, that's imo enough), but if it exists already
not going to block it's use in drm. As long as it's minimally invasive
on the code and drivers don't have to care at all.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
