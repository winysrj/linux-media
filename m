Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:48153 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989AbbCPOFS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 10:05:18 -0400
Message-ID: <5506E316.9070208@xs4all.nl>
Date: Mon, 16 Mar 2015 15:05:10 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: [RFC] devm_kzalloc, embedding video_device and unbind
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Many v4l drivers now embed the video_device struct in their state structure
rather than calling video_device_alloc() to kzalloc that struct.

Lars commented on that: calling unbind on the V4L2 driver could cause
a crash because the state structure could be freed before the video device
was freed, either because someone still had a file handle open, or because of
the DEBUG_KOBJECT_RELEASE config option which delays calling the struct
device release() callback.

Based on his comments I decided to dig a bit deeper.

Calling unbind is effectively the equivalent of a USB disconnect, and other
than USB devices nobody ever tests a disconnect.

There are number of issues here: first of all any struct video_device has
pointers to the v4l2_device struct and to the vb2_queue struct, both of
which are always part of the state struct. If vb2_fop_release is used as
the release() fop callback, then that will refer to that vb2_queue in the
state struct. Ditto the v4l2_device_release() function in v4l2-dev.c uses
the v4l2_device struct.

So whether the video_device struct is allocated or embedded, in both cases
access to the state structure is required.

To do this right you need to have a release callback that is only called
when all device nodes have been released. This is the release() callback
in struct v4l2_device. Drivers that use this (mostly USB drivers) can do
the final kfree(state) in there, knowing that nobody is using it anymore
and that it can finally be freed safely.

This callback was added specifically to handle USB disconnects gracefully.

However, there is one fly in the ointment: increasingly drivers are using
devm_kzalloc to allocate the state structure. Calling unbind means that
that struct is immediately freed since it is associated with the driver
device struct.

This is incompatible with waiting until the v4l2_device release() callback.

With respect to sub-device drivers: calling unbind for them while the
main driver is still running will simply pull the rug from under that
driver and a crash is guaranteed. The only way this can be prevented
is to suppress the presence of the bind/unbind attributes for sub-device
drivers. E.g.:

static struct i2c_driver au8522_driver = {
        .driver = {
                .owner  = THIS_MODULE,
                .name   = "au8522",
                .suppress_bind_attrs = true,
        },
        .probe          = au8522_probe,
        .remove         = au8522_remove,
        .id_table       = au8522_id,
};

It's similar to the situation when you load the driver: all components
needed for the operation of the device have to be there before you can
configure everything (hence the reason for v4l2-async).

Unloaded has the same requirements: you can't release resources until
all components that are needed for operating the hardware are no longer
in use.

My conclusion is that:

1) As long as you do not call unbind directly or set DEBUG_KOBJECT_RELEASE
   all is well with the world (except for buggy USB drivers of which there
   still are a few).

2) The unbind/bind attributes should be suppressed for all subdevices. It's
   incompatible with the way these complex video drivers are organized. Only
   the bridge driver has the knowledge how to free resources and subdevs.

3) Use the v4l2_device's release() callback as the only safe place to release
   resources.

4) Don't use devm_kzalloc to allocate the state structure since that will be
   freed before the v4l2_device's release() callback is called.

5) Whether you allocate or embed the video_device structure really doesn't
   matter. In both cases you have the problem that the state structure is
   expected to be present when the video_device is released. In my opinion
   embedded video_device is still a good idea since there is no need to
   check for memory errors etc.

I've done some tests with vivid and by following these guidelines it handles
bind/unbind gracefully.

See:

http://www.spinics.net/lists/linux-media/msg87629.html
http://www.spinics.net/lists/linux-media/msg87630.html

For the time being I'll put patches that switch to devm_kzalloc and embed
video_device on hold until I have agreement on this.

Regards,

	Hans
