Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42365 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758296AbaGAQXc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jul 2014 12:23:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] Update sync-with-kernel to use installed kernel headers
Date: Tue, 01 Jul 2014 18:24:26 +0200
Message-ID: <5125392.NizmyE01KQ@avalon>
In-Reply-To: <20140701143038.GZ2073@valkosipuli.retiisi.org.uk>
References: <1401792019-20723-1-git-send-email-laurent.pinchart@ideasonboard.com> <20140701143038.GZ2073@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the review.

On Tuesday 01 July 2014 17:30:38 Sakari Ailus wrote:
> On Tue, Jun 03, 2014 at 12:40:19PM +0200, Laurent Pinchart wrote:
> > diff --git a/Makefile.am b/Makefile.am
> > index 11baed1..35d0030 100644
> > --- a/Makefile.am
> > +++ b/Makefile.am
> > @@ -12,31 +12,32 @@ EXTRA_DIST = include COPYING.libv4l README.libv4l
> > README.lib-multi-threading> 
> >  # custom targets
> > 
> >  sync-with-kernel:
> > -	@if [ ! -f $(KERNEL_DIR)/include/uapi/linux/videodev2.h -o \
> > -	      ! -f $(KERNEL_DIR)/include/uapi/linux/fb.h -o \
> > -	      ! -f $(KERNEL_DIR)/include/uapi/linux/v4l2-controls.h -o \
> > -	      ! -f $(KERNEL_DIR)/include/uapi/linux/v4l2-common.h -o \
> > -	      ! -f $(KERNEL_DIR)/include/uapi/linux/v4l2-subdev.h -o \
> > -	      ! -f $(KERNEL_DIR)/include/uapi/linux/v4l2-mediabus.h -o \
> > -	      ! -f $(KERNEL_DIR)/include/uapi/linux/ivtv.h -o \
> > -	      ! -f $(KERNEL_DIR)/include/uapi/linux/dvb/frontend.h -o \
> > -	      ! -f $(KERNEL_DIR)/include/uapi/linux/dvb/dmx.h -o \
> > -	      ! -f $(KERNEL_DIR)/include/uapi/linux/dvb/audio.h -o \
> > -	      ! -f $(KERNEL_DIR)/include/uapi/linux/dvb/video.h ]; then \
> > +	@if [ ! -f $(KERNEL_DIR)/usr/include/linux/videodev2.h -o \
> 
> Shouldn't you use $(INSTALL_HDR_PATH) instead of $(KERNEL_DIR)/usr? If the
> user sets that, the headers won't be installed under usr.

INSTALL_HDR_PATH is only set when running make headers_install in the kernel 
tree, not when running make sync-with-kernel in the media built tree. If we 
want to support syncing with kernel headers installed elsewhere we should add 
a new option to this Makefile. I haven't done so as the need isn't clear to 
me.

-- 
Regards,

Laurent Pinchart

