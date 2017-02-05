Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33175 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751239AbdBEASH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Feb 2017 19:18:07 -0500
MIME-Version: 1.0
In-Reply-To: <1479136968-24477-5-git-send-email-hverkuil@xs4all.nl>
References: <1479136968-24477-1-git-send-email-hverkuil@xs4all.nl> <1479136968-24477-5-git-send-email-hverkuil@xs4all.nl>
From: Pierre-Hugues Husson <phh@phh.me>
Date: Sun, 5 Feb 2017 01:17:45 +0100
Message-ID: <CAJ-oXjSsk=cZgpNp-6qLPo13Mj8Cw5mvqEe8mtFVCPSphxJOWQ@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 4/5] drm/bridge: add dw-hdmi cec driver using Hans
 Verkuil's CEC code
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2016-11-14 16:22 GMT+01:00 Hans Verkuil <hverkuil@xs4all.nl>:
> From: Russell King <rmk+kernel@arm.linux.org.uk>
>
> Add a CEC driver for the dw-hdmi hardware using Hans Verkuil's CEC
> implementation.
>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
I've seen that the patchset concerning CEC/HDMI notifier after this
one dropped dw-hdmi support.
Is this only temporary, or does this driver need someone to take care of it?

> diff --git a/drivers/gpu/drm/bridge/dw-hdmi-cec.c b/drivers/gpu/drm/bridge/dw-hdmi-cec.c
> new file mode 100644
> index 0000000..e7e12b5
> --- /dev/null
> +++ b/drivers/gpu/drm/bridge/dw-hdmi-cec.c
> @@ -0,0 +1,346 @@
> +/* http://git.freescale.com/git/cgit.cgi/imx/linux-2.6-imx.git/
> + * tree/drivers/mxc/hdmi-cec/mxc_hdmi-cec.c?h=imx_3.0.35_4.1.0 */
It is perhaps mandatory to have GPL header?

> +#include <linux/hdmi-notifier.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/notifier.h>
> +#include <linux/platform_data/dw_hdmi-cec.h>
> +#include <linux/platform_device.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +
> +#include <drm/drm_edid.h>
> +
> +#include <media/cec.h>
> +#include <media/cec-edid.h>
> +
> +#define DEV_NAME "mxc_hdmi_cec"
I think that to respect the convention it should be dw-hdmi-cec?

> +       writeb_relaxed(addresses & 255, cec->base + HDMI_CEC_ADDR_L);
> +       writeb_relaxed(addresses >> 8, cec->base + HDMI_CEC_ADDR_H);
Some platforms (at least rockchip) discuss with dw-hdmi with longs
instead of bytes
dw-hdmi-i2s-audio.c uses hdmi_read/hdmi_write for that

Is it ok to add write and read functions to dw_hdmi_cec_ops ?

> +static unsigned int parse_hdmi_addr(const struct edid *edid)
> +{
> +       if (!edid || edid->extensions == 0)
> +               return (u16)~0;
> +
> +       return cec_get_edid_phys_addr((u8 *)edid,
> +                               EDID_LENGTH * (edid->extensions + 1), NULL);
> +}
> +
> +static int dw_hdmi_cec_notify(struct notifier_block *nb, unsigned long event,
> +                             void *data)
> +{
> +       struct dw_hdmi_cec *cec = container_of(nb, struct dw_hdmi_cec, nb);
> +       struct hdmi_notifier *n = data;
> +       unsigned int phys;
> +
> +       dev_info(cec->adap->devnode.parent, "event %lu\n", event);
> +
> +       switch (event) {
> +       case HDMI_CONNECTED:
> +               break;
> +
> +       case HDMI_DISCONNECTED:
> +               cec_s_phys_addr(cec->adap, CEC_PHYS_ADDR_INVALID, false);
> +               break;
> +
> +       case HDMI_NEW_EDID:
> +               phys = parse_hdmi_addr(n->edid);
> +               cec_s_phys_addr(cec->adap, phys, false);
> +               break;
> +       }
> +
> +       return NOTIFY_OK;
> +}
Thanks to "cec: integrate HDMI notifier support" this code can be dropped
