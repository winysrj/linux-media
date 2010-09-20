Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:4445 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab0ITR4t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Sep 2010 13:56:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Control framework bug
Date: Mon, 20 Sep 2010 19:56:43 +0200
Cc: linux-media@vger.kernel.org
References: <201009201908.45274.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201009201908.45274.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009201956.44002.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, September 20, 2010 19:08:44 Laurent Pinchart wrote:
> Hi Hans,
> 
> A code excerpt is better than a long story, so here it is (from 
> drivers/media/video/v4l2-device.c).
> 
> > int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
> >                                                 struct v4l2_subdev *sd)
> > {
> >         int err;
> > 
> >         /* Check for valid input */
> >         if (v4l2_dev == NULL || sd == NULL || !sd->name[0])
> >                 return -EINVAL;
> >         /* Warn if we apparently re-register a subdev */
> >         WARN_ON(sd->v4l2_dev != NULL);
> >         if (!try_module_get(sd->owner))
> >                 return -ENODEV;
> >         /* This just returns 0 if either of the two args is NULL */
> >         err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd-
> >ctrl_handler);
> >         if (err)
> 
> A call to module_put() is needed here. That one is easy to fix.

Oops. Good catch.

> 
> >                 return err;
> >         sd->v4l2_dev = v4l2_dev;
> >         spin_lock(&v4l2_dev->lock);
> >         list_add_tail(&sd->list, &v4l2_dev->subdevs);
> >         spin_unlock(&v4l2_dev->lock);
> 
> The subdev device node patches add a device node registration call here, and 
> the call might fail. How do I cleanup the v4l2_ctrl_add_handler() call ? There 
> doesn't seem to be any v4l2_ctrl_remove_handler() function. The same problem 
> exists in v4l2_device_unregister_subdev(), you're not cleaning up the control 
> framework there.

That's not a bug, there really isn't a counterpart to v4l2_ctrl_add_handler.
In case of an error during subdev registration the driver should just call
v4l2_ctrl_handler_free() which will free everything.

I do agree though that it is probably cleaner if I do add a remove_handler
type function.

Regards,

	Hans

> 
> >         return 0;
> > }
> > EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
