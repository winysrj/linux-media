Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42582 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbdBBWgJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 17:36:09 -0500
Date: Thu, 2 Feb 2017 22:35:28 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v3 20/24] media: imx: Add Camera Interface subdev driver
Message-ID: <20170202223528.GX27312@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-21-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483755102-24785-21-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 06, 2017 at 06:11:38PM -0800, Steve Longerbeam wrote:
> +struct camif_priv {
> +	struct device         *dev;
> +	struct video_device    vfd;

You can't do this.

> +static struct video_device camif_videodev = {
> +	.fops		= &camif_fops,
> +	.ioctl_ops	= &camif_ioctl_ops,
> +	.minor		= -1,
> +	.release	= video_device_release,
> +	.vfl_dir	= VFL_DIR_RX,
> +	.tvnorms	= V4L2_STD_NTSC | V4L2_STD_PAL | V4L2_STD_SECAM,
> +};

> +static int camif_probe(struct platform_device *pdev)
> +{
> +	struct imx_media_internal_sd_platformdata *pdata;
> +	struct camif_priv *priv;
> +	struct video_device *vfd;
> +	int ret;
> +
> +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;

You kmalloc this structure, so this structure has the lifetime of
the driver being bound to the platform device.

> +	vfd = &priv->vfd;
> +	*vfd = camif_videodev;

However, "*vfd" contains a struct device, and you _correctly_ set the
release function for "*vfd" to video_device_release via camif_videodev.

However, if you try to rmmod imx-media, then you end up with a kernel
warning that you're freeing memory containing a held lock, and later
chaos ensues because kmalloc has been corrupted.

The root cause of this is embedding the device structure within the
video_device into the driver's private data.  *Any* structure what so
ever that contains a kref is reference counted, and that includes
struct device, and therefore also includes struct video_device.  What
that means is that its lifetime is _not_ under _your_ control, and
you may not free it except through its release function (which is
video_device_release().)  However, that also tries to kfree (with an
offset of 4) your private data, which results in the warning and the
corrupted kmalloc free lists.

The solution is simple, make "vfd" a pointer in your private data
structure and kmalloc() it separately, letting video_device_release()
kfree() that data when it needs to.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
