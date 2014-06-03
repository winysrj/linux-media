Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51538 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164AbaFCXpx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jun 2014 19:45:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: Poll and empty queues
Date: Wed, 04 Jun 2014 01:46:19 +0200
Message-ID: <1796797.iEz1prGJi5@avalon>
In-Reply-To: <1401817194.13385.49.camel@nicolas-tpx230>
References: <1401738463.2304.15.camel@nicolas-tpx230> <1715728.xzx1A1Sk00@avalon> <1401817194.13385.49.camel@nicolas-tpx230>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On Tuesday 03 June 2014 13:39:54 Nicolas Dufresne wrote:
> Le mardi 03 juin 2014 à 18:11 +0200, Laurent Pinchart a écrit :
> > On Tuesday 03 June 2014 10:37:50 Nicolas Dufresne wrote:
> >> Le mardi 03 juin 2014 à 08:38 +0200, Hans Verkuil a écrit :
> >>> On 06/02/2014 09:47 PM, Nicolas Dufresne wrote:
> >>>> Hi everyone,
> >>>> 
> >>>> Recently in GStreamer we notice that we where not handling the
> >>>> POLLERR flag at all. Though we found that what the code do, and what
> >>>> the doc says is slightly ambiguous.
> >>>> 
> >>>>         "When the application did not call VIDIOC_QBUF or
> >>>>         VIDIOC_STREAMON yet the poll() function succeeds, but sets
> >>>>         the POLLERR flag in the revents field."
> >>>> 
> >>>> In our case, we first seen this error with a capture device. How
> >>>> things worked is that we first en-queue all allocated buffers. Our
> >>>> interpretation was that this would avoid not calling "VIDIOC_QBUF
> >>>> [...] yet", and only then we would call VIDIOC_STREAMON. This way,
> >>>> in our interpretation we would never get that error.
> >>>> 
> >>>> Though, this is not what the code does. Looking at videobuf2, if
> >>>> simply return this error when the queue is empty.
> >>>> 
> >>>> /*
> >>>>  * There is nothing to wait for if no buffers have already been
> >>>>  queued.
> >>>>  */
> >>>> if (list_empty(&q->queued_list))
> >>>> 	return res | POLLERR;
> >>>> 
> >>>> So basically, we endup in this situation where as soon as all
> >>>> existing buffers has been dequeued, we can't rely on the driver to
> >>>> wait for a buffer to be queued and then filled again. This basically
> >>>> forces us into adding a new user-space mechanism, to wait for buffer
> >>>> to come back. We are wandering if this is a bug. If not, maybe it
> >>>> would be nice to improve the documentation.
> >>> 
> >>> Just for my understanding: I assume that gstreamer polls in one
> >>> process or thread and does the queuing/dequeuing in a different
> >>> process/thread, is that correct?
> >> 
> >> Yes, in this particular case (polling with queues/thread downstream),
> >> the streaming thread do the polling, and then push the buffers. The
> >> buffer reach a queue element, which will queued and return. Polling
> >> restart at this point. The queue will later pass it downstream from the
> >> next streaming thread, and eventually the buffer will be released. For
> >> capture device, QBUF will be called upon release.
> >> 
> >> It is assumed that this call to QBUF should take a finite amount of
> >> time. Though, libv4l2 makes this assumption wrong by inter-locking DQBUF
> >> and QBUF, clearly a bug, but not strictly related to this thread. Also,
> >> as we try and avoid blocking in the DQBUF ioctl, it should not be a
> >> problem for us.
> >> 
> >>> If it was all in one process, then it would make no sense polling for
> >>> a buffer to become available if you never queued one.
> >> 
> >> Not exactly true, the driver may take some time before the buffer we
> >> have queued back is filled and available again. The poll/select FD set
> >> also have a control pipe, so we can stop the process at any moment. Not
> >> polling would mean blocking on an ioctl() which cannot be canceled.
> >> 
> >> But, without downstream queues (thread), the size of the queue will be
> >> negotiated so that the buffer will be released before we go back
> >> polling. The queue will never be empty in this case.
> >> 
> >>> That is probably the reasoning behind what poll does today. That said,
> >>> I've always thought it was wrong and that it should be replaced by
> >>> something like:
> >>> 
> >>> 	if (!vb2_is_streaming(q))
> >>> 		return res | POLLERR;
> >>> 
> >>> I.e.: only return an error if we're not streaming.
> >> 
> >> I think it would be easier for user space and closer to what the doc
> >> says.
> > 
> > I tend to agree, and I'd like to raise a different but related issue.
> > 
> > I've recently run into a problem with a V4L2 device (OMAP4 ISS if you want
> > details) that sometimes crashes during video capture. When this occurs the
> > device is rendered completely unusable, and userspace need to stop the
> > video stream and close the video device node in order to reset the
> > device. That's not ideal, but until I pinpoint the root cause that's what
> > we have to live with.
> > 
> > When the OMAP4 ISS driver detects the error it immediately completes all
> > queued buffers with the V4L2_BUF_FLAG_ERROR flag set, and returns -EIO
> > from all subsequent VIDIOC_QBUF calls. The next few VIDIOC_DQBUF calls
> > will return buffers with the V4L2_BUF_FLAG_ERROR flag set, after which the
> > next VIDIOC_DQBUF call will block in __vb2_wait_for_done_vb() on
> > 
> >         ret = wait_event_interruptible(q->done_wq,
> >                         !list_empty(&q->done_list) || !q->streaming);
> > 
> > as the queue is still streaming and the done list stays empty.
> > 
> > (Disclaimer : I'm using gstreamer 0.10 for this project due to TI shipping
> > the OMAP4 H.264 codec for this version only)
> 
> Nod, nothing I can help with. This is a very similar problem to out-of-tree
> kernel drivers. We need to teach vendors to upstream in gst-plugins-bad,
> otherwise it becomes un-maintain.

