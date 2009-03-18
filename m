Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3653 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbZCRJ1V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2009 05:27:21 -0400
Message-ID: <37365.62.70.2.252.1237368437.squirrel@webmail.xs4all.nl>
Date: Wed, 18 Mar 2009 10:27:17 +0100 (CET)
Subject: Re: soc-camera -> v4l2-device: possible API extension requirements
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Wed, 18 Mar 2009, Hans Verkuil wrote:
>
>> In v4l devices these i2c devices are an integral part of the v4l device.
>> It is not like the sensor i2c devices that are basically independent
>> devices. Also, many i2c drivers used by v4l have internal state, so
>> unloading them on the fly and reloading them later will in general not
>> work.
>>
>> If a v4l driver loads an i2c module and it can obtain a v4l2_subdev
>> pointer successfully, then it increases the module's refcount to prevent
>> it from being unloaded. This is by design.
>>
>> Without autoprobing I also see no point in allowing an i2c module to be
>> unloaded while in use. Reloading it won't re-attach it to the adapter
>> anyway.
>
> Yes, that's what I thought was the case, and that's also something that I
> am not quite convinced yet, that it is the best design for this situation.

It really, really is :-)

This is actually not something v4l-related. It's a consequence of the new
i2c API.

>> > 3. Currently soc-camera works in a way, that during probing of an i2c
>> > (sub)device, the Master Clock of the host camera interface is turned
>> on,
>> > after the probing it is turned off again. Then it is turned on at
>> first
>> > open() and off at last close(). This should also be possible with the
>> > module autoloading in v4l2_i2c_new_subdev(), but this adds even more
>> > fragileness to the system.
>> >
>> > I think, a simple addition to the v4l2-device API could solve this
>> > problems and make the API more transparent:
>> >
>> > 1. "hi, I am driver X's probing routine, going to probe device Y,
>> please,
>> > turn it on" (action: master clock on)
>> >
>> > 2. "probing for device Y completed (un)successfully" (action: master
>> clock
>> > off, if successful - create /dev/videoY)
>> >
>> > 3. "driver X is being unloaded, I am releasing device Y" (action: rip
>> > /dev/videoY)
>> >
>> > We could agree on keeping /dev/videoY even when no sensor driver is
>> > present and just return -ENODEV on open(), and thus simplify the above
>> but
>> > I am not sure if this is desired.
>>
>> I don't follow you. It is the adapter driver that controls which subdevs
>> are loaded/probed, when they are loaded or unloaded and it can also
>> decide
>> when to start/stop the master clock. This new situation is different in
>> that loading an i2c module will no longer work, the initiative has to
>> come
>> from the adapter/bridge/host/whatever driver who determines what has to
>> be
>> done based on platform board info.
>
> Ok, but how are we going to address this your comment:
>
> 	/* Note: it is possible in the future that
> 	   c->driver is NULL if the driver is still being loaded.
> 	   We need better support from the kernel so that we
> 	   can easily wait for the load to finish. */
> 	if (client == NULL || client->driver == NULL)
> 		return NULL;
>
> With just an
> msleep(OUR_HARD_CODED_TIMEOUT_WE_BELIEVE_SHOULD_BE_ENOUGH_FOR_ALL)?:-)

As long as we load the modules first (and that's what this function does)
this isn't an issue. But in the future we (that is, Jean Delvare and
myself) want to allow udev to load the module for you. To properly
implement this we need to listen to some notification from the kernel.

It will be complicated and in the few cases where this is supported (not
in v4l AFAIK) there is indeed an msleep() like that :-)

This part is work-in-progress, so it can safely be ignored.

> Also one more point, that I don't see a problem currently with, but that
> we have to keep in mind: soc-camera is aiming at supporting several
> devices on one interface. E.g., there is a design, where two cameras are
> connected to a host, that actually is only supposed to support one camera
> at a time. So, they use some extra switching logic to activate one or
> another camera. In this case the platform registers two cameras, they are
> both probed - one after another, and that's also the reason, why the
> default state "all /dev/videoN devices are closed" must be - no fixed
> connection between a subdevice and a device. We actually have already
> discussed this before, I think, just something to keep an eye on.

This shouldn't be a problem at all. The v4l2_subdev pointer is just that:
a pointer to a struct created by the (in this case) i2c client instance.
As long as you don't call that module it's not doing anything (assuming it
didn't spawn some background task, of course). Just you just don't call
the inactive subdev until you need it.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

