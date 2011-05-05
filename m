Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51522 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab1EELjy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 07:39:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES FOR 2.6.40] Make the UVC API public (and minor enhancements)
Date: Thu, 5 May 2011 13:40:26 +0200
Cc: linux-media@vger.kernel.org
References: <201104271238.03887.laurent.pinchart@ideasonboard.com> <4DC28B00.50505@redhat.com>
In-Reply-To: <4DC28B00.50505@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105051340.26661.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Thursday 05 May 2011 13:33:20 Mauro Carvalho Chehab wrote:
> Em 27-04-2011 07:38, Laurent Pinchart escreveu:
> > Hi Mauro,
> > 
> > These patches move the uvcvideo.h header file from
> > drivers/media/video/uvc to include/linux, making the UVC API public.
> > Support for the old API is kept and will be removed in 2.6.42.
> > 
> > The following changes since commit 
a4761a092fd3b6bf8b5f9cfe361670c86cdcc8ca:
> >   [media] tm6000: fix vbuf may be used uninitialized (2011-04-19 21:13:59
> >   -0300)
> > 
> > are available in the git repository at:
> >   git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next
> > 
> > Laurent Pinchart (5):
> >       uvcvideo: Deprecate UVCIOC_CTRL_{ADD,MAP_OLD,GET,SET}
> >       uvcvideo: Rename UVC_CONTROL_* flags to UVC_CTRL_FLAG_*
> >       uvcvideo: Make the API public
> 
> Why are you declaring this twice:
> 
> Index: patchwork/drivers/media/video/uvc/uvcvideo.h
> 
> ...
> 
>+#ifndef __KERNEL__
> #define UVCIOC_CTRL_ADD     _IOW('U', 1, struct uvc_xu_control_info)
> #define UVCIOC_CTRL_MAP_OLD _IOWR('U', 2, struct uvc_xu_control_mapping_old)
> #define UVCIOC_CTRL_MAP     _IOWR('U', 2, struct uvc_xu_control_mapping)
> #define UVCIOC_CTRL_GET     _IOWR('U', 3, struct uvc_xu_control)
> #define UVCIOC_CTRL_SET     _IOW('U', 4, struct uvc_xu_control)
>-#define UVCIOC_CTRL_QUERY   _IOWR('U', 5, struct uvc_xu_control_query)
>+#else
>+#define __UVCIOC_CTRL_ADD   _IOW('U', 1, struct uvc_xu_control_info)
>+#define __UVCIOC_CTRL_MAP_OLD _IOWR('U', 2, struct 
uvc_xu_control_mapping_old)
>+#define __UVCIOC_CTRL_MAP   _IOWR('U', 2, struct uvc_xu_control_mapping)
>+#define __UVCIOC_CTRL_GET   _IOWR('U', 3, struct uvc_xu_control)
>+#define __UVCIOC_CTRL_SET   _IOW('U', 4, struct uvc_xu_control)
>+#endif

For compatibility with existing applications. Applications should now include 
linux/uvcvideo.h instead of drivers/media/video/uvc/uvcvideo.h, but existing 
applications include the later. I want to make sure they will still compile. A 
warning will be printed, and this will be removed in 2.6.42.

> You shouldn't need to do that. In fact, the better would be to have two
> separate headers: one with just the public API under include/linux, and
> another with the extra uvc-internal bits, as we did in the past with
> videobuf2.h.

That's how linux/uvcvideo.h and drivers/media/video/uvc/uvcvideo.h are 
partitioned by this patch set, except that the private header still contains 
userspace API to avoid breaking applications during the transition period.

> As the other patches don't depend on this one, I'm applying the remaining
> patches, in order to save me the time of review the entire series again.
> 
> >       uvcvideo: Add support for V4L2_PIX_FMT_RGB565
> >       uvcvideo: Add support for JMicron USB2.0 XGA WebCam
> > 
> > Martin Rubli (2):
> >       uvcvideo: Add UVCIOC_CTRL_QUERY ioctl
> >       uvcvideo: Add driver documentation
> >  
> >  Documentation/feature-removal-schedule.txt |   23 ++
> >  Documentation/ioctl/ioctl-number.txt       |    2 +-
> >  Documentation/video4linux/uvcvideo.txt     |  239 ++++++++++++++++++++
> >  drivers/media/video/uvc/uvc_ctrl.c         |  332
> >  +++++++++++++++++----------- drivers/media/video/uvc/uvc_driver.c      
> >  |   14 ++
> >  drivers/media/video/uvc/uvc_v4l2.c         |   51 ++++-
> >  drivers/media/video/uvc/uvcvideo.h         |   57 ++++--
> >  include/linux/Kbuild                       |    1 +
> >  include/linux/uvcvideo.h                   |   69 ++++++
> >  9 files changed, 625 insertions(+), 163 deletions(-)
> >  create mode 100644 Documentation/video4linux/uvcvideo.txt
> >  create mode 100644 include/linux/uvcvideo.h

-- 
Regards,

Laurent Pinchart
