Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f182.google.com ([209.85.210.182]:58642 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422826Ab3DFM2N (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Apr 2013 08:28:13 -0400
Received: by mail-ia0-f182.google.com with SMTP id u8so3883666iag.41
        for <linux-media@vger.kernel.org>; Sat, 06 Apr 2013 05:28:12 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 6 Apr 2013 20:28:12 +0800
Message-ID: <CAEvN+1iN_fZ-Gu904LTLYf8CZs9ZfZm03bfuE4Ev3frEgOLShg@mail.gmail.com>
Subject: Question regarding developing V4L2 device driver and Streaming IO in v4l2-ctl
From: Tzu-Jung Lee <roylee17@gmail.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm writing device v4l2 driver for our video codec, which can be configured to:

    1. decode bitstream and output to TV (output device)
    2. capture video input, and generate encoded bitstream. (capture device)
    3. transcode input bitstream to another format output bitstream.
(mem2mem device)

And I got some questions regarding the GENERIC way to handle the "end
of stream" when doing STREAM I/O.
(Perhaps these questions are only relevant to bitstream data instead of frames?)

    1. Capture path: how does the device driver notify the user
program the end of captured bitstream?
    2. Output path: how does user program tells the the driver the end
of output bitstream?

    Based on the http://linuxtv.org/downloads/v4l-dvb-apis/capture-example.html,
    I wrote a program, which can do the stream I/O with our V4L2 driver.

    For capture path: if the device has stopped, the program will get
a zero-size (bytesused = 0) buffer when it DQBUF.
    For output path: If the program has read the EOF of input file, it
QBUF a zero-size buffer to notify the driver.

    However, this is just the "vendor-specific" way. And I'm wondering
what is the "generic" way to this?



The v4l2-ctl is really handy, and helps me to develop the "control" of
drivers. I'd like to use it for testing STREAM I/O functions as well.

But I have questions regarding Streaming I/O in v4l2-ctl.

    v4l-utils/utils/v4l2-ctl/v4l2-ctl.cpp:

    1. For the path of "--stream-out-mmap", isn't it supposed to set
the payload size (buf->bytesused) after filling data read from STDIN
or file?

    2. For capture path, user programs have to initially QBUF empty
buffers for drivers to fill data.
        However, for output path, do we need to QBUF empty buffers
before the filling loop start?
        Or we only QBUF filled buffers when the loop starts.

It seems to me drivers can't use the buffer length to distinguish if
the queued buffer are empty or filled ones, right.


Thanks

Roy
