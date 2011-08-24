Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58938 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab1HXNpG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 09:45:06 -0400
Received: by bke11 with SMTP id 11so897412bke.19
        for <linux-media@vger.kernel.org>; Wed, 24 Aug 2011 06:45:05 -0700 (PDT)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: linux-media@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 24 Aug 2011 15:45:02 +0200
Subject: dma buffers for camera
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Jan Pohanka" <xhpohanka@gmail.com>
Message-ID: <op.v0p0hctkyxxkfz@localhost.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

could please anyone explain me a bit situation about using memory buffers  
for dma for video input devices? Unfortunately I don't understand it at  
all.
I want to capture images 1600x1200 from 2 mpix sensor on i.mx27 board.
I gave 8MB to mx2_camera device with dma_declare_coherent_memory.

Unfortunately it seems to be not enough. In UYVY format I need 1600x1200x2  
for one picture, it is cca 3.8MB.
After some digging I noticed, that dma_alloc_coherent() is called three  
times and each time with the 3.8MB demand. Once it is directly from  
mx2_camera driver and two times from videobuf_dma_contig. OK, that is more  
than 8MB available, but why there are so big memory demands for one  
picture?

I'm using gstremer for capturing, so it probably requests several buffers  
with VIDIOC_REQBUFS. Is this behaviour normal, even if there is explicitly  
noted that I want only one buffer?

gst-launch \
   v4l2src num-buffers=1 device=/dev/video1 ! \
   video/x-raw-yuv,format=\(fourcc\)UYVY,width=$WIDTH,height=$HEIGHT ! \
   jpegenc ! \
   filesink location=col_image.jpg


with best regards
Jan


-- 
Tato zpráva byla vytvořena převratným poštovním klientem Opery:  
http://www.opera.com/mail/
