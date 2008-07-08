Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m68MGUbH026067
	for <video4linux-list@redhat.com>; Tue, 8 Jul 2008 18:16:30 -0400
Received: from vsmtp3.tin.it (vsmtp3.tin.it [212.216.176.223])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m68MGIhM011375
	for <video4linux-list@redhat.com>; Tue, 8 Jul 2008 18:16:19 -0400
Received: from [192.168.3.11] (77.103.126.124) by vsmtp3.tin.it (8.0.016.5)
	(authenticated as aodetti@tin.it)
	id 4856608C0141A7DE for video4linux-list@redhat.com;
	Wed, 9 Jul 2008 00:16:13 +0200
Message-ID: <4873E6D0.8050202@tiscali.it>
Date: Tue, 08 Jul 2008 23:14:40 +0100
From: Andrea <audetto@tiscali.it>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <4873CBA9.1090603@tiscali.it>
In-Reply-To: <4873CBA9.1090603@tiscali.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

Andrea wrote:
> Hi,
> 
> I would like to understand better the way VIDIOC_DQBUF works.
> 
...
> Is the following correct?
> 
> - First, an application queues a buffer, then it dequeues the buffer.
> - Then again, a buffer is queued and then dequeued.
> - Dequeuing a buffer blocks is the buffer is not ready (unless device 
> opened with O_NONBLOCK).
> - Trying to dequeue a buffer without queuing it first is an error, and 
> the ioctl VIDIOC_DQBUF should return -EINVAL.

Moreover:

- One can only VIDIOC_DQBUF after calling STREAMON. Before it should return -EINVAL? Block?
- After calling STREAMOFF, VIDIOC_DQBUF should return -EINVAL

> 
> <- end of question ->
> 
> Now, about pwc: (if the above is correct).
> 
> 1) VIDIOC_DQBUF blocks always until a buffer is ready, regardless of 
> O_NONBLOCK.
> 2) VIDIOC_DQBUF does not check if a buffer has been previously queued. 
> Moreover VIDIOC_QBUF is almost a no-op. It has no way to check if a 
> buffer has been queued before VIDIOC_DQBUF.
> 
> If I have understood correctly (very unlikely), this is the reason why 
> mplayer hangs while stopping the stream with pwc:
> 
>         while (!ioctl(priv->video_fd, VIDIOC_DQBUF, &buf));
> 

This code is not needed because STREAMOFF flushes the buffer queue. Does it not?

> This code should eventually return -EINVAL, while pwc just blocks 
> waiting for the next buffer (which never arrives because 
> VIDIOC_STREAMOFF has been called).

pwc should return -EINVAL to all ioctl calls after STREAMOFF?

Could someone please tell me where I am right and where I am wrong...

What is the reference implementation? vivi? em28xx?

Andrea

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
