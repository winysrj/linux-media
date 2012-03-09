Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57524 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab2CIMZy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2012 07:25:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
	Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: Re: [PATCH v3 5/5] v4l: Add driver for Micron MT9M032 camera sensor
Date: Fri, 09 Mar 2012 13:26:15 +0100
Message-ID: <2691948.ctHUsthuZj@avalon>
In-Reply-To: <20120308171745.GE1591@valkosipuli.localdomain>
References: <1331051559-13841-1-git-send-email-laurent.pinchart@ideasonboard.com> <2041187.ucBOt7zOjI@avalon> <20120308171745.GE1591@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 08 March 2012 19:17:46 Sakari Ailus wrote:
> On Wed, Mar 07, 2012 at 12:31:34PM +0100, Laurent Pinchart wrote:

[snip]

> > > > +static int mt9m032_set_frame_interval(struct v4l2_subdev *subdev,
> > > > +				      struct v4l2_subdev_frame_interval *fi)
> > > > +{
> > > > +	struct mt9m032 *sensor = to_mt9m032(subdev);
> > > > +	int ret;
> > > > +
> > > > +	if (sensor->streaming)
> > > > +		return -EBUSY;
> > > > +
> > > > +	memset(fi->reserved, 0, sizeof(fi->reserved));
> > > 
> > > I'm not quite sure these should be touched.
> > 
> > Why not ? Do you think this could cause a regression in the future when
> > the fields won't be reserved anymore ?
> 
> The user is responsible for setting those fields to zero. If we set them to
> zero for them they will start relying on that. At some point that might not
> hold true anymore.

Thinking about it some more, applications should set the reserved fields to 0, 
or first issue a get call and modify the fields it's interested in, keeping 
the reserved fields at their default value. I'll remove the memset here.

-- 
Regards,

Laurent Pinchart

