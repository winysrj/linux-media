Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f178.google.com ([209.85.210.178]:54747 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502Ab3DID5l (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 23:57:41 -0400
Received: by mail-ia0-f178.google.com with SMTP id f27so283947iae.9
        for <linux-media@vger.kernel.org>; Mon, 08 Apr 2013 20:57:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201304081607.23357.hverkuil@xs4all.nl>
References: <CAEvN+1iN_fZ-Gu904LTLYf8CZs9ZfZm03bfuE4Ev3frEgOLShg@mail.gmail.com>
	<201304061518.50347.hverkuil@xs4all.nl>
	<CAEvN+1gLBvJNBb8RjkG_TDk6XXY7-ydwg4f3SAaZmr6ESPAsXA@mail.gmail.com>
	<201304081607.23357.hverkuil@xs4all.nl>
Date: Tue, 9 Apr 2013 11:57:40 +0800
Message-ID: <CAEvN+1gcZdrQsnFyh9cyWQeMFUFZe7bfRgNZuWcY_ph-Gqbe+A@mail.gmail.com>
Subject: Re: Question regarding developing V4L2 device driver and Streaming IO
 in v4l2-ctl
From: Tzu-Jung Lee <roylee17@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	Kamil Debski <k.debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

> On Mon, Apr 8, 2013 at 10:07 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> But try the patch below for v4l2-ctl: if you combine streaming with --decoder-cmd
> then instead of doing a STREAMOFF it will call the decoder command. And the
> encoder now listens to the EOS event.
> Note that --en/decoder-cmd=start isn't necessary: STREAMON should call that
> implicitly as per the spec.
>
> Let me know if this works!

The patch works well, thanks!

For trying it out, I need to workaround some frame-based logics.
(please find the attach patch below)

Quote from the spec:

       A read() or VIDIOC_STREAMON call sends an implicit START
command to the encoder if it has not been started yet.
       After a STOP command, read() calls will read the remaining data
buffered by the driver. When the buffer is empty, read() will return
zero and the next read() call will restart the encoder.

       A close() or VIDIOC_STREAMOFF call of a streaming file
descriptor sends an implicit immediate STOP to the encoder, and all
buffered data is discarded.

So I think I'll make the driver itself stop the codec implicitly in
the STREAMOFF call as well to conform the spec.
And then we can change the decoding command line from

    v4l2-ctl --stream-poll --stream-out-mmap
--stream-from=/clips/src.h264 --decoder-cmd=cmd=stop &
to
    v4l2-ctl --stream-poll --stream-out-mmap --stream-from=/clips/src.h264  &

like the encoding command line:

    v4l2-ctl --stream-poll --stream-mmap --stream-to=/clips/dst.h264 &

It will be great if we can combine the two command lines into one for
the transcoding case.

    v4l2-ctl --stream-poll --stream-out-mmap
--stream-from=/clips/src.h264 --stream-mmap
--stream-to=/clips/dst.h264


p.s. I can help on this for the bitstreaming case, though it will need
reviewing for not breaking frame-based cases :-)

Thanks.
Roy

-----------------------
commit 195e914175b2faf7f2e536cbc32760a18bfa4b28
Author: Tzu-Jung Lee <tjlee@ambarella.com>
Date:   Tue Apr 9 11:24:15 2013 +0800

    v4l-ctl: add missing declarations

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 9099f63..df0b2e1 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -628,6 +628,8 @@ void streaming_set(int fd)
                unsigned count = 0, last = 0;
                struct timeval tv_last;
                bool eos = false;
+               fd_set read_fds;
+               fd_set exception_fds;

                while (!eos) {
                        struct v4l2_plane planes[VIDEO_MAX_PLANES];


commit 5671c388ecbe448b11f271079dcd88689e753e3b
Author: Tzu-Jung Lee <tjlee@ambarella.com>
Date:   Tue Apr 9 11:25:13 2013 +0800

    v4l-ctl: tmp hack for straming I/O of bitstreams

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index df0b2e1..5d40810 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -796,10 +796,12 @@ void streaming_set(int fd)
                fmt.type = type;
                doioctl(fd, VIDIOC_G_FMT, &fmt);

+#if 0
                if (!precalculate_bars(fmt.fmt.pix.pixelformat,
stream_pat % NUM_PATTERNS)) {
                        fprintf(stderr, "unsupported pixelformat\n");
                        return;
                }
+#endif

                memset(&reqbufs, 0, sizeof(reqbufs));
                reqbufs.count = reqbufs_count;
@@ -876,6 +878,7 @@ void streaming_set(int fd)
                                if (!fin ||
!fill_buffer_from_file(buffers, buffer_lengths,
                                                buf.index, num_planes, fin))
                                        fill_buffer(buffers[i], &fmt.fmt.pix);
+                               buf.bytesused = buf.length;
                        }
                        if (doioctl(fd, VIDIOC_QBUF, &buf))
                                return;
