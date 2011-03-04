Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:14539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759903Ab1CDUKR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2011 15:10:17 -0500
Message-ID: <4D71471D.6060808@redhat.com>
Date: Fri, 04 Mar 2011 17:10:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org,
	Sakari Ailus <sakari.ailus@retiisi.org.uk>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
References: <201102171606.58540.laurent.pinchart@ideasonboard.com> <4D6EA4EB.9070607@redhat.com> <201103031125.06419.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103031125.06419.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 03-03-2011 07:25, Laurent Pinchart escreveu:
> Hi Mauro,
> 
> The following changes since commit 88a763df226facb74fdb254563e30e9efb64275c:
> 
>   [media] dw2102: prof 1100 corrected (2011-03-02 16:56:54 -0300)
> 
> are available in the git repository at:
>   git://linuxtv.org/pinchartl/media.git media-2.6.39-0005-omap3isp
> 
> The branch has been rebased on top of the latest for_v2.6.39 branch, with the
> v4l2-ioctl.c conflict resolved.
> 
> Antti Koskipaa (1):
>       v4l: v4l2_subdev userspace crop API
> 
> David Cohen (1):
>       omap3isp: Statistics
> 
> Laurent Pinchart (36):
>       v4l: Share code between video_usercopy and video_ioctl2
>       v4l: subdev: Don't require core operations
>       v4l: subdev: Add device node support
>       v4l: subdev: Uninline the v4l2_subdev_init function
>       v4l: subdev: Control ioctls support
>       media: Media device node support
>       media: Media device
>       media: Entities, pads and links
>       media: Entity use count
>       media: Media device information query
>       media: Entities, pads and links enumeration
>       media: Links setup
>       media: Pipelines and media streams
>       v4l: Add a media_device pointer to the v4l2_device structure
>       v4l: Make video_device inherit from media_entity
>       v4l: Make v4l2_subdev inherit from media_entity
>       v4l: Move the media/v4l2-mediabus.h header to include/linux
>       v4l: Replace enums with fixed-sized fields in public structure
>       v4l: Rename V4L2_MBUS_FMT_GREY8_1X8 to V4L2_MBUS_FMT_Y8_1X8
>       v4l: Group media bus pixel codes by types and sort them alphabetically

The presence of those mediabus names against the traditional fourcc codes
at the API adds some mess to the media controller. Not sure how to solve,
but maybe the best way is to add a table at the V4L2 API associating each
media bus format to the corresponding V4L2 fourcc codes.

Cheers,
Mauro
