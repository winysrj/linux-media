Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3832 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab1GALz1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2011 07:55:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [RFCv1 PATCH] Modify core poll implementation to get requested event mask
Date: Fri, 1 Jul 2011 13:55:16 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107011355.16290.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

One thing that would solve all the problems we have with POLLPRI and the
read/write I/O mode is if the driver would know which poll events the application
actually requested.

However, this would require changes in the fs core. I expected this to be very
difficult, but after analyzing it it wasn't that hard or invasive at all.

The diffstat for the core changes is really small:

 fs/eventpoll.c       |   14 ++++++++++----
 fs/select.c          |   32 ++++++++++++++------------------
 include/linux/poll.h |    9 ++++++++-
 3 files changed, 32 insertions(+), 23 deletions(-)

The proctable struct already contained a key field with the events from the
application, but once a poll() call matched one or more events the other poll()
calls would get a NULL proctable pointer, so they could never see the events.

Instead of passing a NULL pointer, this patch sets the qproc callback to
NULL. So poll() implementations always get a valid proctable pointer and can
use the key field.

There are still two WARN_ON() calls in the header, but those are just for testing.
I'm not sure yet whether to allow a NULL proctable pointer. I think it shouldn't
be allowed at all.

I'd like to get some feedback first before going to the lkml with this.

Regards,

	Hans

