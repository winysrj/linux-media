Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:31319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab0IUNlG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Sep 2010 09:41:06 -0400
Message-ID: <4C98B5E3.9010008@redhat.com>
Date: Tue, 21 Sep 2010 10:40:51 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCHES] First version of the V4L2 core locking patches
References: <201009202337.01948.hverkuil@xs4all.nl>
In-Reply-To: <201009202337.01948.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 20-09-2010 18:37, Hans Verkuil escreveu:
> Hi all,
> 
> I've made a first version of the core locking patches available here:
> 
> http://git.linuxtv.org/hverkuil/v4l-dvb.git?a=shortlog;h=refs/heads/test
> 
> I'm actually surprised how trivial the patches are. Which makes me wonder if
> I am overlooking something, it feels too easy.
> 
> One thing I did not yet have time to analyze fully is if it is really OK to
> unlock/relock the vdev_lock in videobuf_waiton. I hope it is, because without
> this another thread will find it impossible to access the video node while it
> is in waiton.
> 
> Currently I've only tested with vivi. I hope to be able to spend more time
> this week for a more thorough analysis and converting a few more drivers to
> this.
> 
> In the meantime, please feel free to shoot at this code!

Hi Hans,

This patch will likely break most drivers:
	http://git.linuxtv.org/hverkuil/v4l-dvb.git?a=commitdiff;h=d1ca35f3e69d909a958eb1cf8c75dd1c0bb2a98c

In the case of events and videobuf_waiton, it doesn't seem to be safe to just
unlock when waiting for an event.

For example, in the case of videobuf_waiton, the code for it is:

#define WAITON_CONDITION (vb->state != VIDEOBUF_ACTIVE &&\
				vb->state != VIDEOBUF_QUEUED)
int videobuf_waiton(struct videobuf_buffer *vb, int non_blocking, int intr)
{
	MAGIC_CHECK(vb->magic, MAGIC_BUFFER);

	if (non_blocking) {
		if (WAITON_CONDITION)
			return 0;
		else
			return -EAGAIN;
	}

	if (intr)
		return wait_event_interruptible(vb->done, WAITON_CONDITION);
	else
		wait_event(vb->done, WAITON_CONDITION);

	return 0;
}

When called internally, it have the vb mutex_locked, while, when called externally, it
doesn't.

By looking on other parts where vb->done is protected, like on videobuf_queue_cancel:

	spin_lock_irqsave(q->irqlock, flags);
	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
		if (NULL == q->bufs[i])
			continue;
		if (q->bufs[i]->state == VIDEOBUF_QUEUED) {
			list_del(&q->bufs[i]->queue);
			q->bufs[i]->state = VIDEOBUF_ERROR;
			wake_up_all(&q->bufs[i]->done);
		}
	}
	spin_unlock_irqrestore(q->irqlock, flags);

It is clear that vb state is protected by a spinlock, and not by a mutex. Using a mutex
there makes no sense at all. Instead of touching a mutex, callers of this function should
be reviewed to not call a mutex.

So, the better approach for videobuf_waiton would be to protect it with a
spinlock.

Also, your patches assume that no driver will touch at vdev lock before calling videobuf_waiton().
This seems to be a risky assumption. So, the better would be to define it as:

static int is_state_active_or_queued(struct videobuf_buffer *vb, struct videobuf_queue *q, )
{
	bool rc;

	spin_lock_irqsave(q->irqlock, flags);
	rc = (vb->state != VIDEOBUF_ACTIVE) && (vb->state != VIDEOBUF_QUEUED));
	spin_unlock_irqrestore(q->irqlock, flags);

	return rc;
};

int videobuf_waiton(struct videobuf_queue *q, struct videobuf_buffer *vb, int non_blocking, int intr)
{
	rc = 0;
 	bool is_vdev_locked;
	MAGIC_CHECK(vb->magic, MAGIC_BUFFER);

	/*
	 * If there's nothing to wait, just return		
	 */
	if (is_state_active_or_queued(vb, q))
		return 0;

	if (non_blocking)
		return -EAGAIN;

	/*
	 * Need to sleep in order to wait for videobufs to complete.
	 * It is not a good idea to sleep while waiting for an event with the dev lock hold,
	 * as it will block any other access to the device. Just unlock it while waiting,
	 * locking it again at the end.
	 */

 	is_vdev_locked = (q->vdev_lock && mutex_is_locked(q->vdev_lock)) ? true : false;
	if (is_vdev_locked)
		mutex_unlock(q->vdev_lock);
	if (intr)
		return wait_event_interruptible(vb->done, is_state_active_or_queued(vb, q));
	else
		wait_event(vb->done, is_state_active_or_queued(vb, q));
	if (is_vdev_locked)
		mutex_lock(q->vdev_lock);

	return 0;
}

Cheers,
Mauro
