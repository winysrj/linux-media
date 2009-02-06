Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:1758 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbZBFPQu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Feb 2009 10:16:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [REVIEW PATCH 00/14] OMAP3 camera + ISP + MT9P012 sensor driver v2
Date: Fri, 6 Feb 2009 16:16:48 +0100
Cc: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Ailus Sakari (Nokia-D/Helsinki)" <Sakari.Ailus@nokia.com>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <19F8576C6E063C45BE387C64729E739403FA81B0D0@dbde02.ent.ti.com> <498C513E.6080501@maxwell.research.nokia.com>
In-Reply-To: <498C513E.6080501@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902061616.48299.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 06 February 2009 16:03:26 Sakari Ailus wrote:
> Hiremath, Vaibhav wrote:
> > [Hiremath, Vaibhav] Sakari, Can you share your version of code
> > (either in form of patches or source) here onto the mailing list, so
> > that everybody those who are interested will be aware of changes?
>
> I will synchronise soon with Sergio (as he noted). After that we'll send
> a new patchset. I was thinking of separating the ISP and camera driver
> patches from other hardware dependent patches. The resulting patchset
> wouldn't be that huge anymore but on the other hand it wouldn't be very
> usable as such.
>
> > Atleast for me I would get prior view of changes which might affect
> > BT656 support (posted on top of Sergio's patch).
> >
> > Again one more thing I would like to bring to your notice is about
> > sub-device framework. Also we need to plan for the migration from
> > V4L2-int to sub-device framework, which is of equal important. I feel
> > the more time we spend in merging and aligning offline, more we are
> > carrying risk.
>
> I agree that we should be moving to v4l2 sub-device at some point,
> preferrably sooner than later, but I think the ISP driver should get a
> much much better interface than it currently has. So that should be part
> of the task.
>
> > According to me as I mentioned before, the plan should be to push
> > ISP-Camera with V4L2-int interface as early as possible with whatever
> > minimal sensor/decoder support we have today, which will make sure
> > that our underneath ISP-library is in place. Once that is placed in,
> > we can have additional patches on top of it to add more features.
>
> I agree. But I'd say that fixing the bugs and cleaning up the code is as
> least as important than adding new features.
>
> > In this way, we can plan for migration to sub-device framework and
> > also be easier and simpler. Even if any customers are interested,
> > they can pick it up the ISP library and start development on top of
> > it.
>
> There's still a long way to get there --- the ISP driver's current
> interface and internals don't mix well with either v4l2 sub-device or
> v4l2-int-if. For example, there's no ISP object, just function calls and
> then output frame size / frame interval enumeration doesn't work
> properly for YUV (maybe not even for RAW10). Enumerating frame size has
> side effects. The ISP driver doesn't have a standard interface, it's now
> specific to OMAP 3. And this is just an example...

Please note that it is easy to add a subdevice-specific set of ops if 
needed. It is not implemented at the moment, but if you need it please ask 
and I can show you how to do it.

In general, if you think something is missing in v4l2_subdev or if something 
is awkward to use, please ask me! I'd be happy to help you with that. It's 
an internal API, so changes are possible and almost certainly necessary for 
omap anyway.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
