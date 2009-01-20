Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0K9RbTZ010715
	for <video4linux-list@redhat.com>; Tue, 20 Jan 2009 04:27:37 -0500
Received: from co203.xi-lite.net (co203.xi-lite.net [149.6.83.203])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0K9RCNA000764
	for <video4linux-list@redhat.com>; Tue, 20 Jan 2009 04:27:13 -0500
Message-ID: <497598ED.3050502@parrot.com>
Date: Tue, 20 Jan 2009 10:27:09 +0100
From: Matthieu CASTET <matthieu.castet@parrot.com>
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
References: <497487F2.7070400@parrot.com>
	<aec7e5c30901192046j1a595day51da698181d034e5@mail.gmail.com>
In-Reply-To: <aec7e5c30901192046j1a595day51da698181d034e5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: soc-camera : sh_mobile_ceu_camera race on free_buffer ?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Magnus,

Magnus Damm a écrit :
> Hi Matthieu,
> 
> On Mon, Jan 19, 2009 at 11:02 PM, Matthieu CASTET
>> But we didn't do stop_capture, so as far I understand the controller is
>> still writing data in memory. What prevent us to free the buffer we are
>> writing.
> 
> I have not looked into this in great detail, but isn't this handled by
> the videobuf state? The videobuf has state VIDEOBUF_ACTIVE while it is
> in use. I don't think such a buffer is freed.
Well from my understanding form videobuf_queue_cancel [1], we call
buf_release on all buffer.

>> I saw that pxa_camera use videobuf_waiton, before freeing the buffer.
>> That seem more safe, but that mean we need to wait that controller
>> finish to write all the pending buffer.
> 
> Hm, but vivi.c does not use videbuf_waiton(). I guess this depends on
> how the frames are queued in the driver.
May be.

Matthieu


[1]
void videobuf_queue_cancel(struct videobuf_queue *q)
{
	unsigned long flags = 0;
	int i;

	q->streaming = 0;
	q->reading  = 0;
	wake_up_interruptible_sync(&q->wait);

	/* remove queued buffers from list */
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

	/* free all buffers + clear queue */
	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
		if (NULL == q->bufs[i])
			continue;
		q->ops->buf_release(q, q->bufs[i]);
	}
	INIT_LIST_HEAD(&q->stream);
}

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
