Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:39538 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758678Ab2HHXJs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2012 19:09:48 -0400
Received: by ggdk6 with SMTP id k6so694176ggd.19
        for <linux-media@vger.kernel.org>; Wed, 08 Aug 2012 16:09:47 -0700 (PDT)
MIME-Version: 1.0
From: Ilyes Gouta <ilyes.gouta@gmail.com>
Date: Thu, 9 Aug 2012 00:09:26 +0100
Message-ID: <CAL4m05UsCZfJtHGybXH47_=e-Ph+T4mw=Ei0nY5ofgBXF=dBdg@mail.gmail.com>
Subject: About switching between V4L2_BUF_TYPE_VIDEO_CAPTURE and
 V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE capture buffers in v4l2-mem2mem, across instances
To: linux-media@vger.kernel.org
Cc: ilyes.gouta@st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm using the v4l2-mem2mem infrastructure for a driver I'm writing and
I'm looking if it's possible to have the capture vb2_queue to take
both V4L2_BUF_TYPE_VIDEO_CAPTURE and
V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE buffers, across instances.

The IP I'm writing the driver for, handles
V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE natively (NV1xM buffers), but I'd
also need to support V4L2_BUF_TYPE_VIDEO_CAPTURE as this type is also
standard and more application friendly (NV12 and NV16 buffers).

In v4l2-mem2mem, v4l2_m2m_ctx_init(), usually called in the device
driver's v4l2_file_operations::open() handler, is used to setup
(statically) both the output and capture queues of a v4l2-mem2mem
device.

Setting up the queues types (output and capture) in open() isn't
practical for my case, as we can't signal yet the desired type of the
capture buffer at that stage. The only way I could find is to call
v4l2_m2m_ctx_init() during v4l2_ioctl_ops::vidioc_reqbufs() instead;
where depending on the v4l2_requestbuffers::type, I could initialize a
mem2mem context with a V4L2_BUF_TYPE_VIDEO_CAPTURE or a
V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE capture buffer.

The problem is that for the context to be correctly created, userspace
has to issue a reqbufs() for the capture buffers first, and then for
the output buffers. Doing it for the output buffers first, would yield
a call to v4l2_m2m_ctx_init() with an incomplete information about the
capture buffers type. Once buffers are requested for a certain type,
they remain of that type until the instance is closed, or
vidioc_reqbufs() is called w/ v4l2_requestbuffers::count == 0.

I could get vidioc_reqbufs() to enforce this logic and only succeed if
capture buffers are requested before output buffers; but still this
limitation sounds like an artificial and unnecessary.

Do you guys think that this is worth fixing in v4l2-mem2mem? If not,
is there another proper way to handle both V4L2_BUF_TYPE_VIDEO_CAPTURE
and V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE capture buffers in capable
v4l2-mem2mem devices?

Regards,

-Ilyes
