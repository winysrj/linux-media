Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33830 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751424AbdELJtv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 May 2017 05:49:51 -0400
MIME-Version: 1.0
In-Reply-To: <20170421105224.899350-1-arnd@arndb.de>
References: <20170421105224.899350-1-arnd@arndb.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 12 May 2017 11:49:50 +0200
Message-ID: <CAK8P3a2V4mUtPNWnFXBBNABqt09vRujRE1w=6wkYc1q63-Ujhg@mail.gmail.com>
Subject: Re: [PATCH] [media] cec: improve MEDIA_CEC_RC dependencies
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 21, 2017 at 12:52 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> Changing the IS_REACHABLE() into a plain #ifdef broke the case of
> CONFIG_MEDIA_RC=m && CONFIG_MEDIA_CEC=y:
>
> drivers/media/cec/cec-core.o: In function `cec_unregister_adapter':
> cec-core.c:(.text.cec_unregister_adapter+0x18): undefined reference to `rc_unregister_device'
> drivers/media/cec/cec-core.o: In function `cec_delete_adapter':
> cec-core.c:(.text.cec_delete_adapter+0x54): undefined reference to `rc_free_device'
> drivers/media/cec/cec-core.o: In function `cec_register_adapter':
> cec-core.c:(.text.cec_register_adapter+0x94): undefined reference to `rc_register_device'
> cec-core.c:(.text.cec_register_adapter+0xa4): undefined reference to `rc_free_device'
> cec-core.c:(.text.cec_register_adapter+0x110): undefined reference to `rc_unregister_device'
> drivers/media/cec/cec-core.o: In function `cec_allocate_adapter':
> cec-core.c:(.text.cec_allocate_adapter+0x234): undefined reference to `rc_allocate_device'
> drivers/media/cec/cec-adap.o: In function `cec_received_msg':
> cec-adap.c:(.text.cec_received_msg+0x734): undefined reference to `rc_keydown'
> cec-adap.c:(.text.cec_received_msg+0x768): undefined reference to `rc_keyup'
>
> This adds an additional dependency to explicitly forbid this combination.
>
> Fixes: 5f2c467c54f5 ("[media] cec: add MEDIA_CEC_RC config option")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

What is the status of this patch? According to
https://patchwork.linuxtv.org/patch/40934/ it is marked 'accepted',
but the patch that caused the problem has made it into mainline
in the merge window, and the fix is still needed on top.

On a related note, I've run into another link error now:

drivers/gpu/drm/sti/sti_hdmi.o: In function `sti_hdmi_remove':
sti_hdmi.c:(.text.sti_hdmi_remove+0x10): undefined reference to
`cec_notifier_set_phys_addr'
sti_hdmi.c:(.text.sti_hdmi_remove+0x34): undefined reference to
`cec_notifier_put'
drivers/gpu/drm/sti/sti_hdmi.o: In function `sti_hdmi_connector_get_modes':
sti_hdmi.c:(.text.sti_hdmi_connector_get_modes+0x4a): undefined
reference to `cec_notifier_set_phys_addr_from_edid'
drivers/gpu/drm/sti/sti_hdmi.o: In function `sti_hdmi_probe':
sti_hdmi.c:(.text.sti_hdmi_probe+0x204): undefined reference to
`cec_notifier_get'
drivers/gpu/drm/sti/sti_hdmi.o: In function `sti_hdmi_connector_detect':
sti_hdmi.c:(.text.sti_hdmi_connector_detect+0x36): undefined reference
to `cec_notifier_set_phys_addr'
drivers/gpu/drm/sti/sti_hdmi.o: In function `sti_hdmi_disable':
sti_hdmi.c:(.text.sti_hdmi_disable+0xc0): undefined reference to
`cec_notifier_set_phys_addr'

The config options leading to the second failure are:

CONFIG_MEDIA_CEC_SUPPORT=y
CONFIG_CEC_CORE=m
CONFIG_MEDIA_CEC_NOTIFIER=y
CONFIG_VIDEO_STI_HDMI_CEC=m
CONFIG_DRM_STI=y

I can probably come up with a workaround, but haven't completely thought
through all the combinations yet. Also, I assume the same fix will be needed
for exynos, though that has not come up in randconfig testing so far.

       Arnd

>  drivers/media/cec/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/cec/Kconfig b/drivers/media/cec/Kconfig
> index f944d93e3167..488fb908244d 100644
> --- a/drivers/media/cec/Kconfig
> +++ b/drivers/media/cec/Kconfig
> @@ -9,6 +9,7 @@ config MEDIA_CEC_NOTIFIER
>  config MEDIA_CEC_RC
>         bool "HDMI CEC RC integration"
>         depends on CEC_CORE && RC_CORE
> +       depends on CEC_CORE=m || RC_CORE=y
>         ---help---
>           Pass on CEC remote control messages to the RC framework.
>
> --
> 2.9.0
>
