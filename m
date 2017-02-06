Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55682 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751372AbdBFWdP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2017 17:33:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarit.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        sakari.ailus@linux.intel.com
Subject: Re: [PATCH v3 13/24] platform: add video-multiplexer subdevice driver
Date: Tue, 07 Feb 2017 00:33:33 +0200
Message-ID: <2038922.a1tReKKdaL@avalon>
In-Reply-To: <f6bfb9ec-1ea3-8477-4933-cf655acd3e0f@xs4all.nl>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com> <2258037.UCXsIYbtGD@avalon> <f6bfb9ec-1ea3-8477-4933-cf655acd3e0f@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

(CC'ing Sakari)

On Monday 06 Feb 2017 10:50:22 Hans Verkuil wrote:
> On 02/05/2017 04:48 PM, Laurent Pinchart wrote:
> > On Tuesday 24 Jan 2017 18:07:55 Steve Longerbeam wrote:
> >> On 01/24/2017 04:02 AM, Philipp Zabel wrote:
> >>> On Fri, 2017-01-20 at 15:03 +0100, Hans Verkuil wrote:
> >>>>> +
> >>>>> +int vidsw_g_mbus_config(struct v4l2_subdev *sd, struct
> >>>>> v4l2_mbus_config
> >>>>> *cfg)
> >>>>> +{
> >>>>> +	struct vidsw *vidsw = v4l2_subdev_to_vidsw(sd);
> >>>>> +	struct media_pad *pad;
> >>>>> +	int ret;
> >>>>> +
> >>>>> +	if (vidsw->active == -1) {
> >>>>> +		dev_err(sd->dev, "no configuration for inactive 
mux\n");
> >>>>> +		return -EINVAL;
> >>>>> +	}
> >>>>> +
> >>>>> +	/*
> >>>>> +	 * Retrieve media bus configuration from the entity connected 
to the
> >>>>> +	 * active input
> >>>>> +	 */
> >>>>> +	pad = media_entity_remote_pad(&vidsw->pads[vidsw->active]);
> >>>>> +	if (pad) {
> >>>>> +		sd = media_entity_to_v4l2_subdev(pad->entity);
> >>>>> +		ret = v4l2_subdev_call(sd, video, g_mbus_config, cfg);
> >>>>> +		if (ret == -ENOIOCTLCMD)
> >>>>> +			pad = NULL;
> >>>>> +		else if (ret < 0) {
> >>>>> +			dev_err(sd->dev, "failed to get source
> >>>>> configuration\n");
> >>>>> +			return ret;
> >>>>> +		}
> >>>>> +	}
> >>>>> +	if (!pad) {
> >>>>> +		/* Mirror the input side on the output side */
> >>>>> +		cfg->type = vidsw->endpoint[vidsw->active].bus_type;
> >>>>> +		if (cfg->type == V4L2_MBUS_PARALLEL ||
> >>>>> +		    cfg->type == V4L2_MBUS_BT656)
> >>>>> +			cfg->flags = vidsw->endpoint[vidsw-
> >>>>> active].bus.parallel.flags;
> >>>>> +	}
> >>>>> +
> >>>>> +	return 0;
> >>>>> +}
> >>>> 
> >>>> I am not certain this op is needed at all. In the current kernel this
> >>>> op is only used by soc_camera, pxa_camera and omap3isp (somewhat
> >>>> dubious). Normally this information should come from the device tree
> >>>> and there should be no need for this op.
> >>>> 
> >>>> My (tentative) long-term plan was to get rid of this op.
> >>>> 
> >>>> If you don't need it, then I recommend it is removed.
> >> 
> >> Hi Hans, the imx-media driver was only calling g_mbus_config to the
> >> camera sensor, and it was doing that to determine the sensor's bus type.
> >> This info was already available from parsing a v4l2_of_endpoint from the
> >> sensor node. So it was simple to remove the g_mbus_config calls, and
> >> instead rely on the parsed sensor v4l2_of_endpoint.
> > 
> > That's not a good point.

(mea culpa, s/point/idea/)

> > The imx-media driver must not parse the sensor DT node as it is not aware
> > of what bindings the sensor is compatible with. Information must instead
> > be queried from the sensor subdev at runtime, through the g_mbus_config()
> > operation.
> > 
> > Of course, if you can get the information from the imx-media DT node,
> > that's certainly an option. It's only information provided by the sensor
> > driver that you have no choice but query using a subdev operation.
> 
> Shouldn't this come from the imx-media DT node? BTW, why is omap3isp using
> this?

It all depends on what type of information needs to be retrieved, and whether 
it can change at runtime or is fixed. Adding properties to the imx-media DT 
node is certainly fine as long as those properties describe the i.MX side.

In the omap3isp case, we use the operation to query whether parallel data 
contains embedded sync (BT.656) or uses separate h/v sync signals.

> The reason I am suspicious about this op is that it came from soc-camera and
> predates the DT. The contents of v4l2_mbus_config seems very much like a HW
> description to me, i.e. something that belongs in the DT.

Part of it is possibly outdated, but for buses that support multiple modes of 
operation (such as the parallel bus case described above) we need to make that 
information discoverable at runtime. Maybe this should be considered as 
related to Sakari's efforts to support VC/DT for CSI-2, and supported through 
the API he is working on.

-- 
Regards,

Laurent Pinchart

