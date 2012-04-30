Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2981 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab2D3Fzu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 01:55:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [GIT PULL FOR v3.5] cpia2: major overhaul to get it in a working state again.
Date: Mon, 30 Apr 2012 07:55:42 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>,
	andrea.merello@gmail.com
References: <201204291357.36484.hverkuil@xs4all.nl> <1335743485.25802.15.camel@palomino.walls.org>
In-Reply-To: <1335743485.25802.15.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204300755.42948.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday, April 30, 2012 01:51:20 Andy Walls wrote:
> On Sun, 2012-04-29 at 13:57 +0200, Hans Verkuil wrote:
> > Hi all,
> > 
> > I managed to get hold of a cpia2-based Hanse USB microscope almost a year
> > ago after reports from Andrea that the driver didn't work properly.
> > 
> > I finally had time to take a really good look at the driver and it was
> > broken in many respects. This patch brings the driver up to speed with
> > respect to the v4l2 framework and it now works as expected, including
> > disconnect handling and suspend/resume handling.
> > 
> > The only thing left to do some day is to convert it to the videobuf2
> > framework.
> 
> Hans,
> 
> cpia2_s_ctrl() doesn't seem to have a case for V4L2_CID_ILLUMINATORS_2.
> Does control cluster magic take care of that?

Correct, the two illuminator controls are clustered so only the 'master
control' (ILLUMINATORS_1) shows up in the switch.

Regards,

	Hans

> 
> Regards,
> Andy
> 
> > Regards,
> > 
> > 	Hans
> > 
> > The following changes since commit bcb2cf6e0bf033d79821c89e5ccb328bfbd44907:
> > 
> >   [media] ngene: remove an unneeded condition (2012-04-26 15:29:23 -0300)
> > 
> > are available in the git repository at:
> > 
> >   git://linuxtv.org/hverkuil/media_tree.git cpia2
> > 
> > for you to fetch changes up to 14a3d232eb5d25c768f40fbd6a87db48a249a391:
> > 
> >   cpia2: major overhaul to get it in a working state again. (2012-04-29 13:44:44 +0200)
> > 
> > ----------------------------------------------------------------
> > Hans Verkuil (1):
> >       cpia2: major overhaul to get it in a working state again.
> > 
> >  drivers/media/video/cpia2/cpia2.h      |   34 ++-
> >  drivers/media/video/cpia2/cpia2_core.c |  142 +++---------
> >  drivers/media/video/cpia2/cpia2_usb.c  |   78 +++++--
> >  drivers/media/video/cpia2/cpia2_v4l.c  |  846 +++++++++++++++++++++------------------------------------------------
> >  drivers/media/video/cpia2/cpia2dev.h   |   50 -----
> >  5 files changed, 363 insertions(+), 787 deletions(-)
> >  delete mode 100644 drivers/media/video/cpia2/cpia2dev.h
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
