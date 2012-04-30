Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-2.cisco.com ([72.163.197.26]:5100 "EHLO
	bgl-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858Ab2D3J77 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 05:59:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [GIT PULL for v3.5] (v2) Control events support for uvcvideo
Date: Mon, 30 Apr 2012 11:49:54 +0200
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
References: <3052114.LipUdaOlsN@avalon> <2717715.JRhGBvOjaF@avalon>
In-Reply-To: <2717715.JRhGBvOjaF@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204301149.54269.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent!

On Monday 30 April 2012 11:43:10 Laurent Pinchart wrote:
> Hi Mauro,
> 
> A locking bug was present in the previous pull request. Please ignore it
> and pull this one instead.

I hate to say it, but while you did update v4l2_ctrl_add_event, you forgot to
update v4l2_ctrl_del_event as well. That one still has the same locking 
issue...

Time for a v3 :-)

Regards,

	Hans

> 
> The following changes since commit
> bcb2cf6e0bf033d79821c89e5ccb328bfbd44907:
> 
>   [media] ngene: remove an unneeded condition (2012-04-26 15:29:23 -0300)
> 
> are available in the git repository at:
>   git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-events
> 
> Hans de Goede (10):
>       media/radio: use v4l2_ctrl_subscribe_event where possible
>       v4l2-event: Add v4l2_subscribed_event_ops
>       v4l2-ctrls: Use v4l2_subscribed_event_ops
>       uvcvideo: Fix a "ignoring return value of ‘__clear_user’" warning
>       uvcvideo: Refactor uvc_ctrl_get and query
>       uvcvideo: Move __uvc_ctrl_get() up
>       uvcvideo: Add support for control events
>       uvcvideo: Properly report the inactive flag for inactive controls
>       uvcvideo: Send control change events for slave ctrls when the master
> changes uvcvideo: Drop unused ctrl member from struct uvc_control_mapping
> 
>  Documentation/video4linux/v4l2-framework.txt |   28 ++-
>  drivers/media/radio/radio-isa.c              |   10 +-
>  drivers/media/radio/radio-keene.c            |   14 +-
>  drivers/media/video/ivtv/ivtv-ioctl.c        |    3 +-
>  drivers/media/video/omap3isp/ispccdc.c       |    2 +-
>  drivers/media/video/omap3isp/ispstat.c       |    2 +-
>  drivers/media/video/uvc/uvc_ctrl.c           |  320
> ++++++++++++++++++++++---- drivers/media/video/uvc/uvc_v4l2.c           | 
>  46 +++-
>  drivers/media/video/uvc/uvcvideo.h           |   26 ++-
>  drivers/media/video/v4l2-ctrls.c             |   47 +++-
>  drivers/media/video/v4l2-event.c             |   71 +++---
>  drivers/usb/gadget/uvc_v4l2.c                |    2 +-
>  include/media/v4l2-ctrls.h                   |    7 +-
>  include/media/v4l2-event.h                   |   24 ++-
>  14 files changed, 447 insertions(+), 155 deletions(-)
