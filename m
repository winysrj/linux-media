Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33939 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751138Ab2KDRaE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Nov 2012 12:30:04 -0500
Date: Sun, 4 Nov 2012 19:29:58 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 10/23] V4L: Add auto focus targets to the selections API
Message-ID: <20121104172957.GB25623@valkosipuli.retiisi.org.uk>
References: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
 <1336645858-30366-11-git-send-email-s.nawrocki@samsung.com>
 <20121029200036.GA25623@valkosipuli.retiisi.org.uk>
 <508F067B.7030301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508F067B.7030301@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks  for the update!

On Mon, Oct 29, 2012 at 11:43:07PM +0100, Sylwester Nawrocki wrote:
> Hi Sakari,
> 
> On 10/29/2012 09:00 PM, Sakari Ailus wrote:
> > On Thu, May 10, 2012 at 12:30:45PM +0200, Sylwester Nawrocki wrote:
> >> The camera automatic focus algorithms may require setting up
> >> a spot or rectangle coordinates or multiple such parameters.
> >>
> >> The automatic focus selection targets are introduced in order
> >> to allow applications to query and set such coordinates. Those
> >> selections are intended to be used together with the automatic
> >> focus controls available in the camera control class.
> >>
> >> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> >> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> >> ---
> >>   Documentation/DocBook/media/v4l/selection-api.xml  |   33 +++++++++++++++++++-
> >>   .../DocBook/media/v4l/vidioc-g-selection.xml       |   11 +++++++
> >>   include/linux/videodev2.h                          |    5 +++
> >>   3 files changed, 48 insertions(+), 1 deletion(-)
> > 
> > What's the status of this patch? May I ask if you have plans to continue
> > with it?
> 
> Thanks for reminding about it. I'd like to make this ready for v3.8, if 
> possible. I've done some minor improvements of the related 
> V4L2_CID_AUTO_FOCUS_AREA control and we use this patch internally. We would 
> like to see how all this can be used for auto focus feature of the s5c73m3 
> camera. I hope to have these patches posted next week.

I'm looking forward to that!

> > Speaking of multiple AF windows --- I originally thought we could just have
> > multiple selection targets for them. I'm not sure which one would be better;
> > multiple selection targets or another field telling the window ID. In case
> > of the former we'd leave a largish gap for additional window IDs.
> > 
> > I think I'm leaning towards using one reserved field for the purpose.
> 
> That also as my preference. I imagine the ID field could be reused for
> other future or existing selection targets anyway. I recall someone already
> asked about multiple ROI support for image cropping [1], perhaps the ID 
> field could be used also for that.

I wonder how that would make sense with a single stream.

Selections could also be used on the event interface: they fit exactly to
the union there. One of the applications is passing face tracking
information to the user space.

> > Another question I had was that which of the selection rectangles would the
> > AF rectangle be related to? Is it the compose bounds rectangle, or the crop
> > bounds rectangle, for example? I thought it might make sense to use another
> > field to tell that, since I think which one this really is related to is
> > purely hardware specific.
> 
> It's indeed very hardware specific. I've seen sensors that allow to define
> bounds for the auto focus rectangle entirely independent from the output 
> format, crop or compose rectangle. It may look strange, but some sensor 
> firmwares just accept rectangle/point coordinates with bounds rectangle 
> corresponding to video display area (so it is easy, e.g. to use coordinates 
> coming directly from a touchscreen) and then perform required calculations 
> to map/scale it onto e.g. sensor crop or output rectangle.
> 
> I guess your question is related to how to determine in what stage of 
> video pipeline the AF selections would be and what the configuration 
> order should be from the user space side ?

How to determine what the coordinates are related to. Only that, and inside
a single subdev, actually. The rest is already well visible to the user.

The targets defined up to now are well defined in relation to the other
targets in the documentation. About the configuration order --- the AF
window target could likely be configured after the related target has been
configured.

Perhaps this information should actually come from
VIDIOC_(SUBDEV_,)QUERY_SELECTION. :-) I think this can well be done later
on.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
