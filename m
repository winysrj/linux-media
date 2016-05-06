Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63881 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757949AbcEFK4k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2016 06:56:40 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [RFC 00/22] Media request API
Date: Fri,  6 May 2016 13:53:09 +0300
Message-Id: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

Here's a set of patches to implement support for the request API that has
been discussed many, many times over the past few years. Some of the
patches are my own while some have been written by Laurent and Hans.

I've made a few changes to these patches and added more, mainly:

- Implement request state in the framework in order to prevent performing
  invalid actions on requests, e.g. deleting a queued request or queueing
  a request which is already queued.

- Use 32 bits for the request ID. As requests are global, a 16-bit space
  could become a limitation. The IDs are reserved using ida (as in
  linux/idr.h) instead of a counter. This way we can ensure that once the
  counter wraps around, we will continue to allocate unique IDs for new
  requests. 

- Add media events to signal applications on completed events. Only the
  file handle which queued the request is notified. I've chosen this
  instead of a request specific means to dequeue events as there isn't
  really anything to obtain other than the information that the request
  has been completed: there's no data related to it, no buffers as in
  V4L2. Some applications may not be interested in receiving such events
  so the events are optional, specific to the queued request.

- Add poll support to tell the user there are dequeueable events.

My own use case for this is a little bit more limited than for some
others, i.e. I only need to bind video buffers to requests. That is
currently functional with these patches.

My open questions and to-do items I'm aware of:

- Global ID space vs. file handles. Should requests be referred to by
  global IDs or file handles specific to a process? V4L2 uses IDs but V4L2
  devices (other than m2m) can meaningfully be used only by a single
  program (or co-operative programs) at a time whereas the media device
  could conceivably be accessed and used for different purposes by
  multiple programs at the same time as the resources accessible through
  the media device are numerous and often independent of each other. A
  badly behaving application could disturb other applications using the
  same media device even if no resource conflict exist by accessing the
  same request IDs than other applications.

- Request completion and deletion. Should completed requests be deleted
  automatically, or should the request return to an "empty" state after
  completion? Applications typically have to create a new request right
  after a completion of an earlier one, and sparing one additional IOCTL
  call would be nice. (In current implementation the requests are deleted
  in completion, but this would be a trivial change.)

- Video buffers vs. requests. In the current implementation, I'm using
  VIDIOC_QBUF() from user space to associate buffers with requests. This
  is convenient in drivers since the only extra steps to support requests
  (vs. operation without requests) is to find the request and not really
  queueing the buffer yet. What's noteworthy as well that the VB2 buffer
  is in correct state after this when the request is queued.

- Subsystem framework specific request information. The requests are about
  the media device, and struct media_device_request is free of e.g. V4L2
  related information. Adding a pointer to V4L2 related data would make it
  easier to add request handling related functionality to the V4L2
  framework.

- MEDIA_IOC_REQUEST_CMD + (ALLOC/DELETE/QUEUE/APPLY) vs.
  MEDIA_IOC_REQUEST_(ALLOC/DELETE/QUEUE/APPLY). Should we continue to have
  a single IOCTL on the media device for requests, or should each
  operation on a request have a distinct IOCTL? The current implementation
  has a single IOCTL.

- VB2 queues are quite self-sufficient at the moment. Starting start in a
  queue requires at least one queued buffer whereas a stream containing
  multiple queues using requests could start e.g. by having a single
  buffer in a request for three streaming queues. The functionality would
  need to be relaxed to properly support requests.

- Limit number of allocated requests and dequeueable events to prevent
  unintentional or intentional system memory exhaustion.

The patchset is dependent on two patchsets (Media device IOCTL handling
refactoring and Media device file handle support) I've posted lately:

<URL:http://www.spinics.net/lists/linux-media/msg100194.html>
<URL:http://www.spinics.net/lists/linux-media/msg100188.html>

The code can be found here in the branch called "request":

<URL:http://git.retiisi.org.uk/?p=~sailus/linux.git;a=summary>

I intend to provide a test program for testing requests in the near
future.

Questions and comments are the most welcome!

-- 
Kind regards,
Sakari

