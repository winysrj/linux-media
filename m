Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4560 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758334Ab2EARs6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 13:48:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: [PATCH/RFC v3 14/14] vivi: Add controls
Date: Tue, 1 May 2012 19:48:53 +0200
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, g.liakhovetski@gmx.de, hdegoede@redhat.com,
	moinejf@free.fr, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com> <201204301809.04891.hverkuil@xs4all.nl> <4FA02027.30909@gmail.com>
In-Reply-To: <4FA02027.30909@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205011948.53191.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue May 1 2012 19:40:55 Sylwester Nawrocki wrote:
> On 04/30/2012 06:09 PM, Hans Verkuil wrote:
> > On Friday 27 April 2012 16:23:31 Sylwester Nawrocki wrote:
> >> This patch is just for testing the new controls, it is NOT
> >> intended for merging upstream.
> >>
> >> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> >> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> >> ---
> >>   drivers/media/video/vivi.c |  111 +++++++++++++++++++++++++++++++++++++++++++-
> >>   1 file changed, 110 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
> >> index d64d482..cbe103e 100644
> >> --- a/drivers/media/video/vivi.c
> >> +++ b/drivers/media/video/vivi.c
> >> @@ -179,6 +179,29 @@ struct vivi_dev {
> >>   	struct v4l2_ctrl	   *bitmask;
> >>   	struct v4l2_ctrl	   *int_menu;
> >>
> >> +	struct v4l2_ctrl	   *exposure_bias;
> >> +	struct v4l2_ctrl	   *metering;
> >> +	struct v4l2_ctrl	   *wb_preset;
> >> +	struct {
> >> +		/* iso/auto iso cluster */
> >> +		struct v4l2_ctrl  *auto_iso;
> >> +		struct v4l2_ctrl  *iso;
> >> +	};
> >> +	struct {
> >> +		/* continuous auto focus/auto focus cluster */
> >> +		struct v4l2_ctrl  *focus_auto;
> >> +		struct v4l2_ctrl  *af_start;
> >> +		struct v4l2_ctrl  *af_stop;
> >> +		struct v4l2_ctrl  *af_status;
> >> +		struct v4l2_ctrl  *af_distance;
> >> +		struct v4l2_ctrl  *af_area;
> >> +	};
> >> +	struct v4l2_ctrl	  *scene_mode;
> >> +	struct v4l2_ctrl	  *lock_3a;
> >> +	struct v4l2_ctrl	  *colorfx;
> >> +	struct v4l2_ctrl	  *wdr;
> >> +	struct v4l2_ctrl	  *stabilization;
> >> +
> > 
> > Why add these controls to vivi? It doesn't belong here.
> 
> Yeah, my intention was to provide some basic means for validating the
> new controls, especially integer menu ones. I really don't use vivi 
> for testing, but I think not many people have currently access to the
> hardware I work with. So this is just in case Mauro wants to do tests
> of the core control framework changes. I agree this patch doesn't 
> make sense for anything other than that.
> 
> I have also a small patch for v4l2-ctl to support integer menu 
> control enumeration. However I run into some weird problems when
> I cross compiled it for ARM (individual menu names are not listed)
> and didn't get around to fix that yet. So I didn't yet send that 
> v4l2-ctl patch out.

There is already an int-menu control in vivi, and v4l2-ctl already
support integer menus as well (as does qv4l2 and v4l2-compliance).

So this should be all ready for you.

BTW, it would be nice to get g/s_selection support in v4l2-ctl, that is
still missing. And a good test in v4l2-compliance would be great as well.

Have you run v4l2-compliance lately? It's getting pretty good at catching
all sorts of inconsistencies.

Regards,

	Hans
