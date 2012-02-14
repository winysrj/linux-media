Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37410 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123Ab2BNTm1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 14:42:27 -0500
Received: by eekc14 with SMTP id c14so120167eek.19
        for <linux-media@vger.kernel.org>; Tue, 14 Feb 2012 11:42:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOMZO5AJ9iZ-nDLpM9g757GjPUxCEVNU20Ou4qMz8+5kRFiDkQ@mail.gmail.com>
References: <CAOMZO5AJ9iZ-nDLpM9g757GjPUxCEVNU20Ou4qMz8+5kRFiDkQ@mail.gmail.com>
Date: Tue, 14 Feb 2012 17:42:25 -0200
Message-ID: <CAOMZO5CyEJNVHZ8meeOdXLnSo_wt8PXnZFH--WP-RNmm=k79OQ@mail.gmail.com>
Subject: Re: mx3_camera: dmaengine: failed to get dma1chan
From: Fabio Estevam <festevam@gmail.com>
To: Sascha Hauer <kernel@pengutronix.de>,
	linux-media <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	=?UTF-8?Q?Philippe_R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2/14/12, Fabio Estevam <festevam@gmail.com> wrote:

> Then I start the following Gstreamer pipeline:
>
> $ gst-launch v4l2src ! fbdevsink
> Setting pipeline to PAUSED ...
> mx3-camera mx3-camera.0: MX3 Camera driver attached to camera 0
> Pipeline is live and does not need PREROLL ...
> WARNING: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Could not
> get
> parameters on device '/dev/video0'
> Additional debug info:
> v4l2src_calls.c(225): gst_v4l2src_set_capture ():
> /GstPipeline:pipeline0/GstV4l2
> Src:v4l2src0:
> system error: Invalid argument
> Setting pipeline to PLAYING ...
> New clock: GstSystemClock
>
> , and I start to see the captured image in the LCD, but after about
> 10-15 seconds I get:
>
>
> dma dma0chan7: NFB4EOF on channel 7, ready 0, 0, cur 80

Ok, looks like if I adjust the resolution and framerate properly I no
longer get this error.

With this pipeline I don`t get this error:

gst-launch -v v4l2src device=/dev/video0 !
video/x-raw-yuv,width=320,height=240,framerate=25/1 ! ffmpegcolorspace
! fbdevsink

Now this leads to a new issue: the board resets after about 3 minutes.

Then I started to investigate if this issue was in the capture side or
in the display side:

Capture only pipeline:

gst-launch -v v4l2src  ! video/x-raw-yuv,width=320,height=240,
framerate=25/1 ! fakesink  (works fine)


Display only pipeline:

gst-launch videotestsrc ! fbdevsink (resets the system after ~ 3 minutes)

I will start investigating this and any comments/suggestions are welcome.

Thanks,

Fabio Estevam
