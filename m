Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35664 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab2GWMh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 08:37:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.6] Add adv7604/ad9389b drivers
Date: Mon, 23 Jul 2012 14:38:03 +0200
Message-ID: <2683187.LgYGVSMlAA@avalon>
In-Reply-To: <201207231436.35962.hverkuil@xs4all.nl>
References: <201207231336.15392.hverkuil@xs4all.nl> <2229729.zs2QQjUUOH@avalon> <201207231436.35962.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 23 July 2012 14:36:35 Hans Verkuil wrote:
> On Mon July 23 2012 14:25:38 Laurent Pinchart wrote:
> > On Monday 23 July 2012 13:36:15 Hans Verkuil wrote:
> > > Hi all!
> > > 
> > > There haven't been any comments since either RFCv1 or RFCv2.
> > > 
> > > (http://www.spinics.net/lists/linux-media/msg48529.html and
> > > http://www.spinics.net/lists/linux-media/msg50413.html)
> > > 
> > > So I'm making this pull request now.
> > > 
> > > The only changes since RFCv2 are some documentation fixes:
> > > 
> > > - Add a note that the SUBDEV_G/S_EDID ioctls are experimental
> > > - Add the proper revision/experimental references.
> > > - Update the spec version to 3.6.
> > 
> > Jumping a bit late on this. Wouldn't it be good to submit the RFCs to the
> > dri- devel mailing list before pushing them upstream ? They have been
> > dealing with EDID for ages and might offer good advices.
> 
> I've looked at DRM as well, but there is really nothing to share. This API
> is for embedded systems: it does *not* parse the EDID, it just transports
> it from kernel to userspace and vice versa.
> 
> The main difference is that DRM attempts to load all blocks from the EDID,
> whereas this API allows you to load blocks on demand (actually, drivers can
> still decide to load all blocks initially, but that's an implementation
> detail). This is more efficient given the slow i2c bus.

I'm not saying we should share or mimic the DRM EDID API, just that, given 
their experience with EDID, they might have useful feedback on our API.

-- 
Regards,

Laurent Pinchart

