Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54078 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443AbcEXQu6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 12:50:58 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [RFC v2 0/21] Media request API
Date: Tue, 24 May 2016 19:47:10 +0300
Message-Id: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is a second version of the RFC set on my request API work. It
includes patches from myself as well as from Hans and Laurent.

The current set can be found here as well:

<URL:http://git.retiisi.org.uk/?p=~sailus/linux.git;a=shortlog;h=refs/heads/request>

I keep updating it as I work with the patches. The set depends on two
other sets available discretely in the media-device-fh and
media-ioctl-rework branches. Both sets have been posted to linux-media:

<URL:http://www.spinics.net/lists/linux-media/msg100194.html>                   
<URL:http://www.spinics.net/lists/linux-media/msg100188.html>                   

There's a large number of changes in these patches, mostly fixes linked
list handling and media request object reference management (read: there
were a ton of bugs). Since v1, I've also dropped patch "vb2: Add helper
function to check for request buffers" as I saw no use for it. The
previous set can be found here:

<URL:http://www.spinics.net/lists/linux-media/msg100285.html>

I'm still posting this as an RFC since I believe there are matters to be
resolved until the patches are mergeable.

My own use case for this is a little bit more limited than for some
others, i.e. I only need to bind video buffers to requests. That is
currently functional with these patches. Applying requests has not been
tested nor I have use for the functionality right now.
                                                                                
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

- Video buffer handling is currently done in a driver I'm working on. Much
  of this should be moved to the framework.

- Queueing requests vs. video buffer queue state. This is a real pain
  point. Queueing a request to hardware requires serialisation with video
  buffer queue state changes, i.e. stop_stream and start_stream video
  buffer queue callbacks for every queue which is a part of the pipeline.
  That is, for streaming devices.

  The problem comes from the fact that for queueing the request all the
  queues of the pipeline need to be in the streaming state and all the
  buffers bound to the request need to be in VB2_BUF_STATE_QUEUED as well.
  Let's see if this could be moved to the framework, otherwise developers
  will have hard time getting this right in drivers. Also consider that
  the queues that are part of a pipeline are specific to device
  configuration.

Comments and questions are very welcome.

-- 
Kind regards,
Sakari


