Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2904 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab3C1OOf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Mar 2013 10:14:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v3.10] hdpvr: driver overhaul
Date: Thu, 28 Mar 2013 15:14:25 +0100
Cc: Leonid Kegulskiy <leo@lumanate.com>, Janne Grunau <j@jannau.net>
References: <201303280927.53374.hverkuil@xs4all.nl>
In-Reply-To: <201303280927.53374.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303281514.25282.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu March 28 2013 09:27:53 Hans Verkuil wrote:
> Hi Mauro,
> 
> This pull request overhauls the hdpvr driver. It's identical to my earlier
> posted patch series:
> 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg60040.html
> 
> except for being rebased to the latest master.
> 
> It's been tested thoroughly on my hdpvr and with a video generator to test all
> the video formats.
> 
> I've taken care to preserve the current VIDIOC_G_FMT behavior since MythTV
> relies on that. See the last patch for more information on that topic.
> 
> Leonid, because of the MythTV behavior your patch (http://patchwork.linuxtv.org/patch/17567/)
> can't be applied.
> 
> The way out would be for someone to add support to MythTV for
> VIDIOC_QUERY_DV_TIMINGS as the preferred method of detecting if a signal
> is present on the HDPVR, and once that it in place this legacy hack can
> be removed from this driver.
> 
> Regards,
> 
> 	Hans
> 

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

Leonid found some issues that I want to address first.

Regards,

	Hans

> The following changes since commit 004e45d736bfe62159bd4dc1549eff414bd27496:
> 
>   [media] tuner-core: handle errors when getting signal strength/afc (2013-03-25 15:10:43 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git hdpvr
> 
> for you to fetch changes up to 6cb9721190d98e654e1b5ac467565ce7784ed2da:
> 
>   hdpvr: add dv_timings support. (2013-03-28 09:16:36 +0100)
> 
> ----------------------------------------------------------------
> Hans Verkuil (11):
>       videodev2.h: fix incorrect V4L2_DV_FL_HALF_LINE bitmask.
>       v4l2-dv-timings.h: add 480i59.94 and 576i50 CEA-861-E timings.
>       hdpvr: convert to the control framework.
>       hdpvr: remove hdpvr_fh and just use v4l2_fh.
>       hdpvr: add prio and control event support.
>       hdpvr: support device_caps in querycap.
>       hdpvr: small fixes
>       hdpvr: register the video node at the end of probe.
>       hdpvr: recognize firmware version 0x1e.
>       hdpvr: add g/querystd, remove deprecated current_norm.
>       hdpvr: add dv_timings support.
> 
>  drivers/media/usb/hdpvr/hdpvr-core.c  |   14 +-
>  drivers/media/usb/hdpvr/hdpvr-video.c |  918 +++++++++++++++++++++++++++++++++++++++++-----------------------------------------------
>  drivers/media/usb/hdpvr/hdpvr.h       |   19 +-
>  include/uapi/linux/v4l2-dv-timings.h  |   18 ++
>  include/uapi/linux/videodev2.h        |    2 +-
>  5 files changed, 473 insertions(+), 498 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
