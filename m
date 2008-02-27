Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1RKANQ3016740
	for <video4linux-list@redhat.com>; Wed, 27 Feb 2008 15:10:23 -0500
Received: from mail6.sea5.speakeasy.net (mail6.sea5.speakeasy.net
	[69.17.117.8])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1RK9pg5012159
	for <video4linux-list@redhat.com>; Wed, 27 Feb 2008 15:09:51 -0500
Date: Wed, 27 Feb 2008 12:09:44 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Brandon Philips <brandon@ifup.org>
In-Reply-To: <54fa1a0d9c5bcdfcb2ba.1204098881@localhost>
Message-ID: <Pine.LNX.4.58.0802271207300.14140@shell4.speakeasy.net>
References: <54fa1a0d9c5bcdfcb2ba.1204098881@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	mchehab@infradead.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] v4l: Deadlock in videobuf-core for
 DQBUF waiting on QBUF
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

On Tue, 26 Feb 2008, Brandon Philips wrote:
> v4l: Deadlock in videobuf-core for DQBUF waiting on QBUF
>
> Avoid a deadlock where DQBUF is holding the vb_lock while waiting on a QBUF
> which also needs the vb_lock.  Reported by Hans Verkuil <hverkuil@xs4all.nl>.
>
>  	buf = list_entry(q->stream.next, struct videobuf_buffer, stream);
> +	mutex_unlock(&q->vb_lock);
>  	retval = videobuf_waiton(buf, nonblocking, 1);
> +	mutex_lock(&q->vb_lock);

Does this create a race condition in videobuf_waiton?  It seems like the
stuff done there with buf would have races with any other thread trying to
access buf at the same time.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
