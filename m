Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m68KKeX4017264
	for <video4linux-list@redhat.com>; Tue, 8 Jul 2008 16:20:40 -0400
Received: from vsmtp2.tin.it (vsmtp2.tin.it [212.216.176.222])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m68KKQxT013989
	for <video4linux-list@redhat.com>; Tue, 8 Jul 2008 16:20:27 -0400
Received: from [192.168.3.11] (77.103.126.124) by vsmtp2.tin.it (8.0.016.5)
	(authenticated as aodetti@tin.it)
	id 48639F8F00BF10D8 for video4linux-list@redhat.com;
	Tue, 8 Jul 2008 22:20:20 +0200
Message-ID: <4873CBA9.1090603@tiscali.it>
Date: Tue, 08 Jul 2008 21:18:49 +0100
From: Andrea <audetto@tiscali.it>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: A question about VIDIOC_DQBUF
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

Hi,

I would like to understand better the way VIDIOC_DQBUF works.

I've read the documentation at
http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec/r8849.htm

and some tutorial at
http://lwn.net/Articles/240667/

I'm trying to check the implementation of pwc of the 2 ioctl VIDIOC_DQBUF and VIDIOC_QBUF.

Is the following correct?

- First, an application queues a buffer, then it dequeues the buffer.
- Then again, a buffer is queued and then dequeued.
- Dequeuing a buffer blocks is the buffer is not ready (unless device opened with O_NONBLOCK).
- Trying to dequeue a buffer without queuing it first is an error, and the ioctl VIDIOC_DQBUF should 
return -EINVAL.

<- end of question ->

Now, about pwc: (if the above is correct).

1) VIDIOC_DQBUF blocks always until a buffer is ready, regardless of O_NONBLOCK.
2) VIDIOC_DQBUF does not check if a buffer has been previously queued. Moreover VIDIOC_QBUF is 
almost a no-op. It has no way to check if a buffer has been queued before VIDIOC_DQBUF.

If I have understood correctly (very unlikely), this is the reason why mplayer hangs while stopping 
the stream with pwc:

		while (!ioctl(priv->video_fd, VIDIOC_DQBUF, &buf));

This code should eventually return -EINVAL, while pwc just blocks waiting for the next buffer (which 
never arrives because VIDIOC_STREAMOFF has been called).

I've read that video-buf should simplify the handling of buffers. Should I try it?

Andrea

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
