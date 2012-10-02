Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4592 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab2JBGum (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 02:50:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL FOR v3.7] Add missing vidioc-subdev-g-edid.xml.
Date: Tue, 2 Oct 2012 08:50:24 +0200
Cc: LMML <linux-media@vger.kernel.org>,
	Dan Carpenter <dan.carpenter@oracle.com>
References: <201209251356.34176.hverkuil@xs4all.nl> <201209261033.51510.hverkuil@xs4all.nl> <20121001152456.16923835@redhat.com>
In-Reply-To: <20121001152456.16923835@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210020850.24144.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon October 1 2012 20:24:56 Mauro Carvalho Chehab wrote:
> Em Wed, 26 Sep 2012 10:33:51 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On Tue 25 September 2012 13:56:34 Hans Verkuil wrote:
> > > Hi Mauro,
> > > 
> > > As requested!
> > 
> > I've respun this tree, fixing one documentation bug (the max value for
> > 'blocks' is 256, not 255) and adding an overflow check in v4l2-ioctl.c as
> > reported by Dan Carpenter:
> > 
> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg52640.html
> 
> It seems you forgot to send the patches for review at the ML (at least, I'm
> not seeing it on my linux-media local inbox).

Posted them (after rebasing to the latest for_3.7).

> Also, please document it better. Only after reading Dan's email I was able
> to understand *why* you wrote such patch, as your patch description is bogus:
> 
> > Subject: Return -EINVAL if blocks > 256.

Hmm, the patch description I see is:

	v4l2-ioctl: add overflow check for VIDIOC_SUBDEV_G/S_EDID

	Return -EINVAL if blocks > 256.

Which I thought was clear enough. Anyway, I've improved it. Strictly speaking
this isn't an overflow check, it's a check for insane memory allocations.

Regards,

	Hans

> >
> >...
> >
> >@@ -2205,6 +2205,10 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
> >                struct v4l2_subdev_edid *edid = parg;
> > 
> >                if (edid->blocks) {
> >+                       if (edid->blocks > 256) {
> >+                               ret = -EINVAL;
> >+                               break;
> 
> Well, Kernel developers are generally able to read C, so you don't need to repeat
> what's written at the code as the patch subject ;)
> 
> Dan's comment provides the reason why this patch is needed:
> 
> >  2207                          *array_size = edid->blocks * 128;
> >                                              ^^^^^^^^^^^^^^^^^^
> > This can overflow.
> 
> So, the patch subject should be saying, instead:
> 
> v4l2-ioctl: limit the max amount of edid blocks to avoid overflow
> 
> and putting Dan's comments in the body of the patch description.
> 
> Thanks!
> Mauro
> 
