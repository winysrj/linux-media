Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:38084 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbaARKnK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jan 2014 05:43:10 -0500
Received: by mail-qc0-f173.google.com with SMTP id i8so4523922qcq.18
        for <linux-media@vger.kernel.org>; Sat, 18 Jan 2014 02:43:09 -0800 (PST)
Message-ID: <52DA5ABA.7070003@gmail.com>
Date: Sat, 18 Jan 2014 11:43:06 +0100
From: Andreas Weber <andy.weber.aw@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: andy.weber.aw@gmail.com
Subject: How to tell libv4l2 which src_fmt should be prefered?
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear maintainer and user,

Is there a way to tell libv4l2 which native source format it should
prefer to convert from? For example my uvcvideo webcam supports natively
YUYV and MJPG (see output below) and when I request V4L2_PIX_FMT_RGB24 I
see in the logs:

...
VIDIOC_S_FMT app requesting: RGB3
VIDIOC_S_FMT converting from: YUYV
request == VIDIOC_S_FMT
  pixelformat: RGB3 640x480
  field: 1 bytesperline: 1920 imagesize921600
  colorspace: 8, priv: 0
...

So it picks up YUYV as source format. I had a look at
v4lconvert_try_format but can see no way how to do this.

Regards, Andy

$ v4l2-ctl --list-formats
ioctl: VIDIOC_ENUM_FMT
	Index       : 0
	Type        : Video Capture
	Pixel Format: 'YUYV'
	Name        : YUV 4:2:2 (YUYV)

	Index       : 1
	Type        : Video Capture
	Pixel Format: 'MJPG' (compressed)
	Name        : MJPEG

$ v4l2-ctl -w -D
Driver Info (using libv4l2):
	Driver name   : uvcvideo
	Card type     : UVC Camera (046d:0825)
	Bus info      : usb-0000:00:16.2-2
	Driver version: 3.2.51
	Capabilities  : 0x05000001
		Video Capture
		Read/Write
		Streaming

