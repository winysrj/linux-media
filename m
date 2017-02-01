Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37478 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750879AbdBAA66 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 19:58:58 -0500
Date: Wed, 1 Feb 2017 00:58:05 +0000
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
Message-ID: <20170201005805.GI27312@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-18-git-send-email-steve_longerbeam@mentor.com>
 <20170131112001.GV27312@n2100.armlinux.org.uk>
 <7ffe2dc6-4098-e89f-03fa-1007eccd7abd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ffe2dc6-4098-e89f-03fa-1007eccd7abd@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 31, 2017 at 04:31:55PM -0800, Steve Longerbeam wrote:
> 
> 
> On 01/31/2017 03:20 AM, Russell King - ARM Linux wrote:
> >On Fri, Jan 06, 2017 at 06:11:35PM -0800, Steve Longerbeam wrote:
> >>+static int csi_link_validate(struct v4l2_subdev *sd,
> >>+			     struct media_link *link,
> >>+			     struct v4l2_subdev_format *source_fmt,
> >>+			     struct v4l2_subdev_format *sink_fmt)
> >>+{
> >>+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
> >>+	bool is_csi2;
> >>+	int ret;
> >>+
> >>+	ret = v4l2_subdev_link_validate_default(sd, link, source_fmt, sink_fmt);
> >>+	if (ret)
> >>+		return ret;
> >>+
> >>+	priv->sensor = __imx_media_find_sensor(priv->md, &priv->sd.entity);
> >>+	if (IS_ERR(priv->sensor)) {
> >>+		v4l2_err(&priv->sd, "no sensor attached\n");
> >>+		ret = PTR_ERR(priv->sensor);
> >>+		priv->sensor = NULL;
> >>+		return ret;
> >>+	}
> >>+
> >>+	ret = v4l2_subdev_call(priv->sensor->sd, video, g_mbus_config,
> >>+			       &priv->sensor_mbus_cfg);
> >>+	if (ret)
> >>+		return ret;
> >>+
> >>+	is_csi2 = (priv->sensor_mbus_cfg.type == V4L2_MBUS_CSI2);
> >>+
> >>+	if (is_csi2) {
> >>+		int vc_num = 0;
> >>+		/*
> >>+		 * NOTE! It seems the virtual channels from the mipi csi-2
> >>+		 * receiver are used only for routing by the video mux's,
> >>+		 * or for hard-wired routing to the CSI's. Once the stream
> >>+		 * enters the CSI's however, they are treated internally
> >>+		 * in the IPU as virtual channel 0.
> >>+		 */
> >>+#if 0
> >>+		vc_num = imx_media_find_mipi_csi2_channel(priv->md,
> >>+							  &priv->sd.entity);
> >>+		if (vc_num < 0)
> >>+			return vc_num;
> >>+#endif
> >>+		ipu_csi_set_mipi_datatype(priv->csi, vc_num,
> >>+					  &priv->format_mbus[priv->input_pad]);
> >This seems (at least to me) to go against the spirit of the subdev
> >negotiation.  Here, you seem to bypass the negotiation performed
> >between the CSI and the attached device, wanting to grab the
> >format from the CSI2 sensor directly.  That bypasses negotiation
> >performed at the CSI2 subdev and video muxes.
> 
> This isn't so much grabbing a pad format, it is determining
> which source pad at the imx6-mipi-csi2 receiver subdev is
> reached from this CSI (which determines the virtual channel
> the CSI is receiving).
> 
> If there was a way to determine the vc# via a status register
> in the CSI, that would be perfect, but there isn't. In fact, the CSIs
> seem to be ignoring the meta-data bus sent by the CSI2IPU gasket
> which contains this info, or that bus is not being routed to the CSIs.
> As the note says, the CSIs only accept vc0 at the CSI_MIPI_DI register.
> Any other value programmed there results in no data from the CSI.
> 
> And even the presence of CSI_MIPI_DI register makes no sense to me,
> the CSIs are given the vc# and MIPI datatype from the CSI2IPU meta-data
> bus, so I don't understand why it needs to be told.

The CSI_MIPI_DI register selects the data stream we want from the
CSI2 camera.

CSI2 cameras can produce many different data streams - for example,
a CSI2 camera can, for the same image, produce a YUV encoded frame
and a jpeg-encoded frame.  These are sent over the CSI2 serial bus
using two different data types.

The CSI2IPU converts the serial data streams into a parallel data
stream, feeding that into the CSI layer.  The CSI layer, in
conjunction with the CSI_MIPI_DI register, selects one of these
streams to pass on to the SMFC and other blocks.

>From what I've read, the CSI can also be programmed to pass other
streams on as well, but I've never tried that.

In my particular case, the IMX219 camera produces a complete frame
using the RAW8 or RAW10 MIPI data type, and also produces two lines
of register data per frame, encoded using another data type.  I
think it should be possible to program the CSI to pass this other
data on as "generic data" through a different FIFO and have it
written to memory, which makes it possible to know the camera
settings for each frame.  (This isn't something I'm interested in
though, I'm just using it as an example of why, possibly, there's
that register in the CSI block.)

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
