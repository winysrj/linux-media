Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48162 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab1BNM4L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:56:11 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [PATCH v7 3/6] v4l: subdev: Add device node support
Date: Mon, 14 Feb 2011 13:56:08 +0100
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1297686059-9622-1-git-send-email-laurent.pinchart@ideasonboard.com> <1297686059-9622-4-git-send-email-laurent.pinchart@ideasonboard.com> <83d190442695d204416e4bc6dc593711.squirrel@webmail.xs4all.nl>
In-Reply-To: <83d190442695d204416e4bc6dc593711.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102141356.09568.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Monday 14 February 2011 13:45:23 Hans Verkuil wrote:

[snip]

> > +int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
> > +{
> > +	struct video_device *vdev;
> > +	struct v4l2_subdev *sd;
> > +	int err;
> > +
> > +	/* Register a device node for every subdev marked with the
> > +	 * V4L2_SUBDEV_FL_HAS_DEVNODE flag.
> > +	 */
> > +	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
> > +		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE))
> > +			continue;
> > +
> > +		vdev = &sd->devnode;
> > +		strlcpy(vdev->name, sd->name, sizeof(vdev->name));
> > +		vdev->parent = v4l2_dev->dev;
> 
> Use this instead:
> 
> vdev->v4l2_dev = v4l2_dev;
> 
> Once all drivers use v4l2_device I intend to remove the parent field. So
> it is better to start using v4l2_dev right from the beginning.

Good point. I'll fix it.

> > +		vdev->fops = &v4l2_subdev_fops;
> > +		vdev->release = video_device_release_empty;
> > +		err = __video_register_device(vdev, VFL_TYPE_SUBDEV, -1, 1,
> > +					      sd->owner);
> > +		if (err < 0)
> > +			return err;
> > +	}
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_device_register_subdev_nodes);
> 
> Once this is modified you can add my ack for this patch series since the
> other 5 patches are fine.
> 
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Thanks.

-- 
Regards,

Laurent Pinchart
