Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6BJJpa5029882
	for <video4linux-list@redhat.com>; Fri, 11 Jul 2008 15:19:51 -0400
Received: from vsmtp3.tin.it (vsmtp3.tin.it [212.216.176.223])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6BJJd1c031547
	for <video4linux-list@redhat.com>; Fri, 11 Jul 2008 15:19:39 -0400
Message-ID: <4877B1E0.70406@tiscali.it>
Date: Fri, 11 Jul 2008 20:17:52 +0100
From: Andrea <audetto@tiscali.it>
MIME-Version: 1.0
To: Aidan Thornton <makosoft@googlemail.com>
References: <4873CBA9.1090603@tiscali.it>
	<c8b4dbe10807090704t4e98b8cu253fab39a9dd81d@mail.gmail.com>
In-Reply-To: <c8b4dbe10807090704t4e98b8cu253fab39a9dd81d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

Aidan Thornton wrote:
> Hi,
>
> On 7/8/08, Andrea <audetto@tiscali.it> wrote:
>   
>> - Trying to dequeue a buffer without queuing it first is an error, and the
>> ioctl VIDIOC_DQBUF should 
>> return -EINVAL.
>>     
>
> Not sure; as far as I can tell, calling VIDIOC_DQBUF with no buffers queued is allowed, and the videobuf code has an explicit case to handle this, by waiting until a buffer is queued.
>
>   

Basically, what I see a correct behviour (so far) is:

QBUF queues a buffer (counter++)
DQBUF dequeues a buffer (counter--)
STRAMOFF removes all buffers (couter = 0)

If at any time DQBUF is called and the counter is 0, it should return 
EINVAL. Otherwise, if a buffer is available but not yet ready, it should 
block.

>> <- end of question ->
>>
>> Now, about pwc: (if the above is correct).
>>
>> 1) VIDIOC_DQBUF blocks always until a buffer is ready, regardless of
>> O_NONBLOCK.
>> 2) VIDIOC_DQBUF does not check if a buffer has been previously queued.
>> Moreover VIDIOC_QBUF is 
>> almost a no-op. It has no way to check if a buffer has been queued before
>> VIDIOC_DQBUF.
>>     
>
> I doubt VIDIOC_QBUF is a no-op, unless the driver is seriously broken; it's supposed to hand the buffer back to the driver for it to put data in.
>
>   

This is the code of VIDIOC_QBUF in pwc:

        case VIDIOC_QBUF:
        {
            struct v4l2_buffer *buf = arg;

            PWC_DEBUG_IOCTL("ioctl(VIDIOC_QBUF) index=%d\n",buf->index);
            if (buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
                return -EINVAL;
            if (buf->memory != V4L2_MEMORY_MMAP)
                return -EINVAL;
            if (buf->index < 0 || buf->index >= pwc_mbufs)
                return -EINVAL;

            buf->flags |= V4L2_BUF_FLAG_QUEUED;
            buf->flags &= ~V4L2_BUF_FLAG_DONE;

            return 0;
        }

It does not do anything.


>> If I have understood correctly (very unlikely), this is the reason why
>> mplayer hangs while stopping 
>> the stream with pwc:
>>
>> 		while (!ioctl(priv->video_fd, VIDIOC_DQBUF, &buf));
>>
>> This code should eventually return -EINVAL, while pwc just blocks waiting
>> for the next buffer (which 
>> never arrives because VIDIOC_STREAMOFF has been called).
>>     
>
> Hmmm... not sure about the interaction of STREAMOFF and DQBUF. I'm guessing the DQBUF should fail and return -EINVAL, though. (It certainly shouldn't succeed; the buffer queues are meant to be flushed by STREAMOFF, so there shouldn't be anything to dequeue.)
>
>   
Agreed. Unless one requeues after calling STREAMOFF.

Andrea

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
