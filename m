Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45518 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaBSMHH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Feb 2014 07:07:07 -0500
Message-ID: <1392811618.3445.43.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v2 0/3] uvcvideo VIDIOC_CREATE_BUFS support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Date: Wed, 19 Feb 2014 13:06:58 +0100
In-Reply-To: <1392737656-16177-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1392737656-16177-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Dienstag, den 18.02.2014, 16:34 +0100 schrieb Laurent Pinchart:
> Hello,
> 
> Here's the second version of the VIDIOC_CREATE_BUFS support for uvcvideo patch
> set.
> 
> Compared to v1, patch 3/3 acquires privileges instead of merely checking for
> them. Now the driver passes the VIDIOC_CREATE_BUFS v4l2-compliance test.
> 
> Laurent Pinchart (2):
>   uvcvideo: Remove duplicate check for number of buffers in queue_setup
>   uvcvideo: Support allocating buffers larger than the current frame
>     size
> 
> Philipp Zabel (1):
>   uvcvideo: Enable VIDIOC_CREATE_BUFS
> 
>  drivers/media/usb/uvc/uvc_queue.c | 20 +++++++++++++++++---
>  drivers/media/usb/uvc/uvc_v4l2.c  | 11 +++++++++++
>  drivers/media/usb/uvc/uvcvideo.h  |  4 ++--
>  3 files changed, 30 insertions(+), 5 deletions(-)

Again,
Tested-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

