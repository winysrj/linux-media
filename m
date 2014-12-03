Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33778 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaLCNGY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Dec 2014 08:06:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 1/2] v4l2 subdevs: replace get/set_crop by get/set_selection
Date: Wed, 03 Dec 2014 15:07 +0200
Message-ID: <4935990.RSvd8chebE@avalon>
In-Reply-To: <547EF165.9030409@cisco.com>
References: <1417522901-43604-1-git-send-email-hverkuil@xs4all.nl> <547EF0A9.2070004@samsung.com> <547EF165.9030409@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday 03 December 2014 12:17:57 Hans Verkuil wrote:
> On 12/03/14 12:14, Sylwester Nawrocki wrote:
> > On 02/12/14 13:21, Hans Verkuil wrote:
> >> -static int s5k6aa_set_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh
> >> *fh,
> >> -			   struct v4l2_subdev_crop *crop)
> >> +static int s5k6aa_set_selection(struct v4l2_subdev *sd,
> >> +				struct v4l2_subdev_fh *fh,
> >> +				struct v4l2_subdev_selection *sel)
> >>  {
> >>  	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
> >>  	struct v4l2_mbus_framefmt *mf;
> >>  	unsigned int max_x, max_y;
> >>  	struct v4l2_rect *crop_r;
> >> 
> >> +	if (sel->pad || sel->target != V4L2_SEL_TGT_CROP)
> >> +		return -EINVAL;
> >> +
> > 
> > Isn't checking sel->pad redundant here ? There is already the pad index
> > validation in check_selection() in v4l2-subdev.c and this driver has only
> > one pad.
> 
> If it is called from a bridge driver, then it hasn't gone through
> check_selection().
> 
> That said, if it is called from a bridge driver, then one might expect
> correct usage of pad.
> 
> Laurent, do you have an opinion on this?

I would expect the pad to be valid when called from a bridge driver. We could 
double-check that in subdev drivers as a debugging help, but I'm not sure if 
it's worth it.

-- 
Regards,

Laurent Pinchart

