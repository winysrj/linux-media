Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61211 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab1HSHFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Aug 2011 03:05:32 -0400
Received: by fxh19 with SMTP id 19so1760136fxh.19
        for <linux-media@vger.kernel.org>; Fri, 19 Aug 2011 00:05:31 -0700 (PDT)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: linux-media@vger.kernel.org, oselas@community.pengutronix.de
Date: Fri, 19 Aug 2011 09:05:29 +0200
Subject: image capturing on i.mx27 with gstreamer
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Jan Pohanka" <xhpohanka@gmail.com>
Message-ID: <op.v0f8nfnjyxxkfz@localhost.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm playing with i.mx27 processor by Freescale, namely with ipcam  
reference design. There is unfortunately no support available for this hw  
this time so I have adapted a kernel from Pengutronix Oselas distribution  
(available here  
ftp://ftp.phytec.de/pub/Products/phyCORE-iMX27/Linux/PD11.1.0/).

There is mt9d131 CMOS imager from Aptina on the board with 1600x1200  
resolution. As there was none driver, I adapted the one for mt9m111 one  
for my chip. Unfortunately I'm able to get image with any resolution only  
up to 800x600, with higher resolution resulting image is fragmented - it  
looks like the both synchronization (vertical, horizontal) fails. I was  
not able to solve it yet, I'm only sure that I wrote correct values to  
WINDOW_WIDHT and WINDOW_HEIGHT registers, also no skipping is set up.
I use following command to capture single image:
gst-launch \
   v4l2src num-buffers=1 device=/dev/video1 ! \
   video/x-raw-yuv,format=\(fourcc\)UYVY,width=$WIDTH,height=$HEIGHT ! \
   ffmpegcolorspace ! \
   video/x-raw-yuv,width=$WIDTH,height=$HEIGHT ! \
   jpegenc ! \
   filesink location=col_image.jpg

My second problem concerns streaming via udp. I'm able to stream mpeg4  
using hardware VPU on the chip using following gstreamer command
gst-launch -v \
   v4l2src device=/dev/video1 ! \
   video/x-raw-yuv,format=\(fourcc\)UYVY,width=$WIDTH,height=$HEIGHT,  
framerate='(fraction)'10/1 ! \
   ffmpegcolorspace ! \
   mfw_vpuencoder codec-type=std_mpeg4 bitrate=16383 gopsize=20  
profile=true ! \
   rtpmp4vpay send-config=TRUE  ! \
   udpsink host=192.168.10.1 port=5434

However, there is also an issue with resolution. This works up to 640x480.  
For example for 800x600 i'm getting this error message
WARNING: erroneous pipeline: could not link ffmpegcsp0 to mfwgstvpu_enc0

Could please anyone give me an advice how to solve described problems?

with best regards
Jan


-- 
Tato zpráva byla vytvořena převratným poštovním klientem Opery:  
http://www.opera.com/mail/
