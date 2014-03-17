Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:61950 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326AbaCQFzx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 01:55:53 -0400
Received: by mail-pa0-f54.google.com with SMTP id lf10so5291735pab.13
        for <linux-media@vger.kernel.org>; Sun, 16 Mar 2014 22:55:53 -0700 (PDT)
Received: from [192.168.33.51] ([121.5.20.50])
        by mx.google.com with ESMTPSA id aj7sm66547862pad.29.2014.03.16.22.55.51
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 16 Mar 2014 22:55:52 -0700 (PDT)
Message-ID: <53268DF3.8040503@gmail.com>
Date: Mon, 17 Mar 2014 13:53:55 +0800
From: Leslie Zhai <xiangzhai83@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Fwd: Fail to set resolution for the Vimicro USB Camera (Altair)
References: <53268D33.8040504@gmail.com>
In-Reply-To: <53268D33.8040504@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi uvc && v4l developers,

My Vimicro USB Camera (Altair) driver info shown as below:

Driver Info (using libv4l2):
        Driver name   : uvcvideo
        Card type     : Vimicro USB Camera (Altair)
        Bus info      : usb-0000:00:1d.2-1
        Driver version: 3.12.7
        Capabilities  : 0x85000001
                Video Capture
                Read/Write
                Streaming
                Device Capabilities
        Device Caps   : 0x05000001
                Video Capture
                Read/Write
                Streaming
Priority: 2
Video input : 0 (Camera 1: ok)
Format Video Capture:
        Width/Height  : 320/240
        Pixel Format  : 'YUYV'
        Field         : None
        Bytes per Line: 640
        Size Image    : 153600
        Colorspace    : SRGB
Crop Capability Video Capture:
        Bounds      : Left 0, Top 0, Width 320, Height 240
        Default     : Left 0, Top 0, Width 320, Height 240
        Pixel Aspect: 1/1
Streaming Parameters Video Capture:
        Capabilities     : timeperframe
        Frames per second: 5.000 (5/1)
        Read buffers     : 0
...

I use v4l2-ctl -d /dev/video1 --set-fmt-video=width=640,height=480
but the camera Format Video Capture Width/Height is still 320/240
Also I tried to use libv4l2 API to VIDIOC_S_FMT, but failed
https://github.com/xiangzhai/laserkbd/blob/master/laser_kbd_neo/src/port/linux/powervideocap_linux.cpp#L130

And I use v4l2-ctl -d /dev/video1 --list-formats-ext
there is NO 640x480 resolution! But my friend use Windows 7 can set
resolution to 640x480

ioctl: VIDIOC_ENUM_FMT
        Index       : 0
        Type        : Video Capture
        Pixel Format: 'YUYV'
        Name        : YUV 4:2:2 (YUYV)
                Size: Discrete 320x240
                        Interval: Discrete 0.200s (5.000 fps)
                Size: Discrete 160x120
                        Interval: Discrete 0.050s (20.000 fps)

Please someone give me some advice, thanks a lot!

Regards,

Leslie Zhai


