Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38040 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388287AbeGXNUZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 09:20:25 -0400
Date: Tue, 24 Jul 2018 15:14:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        p.zabel@pengutronix.de
Subject: Re: [PATCH v6 00/17] media: imx: Switch to subdev notifiers
Message-ID: <20180724121410.etizobu4f43tub5e@valkosipuli.retiisi.org.uk>
References: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Mon, Jul 09, 2018 at 03:39:00PM -0700, Steve Longerbeam wrote:
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
> 4. Patches 7-14 update the subdev drivers to register a subdev notifier
>    with endpoint parsing, and the changes to imx-media to support that.
> 
> 5. Finally, the last 3 patches endeavor to completely remove support for
>    the notifier->subdevs[] array in platform drivers and v4l2 core. All
>    platform drivers are modified to make use of
>    v4l2_async_notifier_add_subdev() and its related convenience functions
>    to add asd's to the notifier @asd_list, and any allocation or reference
>    to the notifier->subdevs[] array removed. After that large patch,
>    notifier->subdevs[] array is stripped from v4l2-async and v4l2-subdev
>    docs are updated to reflect the new method of adding asd's to notifiers.
> 
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> 
> Patches 07-14 (video-mux and the imx patches) are
> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
> 
> Patches 01-14 are
> Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
> on i.MX6 with Toshiba TC358743 connected via MIPI CSI-2.
> 
> History:
> 
> v6:
> - Export v4l2_async_notifier_init(), which must be called by all
>   drivers before the first call to v4l2_async_notifier_add_subdev().
>   Suggested by Sakari Ailus.
> - Removed @num_subdevs from struct v4l2_async_notifier, and the macro
>   V4L2_MAX_SUBDEVS. Sugested by Sakari.
> - Fixed a double device node put in vpif_capture.c. Reported by Sakari.
> - Fixed wrong printk format qualifiers in xilinx-vipp.c. Reported by
>   Dan Carpenter.

The patches seem good to me. Still, the changes are non-trivial and to
allow more time for them to stay in the media tree only I'd like to
postpone applying them until we're past the next merge window.

I'll add Philipp's Tested-by: and Reviewed-by: tags then.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
