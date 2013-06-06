Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51803 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751326Ab3FFVij (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Jun 2013 17:38:39 -0400
Date: Fri, 7 Jun 2013 00:38:04 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC] Support for events with a large payload
Message-ID: <20130606213803.GC3103@valkosipuli.retiisi.org.uk>
References: <201305131414.43685.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201305131414.43685.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the RFC! :-)

On Mon, May 13, 2013 at 02:14:43PM +0200, Hans Verkuil wrote:
> Currently the event API allows for a payload of up to 64 bytes. Sometimes we
> would like to pass larger payloads to userspace such as metadata associated
> with a particular video stream.
> 
> A typical example of that would be object detection events.
> 
> This RFC describes one approach for doing this.
> 
> The event framework has the nice property of being able to use from within
> interrupts. Copying large payloads does not fit into that framework, so
> such payloads should be adminstrated separately.
> 
> In addition, I wouldn't allow large payloads to be filled in from interrupt
> context: a worker queue would be much more appropriate.

How large really is "large"? 65 bytes? 64 kiB?

The newer CPUs tend to be faster and faster and the same applies to memory.
I guess threaded interrupt handlers are still nice. But using a mutex in
order to serialise access to the struct will force drivers to use threaded
interrupt handlers should they want to generate large events.

> Note that the event API is only useful for relatively low-bandwidth data
> since the data is always copied. When dealing with high-bandwidth data the
> data should either be a separate plane or become a special stream I/O buffer
> type.
> 
> The userspace API enhancements in order to achieve this would be the
> following:
> 
> - Any event that has a large payload would specify a payload_sequence counter
>   and a payload size value (in bytes).
> 
> - A new VIDIOC_DQEVENT_PAYLOAD ioctl would be added which passes the event type,
>   the payload_sequence counter and a pointer to a buffer to the kernel, and the
>   payload is returned, or an error is returned if the payload data is no longer
>   available.

Do you think we should have a separate IOCTL for this? The downside is that
to dequeue events, the application would need to try both in the worst case
just to obtain an event.

I think it'd be nicer to be able to fit that into the same IOCTL. There are
plenty of reserved fields and, actually, the event data as well: we could
consider the large-payload event a meta-event which would contain the
required information to pass the event data to the user space. The type of
such an event could be V4L2_EVENT_LARGE, for instance.

> Optional enhancements:
> 
> - Have VIDIOC_SUBSCRIBE_EVENT return the maximum payload size (lets apps
>   preallocate payload memory, but it might be overkill).

Why so? We could use a reserved field as well. The size would be zero if the
maximum would be less than 64.

> - Add functionality to VIDIOC_SUBSCRIBE_EVENT to define the number of
>   events in the event queue for the filehandle. If the payload is large,
>   you may want to limit the number of allocated payload buffers. For
>   example: when dealing with metadata associated with frame you might want
>   to limit the number of payload buffers to the number of allocated frames.

Are we talking now about high level metadata which is typically obtained by
the driver by other means than hardware writing it into a memory buffer?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
