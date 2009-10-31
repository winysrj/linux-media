Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:60689 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977AbZJaTE2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 15:04:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] v4l2_subdev: rename tuner s_standby operation to core s_power
Date: Sat, 31 Oct 2009 20:04:30 +0100
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1254750497-13684-1-git-send-email-laurent.pinchart@ideasonboard.com> <200910120036.37857.laurent.pinchart@ideasonboard.com> <20091031071322.6a234a08@caramujo.chehab.org>
In-Reply-To: <20091031071322.6a234a08@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910312004.30957.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 31 October 2009 10:13:22 Mauro Carvalho Chehab wrote:
> Em Mon, 12 Oct 2009 00:36:37 +0200
> 
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> > On Monday 05 October 2009 15:48:17 Laurent Pinchart wrote:
> > > Upcoming I2C v4l2_subdev drivers need a way to control the subdevice
> > > power state from the core. This use case is already partially covered
> > > by the tuner s_standby operation, but no way to explicitly come back
> > > from the standby state is available.
> > >
> > > Rename the tuner s_standby operation to core s_power, and fix tuner
> > > drivers accordingly. The tuner core will call s_power(0) instead of
> > > s_standby(). No explicit call to s_power(1) is required for tuners as
> > > they are supposed to wake up from standby automatically.
> >
> > Mauro, Hans told me he didn't see anything wrong with this patch. As
> > there's no negative feedback so far (but unfortunately no positive
> > feedback either) can it be applied ?
> 
> It seems ok to me also. Not only tuner devices need to control power, so it
>  seems better to have this as a core operation instead of a tuner specific
>  one.
> 
> ACKED.
> 
> I've applied it at the tree, with a small codingstyle fix.
> 
> Hmm... mailimport script mangled the subject... I'll fix it on -git.

Thanks.

-- 
Regards,

Laurent Pinchart
