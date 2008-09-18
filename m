Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8I79XjK029120
	for <video4linux-list@redhat.com>; Thu, 18 Sep 2008 03:09:34 -0400
Received: from smtp-vbr10.xs4all.nl (smtp-vbr10.xs4all.nl [194.109.24.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8I79KgZ009904
	for <video4linux-list@redhat.com>; Thu, 18 Sep 2008 03:09:20 -0400
Received: from webmail.xs4all.nl (dovemail5.xs4all.nl [194.109.26.7])
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id m8I79Jwg030501
	for <video4linux-list@redhat.com>;
	Thu, 18 Sep 2008 09:09:19 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Message-ID: <14856.208.252.119.63.1221721759.squirrel@webmail.xs4all.nl>
Date: Thu, 18 Sep 2008 09:09:19 +0200 (CEST)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: Sliced VBI Capture with Memory Mapped Buffers
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

> Hi All,
>
> I want to capture Sliced VBI data using the Memory mapped buffer exchange
> mechanism with the device node same as that of video capture. The problem
> is how to distinguish between video buffer and sliced vbi buffer when
> mapping them since mmap system call takes buffer offset as the argument
> and querybuf ioclt always provides me the buffer offset starting from 0 so
> the offset of the first buffer of both video data and sliced vbi data is
> 0. It looks like i have to create separate device node for the vbi data.

That's correct. You have to create a vbi device for that.

> Is there any other way out?

No. VBI is always a separate stream from video.

> Is there any way i can synchronize the sliced
> vbi data with the video data?

Both buffers have timestamps, so that's the way you would synchronize
them. In practice, though, you can usually safely assume that both video
and vbi arrive at the same time.

Are you aware of the sliced VBI support that's in the V4L2 API?

http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html#SLICED

Just making sure that you know about this :-)

Regards,

        Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
