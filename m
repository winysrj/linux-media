Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6B7jcu1003323
	for <video4linux-list@redhat.com>; Fri, 11 Jul 2008 03:45:38 -0400
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6B7jQGc027397
	for <video4linux-list@redhat.com>; Fri, 11 Jul 2008 03:45:26 -0400
From: Jean-Francois Moine <moinejf@free.fr>
To: Andrea <audetto@tiscali.it>
In-Reply-To: <487678F6.50609@tiscali.it>
References: <4873CBA9.1090603@tiscali.it> <4873E6D0.8050202@tiscali.it>
	<487678F6.50609@tiscali.it>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 11 Jul 2008 09:31:52 +0200
Message-Id: <1215761512.1679.17.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: A question about VIDIOC_DQBUF
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

On Thu, 2008-07-10 at 22:02 +0100, Andrea wrote:
> Is there anybody who could help my with the followin?

Not sure, but I'll try.

> I would like to know if my interpretation of VIDIOC_DQBUF is correct.
	[snip]
> >> - First, an application queues a buffer, then it dequeues the buffer.
> >> - Then again, a buffer is queued and then dequeued.
> >> - Dequeuing a buffer blocks is the buffer is not ready (unless device 
> >> opened with O_NONBLOCK).

DQBUF blocks if _no_ buffer is ready.

> >> - Trying to dequeue a buffer without queuing it first is an error, and 
> >> the ioctl VIDIOC_DQBUF should return -EINVAL.

You do not set a specific buffer at DQBUF call.

> > - One can only VIDIOC_DQBUF after calling STREAMON. Before it should 
> > return -EINVAL? Block?

No, STREAMON may be done later by an other application.

> > - After calling STREAMOFF, VIDIOC_DQBUF should return -EINVAL

No, same reason as above.

> >> Now, about pwc: (if the above is correct).
> >>
> >> 1) VIDIOC_DQBUF blocks always until a buffer is ready, regardless of 
> >> O_NONBLOCK.

Oh, bad guy!

> >> 2) VIDIOC_DQBUF does not check if a buffer has been previously queued. 
> >> Moreover VIDIOC_QBUF is almost a no-op. It has no way to check if a 
> >> buffer has been queued before VIDIOC_DQBUF.

Seems normal.

> >> If I have understood correctly (very unlikely), this is the reason why 
> >> mplayer hangs while stopping the stream with pwc:
> >>
> >>         while (!ioctl(priv->video_fd, VIDIOC_DQBUF, &buf));
> >>
> > 
> > This code is not needed because STREAMOFF flushes the buffer queue. Does 
> > it not?

Correct.

> >> This code should eventually return -EINVAL, while pwc just blocks 
> >> waiting for the next buffer (which never arrives because 
> >> VIDIOC_STREAMOFF has been called).
> > 
> > pwc should return -EINVAL to all ioctl calls after STREAMOFF?

No.

> > Could someone please tell me where I am right and where I am wrong...

Done.

It was a good idea to point me on these problems. I will update the
gspca driver accordingly.

Thank you.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
