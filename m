Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1630 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab2EATC5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 15:02:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: [PATCH/RFC v3 14/14] vivi: Add controls
Date: Tue, 1 May 2012 21:02:50 +0200
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, g.liakhovetski@gmx.de, hdegoede@redhat.com,
	moinejf@free.fr, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com> <201205011948.53191.hverkuil@xs4all.nl> <4FA02B2C.1020407@gmail.com>
In-Reply-To: <4FA02B2C.1020407@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205012102.50431.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue May 1 2012 20:27:56 Sylwester Nawrocki wrote:
> On 05/01/2012 07:48 PM, Hans Verkuil wrote:
> > On Tue May 1 2012 19:40:55 Sylwester Nawrocki wrote:
> >> On 04/30/2012 06:09 PM, Hans Verkuil wrote:
> >>> On Friday 27 April 2012 16:23:31 Sylwester Nawrocki wrote:
> ...
> >>> Why add these controls to vivi? It doesn't belong here.
> >>
> >> Yeah, my intention was to provide some basic means for validating the
> >> new controls, especially integer menu ones. I really don't use vivi
> >> for testing, but I think not many people have currently access to the
> >> hardware I work with. So this is just in case Mauro wants to do tests
> >> of the core control framework changes. I agree this patch doesn't
> >> make sense for anything other than that.
> >>
> >> I have also a small patch for v4l2-ctl to support integer menu
> >> control enumeration. However I run into some weird problems when
> >> I cross compiled it for ARM (individual menu names are not listed)
> >> and didn't get around to fix that yet. So I didn't yet send that
> >> v4l2-ctl patch out.
> > 
> > There is already an int-menu control in vivi, and v4l2-ctl already
> > support integer menus as well (as does qv4l2 and v4l2-compliance).
> > 
> > So this should be all ready for you.
> 
> Oh, it is there already! Must have been too busy to notice that :/
> 
> > BTW, it would be nice to get g/s_selection support in v4l2-ctl, that is
> > still missing. And a good test in v4l2-compliance would be great as well.
> 
> Yeah, I noticed that too recently, we use selections on video nodes 
> in some drivers and media-ctl can be only used for subdevs. I'll try
> to find some time to add selection ioctls support to v4l2-ctl first,
> perhaps this weekend.
> 
> > Have you run v4l2-compliance lately? It's getting pretty good at 
> > catching all sorts of inconsistencies.
> 
> No, I haven't used it for a while. I know from the last run I need to
> add G/S_PRIORITY support in one of the drivers. :)
> 
> I'm going to give it a try, however I'm going to need to deal with 
> more and more media controller nodes. For example the fimc-lite
> camera host driver I posted recently can be used with media controller
> API only, I set only V4L2_CAP_STREAMING at the video node, as it was 
> agreed previously. I assume some support for media controller API 
> needs to be added to v4l2-compliance as well ?

Yes, that's true.

Note that the purpose of v4l2-compliance is primarily to test the API: i.e.
are all the fields filled in correctly and consistently. It's not really meant
to test streaming (although some support for that needs to be added at some
point in time).

In practice problems with streaming are quickly discovered, it's the little
things like not filling in all the fields correctly that are much harder to
find.

Regards,

	Hans
