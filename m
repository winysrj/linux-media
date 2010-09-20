Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60214 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004Ab0ITRIv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Sep 2010 13:08:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Control framework bug
Date: Mon, 20 Sep 2010 19:08:44 +0200
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009201908.45274.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

A code excerpt is better than a long story, so here it is (from 
drivers/media/video/v4l2-device.c).

> int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
>                                                 struct v4l2_subdev *sd)
> {
>         int err;
> 
>         /* Check for valid input */
>         if (v4l2_dev == NULL || sd == NULL || !sd->name[0])
>                 return -EINVAL;
>         /* Warn if we apparently re-register a subdev */
>         WARN_ON(sd->v4l2_dev != NULL);
>         if (!try_module_get(sd->owner))
>                 return -ENODEV;
>         /* This just returns 0 if either of the two args is NULL */
>         err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd-
>ctrl_handler);
>         if (err)

A call to module_put() is needed here. That one is easy to fix.

>                 return err;
>         sd->v4l2_dev = v4l2_dev;
>         spin_lock(&v4l2_dev->lock);
>         list_add_tail(&sd->list, &v4l2_dev->subdevs);
>         spin_unlock(&v4l2_dev->lock);

The subdev device node patches add a device node registration call here, and 
the call might fail. How do I cleanup the v4l2_ctrl_add_handler() call ? There 
doesn't seem to be any v4l2_ctrl_remove_handler() function. The same problem 
exists in v4l2_device_unregister_subdev(), you're not cleaning up the control 
framework there.

>         return 0;
> }
> EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);

-- 
Regards,

Laurent Pinchart
