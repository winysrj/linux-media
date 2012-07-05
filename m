Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:13156 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2GEIgk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 04:36:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [GIT PULL FOR v3.6] mostly remove V4L2_FL_LOCK_ALL_FOPS
Date: Thu, 5 Jul 2012 10:36:36 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201207041942.04606.hverkuil@xs4all.nl> <201207050854.20966.hverkuil@xs4all.nl> <4FF55042.6090102@samsung.com>
In-Reply-To: <4FF55042.6090102@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207051036.36803.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 5 July 2012 10:28:50 Sylwester Nawrocki wrote:
> Hi Hans,
> 
> On 07/05/2012 08:54 AM, Hans Verkuil wrote:
> > Hi Sylwester,
> > 
> > It still doesn't apply. This patch starts with:
> > 
> > diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
> > index da2c40e..cb04a870 100644
> > --- a/drivers/media/video/s5p-fimc/fimc-capture.c
> > +++ b/drivers/media/video/s5p-fimc/fimc-capture.c
> > @@ -480,48 +480,59 @@ static int fimc_capture_set_default_format(struct fimc_dev *fimc);
> >  static int fimc_capture_open(struct file *file)
> >  {
> >         struct fimc_dev *fimc = video_drvdata(file);
> > -       int ret;
> > +       int ret = -EBUSY;
> > 
> > The actual current source code starts with:
> > 
> > static int fimc_capture_open(struct file *file)
> > {
> >         struct fimc_dev *fimc = video_drvdata(file);
> >         int ret = v4l2_fh_open(file);
> > 
> > Quite different. That 'int ret = v4l2_fh_open(file);' line was added June 10th, 2011, so
> > I don't understand why that isn't in your git repository.
> 
> Because is has been removed by one of patches from v4l-fimc-fixes branch
> that I sent to Mauro on 25th of May and is still not upstream.
> Branch v4l-fimc-next depends on v4l-fimc-fixes, sorry if it wasn't clear
> enough. You need to pull v4l-fimc-fixes branch first. If I would have
> rebased patches for -next then the fixup patches wouldn't apply. That
> just doesn't seem right.

Ah, OK. Sorry, I misunderstood.

In that case I'll just wait for Mauro to pull in the fimc-fixes, and then
I'll make another pull request to get this last FOPS usage fixed. If I start
pulling in fixes trees as well, then that's going to be confusing.

It's OK to have a second pull request later to finalize this as there is no
urgency associated with these patches.

Regards,

	Hans

> Mauro, are you going to send another pull request to Linus for 3.5-rc,
> including these patches: http://patchwork.linuxtv.org/patch/11503 ?
> 
> Regards,
> 
