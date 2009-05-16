Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:48536 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbZEPXys (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 May 2009 19:54:48 -0400
Received: by ewy24 with SMTP id 24so3294039ewy.37
        for <linux-media@vger.kernel.org>; Sat, 16 May 2009 16:54:48 -0700 (PDT)
Message-ID: <4A0F4F89.9010601@gmail.com>
Date: Sun, 17 May 2009 02:43:05 +0300
From: mahmut g <m.gundes@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: viewing captured data
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


      Hello,

      I am new at media. I want capturing from my webcam and streaming 
to any ip by using RTP. Now, I can getting frames with mmap method in 
V4L2_PIX_FMT_YUV420 pixel format. I write the mapped buffers to a file 
but I cant open this file with any image editor, what can I do? I am 
stuck and confused now. Secondly, what format will be fine for streaming.

Thank you all,
Regards.
Mahmut

kays@debian:~/NetBeansProjects/mycapture.c$ sudo ./capture
Opening device /dev/video0..
Initializing device..
Capability of V4L2_CAP_VIDEO_CAPTURE
Capability of V4L2_CAP_STREAMING
Capability of V4L2_CAP_READWRITE
Capability check OK.
VIDIOC_CROPCAP ioctl: Invalid argument
Error ignored!
image format type: 1
image format pix width: 320
image format pix height: 240
image format pix bytesperline: 480
image format pix sizeimage: 115200
image format pixelformat: 842093913
image format pix field: 1
buffer count: 2
Mapping 1 buffer at adress b7dac000
Mapping 1 buffer at adress b7d3b000
mmap is OK.
:::::
Created file: 5
kays@debian:~/NetBeansProjects/mycapture.c$ sudo file image_*
image_0: data
image_1: data
image_2: data
image_3: data
image_4: data
image_5: data

kays@debian:~/NetBeansProjects/mycapture.c$

