Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:15861 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbaAHOm3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 09:42:29 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ3001FZ7IPQG30@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jan 2014 14:42:25 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'randy' <lxr1234@hotmail.com>, linux-media@vger.kernel.org
References: <BLU0-SMTP32889EC1B64B13894EE7C90ADCB0@phx.gbl>
 <02c701cf07b6$565cd340$031679c0$%debski@samsung.com>
 <BLU0-SMTP266BE9BC66B254061740251ADCB0@phx.gbl>
 <02c801cf07ba$8518f2f0$8f4ad8d0$%debski@samsung.com>
 <BLU0-SMTP150C8C0DB0E9A3A9F4104F8ADCA0@phx.gbl>
In-reply-to: <BLU0-SMTP150C8C0DB0E9A3A9F4104F8ADCA0@phx.gbl>
Subject: RE: using MFC memory to memery encoder,
 start stream and queue order problem
Date: Wed, 08 Jan 2014 15:42:26 +0100
Message-id: <04b601cf0c7f$d9e531d0$8daf9570$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Randy,

> From: randy [mailto:lxr1234@hotmail.com]
> Sent: Friday, January 03, 2014 4:17 PM
> 
> I rewrite my program, it takes the order as below 1.request buffer.
> 2.mmap input buffer with OUTPUT
> 3.output buffer with CAPTURE.
> 4.filled input buffer with the first frame.
> 5.enqueue the first frame in the input buffer in OUTPUT side 6.enqueue
> the output buffer in CAPTURE side 7.start stream 8.dequeue CAPTURE
> buffer and make output buffer pointer to data of it.
> 9.get output data from output buffer
> /* the buffer get size is 22 below */
> 10.dequeue OUTPUT
> /* timed out, it will never end */
> Is there any problem with the order? I don't do any thing
> simultaneously below, it seems to difficult to me to understand and not
> easy to debug.
> I am not sure whether the mmap is correct, but I think it it as I don't
> get segment fault.

Please have a look at the V4L2_CID_MPEG_VIDEO_HEADER_MODE control.
>From your description it seems that it is in its default state - 
V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE. This means that the header for a
newly encoded stream is returned after init. Then in another buffer you will
find the encoded picture.

So after point 9 please enqueue the CAPTURE buffer again and see what
happens. I think that you should get the first frame encoded.

You can also try to set the V4L2_CID_MPEG_VIDEO_HEADER_MODE control to
V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME and see if it works.
(instead of enqueueing the CAPTURE buffer again after receiving the header).

In addition I would recommend you to use more than one buffer per queue.
 
> 
> And the thing in the next is like this I think 11.filled input buffer
> with the next frame 12.enqueue the next frame in the input buffer in
> OUTPUT side 13.dequeue CAPTURE buffer and make output buffer pointer to
> data of it.
> 14.dequeue OUTPUT
> goto 11
> Is it correct
> 
> I doubt the REAME
> 5. Request CAPTURE and OUTPUT buffers. Due to hardware limitations of
> MFC on
>    some platforms it is recommended to use V4L2_MEMORY_MMAP buffers.
> 6. Enqueue CAPTURE buffers.
> 7. Enqueue OUTPUT buffer with first frame.
> 8. Start streaming (VIDIOC_STREAMON) on both ends.
> 9. Simultaneously:
> I don't need to dequeue the OUTPUT buffer which is with first frame?
>    - enqueue buffers with next frames,
>    - dequeue used OUTPUT buffers (blocking operation),
>    - dequeue buffers with encoded stream (blocking operation),
>    - enqueue free CAPTURE buffers.
> 
> 
> 							Thank you.

Best wishes,
Kamil

