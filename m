Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33868 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754039AbaGGOdo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jul 2014 10:33:44 -0400
Date: Mon, 7 Jul 2014 17:33:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] Update sync-with-kernel to use installed kernel headers
Message-ID: <20140707143338.GA16460@valkosipuli.retiisi.org.uk>
References: <1401792019-20723-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <20140701143038.GZ2073@valkosipuli.retiisi.org.uk>
 <5125392.NizmyE01KQ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5125392.NizmyE01KQ@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 01, 2014 at 06:24:26PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the review.
> 
> On Tuesday 01 July 2014 17:30:38 Sakari Ailus wrote:
> > On Tue, Jun 03, 2014 at 12:40:19PM +0200, Laurent Pinchart wrote:
> > > diff --git a/Makefile.am b/Makefile.am
> > > index 11baed1..35d0030 100644
> > > --- a/Makefile.am
> > > +++ b/Makefile.am
> > > @@ -12,31 +12,32 @@ EXTRA_DIST = include COPYING.libv4l README.libv4l
> > > README.lib-multi-threading> 
> > >  # custom targets
> > > 
> > >  sync-with-kernel:
> > > -	@if [ ! -f $(KERNEL_DIR)/include/uapi/linux/videodev2.h -o \
> > > -	      ! -f $(KERNEL_DIR)/include/uapi/linux/fb.h -o \
> > > -	      ! -f $(KERNEL_DIR)/include/uapi/linux/v4l2-controls.h -o \
> > > -	      ! -f $(KERNEL_DIR)/include/uapi/linux/v4l2-common.h -o \
> > > -	      ! -f $(KERNEL_DIR)/include/uapi/linux/v4l2-subdev.h -o \
> > > -	      ! -f $(KERNEL_DIR)/include/uapi/linux/v4l2-mediabus.h -o \
> > > -	      ! -f $(KERNEL_DIR)/include/uapi/linux/ivtv.h -o \
> > > -	      ! -f $(KERNEL_DIR)/include/uapi/linux/dvb/frontend.h -o \
> > > -	      ! -f $(KERNEL_DIR)/include/uapi/linux/dvb/dmx.h -o \
> > > -	      ! -f $(KERNEL_DIR)/include/uapi/linux/dvb/audio.h -o \
> > > -	      ! -f $(KERNEL_DIR)/include/uapi/linux/dvb/video.h ]; then \
> > > +	@if [ ! -f $(KERNEL_DIR)/usr/include/linux/videodev2.h -o \
> > 
> > Shouldn't you use $(INSTALL_HDR_PATH) instead of $(KERNEL_DIR)/usr? If the
> > user sets that, the headers won't be installed under usr.
> 
> INSTALL_HDR_PATH is only set when running make headers_install in the kernel 
> tree, not when running make sync-with-kernel in the media built tree. If we 
> want to support syncing with kernel headers installed elsewhere we should add 
> a new option to this Makefile. I haven't done so as the need isn't clear to 
> me.

Ok. Please then ignore my comment.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
