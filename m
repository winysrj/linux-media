Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:48676 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZJPJEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 05:04:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC] Video events, version 2
Date: Fri, 16 Oct 2009 11:06:15 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Zutshi Vimarsh <vimarsh.zutshi@nokia.com>,
	Ivan Ivanov <iivanov@mm-sol.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Guru Raj <gururaj.nagendra@intel.com>
References: <4AD5CBD6.4030800@maxwell.research.nokia.com> <7c87abde6f2f45f29d56c6b112de169d.squirrel@webmail.xs4all.nl> <4AD834E8.5090209@maxwell.research.nokia.com>
In-Reply-To: <4AD834E8.5090209@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <200910161106.16008.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 16 October 2009 10:55:04 Sakari Ailus wrote:
> Hans Verkuil wrote:
> [clip]
> 
> > I'm not keen on using pointers insides structures unless there is a very
> > good reason to do so. In practice it complicates the driver code
> > substantially due to all the kernel-to-userspace copies that need to be
> > done that are normally handled by video_ioctl2. In addition it requires
> > custom code in the compat-ioctl32 part as well.
> 
> VIDIOC_DQEVENT then.
> 
> [clip]
> 
> >> The size of the structure is now 96 bytes. I guess we could make that
> >> around 128 to allow a bit more space for data without really affecting
> >> performance.
> >
> > With 'big unions' I didn't mean the memory size. I think 64 bytes (16
> > longs) is a decent size. I was talking about the union definition in the
> > videodev2.h header.
> 
> That was a badly placed comment, but I meant the memory size. I have
> currently no opinion on whether to use union or not.
> 
> [clip]
> 
> >>> That said, I think the initial implementation should be that the
> >>> subscribe
> >>> ioctl gets a struct with the event type and a few reserved fields so
> >>> that
> >>> in the future we can use one of the reserved fields as a configuration
> >>> parameter. So for now we just have some default watermark that is set
> >>> by the
> >>> driver.
> >>
> >> I'd like to think a queue size defined by the driver is fine at this
> >> point. It's probably depending on the driver rather than application how
> >> long the queue should to be. At some point old events start becoming
> >> uninteresting...
> >
> > Question: will we drop old events or new events? Or make this
> > configurable? Or driver dependent?
> 
> This should the same than for video buffers. I guess it's undefined? I'd
> let the driver decide at this point.

>From the user point of view it won't make much difference. The same number of 
consecutive events will be lost. Which ones will depend on the events arrival 
time and when/how long the application fails to retrieve pending events. I 
agree to let the driver decide (or rather the v4l2 core, as the queue will be 
implemented there).

-- 
Laurent Pinchart
