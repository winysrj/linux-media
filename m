Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:4999 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbZC2Jk7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 05:40:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] v4l2-ioctl: Check format for S_PARM and G_PARM
Date: Sun, 29 Mar 2009 11:40:31 +0200
Cc: linux-media@vger.kernel.org,
	Trent Piepho via Mercurial <xyzzy@speakeasy.org>
References: <E1LnqiQ-00077f-80@mail.linuxtv.org> <200903291106.19466.hverkuil@xs4all.nl> <20090329063545.1bab6a9e@pedra.chehab.org>
In-Reply-To: <20090329063545.1bab6a9e@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903291140.31388.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 29 March 2009 11:35:45 Mauro Carvalho Chehab wrote:
> On Sun, 29 Mar 2009 11:06:19 +0200
>
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Sunday 29 March 2009 10:50:02 Patch from Trent Piepho wrote:
> > > The patch number 11260 was added via Trent Piepho
> > > <xyzzy@speakeasy.org> to http://linuxtv.org/hg/v4l-dvb master
> > > development tree.
> > >
> > > Kernel patches in this development tree may be modified to be
> > > backward compatible with older kernels. Compatibility modifications
> > > will be removed before inclusion into the mainstream Kernel
> > >
> > > If anyone has any objections, please let us know by sending a message
> > > to: Linux Media Mailing List <linux-media@vger.kernel.org>
> > >
> > > ------
> > >
> > > From: Trent Piepho  <xyzzy@speakeasy.org>
> > > v4l2-ioctl:  Check format for S_PARM and G_PARM
> > >
> > >
> > > Return EINVAL if VIDIOC_S/G_PARM is called for a buffer type that the
> > > driver doesn't define a ->vidioc_try_fmt_XXX() method for.  Several
> > > other ioctls, like QUERYBUF, QBUF, and DQBUF, etc.  do this too.  It
> > > saves each driver from having to check if the buffer type is one that
> > > it supports.
> >
> > Hi Trent,
> >
> > I wonder whether this change is correct. Looking at the spec I see that
> > g/s_parm only supports VIDEO_CAPTURE, VIDEO_OUTPUT and PRIVATE or up.
> >
> > So what should happen if the type is VIDEO_OVERLAY? I think the
> > g/s_parm implementation in v4l2-ioctl.c should first exclude the
> > unsupported types before calling check_fmt.
>
> Makes sense to me.
>
> > I also wonder whether check_fmt shouldn't check for the presence of the
> > s_fmt callbacks instead of try_fmt since try_fmt is an optional ioctl.
>
> One developer suggested to merge try_fmt and s_fmt into one callback.
> IMO, this makes sense, since I have the feeling that this will simplify
> the code a little bit on the drivers. If we go this way, then we can
> check for the new try_s_fmt callback.

I agree with this. It's also easy to gradually migrate to such a new 
callback since it is probably quite difficult to do this in one big bang 
patch.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
