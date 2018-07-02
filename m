Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42084 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753279AbeGBJvW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 05:51:22 -0400
Date: Mon, 2 Jul 2018 12:51:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/17] media: imx: Switch to subdev notifiers
Message-ID: <20180702095119.t2adtiffpuaoanqk@valkosipuli.retiisi.org.uk>
References: <1530298220-5097-1-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1530298220-5097-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Fri, Jun 29, 2018 at 11:49:44AM -0700, Steve Longerbeam wrote:
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

Thanks for the update! This is beginning to look really nice. A few notes
on the entire set. I'll separately review some of the patches; I mainly
wanted to see how the async/fwnode framework changes end up:

- The reason V4L2_MAX_SUBDEVS exists is to avoid drivers accidentally
  allocating more space than intended. Now that the subdevs array will
  disappear, the checks as well as the macro can be removed. I think the
  num_subdevs field also becomes redundant as a result. Could you do this
  in the patch that removes the subdevs array?

- The notifier has register, unregister and cleanup operations. Now that
  there's an obvious need to initialise it, it'd make sense to show that to
  the drivers as an init operation --- rather than silently initialise it
  based on the need.

- I'd assign j in its declaration in
  v4l2_async_notifier_has_async_subdev().

- No need to explicitly check that the notifier's asd_list is empty in
  __v4l2_async_notifier_register --- list_for_each_entry() over the same
  list will be nop in that case.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
