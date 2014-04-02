Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.bemta7.messagelabs.com ([216.82.254.113]:44554 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932252AbaDBPRQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Apr 2014 11:17:16 -0400
Message-ID: <533C2872.5090603@barco.com>
Date: Wed, 2 Apr 2014 17:10:42 +0200
From: Thomas Scheuermann <scheuermann@barco.com>
MIME-Version: 1.0
To: <linux-media@vger.kernel.org>
Subject: v4l2_buffer with PBO mapped memory
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I've written a program which shows my webcam with the v4l2 interface.
In the v4l2_buffer I use the type V4L2_BUF_TYPE_VIDEO_CAPTURE and the
memory is V4L2_MEMORY_USERPTR.
Everything works if I use malloced memory for frame buffers.
Now I want to get the frames directly in OpenGL. I've mapped a pixel
buffer object with glMapBuffer and wanted to use this as a frame buffer.
But if I use this memory, the ioctl VIDIOC_QBUF fails with 'invalid
argument'.

What can I do to use the pixel buffer object together with the v4l2
interface?
I want to use as less copy steps as possible.

Regards,

Thomas
This message is subject to the following terms and conditions: MAIL DISCLAIMER<http://www.barco.com/en/maildisclaimer>
