Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44307 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696AbaDBTVK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Apr 2014 15:21:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thomas Scheuermann <scheuermann@barco.com>
Cc: linux-media@vger.kernel.org
Subject: Re: v4l2_buffer with PBO mapped memory
Date: Wed, 02 Apr 2014 21:23:09 +0200
Message-ID: <11263729.kS3FzW2BUL@avalon>
In-Reply-To: <533C2872.5090603@barco.com>
References: <533C2872.5090603@barco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

