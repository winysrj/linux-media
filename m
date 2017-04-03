Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56318 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751214AbdDCGos (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 02:44:48 -0400
Date: Mon, 3 Apr 2017 09:44:37 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2-compat-ioctl32: VIDIOC_S_EDID should return all
 fields on error.
Message-ID: <20170403064437.GA3207@valkosipuli.retiisi.org.uk>
References: <60d00b48-8aaf-2a80-02ea-c873071d5533@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60d00b48-8aaf-2a80-02ea-c873071d5533@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 30, 2017 at 02:05:25PM +0200, Hans Verkuil wrote:
> Most ioctls do not have to write back the contents of the argument
> if an error is returned. But VIDIOC_S_EDID is an exception together
> with the EXT_CTRLS ioctls (already handled correctly).
> 
> Add this exception to v4l2-compat-ioctl32.
> 
> This fixes a compliance error when using compat32 and trying to
> set a new EDID with more blocks than the hardware supports. In
> that case the driver will return -E2BIG and set edid.blocks to the
> actual maximum number of blocks. This field was never copied back
> to userspace due to this bug.
> 
> Signed-off-by: Hans Verkuil <hansverk@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
