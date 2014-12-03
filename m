Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37508 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751086AbaLCLTi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Dec 2014 06:19:38 -0500
Date: Wed, 3 Dec 2014 13:19:04 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 1/2] v4l2 subdevs: replace get/set_crop by
 get/set_selection
Message-ID: <20141203111904.GF14746@valkosipuli.retiisi.org.uk>
References: <1417522901-43604-1-git-send-email-hverkuil@xs4all.nl>
 <547EF0A9.2070004@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547EF0A9.2070004@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 03, 2014 at 12:14:49PM +0100, Sylwester Nawrocki wrote:
> Hi Hans,
> 
> On 02/12/14 13:21, Hans Verkuil wrote:
> > -static int s5k6aa_set_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
> > -			   struct v4l2_subdev_crop *crop)
> > +static int s5k6aa_set_selection(struct v4l2_subdev *sd,
> > +				struct v4l2_subdev_fh *fh,
> > +				struct v4l2_subdev_selection *sel)
> >  {
> >  	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
> >  	struct v4l2_mbus_framefmt *mf;
> >  	unsigned int max_x, max_y;
> >  	struct v4l2_rect *crop_r;
> >  
> > +	if (sel->pad || sel->target != V4L2_SEL_TGT_CROP)
> > +		return -EINVAL;
> > +
> 
> Isn't checking sel->pad redundant here ? There is already the pad index
> validation in check_selection() in v4l2-subdev.c and this driver has only
> one pad.

Good point. check_crop() does that for the [sg]_crop as well.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
