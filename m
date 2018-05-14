Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37625 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752090AbeENJhP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 05:37:15 -0400
Message-ID: <1526290626.4936.6.camel@pengutronix.de>
Subject: Re: [PATCH v4 00/14] media: imx: Switch to subdev notifiers
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund@ragnatech.se, Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Mon, 14 May 2018 11:37:06 +0200
In-Reply-To: <1525906023-827-1-git-send-email-steve_longerbeam@mentor.com>
References: <1525906023-827-1-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

thank you for the update.

On Wed, 2018-05-09 at 15:46 -0700, Steve Longerbeam wrote:
> This patchset converts the imx-media driver and its dependent
> subdevs to use subdev notifiers.
> 
> There are a couple shortcomings in v4l2-core that prevented
> subdev notifiers from working correctly in imx-media:
> 
> 1. v4l2_async_notifier_fwnode_parse_endpoint() treats a fwnode
>    endpoint that is not connected to a remote device as an error.
>    But in the case of the video-mux subdev, this is not an error,
>    it is OK if some of the mux inputs have no connection. Also,
>    Documentation/devicetree/bindings/media/video-interfaces.txt explicitly
>    states that the 'remote-endpoint' property is optional. So the first
>    patch is a small modification to ignore empty endpoints in
>    v4l2_async_notifier_fwnode_parse_endpoint() and allow
>    __v4l2_async_notifier_parse_fwnode_endpoints() to continue to
>    parse the remaining port endpoints of the device.
> 
> 2. In the imx-media graph, multiple subdevs will encounter the same
>    upstream subdev (such as the imx6-mipi-csi2 receiver), and so
>    v4l2_async_notifier_parse_fwnode_endpoints() will add imx6-mipi-csi2
>    multiple times. This is treated as an error by
>    v4l2_async_notifier_register() later.
> 
>    To get around this problem, add an v4l2_async_notifier_add_subdev()
>    which first verifies the provided asd does not already exist in the
>    given notifier asd list or in other registered notifiers. If the asd
>    exists, the function returns -EEXIST and it's up to the caller to
>    decide if that is an error (in imx-media case it is never an error).
> 
>    Patches 2-5 deal with adding that support.
> 
> 3. Patch 6 adds v4l2_async_register_fwnode_subdev(), which is a
>    convenience function for parsing a subdev's fwnode port endpoints
>    for connected remote subdevs, registering a subdev notifier, and
>    then registering the sub-device itself.
> 
> The remaining patches update the subdev drivers to register a
> subdev notifier with endpoint parsing, and the changes to imx-media
> to support that.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

Patches 07-14 (video-mux and the imx patches) are
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

The series is
Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
on i.MX6 with Toshiba TC358743 connected via MIPI CSI-2.

regards
Philipp
