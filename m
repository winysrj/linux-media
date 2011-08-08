Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36605 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab1HHKIG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 06:08:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [PATCH] [media] omap3isp: queue: fail QBUF if buffer is too small
Date: Mon, 8 Aug 2011 12:08:16 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <1312472437-26231-1-git-send-email-michael.jones@matrix-vision.de> <201108051059.46485.laurent.pinchart@ideasonboard.com> <4E3BD702.8030204@matrix-vision.de>
In-Reply-To: <4E3BD702.8030204@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108081208.16888.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Friday 05 August 2011 13:41:54 Michael Jones wrote:
> On 08/05/2011 10:59 AM, Laurent Pinchart wrote:
> > Hi Michael,
> > 
> > Thanks for the patch.
> > 
> > On Thursday 04 August 2011 17:40:37 Michael Jones wrote:
> >> Add buffer length to sanity checks for QBUF.
> >> 
> >> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
> >> ---
> >> 
> >>  drivers/media/video/omap3isp/ispqueue.c |    3 +++
> >>  1 files changed, 3 insertions(+), 0 deletions(-)
> >> 
> >> diff --git a/drivers/media/video/omap3isp/ispqueue.c
> >> b/drivers/media/video/omap3isp/ispqueue.c index 9c31714..4f6876f 100644
> >> --- a/drivers/media/video/omap3isp/ispqueue.c
> >> +++ b/drivers/media/video/omap3isp/ispqueue.c
> >> @@ -867,6 +867,9 @@ int omap3isp_video_queue_qbuf(struct isp_video_queue
> >> *queue, if (buf->state != ISP_BUF_STATE_IDLE)
> >> 
> >>  		goto done;
> >> 
> >> +	if (vbuf->length < buf->vbuf.length)
> >> +		goto done;
> >> +
> > 
> > The vbuf->length value passed from userspace isn't used by the driver, so
> > I'm not sure if verifying it is really useful. We verify the memory
> > itself instead, to make sure that enough pages can be accessed. The
> > application can always lie about the length, so we can't rely on it
> > anyway.
> 
> According to the spec, it's expected that the application set 'length':
> "To enqueue a user pointer buffer applications set [...] length to its
> size." (Now that I say that, I realize I should only do this length
> check for USERPTR buffers.) If we don't at least sanity check it for the
> application, then it has no purpose at all on QBUF. If this is
> desirable, I would propose changing the spec.
> 
> This patch was born of a mistake when my application set 624x480, which
> resulted in sizeimage=640x480=307200 but it used width & height to
> calculate the buffer size rather than sizeimage or even to take
> bytesperline into account. It was then honest with QBUF, confessing that
> it wasn't providing enough space, but QBUF just went ahead. What
> followed were random crashes while data was DMA'd into memory not set
> aside for the buffer, while I assumed that the buffer size was OK
> because QBUF had succeeded and was looking elsewhere in the program for
> the culprit. I think it makes sense to give the app an error on QBUF in
> this situation.

Right. This will help catching application errors without any drawback on the 
kernel side.

Do you want to resubmit the patch with an additional USERPTR check, or should 
I write one ?

> >>  	if (vbuf->memory == V4L2_MEMORY_USERPTR &&
> >>  	    vbuf->m.userptr != buf->vbuf.m.userptr) {
> >>  		isp_video_buffer_cleanup(buf);

-- 
Regards,

Laurent Pinchart
