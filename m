Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55194 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750822AbdAaLVZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 06:21:25 -0500
Date: Tue, 31 Jan 2017 11:20:01 +0000
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
Subject: Re: [PATCH v3 17/24] media: imx: Add CSI subdev driver
Message-ID: <20170131112001.GV27312@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-18-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483755102-24785-18-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 06, 2017 at 06:11:35PM -0800, Steve Longerbeam wrote:
> +static int csi_link_validate(struct v4l2_subdev *sd,
> +			     struct media_link *link,
> +			     struct v4l2_subdev_format *source_fmt,
> +			     struct v4l2_subdev_format *sink_fmt)
> +{
> +	struct csi_priv *priv = v4l2_get_subdevdata(sd);
> +	bool is_csi2;
> +	int ret;
> +
> +	ret = v4l2_subdev_link_validate_default(sd, link, source_fmt, sink_fmt);
> +	if (ret)
> +		return ret;
> +
> +	priv->sensor = __imx_media_find_sensor(priv->md, &priv->sd.entity);
> +	if (IS_ERR(priv->sensor)) {
> +		v4l2_err(&priv->sd, "no sensor attached\n");
> +		ret = PTR_ERR(priv->sensor);
> +		priv->sensor = NULL;
> +		return ret;
> +	}
> +
> +	ret = v4l2_subdev_call(priv->sensor->sd, video, g_mbus_config,
> +			       &priv->sensor_mbus_cfg);
> +	if (ret)
> +		return ret;
> +
> +	is_csi2 = (priv->sensor_mbus_cfg.type == V4L2_MBUS_CSI2);
> +
> +	if (is_csi2) {
> +		int vc_num = 0;
> +		/*
> +		 * NOTE! It seems the virtual channels from the mipi csi-2
> +		 * receiver are used only for routing by the video mux's,
> +		 * or for hard-wired routing to the CSI's. Once the stream
> +		 * enters the CSI's however, they are treated internally
> +		 * in the IPU as virtual channel 0.
> +		 */
> +#if 0
> +		vc_num = imx_media_find_mipi_csi2_channel(priv->md,
> +							  &priv->sd.entity);
> +		if (vc_num < 0)
> +			return vc_num;
> +#endif
> +		ipu_csi_set_mipi_datatype(priv->csi, vc_num,
> +					  &priv->format_mbus[priv->input_pad]);

This seems (at least to me) to go against the spirit of the subdev
negotiation.  Here, you seem to bypass the negotiation performed
between the CSI and the attached device, wanting to grab the
format from the CSI2 sensor directly.  That bypasses negotiation
performed at the CSI2 subdev and video muxes.

The same goes for the frame rate monitoring code - imho, the frame
rate should be something that results from negotiation with the
neighbouring element, not by poking at some entity that is several
entities away.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
