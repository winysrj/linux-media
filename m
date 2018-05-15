Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:33499 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752171AbeEOH3R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 03:29:17 -0400
Received: by mail-lf0-f44.google.com with SMTP id h9-v6so20832438lfi.0
        for <linux-media@vger.kernel.org>; Tue, 15 May 2018 00:29:17 -0700 (PDT)
Subject: Re: [RFC PATCH 3/5] drm/i915: hdmi: add CEC notifier to intel_hdmi
To: Hans Verkuil <hverkuil@xs4all.nl>, airlied@linux.ie,
        hans.verkuil@cisco.com, lee.jones@linaro.org, olof@lixom.net,
        seanpaul@google.com
Cc: sadolfsson@google.com, felixe@google.com, bleung@google.com,
        darekm@google.com, marcheu@chromium.org, fparent@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1526337639-3568-1-git-send-email-narmstrong@baylibre.com>
 <1526337639-3568-4-git-send-email-narmstrong@baylibre.com>
 <38dcd327-004c-3fb3-8e22-3b3b92542fc9@xs4all.nl>
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <fb65a087-2a56-d40a-fa43-2c47d56dcb10@baylibre.com>
Date: Tue, 15 May 2018 09:29:14 +0200
MIME-Version: 1.0
In-Reply-To: <38dcd327-004c-3fb3-8e22-3b3b92542fc9@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/05/2018 08:34, Hans Verkuil wrote:
> On 05/15/2018 12:40 AM, Neil Armstrong wrote:
>> This patchs adds the cec_notifier feature to the intel_hdmi part
>> of the i915 DRM driver. It uses the HDMI DRM connector name to differentiate
>> between each HDMI ports.
>> The changes will allow the i915 HDMI code to notify EDID and HPD changes
>> to an eventual CEC adapter.
>>
>> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
>> ---
>>  drivers/gpu/drm/i915/intel_drv.h  |  2 ++
>>  drivers/gpu/drm/i915/intel_hdmi.c | 10 ++++++++++
> 
> The Kconfig also needs to be changed. In the DRM_I915 you need to add:
> 
> 	select CEC_CORE if CEC_NOTIFIER

OK, thanks

> 
> Otherwise you'll get problems if the cec driver is a module and i915 is built-in.
> 
> Regards,
> 
> 	Hans
> 
