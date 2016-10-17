Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:40825 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752923AbcJQLhY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 07:37:24 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: keith@kodi.tv
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [ANN] Report of the V4L2 Request API brainstorm meeting
Message-ID: <5518f06f-046f-98e8-05f3-5e9063df15e8@xs4all.nl>
Date: Mon, 17 Oct 2016 13:37:17 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Report of the V4L2 brainstorm meeting October 10-11 2016, Berlin

Attendees:

Sakari Ailus <sakari.ailus@iki.fi>
Kieran Bingham <kieran@bingham.xyz>
Lars-Peter Clausen <lars@metafoo.de>
Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Pawel Osciak <pawel@osciak.com>
Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Maxime Ripard <maxime.ripard@free-electrons.com>
Hans Verkuil <hverkuil@xs4all.nl>

The raw etherpad notes are available here:

https://hverkuil.home.xs4all.nl/v4l2-requests-2016.html

If I misinterpreted something (perfectly possible), then please reply
with a correction!




Goal of the brainstorm meeting:

Drivers for stateless hardware codecs rely on the Request API, which
has still not been merged. As a result a bunch of drivers remain out
of tree. The purpose of the meeting is to determine what the factors
are that prevent the Request API from being merged and how that can be
resolved.

Note: ChromeOS uses an older version of the Request API patch series.
At that time it was called 'Configuration Store API', but other than
the different name it is pretty much the same API.


1. Request API background

The request API is a way of associating configuration data with buffers.

The original version associated controls with buffers:

https://lwn.net/Articles/641204/

This functionality is required to support stateless HW codecs where the
controls are used to pass the state (as maintained by userspace) to the
hardware together with the buffer that has to be en/decoded.

Android's cameraHAL v3 needs similar functionality, but there you also
want to associate formats, selection rectangles and topology changes to
the request.

A version of the Request API doing that is here:

https://lwn.net/Articles/688585/

However, that work doesn't contain the code to associate controls with
buffers.

So we have two versions: one suitable for codecs, one more geared towards
cameraHAL v3. But we need both.

1.1 Request IDs

The original patch series use integer IDs to identify requests. Pawel suggested
that we use file descriptors instead (similar to dmabuf) to keep track of
ownership and better permission handling. This was agreed to since this avoids
the risk of having request objects being hijacked by other applications.

1.2 Allocation of the request FD

Example with a device that has one media node and two video nodes where the sensor
sends video to one video node and e.g. statistics to another video node:

	open("media0") -> fd10
	open("video0") -> fd11 (capture queue)
	open("video1") -> fd12 (capture queue)
	ioctl(fd10, REQUEST, ALLOC) -> fd13
	ioctl(fd11, QBUF, { buffer1, fd13 })
	ioctl(fd12, QBUF, { buffer2, fd13 })
	ioctl(fd10, REQUEST, QUEUE { fd13 })

While it makes sense to allocate the request via the media device node in most
cases, there was a lot of discussion if an exception should be made for mem2mem
devices such as hardware codecs. M2M devices today consist of a single video node,
and every time it is opened a new instance is created (as if a new virtual m2m
device was created). The driver then schedules hardware access for the various
instances.

This means that the request should be associated with a specific m2m instance (i.e.
file descriptor). The easiest way to do that is simply by allocating the request
via the video device instead of creating a new media device and come up with a
way to associate the request with a m2m instance. Note that today's out-of-tree
implementation *does* create the request via the video node.

A final decision on this was postponed until we have a working implementation
and have a better idea of the pros and cons of creating such an exception.

When allocating a request the framework will fill in the request state: this
will either be a copy of the current hardware state, or it will clone the
state of an existing request (it does this by passing the fd of the request
that should be cloned, or by passing 0 to copy the current state).

1.3 Request validation

Some request requirements:

- When you queue a request it is validated.
- The request has a full state, so the validation is independent of any previously
  queued requests.
- If an error occurs, no good error reporting is available. But the only reason for
  such errors would be hardware failures, which usually indicate a serious
  unrecoverable problem and should trigger a halt (requests cancelled, flagged with
  error)
