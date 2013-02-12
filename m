Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2049 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab3BLH7u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Feb 2013 02:59:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [RFC] V4L2 events with extensible payload
Date: Tue, 12 Feb 2013 08:59:34 +0100
Cc: LMML <linux-media@vger.kernel.org>, ming.lei@canonical.com,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	" =?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>,
	Hans de Goede <hdegoede@redhat.com>
References: <51197181.6020000@gmail.com>
In-Reply-To: <51197181.6020000@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302120859.34174.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon February 11 2013 23:32:33 Sylwester Nawrocki wrote:
> 
> Hi All,
> 
> I have run recently into a situation where it would be useful to have
> a data structure within the struct v4l2_event::u union of size greater
> than 64 bytes, which is the current size of the union.
> 
> Currently struct v4l2_event looks like this [1], and I have been thinking
> about extending it with a 'size' member that would be telling the actual
> size of the payload data structure and a pointer to a specific event data
> structure would be added to the union u.
> 
> [1] http://lxr.linux.no/#linux+v3.7.4/include/uapi/linux/videodev2.h#L1798
> 
> struct v4l2_event_ext1 {
>      __u8    data[96];
> };
> 
> struct v4l2_event {
>      __u32                             type;
>      union {
>          struct v4l2_event_vsync       vsync;
>          struct v4l2_event_ctrl        ctrl;
>          struct v4l2_event_frame_sync  frame_sync;
>          struct v4l2_event_ext1        *ext1;
>          __u8                          data[64];
>      } u;
>      __u32                pending;
>      __u32                sequence;
>      struct timespec      timestamp;
>      __u32                id;
>      __u32                size;
>      __u32                reserved[7];
> };
> 
> Then before VIDIOC_DQBUF ioctl an application would have allocated a
> buffer for the event and would set 'size' to the size of this buffer.
> If the size would have been to small for a next event to be dequeued
> from the kernel an ioctl would return -ENOSPC errno.
> 
> Everything seemed nice and straightforward until I have discovered that
> VIDIOC_DQEVENT ioctl doesn't allow to pass anything from user space to
> the kernel, because it is defined with _IOR().
> 
> And here come my questions:
> 
> 1. Is the event payload supposed to be relatively small and the interface
> is deliberately defined to disallow passing anything with the payload
> greater than 64 B ? In order to keep it a rather lightweight interface
> and anything that needs more data should use other/new ioctls ?

Yes, that was the original design philisophy. In particular because events
can be generated from interrupt context and you cannot allocate memory in
interrupt context. Note that the original design had one event queue for
each filehandle containing all types of events. That made it basically
impossible to have variable sized payloads without having to allocate
memory for each payload.

The idea that I had in mind was that if you need larger payloads then
the event should provide a cookie of some sort that you can use with another
ioctl to get hold of the full payload.

The later redesign (one queue per filehandle per event type) would have
made that much easier since you could allocate the needed payload data
when the event is subscribed, but by then the ioctl was already defined as
IOR.

> 2. If answer to 1. is 'no', then what would be a best way to proceed to
> make the event's payload more flexible ? Would creating a new ioctl to
> dequeue events be way to go ?
> 
> I am asking mostly in context of the face detection feature in the
> Exynos4x12 SoC camera ISP. Similarly, the v4l2 event payload size was a
> limitation during development of a driver for the face detection IP block
> available in OMAP4 SoCs by Ming Lei [2]:
> 
> "From the start, I hope that the event interface can be used to retrieve
>   object detection result.
> 
> When I found it is difficult to fit 'struct v4l2_od_object' into 64 bytes,
> I decide to introduce two IOCTLs for the purpose."
> 
> I thought it would have been better to make the event interface more
> flexible and reuse the existing infrastructure, rather than inventing new
> ioctls for the purpose and reimplementing similar set of features.
> 
> 
> Any suggestions, thoughts are warm welcome.

I don't think changing DQEVENT is the right approach. While possible, it
would create more confusion than it solves IMHO. What might be better (just
brainstorming here) is to add a DQEVENT_PAYLOAD ioctl. The DQEVENT will give
you the required size of the payload and the sequence number can be used as
the cookie. Only the payload of the last dequeued event can be retrieved
that way, which shouldn't be an issue as far as I can tell.

Hmm, strictly speaking you do not need the sequence number if you just return
the payload of the last event, but it's probably a good sanity check.

Internally this can be implemented by allocating the payload memory when the
event is subscribed or when the event is generated. The first method is best
if events need to be generated during interrupt context, the second method
is best if the payload can be large and differs in size for each event. Of
course, in that case the event can never be generated from interrupt context.

You probably want to have the choice which method to use.

Regards,

	Hans
