Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33219 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbdAXMoO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jan 2017 07:44:14 -0500
Received: by mail-it0-f67.google.com with SMTP id e137so13704322itc.0
        for <linux-media@vger.kernel.org>; Tue, 24 Jan 2017 04:44:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1483755102-24785-14-git-send-email-steve_longerbeam@mentor.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com> <1483755102-24785-14-git-send-email-steve_longerbeam@mentor.com>
From: Javier Martinez Canillas <javier@dowhile0.org>
Date: Tue, 24 Jan 2017 09:44:12 -0300
Message-ID: <CABxcv=n1z7OwOctm_qmT8oBWSGK4tyvKBY6fWUOSZHfW1x=QUQ@mail.gmail.com>
Subject: Re: [PATCH v3 13/24] platform: add video-multiplexer subdevice driver
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, nick@shmanahar.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Benoit Parrot <bparrot@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Steve,

On Fri, Jan 6, 2017 at 11:11 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> From: Philipp Zabel <p.zabel@pengutronix.de>

[snip]

>
> +config VIDEO_MULTIPLEXER
> +       tristate "Video Multiplexer"
> +       depends on VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER

The driver can be build as a module...

> +
> +static const struct of_device_id vidsw_dt_ids[] = {
> +       { .compatible = "video-multiplexer", },
> +       { /* sentinel */ }
> +};
> +

... so you need a MODULE_DEVICE_TABLE(of, vidsw_dt_ids) here or
otherwise module autoloading won't work.

Best regards,
Javier
