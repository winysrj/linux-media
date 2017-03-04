Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:32980 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751370AbdCDN62 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Mar 2017 08:58:28 -0500
Date: Sat, 4 Mar 2017 15:48:54 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v2 2/3] v4l: Clearly document interactions between
 formats, controls and buffers
Message-ID: <20170304134854.GW3220@valkosipuli.retiisi.org.uk>
References: <20170228150320.10104-1-laurent.pinchart+renesas@ideasonboard.com>
 <20170228150320.10104-3-laurent.pinchart+renesas@ideasonboard.com>
 <20170302153703.GI3220@valkosipuli.retiisi.org.uk>
 <5f3e6c07-e07f-6ce2-0158-3f5ec750637f@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f3e6c07-e07f-6ce2-0158-3f5ec750637f@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sat, Mar 04, 2017 at 11:57:32AM +0100, Hans Verkuil wrote:
...
> >>+To simplify their implementation, drivers may also require buffers to be
> >>+reallocated in order to change formats or controls that influence the buffer
> >>+size. In that case, to perform such changes, userspace applications shall
> >>+first stop the video stream with the :c:func:`VIDIOC_STREAMOFF` ioctl if it
> >>+is running and free all buffers with the :c:func:`VIDIOC_REQBUFS` ioctl if
> >>+they are allocated. The format or controls can then be modified, and buffers
> >>+shall then be reallocated and the stream restarted. A typical ioctl sequence
> >>+is
> >>+
> >>+ #. VIDIOC_STREAMOFF
> >>+ #. VIDIOC_REQBUFS(0)
> >>+ #. VIDIOC_S_FMT
> >>+ #. VIDIOC_S_EXT_CTRLS
> >
> >Same here.
> >
> >Would it be safe to say that controls are changed first? I wonder if there
> >could be special cases where this wouldn't apply though. It could ultimately
> >come down to hardware features: rotation might be only available for certain
> >formats so you'd need to change the format first to enable rotation.
> >
> >What you're documenting above is a typical sequence so it doesn't have to be
> >applicable to all potential hardware. I might mention there could be such
> >dependencies. I wonder if one exists at the moment. No?
> 
> The way V4L2 works is that the last ioctl called gets 'preference'. So the
> driver should attempt to satisfy the ioctl, even if that means undoing previous
> ioctls. In other words, V4L2 allows any order, but the end-result might be
> different depending on the hardware capabilities.

Indeed. But the above sequence suggests that formats are set before
controls. I suggested to clarify that part.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
