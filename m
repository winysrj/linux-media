Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35358 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbbFKMcy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 08:32:54 -0400
Received: by wiga1 with SMTP id a1so74319274wig.0
        for <linux-media@vger.kernel.org>; Thu, 11 Jun 2015 05:32:53 -0700 (PDT)
MIME-Version: 1.0
From: Damiano Albani <damiano.albani@gmail.com>
Date: Thu, 11 Jun 2015 14:32:33 +0200
Message-ID: <CAKys952Gs5M=aQQfz_6YESHpzt6VdY3TN+rtUXL3fHYnsD6zYw@mail.gmail.com>
Subject: Support for UVC 1.5 / H.264 SVC (to be used with Logitech C930e)
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I've recently got hold of a Logitech C930e webcam.
AFAIK that's the only consumer webcam that support UVC 1.5 and H.264/SVC.
Unfortunately, compared to its predecessor the C920, it is not very
well supported on Linux.

For example, the H.264 capability doesn't appear in the list of formats:

> v4l2-ctl -D --list-formats
Driver Info (not using libv4l2):
Driver name   : uvcvideo
Card type     : Logitech Webcam C930e
Bus info      : usb-0000:00:1a.7-1.4
Driver version: 3.13.11
Capabilities  : 0x84000001
Video Capture
Streaming
Device Capabilities
Device Caps   : 0x04000001
Video Capture
Streaming
ioctl: VIDIOC_ENUM_FMT
Index       : 0
Type        : Video Capture
Pixel Format: 'YUYV'
Name        : YUV 4:2:2 (YUYV)

Index       : 1
Type        : Video Capture
Pixel Format: 'MJPG' (compressed)
Name        : MJPEG


Back in August 2013, there was a discussion on adding support for UVC
1.5, among other things:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg66203.html

If I'm not mistaken, this set of patches provided above haven't been
integrated into the kernel.
Is there a lot of work to do to "backport" the code into the current kernel?
2 years after the original was written, has there been changes in the
API that requires to "revisit" the patches?

Cheers,

-- 
Damiano Albani
