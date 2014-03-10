Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3019 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbaCJMrz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 08:47:55 -0400
Message-ID: <531DB475.6020909@xs4all.nl>
Date: Mon, 10 Mar 2014 13:47:49 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [GIT PULL FOR v3.15] Add G/S_EDID support for video nodes
References: <531DB2B5.1060202@xs4all.nl>
In-Reply-To: <531DB2B5.1060202@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/10/2014 01:40 PM, Hans Verkuil wrote:
> Currently the VIDIOC_SUBDEV_G/S_EDID and struct v4l2_subdev_edid are subdev
> APIs. However, that's in reality quite annoying since for simple video
> pipelines there is no need to create v4l-subdev device nodes for anything
> else except for setting or getting EDIDs.
> 
> What happens in practice is that v4l2 bridge drivers add explicit support
> for VIDIOC_SUBDEV_G/S_EDID themselves, just to avoid having to create
> subdev device nodes just for this.
> 
> So this patch series makes the ioctls available as regular ioctls as
> well. In that case the pad field is interpreted as the input or output
> index as returned by ENUMINPUT/OUTPUT.
> 
> Rebased to the latest master branch, but otherwise unchanged from the
> REVIEWv1 patch series:
> 
> http://www.spinics.net/lists/linux-media/msg74022.html

Please note that the first patch is also part of a 3.14 patch series I just
posted. It's a fix that should go to 3.14 as well IMHO.

Regards,

	Hans

> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit f2d7313534072a5fe192e7cf46204b413acef479:
> 
>   [media] drx-d: add missing braces in drxd_hard.c:DRXD_init (2014-03-09 09:20:50 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git edid
> 
> for you to fetch changes up to 66090d7c5b127fa4a461394261c50ca2364a286a:
> 
>   DocBook v4l2: update the G/S_EDID documentation (2014-03-10 13:36:29 +0100)
> 
> ----------------------------------------------------------------
> Hans Verkuil (5):
>       v4l2-compat-ioctl32: fix wrong VIDIOC_SUBDEV_G/S_EDID32 support.
>       v4l2: allow v4l2_subdev_edid to be used with video nodes
>       v4l2: add VIDIOC_G/S_EDID support to the v4l2 core.
>       adv*: replace the deprecated v4l2_subdev_edid by v4l2_edid.
>       DocBook v4l2: update the G/S_EDID documentation
> 
>  Documentation/DocBook/media/v4l/v4l2.xml                                        |  2 +-
>  Documentation/DocBook/media/v4l/{vidioc-subdev-g-edid.xml => vidioc-g-edid.xml} | 36 +++++++++++++++++++++++-------------
>  drivers/media/i2c/ad9389b.c                                                     |  2 +-
>  drivers/media/i2c/adv7511.c                                                     |  2 +-
>  drivers/media/i2c/adv7604.c                                                     |  4 ++--
>  drivers/media/i2c/adv7842.c                                                     |  4 ++--
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c                                   | 32 ++++++++++++++++----------------
>  drivers/media/v4l2-core/v4l2-dev.c                                              |  2 ++
>  drivers/media/v4l2-core/v4l2-ioctl.c                                            | 16 +++++++++++++---
>  drivers/media/v4l2-core/v4l2-subdev.c                                           |  4 ++--
>  include/media/v4l2-ioctl.h                                                      |  2 ++
>  include/media/v4l2-subdev.h                                                     |  4 ++--
>  include/uapi/linux/v4l2-common.h                                                |  8 ++++++++
>  include/uapi/linux/v4l2-subdev.h                                                | 14 +++++---------
>  include/uapi/linux/videodev2.h                                                  |  2 ++
>  15 files changed, 82 insertions(+), 52 deletions(-)
>  rename Documentation/DocBook/media/v4l/{vidioc-subdev-g-edid.xml => vidioc-g-edid.xml} (77%)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

