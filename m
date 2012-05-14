Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1219 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab2ENP5n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 11:57:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [GIT PULL FOR v3.5] Three small improvements
Date: Mon, 14 May 2012 17:57:37 +0200
Cc: linux-media@vger.kernel.org
References: <201205141637.23510.hverkuil@xs4all.nl> <2197880.FrgH45SkDS@avalon>
In-Reply-To: <2197880.FrgH45SkDS@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205141757.37958.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon May 14 2012 16:47:19 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday 14 May 2012 16:37:23 Hans Verkuil wrote:
> > Hi Mauro, Laurent,
> > 
> > I hope that these three patches address the comments Laurent made.
> 
> Thank you. There's a typo in the first patch:
> 
> "Otherwise you give it a pointer to a struct mutex_lock and the unlocked_ioctl
> file operation is called this lock will be taken by the core and released
> afterwards. See the next section for more details."
> 
> I suppose it should read "... and *before* the unlocked_ioctl ...".

Indeed. Fixed in my git repository.

> The rest looks OK to me (you haven't renamed valid_ioctls to invalid_ioctls, 
> but I suppose that was on purpose).

Yes, that was on purpose. I am not planning to change that.

Regards,

	Hans

> 
> > The only remaining item is to take the ioctl lock after copy_from user is
> > called. But that's for 3.6.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > The following changes since commit e89fca923f32de26b69bf4cd604f7b960b161551:
> > 
> >   [media] gspca - ov534: Add Hue control (2012-05-14 09:48:00 -0300)
> > 
> > are available in the git repository at:
> > 
> >   git://linuxtv.org/hverkuil/media_tree.git update
> > 
> > for you to fetch changes up to 308cb1f20bcaba72c8234794479cf8962c13032f:
> > 
> >   v4l2-dev: rename two functions. (2012-05-14 16:32:48 +0200)
> > 
> > ----------------------------------------------------------------
> > Hans Verkuil (3):
> >       v4l2-framework.txt: update the core lock documentation.
> >       v4l2-dev.h: add comment not to use V4L2_FL_LOCK_ALL_FOPS in new
> > drivers. v4l2-dev: rename two functions.
> > 
> >  Documentation/video4linux/v4l2-framework.txt |   18 +++++++++---------
> >  drivers/media/video/gspca/gspca.c            |    6 +++---
> >  drivers/media/video/pwc/pwc-if.c             |    6 +++---
> >  drivers/media/video/v4l2-dev.c               |    2 +-
> >  include/media/v4l2-dev.h                     |   12 ++++++------
> >  sound/i2c/other/tea575x-tuner.c              |    2 +-
> >  6 files changed, 23 insertions(+), 23 deletions(-)
> 
> 
