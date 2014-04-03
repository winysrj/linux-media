Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.bemta8.messagelabs.com ([216.82.243.208]:48588 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427AbaDCQwX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 12:52:23 -0400
From: "Scheuermann, Mail" <Scheuermann@barco.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: AW: v4l2_buffer with PBO mapped memory
Date: Thu, 3 Apr 2014 16:52:19 +0000
Message-ID: <67C778DDEF97AE4BA9DC4BA8ECFD811E1DB2C949@KUUMEX11.barco.com>
References: <533C2872.5090603@barco.com>,<11263729.kS3FzW2BUL@avalon>
In-Reply-To: <11263729.kS3FzW2BUL@avalon>
Content-Language: de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

the driver my device uses is the uvcvideo. I have the kernel 3.11.0-18 from Ubuntu 13.10 running.
It is built in in a Thinkpad X240 notebook.

Regards,

Thomas

________________________________________
Von: Laurent Pinchart [laurent.pinchart@ideasonboard.com]
Gesendet: Mittwoch, 2. April 2014 21:23
An: Scheuermann, Mail
Cc: linux-media@vger.kernel.org
Betreff: Re: v4l2_buffer with PBO mapped memory

Hi Thomas,

On Wednesday 02 April 2014 17:10:42 Thomas Scheuermann wrote:
> Hello,
>
> I've written a program which shows my webcam with the v4l2 interface.
> In the v4l2_buffer I use the type V4L2_BUF_TYPE_VIDEO_CAPTURE and the
> memory is V4L2_MEMORY_USERPTR.
> Everything works if I use malloced memory for frame buffers.
> Now I want to get the frames directly in OpenGL. I've mapped a pixel
> buffer object with glMapBuffer and wanted to use this as a frame buffer.
> But if I use this memory, the ioctl VIDIOC_QBUF fails with 'invalid
> argument'.
>
> What can I do to use the pixel buffer object together with the v4l2
> interface?
> I want to use as less copy steps as possible.

The use case is reasonable (although V4L2_MEMORY_DMABUF would be better, but
we're not there yet on the OpenGL side I believe), so let's try to debug this.
First of all, what webcam driver do you use ?

--
Regards,

Laurent Pinchart

This message is subject to the following terms and conditions: MAIL DISCLAIMER<http://www.barco.com/en/maildisclaimer>