diff --git a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/video/ivtv/ivtv-fileops.c
index 38f0522..e17658b 100644
--- a/drivers/media/video/ivtv/ivtv-fileops.c
+++ b/drivers/media/video/ivtv/ivtv-fileops.c
@@ -746,14 +746,18 @@ unsigned int ivtv_v4l2_dec_poll(struct file *filp, poll_table *wait)
 
 unsigned int ivtv_v4l2_enc_poll(struct file *filp, poll_table * wait)
 {
+	unsigned long req_ev = poll_requested_events(wait);
 	struct ivtv_open_id *id = fh2id(filp->private_data);
 	struct ivtv *itv = id->itv;
 	struct ivtv_stream *s = &itv->streams[id->type];
 	int eof = test_bit(IVTV_F_S_STREAMOFF, &s->s_flags);
 	unsigned res = 0;
+	bool has_input_events;
+
+	has_input_events = req_ev & (POLLRDNORM | POLLRDBAND | POLLIN);
 
 	/* Start a capture if there is none */
-	if (!eof && !test_bit(IVTV_F_S_STREAMING, &s->s_flags)) {
+	if (!eof && !test_bit(IVTV_F_S_STREAMING, &s->s_flags) && has_input_events) {
 		int rc;
 
 		mutex_lock(&itv->serialize_lock);
diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 6ba1461..ccdd065 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1371,20 +1371,28 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q);
  */
 unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 {
+	unsigned long req_ev = poll_requested_events(wait);
 	unsigned long flags;
 	unsigned int ret;
+	bool has_input_events;
+	bool has_output_events;
 	struct vb2_buffer *vb = NULL;
 
+	has_input_events = req_ev & (POLLRDNORM | POLLRDBAND | POLLIN);
+	has_output_events = req_ev & (POLLWRBAND | POLLWRNORM | POLLOUT);
+
 	/*
 	 * Start file I/O emulator only if streaming API has not been used yet.
 	 */
 	if (q->num_buffers == 0 && q->fileio == NULL) {
-		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ)) {
+		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ) &&
+				has_input_events) {
 			ret = __vb2_init_fileio(q, 1);
 			if (ret)
 				return POLLERR;
 		}
-		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE)) {
+		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE) &&
+				has_output_events) {
 			ret = __vb2_init_fileio(q, 0);
 			if (ret)
 				return POLLERR;
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index f9cfd16..f89b1a5 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -650,9 +650,11 @@ static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
 			       void *priv)
 {
 	struct epitem *epi, *tmp;
+	poll_table pt = { NULL, 0 };
 
 	list_for_each_entry_safe(epi, tmp, head, rdllink) {
-		if (epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
+		pt.key = epi->event.events;
+		if (epi->ffd.file->f_op->poll(epi->ffd.file, &pt) &
 		    epi->event.events)
 			return POLLIN | POLLRDNORM;
 		else {
@@ -946,6 +948,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	/* Initialize the poll table using the queue callback */
 	epq.epi = epi;
 	init_poll_funcptr(&epq.pt, ep_ptable_queue_proc);
+	epq.pt.key = event->events;
 
 	/*
 	 * Attach the item to the poll hooks and get current event bits.
@@ -1027,20 +1030,21 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 {
 	int pwake = 0;
 	unsigned int revents;
+	poll_table pt = { NULL, 0 };
 
 	/*
 	 * Set the new event interest mask before calling f_op->poll();
 	 * otherwise we might miss an event that happens between the
 	 * f_op->poll() call and the new event set registering.
 	 */
-	epi->event.events = event->events;
+	epi->event.events = pt.key = event->events;
 	epi->event.data = event->data; /* protected by mtx */
 
 	/*
 	 * Get current event bits. We can safely use the file* here because
 	 * its usage count has been increased by the caller of this function.
 	 */
-	revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL);
+	revents = epi->ffd.file->f_op->poll(epi->ffd.file, &pt);
 
 	/*
 	 * If the item is "hot" and it is not registered inside the ready
@@ -1075,6 +1079,7 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 	unsigned int revents;
 	struct epitem *epi;
 	struct epoll_event __user *uevent;
+	poll_table pt = { NULL, 0 };
 
 	/*
 	 * We can loop without lock because we are passed a task private list.
@@ -1087,7 +1092,8 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 
 		list_del_init(&epi->rdllink);
 
-		revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
+		pt.key = epi->event.events;
+		revents = epi->ffd.file->f_op->poll(epi->ffd.file, &pt) &
 			epi->event.events;
 
 		/*
diff --git a/fs/select.c b/fs/select.c
index d33418f..2da21b8 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -386,13 +386,11 @@ get_max:
 static inline void wait_key_set(poll_table *wait, unsigned long in,
 				unsigned long out, unsigned long bit)
 {
-	if (wait) {
-		wait->key = POLLEX_SET;
-		if (in & bit)
-			wait->key |= POLLIN_SET;
-		if (out & bit)
-			wait->key |= POLLOUT_SET;
-	}
+	wait->key = POLLEX_SET;
+	if (in & bit)
+		wait->key |= POLLIN_SET;
+	if (out & bit)
+		wait->key |= POLLOUT_SET;
 }
 
 int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
@@ -414,7 +412,7 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 	poll_initwait(&table);
 	wait = &table.pt;
 	if (end_time && !end_time->tv_sec && !end_time->tv_nsec) {
-		wait = NULL;
+		wait->qproc = NULL;
 		timed_out = 1;
 	}
 
@@ -459,17 +457,17 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 					if ((mask & POLLIN_SET) && (in & bit)) {
 						res_in |= bit;
 						retval++;
-						wait = NULL;
+						wait->qproc = NULL;
 					}
 					if ((mask & POLLOUT_SET) && (out & bit)) {
 						res_out |= bit;
 						retval++;
-						wait = NULL;
+						wait->qproc = NULL;
 					}
 					if ((mask & POLLEX_SET) && (ex & bit)) {
 						res_ex |= bit;
 						retval++;
-						wait = NULL;
+						wait->qproc = NULL;
 					}
 				}
 			}
@@ -481,7 +479,7 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 				*rexp = res_ex;
 			cond_resched();
 		}
-		wait = NULL;
+		wait->qproc = NULL;
 		if (retval || timed_out || signal_pending(current))
 			break;
 		if (table.error) {
@@ -738,9 +736,7 @@ static inline unsigned int do_pollfd(struct pollfd *pollfd, poll_table *pwait)
 		if (file != NULL) {
 			mask = DEFAULT_POLLMASK;
 			if (file->f_op && file->f_op->poll) {
-				if (pwait)
-					pwait->key = pollfd->events |
-							POLLERR | POLLHUP;
+				pwait->key = pollfd->events | POLLERR | POLLHUP;
 				mask = file->f_op->poll(file, pwait);
 			}
 			/* Mask out unneeded events. */
@@ -763,7 +759,7 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
 
 	/* Optimise the no-wait case */
 	if (end_time && !end_time->tv_sec && !end_time->tv_nsec) {
-		pt = NULL;
+		pt->qproc = NULL;
 		timed_out = 1;
 	}
 
@@ -788,7 +784,7 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
 				 */
 				if (do_pollfd(pfd, pt)) {
 					count++;
-					pt = NULL;
+					pt->qproc = NULL;
 				}
 			}
 		}
@@ -796,7 +792,7 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
 		 * All waiters have already been registered, so don't provide
 		 * a poll_table to them on the next loop iteration.
 		 */
-		pt = NULL;
+		pt->qproc = NULL;
 		if (!count) {
 			count = wait->error;
 			if (signal_pending(current))
diff --git a/include/linux/poll.h b/include/linux/poll.h
index cf40010..93f3fd5 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -39,10 +39,17 @@ typedef struct poll_table_struct {
 
 static inline void poll_wait(struct file * filp, wait_queue_head_t * wait_address, poll_table *p)
 {
-	if (p && wait_address)
+	WARN_ON(p == NULL);
+	if (p && p->qproc && wait_address)
 		p->qproc(filp, wait_address, p);
 }
 
+static inline unsigned long poll_requested_events(const poll_table *p)
+{
+	WARN_ON(p == NULL);
+	return p ? p->key : ~0;
+}
+
 static inline void init_poll_funcptr(poll_table *pt, poll_queue_proc qproc)
 {
 	pt->qproc = qproc;
