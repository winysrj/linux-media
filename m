Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:15335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab1EELdY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2011 07:33:24 -0400
Message-ID: <4DC28B00.50505@redhat.com>
Date: Thu, 05 May 2011 08:33:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.40] Make the UVC API public (and minor enhancements)
References: <201104271238.03887.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201104271238.03887.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 27-04-2011 07:38, Laurent Pinchart escreveu:
> Hi Mauro,
> 
> These patches move the uvcvideo.h header file from drivers/media/video/uvc
> to include/linux, making the UVC API public. Support for the old API is kept
> and will be removed in 2.6.42.
> 
> The following changes since commit a4761a092fd3b6bf8b5f9cfe361670c86cdcc8ca:
> 
>   [media] tm6000: fix vbuf may be used uninitialized (2011-04-19 21:13:59 -0300)
> 
> are available in the git repository at:
>   git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next
> 
> Laurent Pinchart (5):
>       uvcvideo: Deprecate UVCIOC_CTRL_{ADD,MAP_OLD,GET,SET}
>       uvcvideo: Rename UVC_CONTROL_* flags to UVC_CTRL_FLAG_*
>       uvcvideo: Make the API public

Why are you declaring this twice:

Index: patchwork/drivers/media/video/uvc/uvcvideo.h

...

+#ifndef __KERNEL__
 #define UVCIOC_CTRL_ADD              _IOW('U', 1, struct uvc_xu_control_info)
#define UVCIOC_CTRL_MAP_OLD  _IOWR('U', 2, struct uvc_xu_control_mapping_old)
 #define UVCIOC_CTRL_MAP              _IOWR('U', 2, struct uvc_xu_control_mapping)
 #define UVCIOC_CTRL_GET              _IOWR('U', 3, struct uvc_xu_control)
 #define UVCIOC_CTRL_SET        	_IOW('U', 4, struct uvc_xu_control)
-#define UVCIOC_CTRL_QUERY    _IOWR('U', 5, struct uvc_xu_control_query)
+#else
+#define __UVCIOC_CTRL_ADD    _IOW('U', 1, struct uvc_xu_control_info)
+#define __UVCIOC_CTRL_MAP_OLD        _IOWR('U', 2, struct uvc_xu_control_mapping_old)
+#define __UVCIOC_CTRL_MAP    _IOWR('U', 2, struct uvc_xu_control_mapping)
+#define __UVCIOC_CTRL_GET    _IOWR('U', 3, struct uvc_xu_control)
+#define __UVCIOC_CTRL_SET    _IOW('U', 4, struct uvc_xu_control)
+#endif

You shouldn't need to do that. In fact, the better would be to have two separate
headers: one with just the public API under include/linux, and another with the
extra uvc-internal bits, as we did in the past with videobuf2.h.

As the other patches don't depend on this one, I'm applying the remaining patches,
in order to save me the time of review the entire series again.

>       uvcvideo: Add support for V4L2_PIX_FMT_RGB565
>       uvcvideo: Add support for JMicron USB2.0 XGA WebCam
> 
> Martin Rubli (2):
>       uvcvideo: Add UVCIOC_CTRL_QUERY ioctl
>       uvcvideo: Add driver documentation
> 
>  Documentation/feature-removal-schedule.txt |   23 ++
>  Documentation/ioctl/ioctl-number.txt       |    2 +-
>  Documentation/video4linux/uvcvideo.txt     |  239 ++++++++++++++++++++
>  drivers/media/video/uvc/uvc_ctrl.c         |  332 +++++++++++++++++-----------
>  drivers/media/video/uvc/uvc_driver.c       |   14 ++
>  drivers/media/video/uvc/uvc_v4l2.c         |   51 ++++-
>  drivers/media/video/uvc/uvcvideo.h         |   57 ++++--
>  include/linux/Kbuild                       |    1 +
>  include/linux/uvcvideo.h                   |   69 ++++++
>  9 files changed, 625 insertions(+), 163 deletions(-)
>  create mode 100644 Documentation/video4linux/uvcvideo.txt
>  create mode 100644 include/linux/uvcvideo.h
> 

