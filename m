Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBUI53oC003758
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 13:05:03 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.231])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBUI4js7011657
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 13:04:45 -0500
Received: by rv-out-0506.google.com with SMTP id f6so5558709rvb.51
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 10:04:44 -0800 (PST)
Message-ID: <fb249edb0812301004t3cb4538bjb2324819922d5580@mail.gmail.com>
Date: Tue, 30 Dec 2008 19:04:44 +0100
From: "andrzej zaborowski" <balrogg@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <fb249edb0812292108x7286207ar84886e998348d8d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fb249edb0812292050s2e3e46a0u8588d79cf3cf858e@mail.gmail.com>
	<fb249edb0812292056u32019ddbt4dc29de03a938368@mail.gmail.com>
	<fb249edb0812292108x7286207ar84886e998348d8d1@mail.gmail.com>
Subject: V4L2 Bug and/or Bad Docs for VIDIOC_REQBUFS ioctl()
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

[Resending the message because I wasn't subscribed before, hopefully
it doesn't come doubled now.  It's forwarded from a coder who wants to
be anonymous]

The documentation at:

 http://v4l2spec.bytesex.org/spec-single/v4l2.html#VIDIOC-REQBUFS

says that the VIDIOC_REQBUFS ioctl(), used to initiate memory mapping
or user pointer i/o on V4L2 devices, returns a 0 upon success, or a -1
on error, and sets errno to either EBUSY or EINVAL. The code, however,
does not follow this logic.

In /usr/src/linux/drivers/media/video/videobuf-core.c, in the function

 int videobuf_reqbufs(struct videobuf_queue *q, \
                    struct v4l2_requestbuffers *req);

If an error occours, "return -EINVAL" is called. If an error does not
occour, execution reaches the following statement:

 retval = __videobuf_mmap_setup(q, count, size, req->memory);

followed by:

 req->count = retval;

and:

 return retval;

So, the value being returned, upon success, is the value returned from
the call to __videobuf_mmap_setup(). Looking inside the code for this
function, the buffers are setup inside a for() loop, and the last value
of "i" used as a counter for that loop is returned. In other words, the
buffers allocated count is returned.

So, is the documentation wrong ? or is the code wrong ?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
