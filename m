Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43197 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbbBQUuI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 15:50:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 3/6] uvc gadget: switch to v4l2 core locking
Date: Tue, 17 Feb 2015 22:51:02 +0200
Message-ID: <1478373.Z0MeTcWs1H@avalon>
In-Reply-To: <1424162649-17249-4-git-send-email-hverkuil@xs4all.nl>
References: <1424162649-17249-1-git-send-email-hverkuil@xs4all.nl> <1424162649-17249-4-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Tuesday 17 February 2015 09:44:06 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Switch this driver over to the V4L2 core locking mechanism in preparation
> for switching to unlocked_ioctl. Suggested by Laurent Pinchart.
> 
> This patch introduces a new mutex at the struct uvc_video level and
> drops the old mutex at the queue level. The new lock is now used for all
> ioctl locking and in the release file operation (the driver always has
> to take care of locking in file operations, the core only serializes
> ioctls).

The patch also drops locking in the mmap and get_unmapped_area functions, 
shouldn't you mention it in the commit message ? Or possibly split that change 
to a separate patch, as that's a bugfix by itself (taking the queue lock there 
creates a possible AB-BA deadlock).

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/usb/gadget/function/f_uvc.c     |  2 +
>  drivers/usb/gadget/function/uvc.h       |  1 +
>  drivers/usb/gadget/function/uvc_queue.c | 79 +++++-------------------------
>  drivers/usb/gadget/function/uvc_queue.h |  4 +-
>  drivers/usb/gadget/function/uvc_v4l2.c  |  3 +-
>  drivers/usb/gadget/function/uvc_video.c |  3 +-
>  6 files changed, 22 insertions(+), 70 deletions(-)

-- 
Regards,

Laurent Pinchart

