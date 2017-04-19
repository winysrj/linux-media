Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:39463 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966685AbdDSVG0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 17:06:26 -0400
Subject: Re: [PATCH] [media] sti: hdmi: improve MEDIA_CEC_NOTIFIER dependency
To: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <20170419165936.2836426-1-arnd@arndb.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Vincent Abriou <vincent.abriou@st.com>,
        David Airlie <airlied@linux.ie>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <881e9c72-62fc-157b-b74a-66dc14f111d4@xs4all.nl>
Date: Wed, 19 Apr 2017 23:06:21 +0200
MIME-Version: 1.0
In-Reply-To: <20170419165936.2836426-1-arnd@arndb.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On 19/04/17 18:59, Arnd Bergmann wrote:
> When the media subsystem is built as a loadable module, a built-in
> DRM driver cannot use the cec notifiers:
> 
> drivers/gpu/drm/sti/sti_hdmi.o: In function `sti_hdmi_remove':
> sti_hdmi.c:(.text.sti_hdmi_remove+0x28): undefined reference to `cec_notifier_set_phys_addr'
> sti_hdmi.c:(.text.sti_hdmi_remove+0x50): undefined reference to `cec_notifier_put'
> drivers/gpu/drm/sti/sti_hdmi.o: In function `sti_hdmi_connector_get_modes':
> sti_hdmi.c:(.text.sti_hdmi_connector_get_modes+0x84): undefined reference to `cec_notifier_set_phys_addr_from_edid'
> drivers/gpu/drm/sti/sti_hdmi.o: In function `sti_hdmi_probe':
> sti_hdmi.c:(.text.sti_hdmi_probe+0x1a8): undefined reference to `cec_notifier_get'
> drivers/gpu/drm/sti/sti_hdmi.o: In function `sti_hdmi_connector_detect':
> sti_hdmi.c:(.text.sti_hdmi_connector_detect+0x68): undefined reference to `cec_notifier_set_phys_addr'
> drivers/gpu/drm/sti/sti_hdmi.o: In function `sti_hdmi_disable':
> sti_hdmi.c:(.text.sti_hdmi_disable+0xec): undefined reference to `cec_notifier_set_phys_addr'
> 
> This adds a Kconfig dependency to enforce the HDMI driver to also
> be a loadable module in this case.

I've marked this patch and the exynos_hdmi patch as 'Obsoleted' in patchwork:
today several CEC Kconfig cleanup patches were merged that invalidate these
two patches. I expect they'll turn up soon in -next.

Regards,

	Hans

> 
> Fixes: bca55958ea87 ("[media] sti: hdmi: add CEC notifier support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/gpu/drm/sti/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpu/drm/sti/Kconfig b/drivers/gpu/drm/sti/Kconfig
> index acd72865feac..adac4c3e142e 100644
> --- a/drivers/gpu/drm/sti/Kconfig
> +++ b/drivers/gpu/drm/sti/Kconfig
> @@ -1,6 +1,7 @@
>  config DRM_STI
>  	tristate "DRM Support for STMicroelectronics SoC stiH4xx Series"
>  	depends on DRM && (ARCH_STI || ARCH_MULTIPLATFORM)
> +	depends on (MEDIA_SUPPORT && MEDIA_CEC_NOTIFIER) || !MEDIA_CEC_NOTIFIER
>  	select RESET_CONTROLLER
>  	select DRM_KMS_HELPER
>  	select DRM_GEM_CMA_HELPER
> 
