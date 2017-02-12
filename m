Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:33236 "EHLO
        mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751114AbdBLCfa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Feb 2017 21:35:30 -0500
Received: by mail-vk0-f41.google.com with SMTP id k127so45775944vke.0
        for <linux-media@vger.kernel.org>; Sat, 11 Feb 2017 18:35:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+HxBUJP5Z7d8=3D3WE9H1Mqfhp0qKqrZbJNGHmt=rc4vRwHiw@mail.gmail.com>
References: <CA+HxBUJP5Z7d8=3D3WE9H1Mqfhp0qKqrZbJNGHmt=rc4vRwHiw@mail.gmail.com>
From: =?UTF-8?Q?St=C3=A9phane_Charette?= <stephanecharette@gmail.com>
Date: Sat, 11 Feb 2017 18:35:29 -0800
Message-ID: <CA+HxBULDpsADJCKENFkp7ASb4Hq2QS0U9vt92Rp0PM5_S4AW6g@mail.gmail.com>
Subject: Re: partial webcam image transfer
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm using V4L2 to capture images from a web cam.  I've tried:

- mmap()
- read()
- libv4l2
- without libv4l2

At low resolutions, such as 160x120 and 320x240, things are typically
good.  But starting at 640x480 and higher resolutions, I often get
only 10% to 25% of the image.  The rest of the bytes in the buffer are
left untouched.

When using mmap buffers, v4l2_buffer.bytesused is much less than
v4l2_buffer.length.
When using read, the ssize_t count is less than the full image.

I'm using a native non-compressed YUYV 4:2:2 format, so I know exactly
how many bytes to expect.  When the full image doesn't come in, it
looks like this:

https://www.ccoderun.ca/tmp/partial_image.jpg

In case it helps, here is some relevant V4L information I dump out
after the capture.  Note the bytes used and length of the memory
mapped buffer, which corresponds to the image linked above:

Filename: "/dev/video0"
Driver name: uvcvideo v4.4.40
Device name: USB 2.0 Camera
Location: usb-0000:00:0b.0-1
Flags: 0x85200001
  The device supports the single-planar API through the Video Capture inter=
face.
  The device supports the struct v4l2_pix_format extended fields.
  The device supports the read() and/or write() I/O methods.
  The device supports the streaming I/O method.
  The driver fills the device_caps field.

Currently selected format:
type: V4L2_BUF_TYPE_VIDEO_CAPTURE
width: 1024
height: 768
pixel format: YUYV
field: V4L2_FIELD_NONE
bytes per line: 2048 bytes
image size: 1572864 bytes
colour space: V4L2_COLORSPACE_DEFAULT

Memory mapped buffer #0:
type: V4L2_BUF_TYPE_VIDEO_CAPTURE
bytes used: 284880 bytes
flags: 73733
field: V4L2_FIELD_NONE
sequence: 0
length: 1572864 bytes
address: 0xb7197000

I've checked things like errno and xioctl results to ensure no errors
are reported.  Does anyone have a guess as to why the buffers aren't
always full, or what I must do to ensure I get the whole buffer/read?

TIA,

St=C3=A9phane Charette
