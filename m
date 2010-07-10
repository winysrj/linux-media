Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4314 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab0GJQf6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jul 2010 12:35:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH v2 0/7] V4L2 subdev userspace API
Date: Sat, 10 Jul 2010 18:38:22 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1278689512-30849-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1278689512-30849-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201007101838.22084.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks good, I have no comments for this patch series.

Regards,

	Hans

On Friday 09 July 2010 17:31:45 Laurent Pinchart wrote:
> Hi everybody,
> 
> Here's the second version of the V4L2 subdev userspace API patches. Comments
> received on the first version have been incorporated, with the exception of the
> video_usercopy usage as this is still under discussion.
> 
> A problem with module reference counting has also been solved by setting the
> owner of the subdev device node to the subdev driver, not videodev.ko. This
> required a change to the v4l2_i2c_new_subdev_board function prototype, and thus
> a modification to the radio-si4713 driver.
> 
> Due to the fast review (thanks everybody) I haven't had time to finish the media
> controller core patches, but they will arrive soon.
> 
> Laurent Pinchart (6):
>   v4l: subdev: Don't require core operations
>   v4l: Merge v4l2_i2c_new_subdev_cfg and v4l2_i2c_new_subdev
>   v4l: subdev: Add device node support
>   v4l: subdev: Uninline the v4l2_subdev_init function
>   v4l: subdev: Control ioctls support
>   v4l: subdev: Generic ioctl support
> 
> Sakari Ailus (1):
>   v4l: subdev: Events support
> 
>  Documentation/video4linux/v4l2-framework.txt |   57 +++++++++
>  drivers/media/radio/radio-si4713.c           |    2 +-
>  drivers/media/video/Makefile                 |    2 +-
>  drivers/media/video/soc_camera.c             |    2 +-
>  drivers/media/video/v4l2-common.c            |   22 ++--
>  drivers/media/video/v4l2-dev.c               |   27 ++---
>  drivers/media/video/v4l2-device.c            |   25 ++++-
>  drivers/media/video/v4l2-subdev.c            |  172 ++++++++++++++++++++++++++
>  include/media/v4l2-common.h                  |   21 +---
>  include/media/v4l2-dev.h                     |   18 +++-
>  include/media/v4l2-subdev.h                  |   40 ++++---
>  11 files changed, 326 insertions(+), 62 deletions(-)
>  create mode 100644 drivers/media/video/v4l2-subdev.c
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
