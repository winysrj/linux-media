Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44662 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932466AbeBUMyY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 07:54:24 -0500
Date: Wed, 21 Feb 2018 14:54:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv3 05/15] v4l2-subdev: implement VIDIOC_DBG_G_CHIP_INFO
 ioctl
Message-ID: <20180221125422.zbjdc5sz5bjnmqg6@valkosipuli.retiisi.org.uk>
References: <20180219103806.17032-1-hverkuil@xs4all.nl>
 <20180219103806.17032-6-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180219103806.17032-6-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 19, 2018 at 11:37:56AM +0100, Hans Verkuil wrote:
> The VIDIOC_DBG_G/S_REGISTER ioctls imply that VIDIOC_DBG_G_CHIP_INFO is also
> present, since without that you cannot use v4l2-dbg.
> 
> Just like the implementation in v4l2-ioctl.c this can be implemented in the
> core and no drivers need to be modified.
> 
> It also makes it possible for v4l2-compliance to properly test the
> VIDIOC_DBG_G/S_REGISTER ioctls.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Considering the interface already is there and as debugfs isn't a drop-in
placement,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

It'd be still good to have generic, non V4L2-specific solution to this
issue in the future.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
