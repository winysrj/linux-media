Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:46997 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbZEONQs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 09:16:48 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Guillaume <Kowaio@gmail.com>
Subject: Re: V4L2 - Capturing uncompressed data
Date: Fri, 15 May 2009 15:20:26 +0200
Cc: linux-media@vger.kernel.org
References: <loom.20090515T125828-924@post.gmane.org>
In-Reply-To: <loom.20090515T125828-924@post.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905151520.26540.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guillaume,

On Friday 15 May 2009 15:03:11 Guillaume wrote:
> Hello,
>
> I'm a French student and I'm doing an intern ship in a French image
> processing software company, and I've got some questions about V4L2 and more
> precisely, the video formats.
>
> In the application, I just need to capture frames of webcams and display the
> result. After research, I found the capture example on the 
http://v4l2spec.bytesex.org/ website. So now, I capture correctly the frames.
>
> During the initialisation of the device, I'm doing a VIDIOC_G_FMT in order
> to get the format description of the webcam. Then, I tried to change the
> pixelformat. Indeed, I wanted the YUYV FORMAT because I need to get the raw
> data in order to get the best quality possible.
>
> My problem is, after the VIDIOC_S_FMT, the pixelformat field is set back to
> JPEG FORMAT (and the colorspace too) and so, I don't get raw data, but
> compressed jpeg data.
>
> I know that the VIDIOC_S_FMT try to change these fields but if the driver
> don't authorise them, it will put the originals back.
>
> But, I really need to get the uncompressed data of the captured picture,
> so is there by any chance, another solution to 'force' and capture the
> images in an Uncompressed format ? Or is it really set by the driver and so,
> no chance to have the raw ?

It depends on the camera. If the camera can deliver uncompressed data, you 
should be able to get that out of the driver. Otherwise you're stuck.

[snip]

> To be clear, I want the uncompressed pixels of the capture. I already
> succeeded in converting from JPEG to BGR, but the data are compressed.
>
> So now, I don't want to do that conversion. Actually, I want to save the
> uncompressed data for quality directly!
>
> But I don't know if that is possible because the driver of the webcam
> (VF0420 Live! Cam Vista IM - ov519) specified only JPEG format when I'm
> doing a 'V4l-info'.

That probably means that the camera can't deliver uncompressed data, although 
you should ask the driver's author to make sure. If the camera indeed supports 
(M)JPEG only, you will probably have to get another camera.

> I really looked for answers everywhere on the web, so I'm losing hope and
> that's why I'm asking you that today.I'm sorry if my comment is misplaced or
> if the answer has already been posted.

This is the right place for such questions, don't worry.

Best regards,

Laurent Pinchart

