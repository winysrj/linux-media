Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38336 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754441AbdBPLw7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 06:52:59 -0500
Date: Thu, 16 Feb 2017 11:52:06 +0000
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
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v4 20/36] media: imx: Add CSI subdev driver
Message-ID: <20170216115206.GL27312@n2100.armlinux.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-21-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487211578-11360-21-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 15, 2017 at 06:19:22PM -0800, Steve Longerbeam wrote:
> +static const struct platform_device_id imx_csi_ids[] = {
> +	{ .name = "imx-ipuv3-csi" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(platform, imx_csi_ids);
> +
> +static struct platform_driver imx_csi_driver = {
> +	.probe = imx_csi_probe,
> +	.remove = imx_csi_remove,
> +	.id_table = imx_csi_ids,
> +	.driver = {
> +		.name = "imx-ipuv3-csi",
> +	},
> +};
> +module_platform_driver(imx_csi_driver);
> +
> +MODULE_DESCRIPTION("i.MX CSI subdev driver");
> +MODULE_AUTHOR("Steve Longerbeam <steve_longerbeam@mentor.com>");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:imx-ipuv3-csi");

Just a reminder that automatic module loading of this is completely
broken right now (not your problem) due to this stupid idea in the
IPUv3 code:

		if (!ret)
			ret = platform_device_add(pdev);
		if (ret) {
			platform_device_put(pdev);
			goto err_register;
		}

		/*
		 * Set of_node only after calling platform_device_add. Otherwise
		 * the platform:imx-ipuv3-crtc modalias won't be used.
		 */
		pdev->dev.of_node = of_node;

setting pdev->dev.of_node changes the modalias exported to userspace,
so udev sees a DT based modalias, which causes it to totally miss any
driver using a non-DT based modalias.

The IPUv3 code needs fixing, not only for imx-media-csi, but also for
imx-ipuv3-crtc too, because that module will also suffer the same
issue.

The only solution is... don't fsck with dev->of_node assignment.  In
this case, it's probably much better to pass it in via platform data.
If you then absolutely must have dev->of_node, doing it in the driver
means that you avoid the modalias mess before the appropriate driver
is loaded.  However, that's still not a nice solution because the
modalias file still ends up randomly changing its contents.

As I say, not _your_ problem, but it's still a problem that needs
solving, and I don't want it forgotten about.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
