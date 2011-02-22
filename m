Return-path: <mchehab@pedra>
Received: from mx06.syd.iprimus.net.au ([210.50.76.235]:33444 "EHLO
	mx06.syd.iprimus.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab1BVJFe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 04:05:34 -0500
Message-Id: <e05367$6n6fju@smtp06.syd.iprimus.net.au>
From: Mike Booth <mike_booth76@iprimus.com.au>
To: linux-media@vger.kernel.org
Subject: Re: v4l-utils-0.8.3 and KVDR
Date: Tue, 22 Feb 2011 20:03:51 +1100
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

KVDR has a number of different parameters including

-x                        force xv-mode on startup and disable overlay-mod

-d                        dont switch modeline during xv
 with kernel 2.6.35 I run KVDR with -x as I have an NVIDIA graphics. Running 
on 2.6.38 KVDR -x doesn't produce any log. The display appears and immediately 
disappears although there is a process running.

With KVDR -d I get a display window but no picture but the attached log is 
produced. 

I hope this helps


Mike

libv4l2: open: 4
request == VIDIOC_G_FMT
  pixelformat: BGR3 384x288
  field: 0 bytesperline: 0 imagesize331776
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_ENUM_FMT
  index: 0, description: RGB-8 (3-3-2)
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: RGB1 48x32
  field: 3 bytesperline: 48 imagesize1536
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: RGB1 768x288
  field: 3 bytesperline: 768 imagesize221184
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_ENUM_FMT
  index: 1, description: RGB-16 (5/B-6/G-5/R)
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: RGBP 48x32
  field: 3 bytesperline: 768 imagesize24576
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: RGBP 768x288
  field: 3 bytesperline: 1536 imagesize442368
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_ENUM_FMT
  index: 2, description: RGB-24 (B-G-R)
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: BGR3 48x32
  field: 3 bytesperline: 1536 imagesize49152
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: BGR3 768x288
  field: 3 bytesperline: 2304 imagesize663552
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_ENUM_FMT
  index: 3, description: RGB-32 (B-G-R)
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: BGR4 48x32
  field: 3 bytesperline: 2304 imagesize73728
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: BGR4 768x288
  field: 3 bytesperline: 3072 imagesize884736
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_ENUM_FMT
  index: 4, description: RGB-32 (R-G-B)
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: RGB4 48x32
  field: 3 bytesperline: 3072 imagesize98304
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: RGB4 768x288
  field: 3 bytesperline: 3072 imagesize884736
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_ENUM_FMT
  index: 5, description: Greyscale-8
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: GREY 48x32
  field: 3 bytesperline: 3072 imagesize98304
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: GREY 768x288
  field: 3 bytesperline: 3072 imagesize884736
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_ENUM_FMT
  index: 6, description: YUV 4:2:2 planar (Y-Cb-Cr)
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: 422P 48x32
  field: 3 bytesperline: 3072 imagesize98304
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: 422P 768x288
  field: 3 bytesperline: 3072 imagesize884736
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_ENUM_FMT
  index: 7, description: YVU 4:2:0 planar (Y-Cb-Cr)
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: YV12 48x32
  field: 3 bytesperline: 3072 imagesize98304
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: YV12 768x288
  field: 3 bytesperline: 3072 imagesize884736
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_ENUM_FMT
  index: 8, description: YUV 4:2:0 planar (Y-Cb-Cr)
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: YU12 48x32
  field: 3 bytesperline: 3072 imagesize98304
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: YU12 768x288
  field: 3 bytesperline: 3072 imagesize884736
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_ENUM_FMT
  index: 9, description: YUV 4:2:2 (U-Y-V-Y)
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: UYVY 48x32
  field: 3 bytesperline: 3072 imagesize98304
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: UYVY 768x288
  field: 3 bytesperline: 3072 imagesize884736
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_ENUM_FMT
  index: 10, description: RGB3
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: RGB3 48x32
  field: 3 bytesperline: 144 imagesize4608
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_TRY_FMT
  pixelformat: RGB3 768x288
  field: 3 bytesperline: 2304 imagesize663552
  colorspace: 0, priv: 0
result == 0
request == VIDIOC_ENUM_FMT
  index: 11, description: 
result == -1 (Invalid argument)
request == VIDIOC_ENUMINPUT
result == 0
request == VIDIOC_ENUMSTD
result == 0
libv4l1: open: 4
request == VIDIOC_QUERYCAP
result == 0
request == VIDIOC_G_FBUF
result == 0
request == VIDIOC_S_FBUF
result == 0
libv4l2: close: 4
libv4l1: close: 4

