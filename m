Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54305 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZC2Jfw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 05:35:52 -0400
Date: Sun, 29 Mar 2009 06:35:45 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Trent Piepho via Mercurial <xyzzy@speakeasy.org>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] v4l2-ioctl: Check format for
 S_PARM and G_PARM
Message-ID: <20090329063545.1bab6a9e@pedra.chehab.org>
In-Reply-To: <200903291106.19466.hverkuil@xs4all.nl>
References: <E1LnqiQ-00077f-80@mail.linuxtv.org>
	<200903291106.19466.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 29 Mar 2009 11:06:19 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On Sunday 29 March 2009 10:50:02 Patch from Trent Piepho wrote:
> > The patch number 11260 was added via Trent Piepho <xyzzy@speakeasy.org>
> > to http://linuxtv.org/hg/v4l-dvb master development tree.
> >
> > Kernel patches in this development tree may be modified to be backward
> > compatible with older kernels. Compatibility modifications will be
> > removed before inclusion into the mainstream Kernel
> >
> > If anyone has any objections, please let us know by sending a message to:
> > 	Linux Media Mailing List <linux-media@vger.kernel.org>
> >
> > ------
> >
> > From: Trent Piepho  <xyzzy@speakeasy.org>
> > v4l2-ioctl:  Check format for S_PARM and G_PARM
> >
> >
> > Return EINVAL if VIDIOC_S/G_PARM is called for a buffer type that the
> > driver doesn't define a ->vidioc_try_fmt_XXX() method for.  Several other
> > ioctls, like QUERYBUF, QBUF, and DQBUF, etc.  do this too.  It saves each
> > driver from having to check if the buffer type is one that it supports.
> 
> Hi Trent,
> 
> I wonder whether this change is correct. Looking at the spec I see that 
> g/s_parm only supports VIDEO_CAPTURE, VIDEO_OUTPUT and PRIVATE or up.
> 
> So what should happen if the type is VIDEO_OVERLAY? I think the g/s_parm 
> implementation in v4l2-ioctl.c should first exclude the unsupported types 
> before calling check_fmt.

Makes sense to me.

> I also wonder whether check_fmt shouldn't check for the presence of the 
> s_fmt callbacks instead of try_fmt since try_fmt is an optional ioctl.

One developer suggested to merge try_fmt and s_fmt into one callback.
IMO, this makes sense, since I have the feeling that this will simplify the
code a little bit on the drivers. If we go this way, then we can check for
the new try_s_fmt callback.

Cheers,
Mauro
