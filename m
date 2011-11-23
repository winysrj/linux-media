Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55663 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab1KWNW3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 08:22:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH 4/4] uvcvideo: Add UVC timestamps support
Date: Wed, 23 Nov 2011 14:22:22 +0100
Cc: linux-media@vger.kernel.org, Yann Sionneau <yann@minet.net>
References: <1320753962-14079-1-git-send-email-laurent.pinchart@ideasonboard.com> <1320753962-14079-5-git-send-email-laurent.pinchart@ideasonboard.com> <CACKLOr2XoEWba_aYvV==6czbinHaAVK1Ufxu0kHpZcoWpz7DDQ@mail.gmail.com>
In-Reply-To: <CACKLOr2XoEWba_aYvV==6czbinHaAVK1Ufxu0kHpZcoWpz7DDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111231422.23898.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Thursday 17 November 2011 13:14:26 javier Martin wrote:
> On 8 November 2011 13:06, Laurent Pinchart wrote:
> >  void uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type
> > type, diff --git a/drivers/media/video/uvc/uvc_video.c
> > b/drivers/media/video/uvc/uvc_video.c index 513ba30..d0600a5 100644
> > --- a/drivers/media/video/uvc/uvc_video.c
> > +++ b/drivers/media/video/uvc/uvc_video.c
> 
> [snip]
> 
> > +       ts.tv_sec = first->host_ts.tv_sec - 1 + y / NSEC_PER_SEC;
> > +       ts.tv_nsec = first->host_ts.tv_nsec + y % NSEC_PER_SEC;
> 
> I'm trying to build the uvcvideo-next branch which includes this patch
> and the previous two lines give the following error:
> 
> drivers/built-in.o: In function `uvc_video_clock_update':
> /home/javier/GIT/linux-uvc/drivers/media/video/uvc/uvc_video.c:656:
> undefined reference to `__aeabi_uldivmod'
> /home/javier/GIT/linux-uvc/drivers/media/video/uvc/uvc_video.c:657:
> undefined reference to `__aeabi_uldivmod'
> 
> I am using gcc version 4.2.3 (Sourcery G++ Lite 2008q1-126) for ARM.

Thanks for the report. I've fixed this and updated the uvcvideo-next branch.

-- 
Regards,

Laurent Pinchart
