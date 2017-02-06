Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:34070 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751563AbdBFJup (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Feb 2017 04:50:45 -0500
Subject: Re: [PATCH v3 13/24] platform: add video-multiplexer subdevice driver
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1485259368.3600.126.camel@pengutronix.de>
 <651d7b40-e87d-05ce-ae4d-256b0c1b28f7@gmail.com> <2258037.UCXsIYbtGD@avalon>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, robh+dt@kernel.org,
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
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f6bfb9ec-1ea3-8477-4933-cf655acd3e0f@xs4all.nl>
Date: Mon, 6 Feb 2017 10:50:22 +0100
MIME-Version: 1.0
In-Reply-To: <2258037.UCXsIYbtGD@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/2017 04:48 PM, Laurent Pinchart wrote:
> Hi Steve,
> 
> On Tuesday 24 Jan 2017 18:07:55 Steve Longerbeam wrote:
>> On 01/24/2017 04:02 AM, Philipp Zabel wrote:
>>> On Fri, 2017-01-20 at 15:03 +0100, Hans Verkuil wrote:
>>>>> +
>>>>> +int vidsw_g_mbus_config(struct v4l2_subdev *sd, struct v4l2_mbus_config
>>>>> *cfg)
>>>>> +{
>>>>> +	struct vidsw *vidsw = v4l2_subdev_to_vidsw(sd);
>>>>> +	struct media_pad *pad;
>>>>> +	int ret;
>>>>> +
>>>>> +	if (vidsw->active == -1) {
>>>>> +		dev_err(sd->dev, "no configuration for inactive mux\n");
>>>>> +		return -EINVAL;
>>>>> +	}
>>>>> +
>>>>> +	/*
>>>>> +	 * Retrieve media bus configuration from the entity connected to the
>>>>> +	 * active input
>>>>> +	 */
>>>>> +	pad = media_entity_remote_pad(&vidsw->pads[vidsw->active]);
>>>>> +	if (pad) {
>>>>> +		sd = media_entity_to_v4l2_subdev(pad->entity);
>>>>> +		ret = v4l2_subdev_call(sd, video, g_mbus_config, cfg);
>>>>> +		if (ret == -ENOIOCTLCMD)
>>>>> +			pad = NULL;
>>>>> +		else if (ret < 0) {
>>>>> +			dev_err(sd->dev, "failed to get source 
> configuration\n");
>>>>> +			return ret;
>>>>> +		}
>>>>> +	}
>>>>> +	if (!pad) {
>>>>> +		/* Mirror the input side on the output side */
>>>>> +		cfg->type = vidsw->endpoint[vidsw->active].bus_type;
>>>>> +		if (cfg->type == V4L2_MBUS_PARALLEL ||
>>>>> +		    cfg->type == V4L2_MBUS_BT656)
>>>>> +			cfg->flags = vidsw->endpoint[vidsw-
>> active].bus.parallel.flags;
>>>>> +	}
>>>>> +
>>>>> +	return 0;
>>>>> +}
>>>>
>>>> I am not certain this op is needed at all. In the current kernel this op
>>>> is only used by soc_camera, pxa_camera and omap3isp (somewhat dubious).
>>>> Normally this information should come from the device tree and there
>>>> should be no need for this op.
>>>>
>>>> My (tentative) long-term plan was to get rid of this op.
>>>>
>>>> If you don't need it, then I recommend it is removed.
>>
>> Hi Hans, the imx-media driver was only calling g_mbus_config to the camera
>> sensor, and it was doing that to determine the sensor's bus type. This info
>> was already available from parsing a v4l2_of_endpoint from the sensor node.
>> So it was simple to remove the g_mbus_config calls, and instead rely on the
>> parsed sensor v4l2_of_endpoint.
> 
> That's not a good point. The imx-media driver must not parse the sensor DT 
> node as it is not aware of what bindings the sensor is compatible with. 
> Information must instead be queried from the sensor subdev at runtime, through 
> the g_mbus_config() operation.
> 
> Of course, if you can get the information from the imx-media DT node, that's 
> certainly an option. It's only information provided by the sensor driver that 
> you have no choice but query using a subdev operation.

Shouldn't this come from the imx-media DT node? BTW, why is omap3isp using this?

The reason I am suspicious about this op is that it came from soc-camera and
predates the DT. The contents of v4l2_mbus_config seems very much like a HW
description to me, i.e. something that belongs in the DT.

Regards,

	Hans
