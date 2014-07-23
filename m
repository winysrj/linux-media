Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54148 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757287AbaGWIrN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 04:47:13 -0400
Date: Wed, 23 Jul 2014 11:47:04 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sylwester.nawrocki@gmail.com
Subject: Re: Media bus pixel code and pixel format enumeration (was: )
Message-ID: <20140723084703.GS16460@valkosipuli.retiisi.org.uk>
References: <alpine.DEB.2.01.1407211419320.18226@pmeerw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1407211419320.18226@pmeerw.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

On Mon, Jul 21, 2014 at 02:35:39PM +0200, Peter Meerwald wrote:
> how can I query the supported pixel format(s) of a sensor connected via 
> media-ctl and exposed via /dev/videoX
> 
> there is 
> VIDIOC_ENUM_FMT (which fails)
> and
> VIDIOC_SUBDEV_ENUM_MBUS_CODE (which works, but on a subdev, not on 
> /dev/videoX)
> 
> v4l2_subdev_video_ops has .enum_mbus_fmt (this is SoC camera stuff?)
> 
> v4l2_subdev_pad_ops has .enum_mbus_code
> 
> 
> the application just sees /dev/videoX and cannot do VIDIOC_ENUM_FMT
> what is the logic behind this?
> shouldn't a compabatibility layer be added turning VIDIOC_ENUM_FMT into 
> VIDIOC_SUBDEV_ENUM_MBUS_CODE?

The issue has been that enumerating should not change the state of the
device. Within a single device node things are fine, but in this case the
media bus pixel code at the other end of the link affects the result of the
enumeration.

There hasn't been really a solution for this in the past; what has been
discussed as possible options have been (at least to my recollection) but
none has been implemented:

1) Use the media bux pixel code from the other end of the link. As there is
no common file handle to share the state with, the link configuration and
setting the media bus pixel code are necessary state changes before the
enumeration can take place, and the two must not be changed during the it.
This breaks the separation between configuration and enumeration. (There has
been a patch to the omap3isp driver which essentially did this long time ago
AFAIR.)

2) Use a reserved field in struct v4l2_fmtdesc to tell the pixel code. This
way enumeration can stay separate from configuration and is probably easier
for the user space as well. I vote for this: it's clean, simple and gets the
job done.

Feel free to submit a patch. :-) I could do this as well but it might take
some time. Driver support is another matter.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
