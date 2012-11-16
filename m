Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2087 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab2KPOJZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 09:09:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 0/6] uvcvideo: V4L2 compliance fixes
Date: Fri, 16 Nov 2012 15:09:20 +0100
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1348758980-21683-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1348758980-21683-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211161509.20625.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

My apologies for the long delay before I got around to reviewing these.

On Thu September 27 2012 17:16:14 Laurent Pinchart wrote:
> Hi everybody,
> 
> Here are 6 patches that fix V4L2 compliance issues in the uvcvideo driver found
> by the v4l2-compliance tool.
> 
> I'm working on the last remaining issue (control classes not implemented).
> 
> Laurent Pinchart (6):
>   uvcvideo: Set error_idx properly for extended controls API failures
>   uvcvideo: Return -EACCES when trying to access a read/write-only
>     control
>   uvcvideo: Don't fail when an unsupported format is requested
>   uvcvideo: Set device_caps in VIDIOC_QUERYCAP
>   uvcvideo: Return -ENOTTY for unsupported ioctls
>   uvcvideo: Add VIDIOC_[GS]_PRIORITY support
> 
>  drivers/media/usb/uvc/uvc_ctrl.c   |   21 +++++----
>  drivers/media/usb/uvc/uvc_driver.c |    8 +++
>  drivers/media/usb/uvc/uvc_v4l2.c   |   89 ++++++++++++++++++++++++++++-------
>  drivers/media/usb/uvc/uvc_video.c  |    1 +
>  drivers/media/usb/uvc/uvcvideo.h   |    4 ++
>  5 files changed, 96 insertions(+), 27 deletions(-)
> 
> 

For patches 1, 2, 3 and 5:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

I've got some comments for patches 4 and 6. See my reply to those.

Regards,

	Hans