- Change in hardware configuration (e.g. disconnecting an HDMI input) could also
  invalidate requests

1.4 Completing requests

- A request is completed when all buffers are dequeued and all results are
  copied to the request.
- An event of some sort is needed to signal that the request has been completed.
  Since the request is a FD, this can be used with poll() to signal this.
- To delete a request the application has to call close(). The request will be
  really deleted once the refcount goes to 0.
- A request cannot be re-used without re-initializing it first by cloning the
  current HW state or an existing request or by 'cloning' itself, in which
  case the request's configuration will be re-used. This last option is useful
  for codecs: this is how the current out-of-tree implementation works.

1.5 Requests vs. w/o requests

There are three options for drivers w.r.t. the request API:

1) The driver doesn't use the request API
2) The driver requires the request API
3) The request API is optional.

It is not clear at this stage if 3 is ever needed. So for now just add a capability
flag for "requests required". And add a "requests supported with legacy" flag later
on if needed.

1.6 Minimum stateless codec requirements

- Request allocation
- Request capability flag
- Associate controls and buffers with requests

1.7 Stateless codec behaviour

- Each OUTPUT buffer produces one CAPTURE buffer of data.
- The user is responsible for providing just the right amount of data to the decoder.
	- Less data than required does produce a CAPTURE buffer but with ERROR flag set
	- More data than required does produce a CAPTURE buffer but the rest of the
	  data is discarded

The hardware processes jobs that consume a single OUTPUT buffer and fill a single
CAPTURE buffer. There are two ways to associate buffers with requests:

1) We can create requests that contain one OUTPUT buffer and one CAPTURE buffer.
   When a request completes, the OUTPUT and CAPTURE buffers contain the request
   FD they were queued with. These are the same buffers that were associated to
   the request before the request was queued. This works if there is a 1-to-1
   relationship between output and capture buffers.
2) We can prequeue a set of buffers on the CAPTURE side, and create requests that
   contain one OUTPUT buffer. When a request completes, the next DQBUF call will
   return an unspecified buffer ID and the request FD of the request that just
   completed. This is typically used by codecs where the capture buffers can be
   out-of-order.

- How to signal this to the application? Should we bother with 1) at all?

1.8. Sequence of calls for stateless codecs

- Open the video device node V -> fd1
- Option TBD: Open the media controller device node M -> fd2?
- Allocate a set of requests:

	#define MEDIA_REQ_CMD_ALLOC      0
	#define MEDIA_REQ_CMD_DELETE     1
	#define MEDIA_REQ_CMD_APPLY      2
	#define MEDIA_REQ_CMD_QUEUE      3
	#define MEDIA_REQ_CMD_INIT       4

	struct media_request_cmd {
		__u32 cmd;
		__u32 request; /* Is a file descriptor */
		__u32 base; /* Is a file descriptor */
	};

	for (...) {
		struct media_request_cmd cmd = { .cmd = MEDIA_REQ_CMD_ALLOC };

		ret = ioctl(fd1 or fd2, MEDIA_IOC_REQUEST_CMD, &cmd);
		
		list_add(cmd.request);
	}

- Process a frame:

    struct v4l2_control[] ctrls;
    struct v4l2_ext_controls ext_ctrls = { .controls = ctrls, .request = ... };
    struct v4l2_buffer buf = { .index = ..., .request = ... };
    struct media_request_cmd cmd  = { .cmd = MEDIA_REQ_CMD_QUEUE, .request = ... };

    ioctl(fd1, VIDIOC_S_EXT_CTRLS, &ctrls);
    ioctl(fd1, VIDIOC_QBUF, &buf);
    ...
    ioctl(fd1 or fd2, MEDIA_IOC_REQUEST_CMD, &cmd);

2 Conclusions

- File descriptors are used to refer to requests
- Request is validated when it is queued
- On mem-to-mem devices ONLY, the requests are created on the video device
  in order to associate it to the mem-to-mem context. On all other devices,
  the requests are created on the media device. (TBC once this is implemented)
- All mem-to-mem devices must have a per-file handle context. This is probably
  already the case, but this must be verified and documented.
