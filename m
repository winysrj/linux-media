Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s5.blu0.hotmail.com ([65.55.111.80]:15472 "EHLO
	blu0-omc2-s5.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931AbaACPQ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jan 2014 10:16:57 -0500
Message-ID: <BLU0-SMTP150C8C0DB0E9A3A9F4104F8ADCA0@phx.gbl>
Date: Fri, 3 Jan 2014 23:16:52 +0800
From: randy <lxr1234@hotmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Kamil Debski <k.debski@samsung.com>
Subject: Re: using MFC memory to memery encoder, start stream and queue order
 problem
References: <BLU0-SMTP32889EC1B64B13894EE7C90ADCB0@phx.gbl> <02c701cf07b6$565cd340$031679c0$%debski@samsung.com> <BLU0-SMTP266BE9BC66B254061740251ADCB0@phx.gbl> <02c801cf07ba$8518f2f0$8f4ad8d0$%debski@samsung.com>
In-Reply-To: <02c801cf07ba$8518f2f0$8f4ad8d0$%debski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I rewrite my program, it takes the order as below
1.request buffer.
2.mmap input buffer with OUTPUT
3.output buffer with CAPTURE.
4.filled input buffer with the first frame.
5.enqueue the first frame in the input buffer in OUTPUT side
6.enqueue the output buffer in CAPTURE side
7.start stream
8.dequeue CAPTURE buffer and make output buffer pointer to data of it.
9.get output data from output buffer
/* the buffer get size is 22 below */
10.dequeue OUTPUT
/* timed out, it will never end */
Is there any problem with the order? I don't do any thing simultaneously
below, it seems to difficult to me to understand and not easy to debug.
I am not sure whether the mmap is correct, but I think it it as I don't
get segment fault.


And the thing in the next is like this I think
11.filled input buffer with the next frame
12.enqueue the next frame in the input buffer in OUTPUT side
13.dequeue CAPTURE buffer and make output buffer pointer to data of it.
14.dequeue OUTPUT
goto 11
Is it correct

I doubt the REAME
5. Request CAPTURE and OUTPUT buffers. Due to hardware limitations of MFC on
   some platforms it is recommended to use V4L2_MEMORY_MMAP buffers.
6. Enqueue CAPTURE buffers.
7. Enqueue OUTPUT buffer with first frame.
8. Start streaming (VIDIOC_STREAMON) on both ends.
9. Simultaneously:
I don't need to dequeue the OUTPUT buffer which is with first frame?
   - enqueue buffers with next frames,
   - dequeue used OUTPUT buffers (blocking operation),
   - dequeue buffers with encoded stream (blocking operation),
   - enqueue free CAPTURE buffers.


							Thank you.
