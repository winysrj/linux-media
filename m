Return-path: <linux-media-owner@vger.kernel.org>
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:57167 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab0CPXGv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Mar 2010 19:06:51 -0400
Date: Wed, 17 Mar 2010 00:06:45 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Guennadi Liakhovetski <kernel@pengutronix.de>
Cc: linux-media@vger.kernel.org
Message-ID: <20100316230645.GA26770@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: PXA camera and Planar YUV422 16 bit camera
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm puzzled to know if the pxa_camera driver can manage a data depth
different from 8 bits.

I'm currently trying to add a camera interface support to my PXA270
based board with an adv7180 as soc camera device.

For the adv7180 I defined:

static const struct soc_camera_data_format adv7180_colour_formats[] =
{
        {
                .name           = "Planar YUV422 16 bit",
                .depth          = 16,
                .fourcc         = V4L2_PIX_FMT_YUV422P,
                .colorspace     = V4L2_COLORSPACE_JPEG,
        }
};

but this is rejected by the pxa_camera driver buswidth_supported().

On the other hands if I set .depth = 8 in above struct I get the
following:

debian:~# gst-launch v4l2src ! video/x-raw-yuv,width=320,height=240 !
filesink location=/tmp/video.raw
Setting pipeline to PAUSED ...
Pipeline is live and does not need PREROLL ...
WARNING: from element /pipeline0/v4l2src0: Could not get parameters on
device '/dev/video0'
Additional debug info:
v4l2src_calls.c(1172): gst_v4l2src_set_capture ():
/pipeline0/v4l2src0:
system error: Invalid argument
Setting pipeline to PLAYING ...
New clock: GstSystemClock
WARNING: from element /pipeline0/v4l2src0: Got unexpected frame size
of 76800 instead of 153600.
Additional debug info:
gstv4l2src.c(1077): gst_v4l2src_get_mmap (): /pipeline0/v4l2src0
WARNING: from element /pipeline0/v4l2src0: Got unexpected frame size
of 76800 instead of 153600.

That is the pax_camera device returns 8bits per pixel instead of 16...

Can you please help me in finding what's wrong? :'(

Thanks in advance,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
