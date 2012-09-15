Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3014 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab2IOHeE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 03:34:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFCv3 API PATCH 00/31] Full series of API fixes from the 2012 Media Workshop
Date: Sat, 15 Sep 2012 09:33:21 +0200
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com> <5053A115.9060303@iki.fi>
In-Reply-To: <5053A115.9060303@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209150933.21699.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri September 14 2012 23:26:45 Sakari Ailus wrote:
> Hans Verkuil wrote:
> > Hi all,
> >
> > This is the full patch series containing API fixes as discussed during the
> > 2012 Media Workshop.
> >
> > Regarding the 'make ioctl const' patches: I've only done the easy ones in
> > this patch series. The remaining write-only ioctls are used much more widely,
> > so changing those will happen later.
> >
> > The last few patches that enhance the core code with more stringent tests
> > against what ioctls can be called for which types of device node will need
> > reviewing. I have tested it exhaustively with ivtv (which is one of the
> > most complex drivers, and the only one that has exotic devices like VBI
> > out).
> >
> > To use v4l2-compliance with ivtv I also needed to make a few other fixes
> > elsewhere. The tree with both this patch series and the addition ivtv fixes
> > can be found here:
> >
> > http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/ivtv
> >
> > I have also tested this patch series (actually a slightly older version)
> > with em28xx. That driver needed a lot of changes to get it to pass the
> > v4l2-compliance tests. Those can be found here:
> >
> > http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/em28xx
> 
> Hi, Hans!
> 
> Thanks for the patchset!
> 
> On patch 7 (which I somehow managed not to receive): both cx18 and ivtv 
> contain references to V4L2_BUF_TYPE_PRIVATE. I wonder if that's intentional.

Yes. Those streams are, well, private to those drivers. It's just an internal
placeholder and could be replaced by a cx18/ivtv specific define.

Perhaps I should do that anyway to prevent exactly this confusion.

> For patches 2, 3, 4, 6, 8, 17 and 28 (for omap3isp)
> 
> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> And for patches 5, 11, 18
> 
> Reviewed-by: Sakari Ailus <sakari.ailus@iki.fi>

Thanks!

Regards,

	Hans
