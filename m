Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:42046 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751059AbeCIM5v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 07:57:51 -0500
Subject: Re: [PATCH 00/13] media: imx: Switch to subdev notifiers
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund@ragnatech.se, Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1519263589-19647-1-git-send-email-steve_longerbeam@mentor.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e0edd9bb-7ce3-5f9a-b461-e96cc20f2323@xs4all.nl>
Date: Fri, 9 Mar 2018 13:57:44 +0100
MIME-Version: 1.0
In-Reply-To: <1519263589-19647-1-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

I understand there will be a v2 of this series? If so, then I can mark this
series as 'Changes Requested' in patchwork.

Regards,

	Hans

On 22/02/18 02:39, Steve Longerbeam wrote:
> This patchset converts the imx-media driver and its dependent
> subdevs to use subdev notifiers.
> 
> There are a couple shortcomings in v4l2-core that prevented
> subdev notifiers from working correctly in imx-media:
> 
> 1. v4l2_async_notifier_fwnode_parse_endpoint() treats a fwnode
>    endpoint that is not connected to a remote device as an error.
>    But in the case of the video-mux subdev, this is not an error, it's
>    ok if some of the muxes inputs have no connection. So the first
>    patch is a small modification to allow the parse_endpoint callback
>    to decide whether an unconnected endpoint is an error.
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
>    Patches 2-4 deal with adding that support.
> 
> 3. Patch 5 adds v4l2_async_register_fwnode_subdev(), which is a
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
> 
> 
> Steve Longerbeam (13):
>   media: v4l2-fwnode: Let parse_endpoint callback decide if no remote is
>     error
>   media: v4l2: async: Allow searching for asd of any type
>   media: v4l2: async: Add v4l2_async_notifier_add_subdev
>   media: v4l2-fwnode: Switch to v4l2_async_notifier_add_subdev
>   media: v4l2-fwnode: Add a convenience function for registering subdevs
>     with notifiers
>   media: platform: video-mux: Register a subdev notifier
>   media: imx: csi: Register a subdev notifier
>   media: imx: mipi csi-2: Register a subdev notifier
>   media: staging/imx: of: Remove recursive graph walk
>   media: staging/imx: Loop through all registered subdevs for media
>     links
>   media: staging/imx: Rename root notifier
>   media: staging/imx: Switch to v4l2_async_notifier_add_subdev
>   media: staging/imx: TODO: Remove one assumption about OF graph parsing
> 
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c          |  13 +-
>  drivers/media/platform/omap3isp/isp.c             |   3 +
>  drivers/media/platform/rcar-vin/rcar-core.c       |   3 +
>  drivers/media/platform/video-mux.c                |  35 ++-
>  drivers/media/v4l2-core/v4l2-async.c              | 275 ++++++++++++++++------
>  drivers/media/v4l2-core/v4l2-fwnode.c             | 230 ++++++++++--------
>  drivers/staging/media/imx/TODO                    |  29 +--
>  drivers/staging/media/imx/imx-media-csi.c         |  11 +-
>  drivers/staging/media/imx/imx-media-dev.c         | 134 +++--------
>  drivers/staging/media/imx/imx-media-internal-sd.c |   5 +-
>  drivers/staging/media/imx/imx-media-of.c          | 106 +--------
>  drivers/staging/media/imx/imx-media.h             |   6 +-
>  drivers/staging/media/imx/imx6-mipi-csi2.c        |  31 ++-
>  include/media/v4l2-async.h                        |  24 +-
>  include/media/v4l2-fwnode.h                       |  64 ++++-
>  15 files changed, 546 insertions(+), 423 deletions(-)
> 