- Event created on request completion.
- Finished requests cannot be requeued until you re-initialize the state
  to some initial state (either the HW state or that of another request).
  If it is re-initialized to itself, then nothing changes, other than that
  the request can now be requeued again.
  The reason for this is to force the application to think about the state that
  the request should contain.
  Another reason why you want to reuse requests is to avoid closing/opening fds
  all the time to avoid running out of fds in the middle of streaming, which can
  happen in e.g. a browser where some websites (facebook) request a huge number of fds.
- The initial request state may originate either from the current device state or
  from a given request.
- An actual request handling implementation in a framework should not copy
  the entire state but to refer to a different request or current device
  state instead. The aim here is to avoid copying large amount of state information
  that is unchanged in the most cases anyway.
- The scope of the requests may be limited to less than the full configurability of the device
	- E.g. sensor exposure time is most likely out of scope of requests whereas
	  buffers would go to the request
	- How to tell to the user what is the exact scope of the request API in the driver?

3 Work split

Laurent:
- Change the request API to use file descriptors to refer to requests
- Core request API (allocate, delete, queue, clone) + QBUF

Sakari:
- Make sure each mem-to-mem device does use a context
- Fix the drivers that do not have a context (if any)
- Update the API documentation accordingly

Tentative timeline for the actions above: first half of December (earlier
if possible).

Hans:
- Use core request API to add control support

Laurent:
- Use core request API to add support S_FMT, S_SELECTION

Last two actions are done in parallel. Timeline for these two actions:
end of January. We really need a first workable patch series by then.

4 Open questions and random thoughts

4.1 What happens if an application associates a buffer to a request and then calls streamoff?

We need to define what happens with that buffer and request.

4.2 Complex camera devices that have ISPs and I2C connected sensors or other sub-devices

- I2C bus access takes time and the sensor settings need to be applied at a
  particular point of time, well before the settings take effect
- In case of Android, the device specific HAL is aware of the timing model of
  the underlying hardware:
  - This reflects the current implementations
  - Splitting the timing model between the kernel and the user space would not
    improve the reliability of the system and would make resolving a complex problem
    even more complex:
  	- Sophisticated timing model required, this is most likely at least somewhat
	  specific to hardware
	- Interfaces required for ISP and sensor to provide information on their
	  configuration latching points
	  - The user space needs much of this information in order to keep requests going
	- Error handling in case the kernel cannot apply sensor settings in time

4.3 Asymmetric devices (that produce different number of buffers per a consumed buffer)

- How do we handle M2M devices which could produce 0 or more buffers of output?
- We know the maximum number of buffers that we will produce, but not the actual number
- Output buffers can be held internally until enough data available to Capture first result.

4.4 Streamon and streamoff

- How to handle STREAMON/OFF?
	- Pipelines without video nodes?
	- Buffer size may change. Need to reallocate buffers, which is currently done
	  through streamoff, reqbufs and streamon.
- We probably want a STREAM_CANCEL which would dequeue pending buffers (requests)
  without stopping streaming.

4.5 Concurrent access (or how to make requests for pipelines?)

What to do if the topology of the media device can be configured in two
independent pipelines? You would want to make requests for each pipeline,
so containing a partial configuration (just for that pipeline) instead of
for the full media state.

There currently is no object which represents a pipeline.

- Exclusive access to the request queue? Or entities? Or pads? Really: how to
  make requests for pipelines? (currently there is no object represent a pipeline)
- Define error codes in advance
- Implementations can try to request access to 'sub-parts' of pipelines
  - This should be done by requesting exclusive access to given pads
    (with possible exception of multiplexed pads)
  - Request should be validated against pads to which fd has exclusive access

4.6 Video buffer queues

- Currently vb2 only deals with one queue at a time
- Multiple queues has to be handled by the driver instead. This is quite painful
  if the queues are part of the same pipeline.
- vb2 should help with multiple queues. Helper function / framework at the same
  level as the m2m framework? The basic idea is to e.g. synchronize starting streaming
  until all queues are ready for it.
