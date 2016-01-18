Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:37487 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbcARQ07 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 11:26:59 -0500
Received: by mail-ig0-f171.google.com with SMTP id h5so50421896igh.0
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2016 08:26:58 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 18 Jan 2016 18:26:58 +0200
Message-ID: <CAJ2oMhL=aaN+O0F+_Bo8mjnSEOSCkN3vGk9WB1GeC+1t1tDw5w@mail.gmail.com>
Subject: dma start/stop & vb2 APIs
From: Ran Shalit <ranshalit@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am trying to understand how to implement dma transfer correctly
using videobuf2 APIs.

Normally, application will do semthing like this (video test API):

                xioctl(fd, VIDIOC_DQBUF, &buf)
                process_image(buffers[buf.index].start, buf.bytesused);
                xioctl(fd, VIDIOC_QBUF, &buf)

Therefore, in the driver below I will assume that:
1. VIDIOC_DQBUF -  trigger dma to start
2. interrupt handler in driver - stop dma
3. VIDIOC_QBUF - do nothing with dma.

But, on code review of the following two drivers, I see other things,
much more complex, and I don't understand it yet.

These are the two drivers I reviewed:
- STA2X11
- dt3511

In STA2X11 I see:

1. start_streaming - also triggers dma to start, why ?
2. buf_queue - add buffer to list & if No active buffer, active the
first one , and trigger dma. why do we trigger dma with buf_queue (I
would assume triggering is done with  VIDIOC_DQBUF -> buffer_finish) ?
3. buf_finish - remove buffer from list, but also get the next buffer
in list and trigger dma, why  do we need to trigger a next buffer ?
Isn't buffer_finish is called as a result of VIDIOC_QBUF ?


In dt3511 I see something else as following:
buf_queue()
{...
if (pd->curr_buf)
list_add_tail(&vb->done_entry, &pd->dmaq);
else {
pd->curr_buf = vb;
elbit_start_acq(pd);
}
...}

1. Again, why dma triggering is done as part of  buf_queue instead buf_finish
2. what's the meaning of the condition in this code, it is as if only
the first buffer in buf_queue i striggered, what about the next
ones,why do they only get into list without triggering dma ?
3. In this driver there is no buf_finish.

Thank you for any comments,
Ran
