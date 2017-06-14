Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:40100 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751750AbdFNPmo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 11:42:44 -0400
Subject: Re: [RFC 0/2] BCM283x Camera Receiver driver
To: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org
References: <cover.1497452006.git.dave.stevenson@raspberrypi.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <eef29bfb-3336-4f65-c188-975d3937cb67@xs4all.nl>
Date: Wed, 14 Jun 2017 17:42:39 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1497452006.git.dave.stevenson@raspberrypi.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dave,

How does this driver relate to this staging driver:

drivers/staging/vc04_services/bcm2835-camera/

It's not obvious to me.

On 06/14/2017 05:15 PM, Dave Stevenson wrote:
> Hi All.
> 
> This is adding a V4L2 subdevice driver for the CSI2/CCP2 camera
> receiver peripheral on BCM283x, as used on Raspberry Pi.
> 
> v4l2-compliance results depend on the sensor subdevice this is
> connected to. It passes the basic tests cleanly with TC358743,
> but objects with OV5647
> fail: v4l2-test-controls.cpp(574): g_ext_ctrls does not support count == 0
> Neither OV5647 nor Unicam support any controls.

Are you compiling v4l2-compliance from the v4l-utils git repo? If not,
then please do so and run again. The version packaged by distros tends
to be seriously outdated.

> 
> I must admit to not having got OV5647 to stream with the current driver
> register settings. It works with a set of register settings for VGA RAW10.
> I also have a couple of patches pending for OV5647, but would like to
> understand the issues better before sending them out.
> 
> Two queries I do have in V4L2-land:
> - When s_dv_timings or s_std is called, is the format meant to
>    be updated automatically?

Yes. Exception is if the new timings/std is exactly the same as the old
timings/std, in that case you can just return 0 and do nothing.

 > Even if we're already streaming?

That's not allowed. Return -EBUSY in that case.

>    Some existing drivers seem to, but others don't.
> - With s_fmt, is sizeimage settable by the application in the same
>    way as bytesperline?

No, the driver will fill in this field, overwriting anything the
application put there.

bytesperline IS settable, but most drivers will ignore what userspace
did and overwrite this as well.

Normally the driver knows about HW requirements and will set sizeimage
to something that will work (e.g. make sure it is a multiple of 16 lines).


 > yavta allows you to specify it on the command
>    line, whilst v4l2-ctl doesn't. Some of the other parts of the Pi
>    firmware have a requirement that the buffer is a multiple of 16 lines
>    high, which can be matched by V4L2 if we can over-allocate the
>    buffers by the app specifying sizeimage. But if I allow that,
>    then I get a v4l2-compliance failure as the size doesn't get
>    reset when switching from RGB3 to UYVY as it takes the request as
>    a request to over-allocate.
> 
> Apologies if I've messed up in sending these patches - so many ways
> to do something.

It looks fine at a glance.

I will probably review this on Friday or Monday. But I need some clarification
of the difference between this and the staging driver first.

Thanks!

	Hans
