Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48026 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757920AbcEFPZ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2016 11:25:26 -0400
Date: Fri, 6 May 2016 18:25:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, mchehab@osg.samsung.com
Subject: Re: [RFC 00/22] Media request API
Message-ID: <20160506152522.GO26360@valkosipuli.retiisi.org.uk>
References: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 06, 2016 at 01:53:09PM +0300, Sakari Ailus wrote:
> My open questions and to-do items I'm aware of:
> 
> - Global ID space vs. file handles. Should requests be referred to by
>   global IDs or file handles specific to a process? V4L2 uses IDs but V4L2
>   devices (other than m2m) can meaningfully be used only by a single
>   program (or co-operative programs) at a time whereas the media device
>   could conceivably be accessed and used for different purposes by
>   multiple programs at the same time as the resources accessible through
>   the media device are numerous and often independent of each other. A
>   badly behaving application could disturb other applications using the
>   same media device even if no resource conflict exist by accessing the
>   same request IDs than other applications.
> 
> - Request completion and deletion. Should completed requests be deleted
>   automatically, or should the request return to an "empty" state after
>   completion? Applications typically have to create a new request right
>   after a completion of an earlier one, and sparing one additional IOCTL
>   call would be nice. (In current implementation the requests are deleted
>   in completion, but this would be a trivial change.)
> 
> - Video buffers vs. requests. In the current implementation, I'm using
>   VIDIOC_QBUF() from user space to associate buffers with requests. This
>   is convenient in drivers since the only extra steps to support requests
>   (vs. operation without requests) is to find the request and not really
>   queueing the buffer yet. What's noteworthy as well that the VB2 buffer
>   is in correct state after this when the request is queued.
> 
> - Subsystem framework specific request information. The requests are about
>   the media device, and struct media_device_request is free of e.g. V4L2
>   related information. Adding a pointer to V4L2 related data would make it
>   easier to add request handling related functionality to the V4L2
>   framework.
> 
> - MEDIA_IOC_REQUEST_CMD + (ALLOC/DELETE/QUEUE/APPLY) vs.
>   MEDIA_IOC_REQUEST_(ALLOC/DELETE/QUEUE/APPLY). Should we continue to have
>   a single IOCTL on the media device for requests, or should each
>   operation on a request have a distinct IOCTL? The current implementation
>   has a single IOCTL.
> 
> - VB2 queues are quite self-sufficient at the moment. Starting start in a
>   queue requires at least one queued buffer whereas a stream containing
>   multiple queues using requests could start e.g. by having a single
>   buffer in a request for three streaming queues. The functionality would
>   need to be relaxed to properly support requests.
> 
> - Limit number of allocated requests and dequeueable events to prevent
>   unintentional or intentional system memory exhaustion.

One matter to add here:

- Serialisation. How should access to various objects be handled? There
  might not be bugs in the current code, but supporting requests changing
  the Media device (graph) state would definitely benefit from abolishing
  the big graph_mutex.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
