Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:55267 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752206AbeEOGeL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 02:34:11 -0400
Subject: Re: [RFC PATCH 3/5] drm/i915: hdmi: add CEC notifier to intel_hdmi
To: Neil Armstrong <narmstrong@baylibre.com>, airlied@linux.ie,
        hans.verkuil@cisco.com, lee.jones@linaro.org, olof@lixom.net,
        seanpaul@google.com
Cc: sadolfsson@google.com, felixe@google.com, bleung@google.com,
        darekm@google.com, marcheu@chromium.org, fparent@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1526337639-3568-1-git-send-email-narmstrong@baylibre.com>
 <1526337639-3568-4-git-send-email-narmstrong@baylibre.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <38dcd327-004c-3fb3-8e22-3b3b92542fc9@xs4all.nl>
Date: Tue, 15 May 2018 08:34:06 +0200
MIME-Version: 1.0
In-Reply-To: <1526337639-3568-4-git-send-email-narmstrong@baylibre.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/15/2018 12:40 AM, Neil Armstrong wrote:
> This patchs adds the cec_notifier feature to the intel_hdmi part
> of the i915 DRM driver. It uses the HDMI DRM connector name to differentiate
> between each HDMI ports.
> The changes will allow the i915 HDMI code to notify EDID and HPD changes
> to an eventual CEC adapter.
> 
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  drivers/gpu/drm/i915/intel_drv.h  |  2 ++
>  drivers/gpu/drm/i915/intel_hdmi.c | 10 ++++++++++

The Kconfig also needs to be changed. In the DRM_I915 you need to add:

	select CEC_CORE if CEC_NOTIFIER

Otherwise you'll get problems if the cec driver is a module and i915 is built-in.

Regards,

	Hans
