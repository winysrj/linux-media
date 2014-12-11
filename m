Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34956 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaLKNAi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Dec 2014 08:00:38 -0500
Received: by mail-lb0-f182.google.com with SMTP id f15so4325676lbj.41
        for <linux-media@vger.kernel.org>; Thu, 11 Dec 2014 05:00:36 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 11 Dec 2014 11:00:36 -0200
Message-ID: <CAOMZO5BgYVQQY4_jJK0h1jMW-Tpb8DHqAkfi2MerhmndMSZr3w@mail.gmail.com>
Subject: coda: not generating EOS event
From: Fabio Estevam <festevam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	frederic.sureau@vodalys.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am running Gstreamer 1.4.4 with on a imx6q-sabresd board and I am
able to decode a video through the coda driver.

The pipeline I use is:
gst-launch-1.0 filesrc
location=/home/H264_test1_Talkinghead_mp4_480x360.mp4 ! qtdemux !
h264parse ! v4l2video1dec ! videoconvert ! fbdevsink

It plays the video fine, but it does not handle the end of stream
correctly: when the video reaches its end, then I get a flood of the
following messages:
[  144.049830] DEC_PIC_SUCCESS = 524289
[  144.064928] DEC_PIC_SUCCESS = 524289
[  144.085516] DEC_PIC_SUCCESS = 524289
[  144.108056] DEC_PIC_SUCCESS = 524289
[  144.130351] DEC_PIC_SUCCESS = 524289
[  144.152852] DEC_PIC_SUCCESS = 524289
[  144.176114] DEC_PIC_SUCCESS = 524289
[  144.198165] DEC_PIC_SUCCESS = 524289
[  144.220579] DEC_PIC_SUCCESS = 524289
[  144.242607] DEC_PIC_SUCCESS = 524289

These same DEC_PIC_SUCCESS messages appear if I use fakesink:
gst-launch-1.0 filesrc
location=/home/H264_test1_Talkinghead_mp4_480x360.mp4 ! qtdemux !
h264parse ! v4l2video1dec ! fakesink

In coda_dqbuf() we have:

    /* If this is the last capture buffer, emit an end-of-stream event */
    if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
        coda_buf_is_end_of_stream(ctx, buf)) {
        const struct v4l2_event eos_event = {
            .type = V4L2_EVENT_EOS
        };

        v4l2_event_queue_fh(&ctx->fh, &eos_event);
    }

Seems we should also check for V4L2_BUF_TYPE_VIDEO_OUPUT. I tried it,
but still not able to fix the end of stream problem.

Any ideas?

Thanks
