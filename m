Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50268 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752320AbZCRJMc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2009 05:12:32 -0400
Date: Wed, 18 Mar 2009 10:12:34 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: soc-camera -> v4l2-device: possible API extension requirements
In-Reply-To: <52074.62.70.2.252.1237365718.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.64.0903181000200.4262@axis700.grange>
References: <52074.62.70.2.252.1237365718.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 18 Mar 2009, Hans Verkuil wrote:

> In v4l devices these i2c devices are an integral part of the v4l device.
> It is not like the sensor i2c devices that are basically independent
> devices. Also, many i2c drivers used by v4l have internal state, so
> unloading them on the fly and reloading them later will in general not
> work.
> 
> If a v4l driver loads an i2c module and it can obtain a v4l2_subdev
> pointer successfully, then it increases the module's refcount to prevent
> it from being unloaded. This is by design.
> 
> Without autoprobing I also see no point in allowing an i2c module to be
> unloaded while in use. Reloading it won't re-attach it to the adapter
> anyway.

Yes, that's what I thought was the case, and that's also something that I 
am not quite convinced yet, that it is the best design for this situation.

> > 3. Currently soc-camera works in a way, that during probing of an i2c
> > (sub)device, the Master Clock of the host camera interface is turned on,
> > after the probing it is turned off again. Then it is turned on at first
> > open() and off at last close(). This should also be possible with the
> > module autoloading in v4l2_i2c_new_subdev(), but this adds even more
> > fragileness to the system.
> >
> > I think, a simple addition to the v4l2-device API could solve this
> > problems and make the API more transparent:
> >
> > 1. "hi, I am driver X's probing routine, going to probe device Y, please,
> > turn it on" (action: master clock on)
> >
> > 2. "probing for device Y completed (un)successfully" (action: master clock
> > off, if successful - create /dev/videoY)
> >
> > 3. "driver X is being unloaded, I am releasing device Y" (action: rip
> > /dev/videoY)
> >
> > We could agree on keeping /dev/videoY even when no sensor driver is
> > present and just return -ENODEV on open(), and thus simplify the above but
> > I am not sure if this is desired.
> 
> I don't follow you. It is the adapter driver that controls which subdevs
> are loaded/probed, when they are loaded or unloaded and it can also decide
> when to start/stop the master clock. This new situation is different in
> that loading an i2c module will no longer work, the initiative has to come
> from the adapter/bridge/host/whatever driver who determines what has to be
> done based on platform board info.

Ok, but how are we going to address this your comment:

	/* Note: it is possible in the future that
	   c->driver is NULL if the driver is still being loaded.
	   We need better support from the kernel so that we
	   can easily wait for the load to finish. */
	if (client == NULL || client->driver == NULL)
		return NULL;

With just an 
msleep(OUR_HARD_CODED_TIMEOUT_WE_BELIEVE_SHOULD_BE_ENOUGH_FOR_ALL)?:-)

Also one more point, that I don't see a problem currently with, but that 
we have to keep in mind: soc-camera is aiming at supporting several 
devices on one interface. E.g., there is a design, where two cameras are 
connected to a host, that actually is only supposed to support one camera 
at a time. So, they use some extra switching logic to activate one or 
another camera. In this case the platform registers two cameras, they are 
both probed - one after another, and that's also the reason, why the 
default state "all /dev/videoN devices are closed" must be - no fixed 
connection between a subdevice and a device. We actually have already 
discussed this before, I think, just something to keep an eye on.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