In this specific case the code depends on the unmaintained TI OMAP4 BSP 
kernel, so it wouldn't have helped much :-/

> > As gstreamer doesn't handle POLLERR in v4l2src the gst_poll_wait() call in
> > gst_v4l2src_grab_frame() will return success, and the function then
> > proceeds to call gst_v4l2_buffer_pool_dqbuf() which will block. Trying to
> > stop the pipeline at that point just hangs forever on the VIDIOC_DQBUF
> > call.
>
> This is what I'm working on right now, don't expect a fix for 0.10, it has
> been un-maintained for 2 years now.

I know I'm on my own. Or mostly, there are still very helpful gstreamer 
developers who I want to thank for helping me (they will know who they are 
:-)).

> For the reference:
> 
> https://bugzilla.gnome.org/show_bug.cgi?id=731015

Thank you.

> > This kind of fatal error condition should be detected and reported to the
> > application.
> > 
> > If we modified the poll() behaviour to return POLLERR on
> > !vb2_is_streaming() instead of list_empty(&q->queued_list) the poll call
> > would block and stopping the pipeline would be possible.
> > 
> > We would however still miss a mechanism to detect the fatal error and
> > report it to the application. As I'm not too familiar with gstreamer I'd
> > appreciate any help I could get to implement this.
> 
> It might not be the appropriate list but oh well ...
> 
> GStreamer abstract polling through GstPoll (reason: special features and
> multi-platform). To detect the POLLERR, simply keep the GstPollFD
> structure around in the object, and call gst_poll_fd_has_error(poll,
> pollfd), you can read errno as usual. If you change the kernel as we
> said, this code should never be reached, hence shall be a fatal error
> (return GST_FLOW_ERROR and GST_ELEMENT_ERROR so application is notified
> and can handle it).
> 
> It would indeed be a good mechanism to trigger fatal run-time error in
> my opinion. We would need to document values of errno that make sense I
> suppose. The ERROR flag is clearly documented as a mechanism for
> recoverable errors.

Thanks a lot for the information. I'll give this a try and will post RFC 
patches to the linux-media list, CC'ing you.

> >> Though, it's not just about changing that check, there is some more work
> >> involved from what I've seen.
> > 
> > What have you seen ? :-)
> 
> My bad, miss-read the next statement:
> 
>         if (list_empty(&q->done_list))
>         		poll_wait(file, &q->done_wq, wait);
> 
> Nothing complex to do indeed.

-- 
Regards,

Laurent Pinchart

