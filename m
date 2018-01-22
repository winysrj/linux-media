Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:37093 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751024AbeAVMiJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 07:38:09 -0500
Date: Mon, 22 Jan 2018 14:38:03 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: Re: [PATCHv2 0/9] media: replace g/s_parm by g/s_frame_interval
Message-ID: <20180122123802.64zsr564l3shhwhy@paasikivi.fi.intel.com>
References: <20180122123125.24709-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180122123125.24709-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Jan 22, 2018 at 01:31:16PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> There are currently two subdev ops variants to get/set the frame interval:
> g/s_parm and g/s_frame_interval.
> 
> This patch series replaces all g/s_parm calls by g/s_frame_interval.
> 
> The first patch adds helper functions that can be used by bridge drivers.
> Only em28xx can't use it and it needs custom code (it uses v4l2_device_call()
> to try all subdevs instead of calling a specific subdev).
> 
> The next patch converts all non-staging drivers, then come Sakari's
> atomisp staging fixes.
> 
> The v4l2-subdev.h patch removes the now obsolete g/s_parm ops and the
> final patch clarifies the documentation a bit (the core allows for
> _MPLANE to be used as well).
> 
> I would really like to take the next step and introduce two new ioctls
> VIDIOC_G/S_FRAME_INTERVAL (just like the SUBDEV variants that already
> exist) and convert all bridge drivers to use that and just have helper
> functions in the core for VIDIOC_G/S_PARM.
> 
> I hate that ioctl and it always confuses driver developers. It would
> also prevent the type of abuse that was present in the atomisp driver.
> 
> But that's for later, let's simplify the subdev drivers first.

Apart from my patches,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
