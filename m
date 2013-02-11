Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:64576 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757Ab3BKWck (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Feb 2013 17:32:40 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so3359443eei.7
        for <linux-media@vger.kernel.org>; Mon, 11 Feb 2013 14:32:37 -0800 (PST)
Message-ID: <51197181.6020000@gmail.com>
Date: Mon, 11 Feb 2013 23:32:33 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>, ming.lei@canonical.com,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	=?ISO-8859-1?Q?R=E9mi_Denis-Courmont?= <remi@remlab.net>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [RFC] V4L2 events with extensible payload
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi All,

I have run recently into a situation where it would be useful to have
a data structure within the struct v4l2_event::u union of size greater
than 64 bytes, which is the current size of the union.

Currently struct v4l2_event looks like this [1], and I have been thinking
about extending it with a 'size' member that would be telling the actual
size of the payload data structure and a pointer to a specific event data
structure would be added to the union u.

[1] http://lxr.linux.no/#linux+v3.7.4/include/uapi/linux/videodev2.h#L1798

struct v4l2_event_ext1 {
     __u8    data[96];
};

struct v4l2_event {
     __u32                             type;
     union {
         struct v4l2_event_vsync       vsync;
         struct v4l2_event_ctrl        ctrl;
         struct v4l2_event_frame_sync  frame_sync;
         struct v4l2_event_ext1        *ext1;
         __u8                          data[64];
     } u;
     __u32                pending;
     __u32                sequence;
     struct timespec      timestamp;
     __u32                id;
     __u32                size;
     __u32                reserved[7];
};

Then before VIDIOC_DQBUF ioctl an application would have allocated a
buffer for the event and would set 'size' to the size of this buffer.
If the size would have been to small for a next event to be dequeued
from the kernel an ioctl would return -ENOSPC errno.

Everything seemed nice and straightforward until I have discovered that
VIDIOC_DQEVENT ioctl doesn't allow to pass anything from user space to
the kernel, because it is defined with _IOR().

And here come my questions:

1. Is the event payload supposed to be relatively small and the interface
is deliberately defined to disallow passing anything with the payload
greater than 64 B ? In order to keep it a rather lightweight interface
and anything that needs more data should use other/new ioctls ?

2. If answer to 1. is 'no', then what would be a best way to proceed to
make the event's payload more flexible ? Would creating a new ioctl to
dequeue events be way to go ?

I am asking mostly in context of the face detection feature in the
Exynos4x12 SoC camera ISP. Similarly, the v4l2 event payload size was a
limitation during development of a driver for the face detection IP block
available in OMAP4 SoCs by Ming Lei [2]:

"From the start, I hope that the event interface can be used to retrieve
  object detection result.

When I found it is difficult to fit 'struct v4l2_od_object' into 64 bytes,
I decide to introduce two IOCTLs for the purpose."

I thought it would have been better to make the event interface more
flexible and reuse the existing infrastructure, rather than inventing new
ioctls for the purpose and reimplementing similar set of features.


Any suggestions, thoughts are warm welcome.


[2] http://patchwork.linuxtv.org/patch/8814

--

Regards,
Sylwester
