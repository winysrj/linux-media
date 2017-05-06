Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:37633 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751196AbdEFL65 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 6 May 2017 07:58:57 -0400
Subject: Re: [PATCH 8/8] omapdrm: hdmi4: hook up the HDMI CEC support
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-9-hverkuil@xs4all.nl>
Message-ID: <144b95df-8eb2-1307-1157-2eb2572c51aa@xs4all.nl>
Date: Sat, 6 May 2017 13:58:51 +0200
MIME-Version: 1.0
In-Reply-To: <20170414102512.48834-9-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomi,

I did some more testing, and I discovered a bug in this code, but I am not
sure how to solve it.

On 04/14/2017 12:25 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Hook up the HDMI CEC support in the hdmi4 driver.
> 
> It add the CEC irq handler, the CEC (un)init calls and tells the CEC
> implementation when the physical address changes.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/gpu/drm/omapdrm/dss/Kconfig  |  9 +++++++++
>  drivers/gpu/drm/omapdrm/dss/Makefile |  1 +
>  drivers/gpu/drm/omapdrm/dss/hdmi4.c  | 23 ++++++++++++++++++++++-
>  3 files changed, 32 insertions(+), 1 deletion(-)
> 

<snip>

> diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4.c b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
> index e371b47ff6ff..ebe5b27cee6f 100644
> --- a/drivers/gpu/drm/omapdrm/dss/hdmi4.c
> +++ b/drivers/gpu/drm/omapdrm/dss/hdmi4.c

<snip>

> @@ -392,6 +401,8 @@ static void hdmi_display_disable(struct omap_dss_device *dssdev)
>  
>  	DSSDBG("Enter hdmi_display_disable\n");
>  
> +	hdmi4_cec_set_phys_addr(&hdmi.core, CEC_PHYS_ADDR_INVALID);
> +
>  	mutex_lock(&hdmi.lock);
>  
>  	spin_lock_irqsave(&hdmi.audio_playing_lock, flags);

My assumption was that hdmi_display_disable() was called when the hotplug would go
away. But I discovered that that isn't the case, or at least not when X is running.
It seems that the actual HPD check is done in hdmic_detect() in
omapdrm/displays/connector-hdmi.c.

But there I have no access to hdmi.core (needed for the hdmi4_cec_set_phys_addr() call).

Any idea how to solve this? I am not all that familiar with drm, let alone omapdrm,
so if you can point me in the right direction, then that would be very helpful.

Regards,

	Hans
