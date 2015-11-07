Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33264 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753608AbbKGUkv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2015 15:40:51 -0500
Date: Sat, 7 Nov 2015 22:40:45 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, jh1009.sung@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/2] vb2: drop v4l2_format argument from queue_setup
Message-ID: <20151107204045.GR17128@valkosipuli.retiisi.org.uk>
References: <1446092666-2313-1-git-send-email-hverkuil@xs4all.nl>
 <1446092666-2313-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1446092666-2313-2-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Oct 29, 2015 at 05:24:25AM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The queue_setup callback has a void pointer that is just for V4L2
> and is the pointer to the v4l2_format struct that was passed to
> VIDIOC_CREATE_BUFS. The idea was that drivers would use the information
> from that struct to buffers suitable for the requested format.
> 
> After the vb2 split series this pointer is now a void pointer,
> which is ugly, and the reality is that all existing drivers will
> effectively just look at the sizeimage field of v4l2_format.
> 
> To make this more generic the queue_setup callback is changed:
> the void pointer is dropped, instead if the *num_planes argument
> is 0, then use the current format size, if it is non-zero, then
> it contains the number of requested planes and the sizes array
> contains the requested sizes. If either is unsupported, then return
> -EINVAL, otherwise use the requested size(s).

Please don't.

This effectively prevents allocating new buffers while streaming if they're
for a different format than that used by the stream. That was the very point
in struct v4l2_format being part of the argument to the IOCTL.

If this is not used right now I could well imagine someone to need it sooner
or later.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
