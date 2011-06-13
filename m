Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43172 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab1FMJlg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2011 05:41:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Crash on unplug with the uvc driver in linuxtv/staging/for_v3.1
Date: Mon, 13 Jun 2011 11:41:42 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <4DF0ACDB.9000800@redhat.com> <201106111116.10615.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201106111116.10615.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201106131141.43153.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans (and Hans),

On Saturday 11 June 2011 11:16:10 Laurent Pinchart wrote:
> On Thursday 09 June 2011 13:22:03 Hans de Goede wrote:
> > Hi,
> > 
> > When I unplug a uvc camera *while streaming* I get:
> > 
> > [15824.809741] BUG: unable to handle kernel NULL pointer dereference at
> > (null)
> 
> [snip]
> 
> > I've not tested if this also impacts 3.0!!
> 
> It probably does. Thanks for the report. I'll fix it.

It does. Fixing the problem turns to be more complex than expected.

The crash is caused by media entities life time management issues.

Entities associated with video device nodes are unregistered in 
video_unregister_device(). This removes the entity from its parent's entities 
list, and sets the entity's parent to NULL.

Entities also get/put references to their parent's module through 
media_entity_get() and media_entity_put(). Those functions are called in the 
open and release handlers of video device nodes and subdev device nodes. The 
reason behind this is to avoid a parent module from being removed while a 
subdev is opened, as closing a subdev can call to the parent's module through 
board code.

When a UVC device is unplugged while streaming, the uvcvideo driver will call 
video_unregister_device() in the disconnect handler. This will in turn call 
media_device_unregister_entity() which sets the entity's parent to NULL. When 
the user then closes open video device nodes, v4l2_release() calls 
media_entity_put() which tries to dereference entity->parent, and oopses.

I've tried to move the media_device_unregister_entity() call from 
video_unregister_device() to v4l2_device_release() (called when the last 
reference to the video device is released). media_entity_put() is then called 
before the entity is unregistered, but that results in a different oops: as 
this happens after the USB disconnect callback is called, entity->parent->dev-
>driver is now NULL, and trying to access entity->parent->dev->driver->owner 
to decrement the module use count oopses.

One possible workaround is to remove media_entity_get()/media_entity_put() 
calls from v4l2-dev.c. As the original purpose of those functions was to avoid 
a parent module from being removed while still accessible through board code, 
and all existing MC-enabled drivers register video device nodes with the owner 
equal to the entity's parent's module, we can safely do it.

I'd rather implement a proper solution though, but that's not straightforward. 
We short-circuit the kernel reference management by going through board code. 
There's something fundamentally wrong in the way we manage subdevs and 
device/module reference counts. I'm not sure where the proper fix should go to 
though.

-- 
Regards,

Laurent Pinchart
