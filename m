Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n68FvTZD021839
	for <video4linux-list@redhat.com>; Wed, 8 Jul 2009 11:57:29 -0400
Received: from mail-qy0-f201.google.com (mail-qy0-f201.google.com
	[209.85.221.201])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n68FvAfv022472
	for <video4linux-list@redhat.com>; Wed, 8 Jul 2009 11:57:10 -0400
Received: by qyk39 with SMTP id 39so2286631qyk.23
	for <video4linux-list@redhat.com>; Wed, 08 Jul 2009 08:57:09 -0700 (PDT)
From: Lamarque Vieira Souza <lamarque@gmail.com>
To: video4linux-list@redhat.com
Date: Wed, 8 Jul 2009 12:57:01 -0300
References: <3a9b62b20907062344p56d1ecafsbbb936c74eadfd43@mail.gmail.com>
In-Reply-To: <3a9b62b20907062344p56d1ecafsbbb936c74eadfd43@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200907081257.02308.lamarque@gmail.com>
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Re: how to make qbuf
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

Em Tuesday 07 July 2009, 서정민 escreveu:
> Hi.

	Hi,

> I'm making V4l2 device driver for mplayer.

	mplayer already implements v4l2 specification, you do not need to implement a 
driver for it.

> But
> It's too difficult to understand V4l2 driver internal structure.
>
> I can't understand how to use VIDIOC_QBUF, VIDIOC_DQBUF ioctl and 'struct
> videobuf_queue'

	VIDIOC_QBUF queues a buffer (struct v4l2_buffer) to a buffer list managed by 
the device driver (usually a kernel module). The driver fills the buffer with 
needed information (image data, compression type, etc) and the application 
must use VIDIOC_DQBUF to get the filled buffer from the device driver's buffer 
list. Applications, such as mplayer must use VIDIOC_QBUF and VIDIOC_DQBUF. 
videobuf_queue is used by the device driver (kernel space) to manage the 
buffer list. If you are creating/changing an application (mplayer) you do not 
need to know about videobuf_queue. If you are creating a device driver for a 
capture device (webcam, etc) in kernel space then using videobuf_queue will 
make your life easier.

> Why does v4l2 driver need to use 'videobuf_queue'?

	videobuf_queue is not mandatory but it will make it easier to manage video 
frames and implement some needed ioctls in the device driver. 

> Please. tell me v4l2 driver internal operation.

	You can read more bout v4l2 here http://v4l2spec.bytesex.org/spec-
single/v4l2.html

> Thanks.
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


-- 
Lamarque V. Souza
http://www.geographicguide.com/brazil.htm
Linux User #57137 - http://counter.li.org/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
