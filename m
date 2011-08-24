Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:55437 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab1HXTSA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 15:18:00 -0400
Date: Wed, 24 Aug 2011 21:17:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jan Pohanka <xhpohanka@gmail.com>
cc: linux-media@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: dma buffers for camera
In-Reply-To: <op.v0p0hctkyxxkfz@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.1108242111560.14818@axis700.grange>
References: <op.v0p0hctkyxxkfz@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jan

On Wed, 24 Aug 2011, Jan Pohanka wrote:

> Hello,
> 
> could please anyone explain me a bit situation about using memory buffers for
> dma for video input devices? Unfortunately I don't understand it at all.
> I want to capture images 1600x1200 from 2 mpix sensor on i.mx27 board.
> I gave 8MB to mx2_camera device with dma_declare_coherent_memory.
> 
> Unfortunately it seems to be not enough. In UYVY format I need 1600x1200x2 for
> one picture, it is cca 3.8MB.
> After some digging I noticed, that dma_alloc_coherent() is called three times
> and each time with the 3.8MB demand. Once it is directly from mx2_camera
> driver and two times from videobuf_dma_contig. OK, that is more than 8MB
> available, but why there are so big memory demands for one picture?
> 
> I'm using gstremer for capturing, so it probably requests several buffers with
> VIDIOC_REQBUFS. Is this behaviour normal, even if there is explicitly noted
> that I want only one buffer?

The mx2_camera driver is allocating one "discard" buffer of the same size, 
as regular buffers for cases, when the user is not fast enough to queue 
new buffers for the running capture. Arguably, this could be aliminated 
and the last submitted buffer could be re-used until either more buffers 
are available or the streaming is stopped. Otherwise, it could also be 
possible to stop capture until buffers are available again. In any case, 
this is the current driver implementation. As for 2 buffers instead of one 
for the actual capture, I think, gstreamer defines 2 as a minimum number 
of buffers, which is actually also required for any streaming chance.

Thanks
Guennadi

> gst-launch \
>  v4l2src num-buffers=1 device=/dev/video1 ! \
>  video/x-raw-yuv,format=\(fourcc\)UYVY,width=$WIDTH,height=$HEIGHT ! \
>  jpegenc ! \
>  filesink location=col_image.jpg
> 
> 
> with best regards
> Jan

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
