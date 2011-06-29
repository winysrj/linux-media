Return-path: <mchehab@pedra>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:59153 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab1F2NoC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 09:44:02 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: RFC: poll behavior
Date: Wed, 29 Jun 2011 15:43:51 +0200
Cc: linux-media@vger.kernel.org
References: <201106291326.47527.hansverk@cisco.com> <201106291442.30210.hansverk@cisco.com> <4E0B2382.4090409@redhat.com>
In-Reply-To: <4E0B2382.4090409@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291543.51271.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, June 29, 2011 15:07:14 Hans de Goede wrote:
> Hi,
> 
> On 06/29/2011 02:42 PM, Hans Verkuil wrote:
> > On Wednesday, June 29, 2011 14:10:44 Hans de Goede wrote:
> >> Hi,
> >>
> >> On 06/29/2011 01:26 PM, Hans Verkuil wrote:
> 
> <Snip>
> 
> >>> 4) Proposal to change the poll behavior
> >>>
> >>> For the short term I propose that condition c is handled as follows:
> >>>
> >>> If for the filehandle passed to poll() no events have been subscribed, then
> >>> keep the old behavior (i.e. start streaming). If events have been subscribed,
> >>> however, then implement the new behavior (return POLLERR).
> >>>
> >>
> >> If events have been subscribed and no events are pending then the right
> >> behavior would be to return 0, not POLLERR, otherwise a waiting app
> >> will return from the poll immediately, or am I missing something?
> >
> > Yes and no. For select() POLLERR is ignored if you are only waiting for POLLPRI.
> >
> > But I see that that does not happen for the poll(2) API (see do_pollfd() in
> > fs/select.c). This means that POLLERR is indeed not a suitable event it
> > return. It will have to be POLLIN or POLLOUT instead.
> >
> > This is actually a real problem with poll(2): if there is no streaming in progress
> > and the driver does not support r/w, and you want to poll for just POLLPRI, then
> > POLLERR will be set, and poll(2) will always return. But select(2) will work fine.
> >
> > In other words, poll(2) and select(2) handle POLLPRI differently with respect to
> > POLLERR. What a mess. You can't really return POLLERR and support POLLPRI at the
> > same time.
> >
> 
> Ok, yet more reason to go with my proposal, but then simplified to:
> 
> When streaming has not started return POLLIN or POLLOUT (or-ed with
> POLLPRI if events are pending).

So would this be what you are looking for:

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 6ba1461..a3ce5a3 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1371,35 +1371,37 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q);
  */
 unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 {
+	struct video_device *vfd = video_devdata(file);
 	unsigned long flags;
 	unsigned int ret;
 	struct vb2_buffer *vb = NULL;
+	bool have_events = false;
+	unsigned int res = 0;
+
+	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
+		struct v4l2_fh *fh = file->private_data;
+
+		/* Is this file handle subscribed to any events? */
+		have_events = fh->events != NULL;
+		if (have_events && v4l2_event_pending(fh))
+			res = POLLPRI;
+	} 
 
 	/*
 	 * Start file I/O emulator only if streaming API has not been used yet.
 	 */
 	if (q->num_buffers == 0 && q->fileio == NULL) {
-		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ)) {
-			ret = __vb2_init_fileio(q, 1);
-			if (ret)
-				return POLLERR;
-		}
-		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE)) {
-			ret = __vb2_init_fileio(q, 0);
-			if (ret)
-				return POLLERR;
-			/*
-			 * Write to OUTPUT queue can be done immediately.
-			 */
-			return POLLOUT | POLLWRNORM;
-		}
+		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ))
+			return res | POLLIN | POLLRDNORM;
+		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE))
+			return res | POLLOUT | POLLWRNORM;
 	}
 
 	/*
 	 * There is nothing to wait for if no buffers have already been queued.
 	 */
 	if (list_empty(&q->queued_list))
-		return POLLERR;
+		return have_events ? res : POLLERR;
 
 	poll_wait(file, &q->done_wq, wait);
 
@@ -1414,10 +1416,10 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 
 	if (vb && (vb->state == VB2_BUF_STATE_DONE
 			|| vb->state == VB2_BUF_STATE_ERROR)) {
-		return (V4L2_TYPE_IS_OUTPUT(q->type)) ? POLLOUT | POLLWRNORM :
+		return res | (V4L2_TYPE_IS_OUTPUT(q->type)) ? POLLOUT | POLLWRNORM :
 			POLLIN | POLLRDNORM;
 	}
-	return 0;
+	return res;
 }
 EXPORT_SYMBOL_GPL(vb2_poll);
 

One note: the only time POLLERR is now returned is if no buffers have been queued
and no events have been subscribed to. I think that qualifies as an error condition.
I am not 100% certain, though.

Comments?

	Hans
