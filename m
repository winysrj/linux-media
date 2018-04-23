Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:53078 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754729AbeDWMMn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 08:12:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Peter Rosin <peda@axentia.se>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        architt@codeaurora.org, a.hajda@samsung.com, airlied@linux.ie,
        daniel@ffwll.ch, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] drm: bridge: thc63lvd1024: Add support for LVDS mode map
Date: Mon, 23 Apr 2018 15:12:54 +0300
Message-ID: <1653352.Yto2ZqehFs@avalon>
In-Reply-To: <20180423074156.GO4235@w540>
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org> <86c2d4c9-8079-9f25-f24a-58c7866a8274@axentia.se> <20180423074156.GO4235@w540>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Monday, 23 April 2018 10:41:56 EEST jacopo mondi wrote:
> On Sun, Apr 22, 2018 at 10:02:51PM +0200, Peter Rosin wrote:
> > On 2018-04-19 11:31, Jacopo Mondi wrote:
> >> The THC63LVD1024 LVDS to RGB bridge supports two different LVDS mapping
> >> modes, selectable by means of an external pin.
> >> 
> >> Add support for configurable LVDS input mapping modes, using the newly
> >> introduced support for bridge input image formats.
> >> 
> >> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >> ---
> >> 
> >>  drivers/gpu/drm/bridge/thc63lvd1024.c | 41 ++++++++++++++++++++++++++++
> >>  1 file changed, 41 insertions(+)
> >> 
> >> diff --git a/drivers/gpu/drm/bridge/thc63lvd1024.c
> >> b/drivers/gpu/drm/bridge/thc63lvd1024.c index 48527f8..a3071a1 100644
> >> --- a/drivers/gpu/drm/bridge/thc63lvd1024.c
> >> +++ b/drivers/gpu/drm/bridge/thc63lvd1024.c

[snip]

> >> +static int thc63_set_bus_fmt(struct thc63_dev *thc63)
> >> +{
> >> +	u32 bus_fmt;
> >> +	u32 map;
> >> +	int ret;
> >> +
> >> +	ret = of_property_read_u32(thc63->dev->of_node, "thine,map", &map);
> >> +	if (ret) {
> >> +		dev_err(thc63->dev,
> >> +			"Unable to parse property \"thine,map\": %d\n", ret);
> >> +		return ret;
> >> +	}
> >> +
> >> +	switch (map) {
> >> +	case THC63_LVDS_MAP_MODE1:
> >> +		bus_fmt = MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA;
> >> +		break;
> >> +	case THC63_LVDS_MAP_MODE2:
> >> +		bus_fmt = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG;
> > 
> > Why do you assume rgb888/1x7x4 here? It might as well be rgb666/1x7x3
> > or rgb101010/1x7x5, no?
> 
> I should combine the 'map' pin input mode property with the 'bus_width' one
> to find that out probably.

Yes, but that could also be left for later, when the need to support those 
formats arise, especially given that include/uapi/linux/media-bus-format.h has 
no 1x7x5 formats yet.

> >> +		break;
> >> +	default:
> >> +		dev_err(thc63->dev,
> >> +			"Invalid value for property \"thine,map\": %u\n", map);
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	drm_bridge_set_bus_formats(&thc63->bridge, &bus_fmt, 1);
> >> +
> >> +	return 0;
> >> +}

-- 
Regards,

Laurent Pinchart
