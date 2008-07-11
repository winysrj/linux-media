Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6BK5gmR026134
	for <video4linux-list@redhat.com>; Fri, 11 Jul 2008 16:05:42 -0400
Received: from vsmtp12.tin.it (vsmtp12.tin.it [212.216.176.206])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6BK56kG027181
	for <video4linux-list@redhat.com>; Fri, 11 Jul 2008 16:05:17 -0400
Message-ID: <4877BC87.50801@tiscali.it>
Date: Fri, 11 Jul 2008 21:03:19 +0100
From: Andrea <audetto@tiscali.it>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
References: <4873CBA9.1090603@tiscali.it>
	<4873E6D0.8050202@tiscali.it>	<487678F6.50609@tiscali.it>
	<1215761512.1679.17.camel@localhost>
In-Reply-To: <1215761512.1679.17.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

Jean-Francois Moine wrote:
> On Thu, 2008-07-10 at 22:02 +0100, Andrea wrote:
>> Is there anybody who could help my with the followin?
> 
> Not sure, but I'll try.
> 
>> I would like to know if my interpretation of VIDIOC_DQBUF is correct.
> 	[snip]
>>>> - First, an application queues a buffer, then it dequeues the buffer.
>>>> - Then again, a buffer is queued and then dequeued.
>>>> - Dequeuing a buffer blocks is the buffer is not ready (unless device 
>>>> opened with O_NONBLOCK).
> 
> DQBUF blocks if _no_ buffer is ready.

I think there is (should be) a difference between (but it is not 100% clear on documentation):

1) buffers in the queue, but not yet ready
2) no buffer in the queue

In the second case, all drivers I can try (em28xx, uvc, vivi) return -EINVAL. Only pwc blocks.
This is easy tested with mplayer

mplayer -tv driver=v4l2:device=/dev/videoXXX tv://

If it hangs on quit (IMHO wrong), then the driver blocks; if it ends normally (IMHO correct), the 
driver returns -EINVAL.

> 
>>>> - Trying to dequeue a buffer without queuing it first is an error, and 
>>>> the ioctl VIDIOC_DQBUF should return -EINVAL.
> 
> You do not set a specific buffer at DQBUF call.

You are right.

> 
>>> - One can only VIDIOC_DQBUF after calling STREAMON. Before it should 
>>> return -EINVAL? Block?
> 
> No, STREAMON may be done later by an other application.

Again, I agree with you. It is not a matter of "before or after", but if there are buffers in the 
queue (regardless of the fact if they are ready)

> 
>>> - After calling STREAMOFF, VIDIOC_DQBUF should return -EINVAL
> 
> No, same reason as above.

Again, I am not yet sure.
IMHO: Immediately after STREAMOFF (which clears the queue) it should be -EINVAL.
In case buffer are requeued, then it blocks.

> 
>>>> Now, about pwc: (if the above is correct).
>>>>
>>>> 1) VIDIOC_DQBUF blocks always until a buffer is ready, regardless of 
>>>> O_NONBLOCK.
> 
> Oh, bad guy!
> 
>>>> 2) VIDIOC_DQBUF does not check if a buffer has been previously queued. 
>>>> Moreover VIDIOC_QBUF is almost a no-op. It has no way to check if a 
>>>> buffer has been queued before VIDIOC_DQBUF.
> 
> Seems normal.

IMHO it should check the queue. What happens if it picks a buffer that it still being used by the my 
application (which did not QBUF it)?

> 
>>>> If I have understood correctly (very unlikely), this is the reason why 
>>>> mplayer hangs while stopping the stream with pwc:
>>>>
>>>>         while (!ioctl(priv->video_fd, VIDIOC_DQBUF, &buf));
>>>>
>>> This code is not needed because STREAMOFF flushes the buffer queue. Does 
>>> it not?
> 
> Correct.

Agree.

> 
>>>> This code should eventually return -EINVAL, while pwc just blocks 
>>>> waiting for the next buffer (which never arrives because 
>>>> VIDIOC_STREAMOFF has been called).
>>> pwc should return -EINVAL to all ioctl calls after STREAMOFF?
> 
> No.

In that case the drivers "em28xx", "vivi", "uvc" (and all the ones that work with mplayer) are all 
wrong.

> 
>>> Could someone please tell me where I am right and where I am wrong...
> 
> Done.
> 
> It was a good idea to point me on these problems. I will update the
> gspca driver accordingly.


It seems to be a very corner-case of the documentation. And usually tests are done to check when it 
should work, not when and how it should fail.

Andrea

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
