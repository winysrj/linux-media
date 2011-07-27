Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab1G0SDk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 14:03:40 -0400
Message-ID: <4E3052F5.3010202@redhat.com>
Date: Wed, 27 Jul 2011 15:03:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PATCHES FOR 3.1] v4l-dvb: add and use poll_requested_events()
 function
References: <201107171319.48483.hverkuil@xs4all.nl>
In-Reply-To: <201107171319.48483.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 17-07-2011 08:19, Hans Verkuil escreveu:
> Hi Mauro,
> 
> This patch series adds the poll_requested_events() function and uses it in
> the V4L2 core and the ivtv driver.
> 
> The poll patch is unchanged from the RFCv3 patch posted a week ago and the
> other patches are unchanged from the RFCv1 patch series posted last Wednesday
> on the linux-media list.
> 
> Tested with vivi and ivtv.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit bec969c908bb22931fd5ab8ecdf99de8702a6a31:
> 
>   [media] v4l: s5p-tv: add TV Mixer driver for Samsung S5P platform (2011-07-14 13:09:48 -0300)
> 
> are available in the git repository at:
>   ssh://linuxtv.org/git/hverkuil/media_tree.git poll
> 
> Hans Verkuil (6):
>       poll: add poll_requested_events() function
>       ivtv: only start streaming in poll() if polling for input.
>       videobuf2: only start streaming in poll() if so requested by the poll mask.
>       videobuf: only start streaming in poll() if so requested by the poll mask.
>       videobuf2-core: also test for pending events.
>       vivi: let vb2_poll handle events.
> 
>  drivers/media/video/ivtv/ivtv-fileops.c |    6 ++-
>  drivers/media/video/videobuf-core.c     |    3 +-
>  drivers/media/video/videobuf2-core.c    |   48 +++++++++++++++++++++---------
>  drivers/media/video/vivi.c              |    9 +-----
>  fs/eventpoll.c                          |   19 +++++++++--
>  fs/select.c                             |   38 +++++++++++-------------
>  include/linux/poll.h                    |    7 ++++-
>  7 files changed, 78 insertions(+), 52 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I don't like the idea of merging the first patch directly on my tree, without
the vfs maintainer ack.

The better would be if Alexander could merge it, or give his ack on it.
Alternatively, if he is not maintaining it anymore, then maybe Andrew
can help us.

Thanks!
Mauro

-

From: Hans Verkuil <hans.verkuil@cisco.com>
Subject: poll: add poll_requested_events() function

In some cases the poll() implementation in a driver has to do different
things depending on the events the caller wants to poll for. An example is
when a driver needs to start a DMA engine if the caller polls for POLLIN,
but doesn't want to do that if POLLIN is not requested but instead only
POLLOUT or POLLPRI is requested. This is something that can happen in the
video4linux subsystem.

Unfortunately, the current epoll/poll/select implementation doesn't provide
that information reliably. The poll_table_struct does have it: it has a key
field with the event mask. But once a poll() call matches one or more bits
of that mask any following poll() calls are passed a NULL poll_table_struct
pointer.

The solution is to set the qproc field to NULL in poll_table_struct once
poll() matches the events, not the poll_table_struct pointer itself. That
way drivers can obtain the mask through a new poll_requested_events inline.

The poll_table_struct can still be NULL since some kernel code calls it
internally (netfs_state_poll() in ./drivers/staging/pohmelfs/netfs.h). In
that case poll_requested_events() returns ~0 (i.e. all events).

Since eventpoll always leaves the key field at ~0 instead of using the
requested events mask, that source was changed as well to properly fill in
the key field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 fs/eventpoll.c       |   19 +++++++++++++++----
 fs/select.c          |   38 +++++++++++++++++---------------------
 include/linux/poll.h |    7 ++++++-
 3 files changed, 38 insertions(+), 26 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index f9cfd16..6a54a69 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -650,9 +650,12 @@ static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
 			       void *priv)
 {
 	struct epitem *epi, *tmp;
+	poll_table pt;
 
+	init_poll_funcptr(&pt, NULL);
 	list_for_each_entry_safe(epi, tmp, head, rdllink) {
-		if (epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
+		pt.key = epi->event.events;
+		if (epi->ffd.file->f_op->poll(epi->ffd.file, &pt) &
 		    epi->event.events)
 			return POLLIN | POLLRDNORM;
 		else {
@@ -946,6 +949,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	/* Initialize the poll table using the queue callback */
 	epq.epi = epi;
 	init_poll_funcptr(&epq.pt, ep_ptable_queue_proc);
+	epq.pt.key = event->events;
 
 	/*
 	 * Attach the item to the poll hooks and get current event bits.
@@ -1027,20 +1031,23 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 {
 	int pwake = 0;
 	unsigned int revents;
+	poll_table pt;
+
+	init_poll_funcptr(&pt, NULL);
 
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
@@ -1075,6 +1082,9 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 	unsigned int revents;
 	struct epitem *epi;
 	struct epoll_event __user *uevent;
+	poll_table pt;
+
+	init_poll_funcptr(&pt, NULL);
 
 	/*
 	 * We can loop without lock because we are passed a task private list.
@@ -1087,7 +1097,8 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 
 		list_del_init(&epi->rdllink);
 
-		revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
+		pt.key = epi->event.events;
+		revents = epi->ffd.file->f_op->poll(epi->ffd.file, &pt) &
 			epi->event.events;
 
 		/*
diff --git a/fs/select.c b/fs/select.c
index d33418f..b6765cf 100644
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
@@ -720,7 +718,7 @@ struct poll_list {
  * interested in events matching the pollfd->events mask, and the result
  * matching that mask is both recorded in pollfd->revents and returned. The
  * pwait poll_table will be used by the fd-provided poll handler for waiting,
- * if non-NULL.
+ * if pwait->qproc is non-NULL.
  */
 static inline unsigned int do_pollfd(struct pollfd *pollfd, poll_table *pwait)
 {
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
 
@@ -781,22 +777,22 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
 			for (; pfd != pfd_end; pfd++) {
 				/*
 				 * Fish for events. If we found one, record it
-				 * and kill the poll_table, so we don't
+				 * and kill poll_table->qproc, so we don't
 				 * needlessly register any other waiters after
 				 * this. They'll get immediately deregistered
 				 * when we break out and return.
 				 */
 				if (do_pollfd(pfd, pt)) {
 					count++;
-					pt = NULL;
+					pt->qproc = NULL;
 				}
 			}
 		}
 		/*
 		 * All waiters have already been registered, so don't provide
-		 * a poll_table to them on the next loop iteration.
+		 * a poll_table->qproc to them on the next loop iteration.
 		 */
-		pt = NULL;
+		pt->qproc = NULL;
 		if (!count) {
 			count = wait->error;
 			if (signal_pending(current))
diff --git a/include/linux/poll.h b/include/linux/poll.h
index cf40010..fe1e360 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -39,10 +39,15 @@ typedef struct poll_table_struct {
 
 static inline void poll_wait(struct file * filp, wait_queue_head_t * wait_address, poll_table *p)
 {
-	if (p && wait_address)
+	if (p && p->qproc && wait_address)
 		p->qproc(filp, wait_address, p);
 }
 
+static inline unsigned long poll_requested_events(const poll_table *p)
+{
+	return p ? p->key : ~0UL;
+}
+
 static inline void init_poll_funcptr(poll_table *pt, poll_queue_proc qproc)
 {
 	pt->qproc = qproc;
-- 
1.7.1
