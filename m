Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60323 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab2BNOUU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 09:20:20 -0500
Received: by eekc14 with SMTP id c14so11963eek.19
        for <linux-media@vger.kernel.org>; Tue, 14 Feb 2012 06:20:19 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 14 Feb 2012 12:20:19 -0200
Message-ID: <CAOMZO5AJ9iZ-nDLpM9g757GjPUxCEVNU20Ou4qMz8+5kRFiDkQ@mail.gmail.com>
Subject: mx3_camera: dmaengine: failed to get dma1chan
From: Fabio Estevam <festevam@gmail.com>
To: Sascha Hauer <kernel@pengutronix.de>,
	linux-media <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Javier Martin <javier.martin@vista-silicon.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am testing mx3_camera on a mx31pdk board running linux-next and this
is what I get during kernel boot:

....
soc-camera-pdrv soc-camera-pdrv.0: Probing soc-camera-pdrv.0
mx3-camera mx3-camera.0: MX3 Camera driver attached to camera 0
ov2640 0-0030: ov2640 Product ID 26:42 Manufacturer ID 7f:a2
i2c i2c-0: OV2640 Probed
mx3-camera mx3-camera.0: MX3 Camera driver detached from camera 0
dmaengine: failed to get dma1chan0: (-22)
dmaengine: failed to get dma1chan1: (-22)
dmaengine: failed to get dma1chan2: (-22)
dmaengine: failed to get dma1chan3: (-22)
dmaengine: failed to get dma1chan4: (-22)
dmaengine: failed to get dma1chan5: (-22)
dmaengine: failed to get dma1chan6: (-22)
dmaengine: failed to get dma1chan7: (-22)
dmaengine: failed to get dma1chan8: (-22)
dmaengine: failed to get dma1chan9: (-22)
dmaengine: failed to get dma1chan10: (-22)
dmaengine: failed to get dma1chan11: (-22)
dmaengine: failed to get dma1chan12: (-22)
dmaengine: failed to get dma1chan13: (-22)
dmaengine: failed to get dma1chan14: (-22)
dmaengine: failed to get dma1chan15: (-22)
dmaengine: failed to get dma1chan16: (-22)
dmaengine: failed to get dma1chan17: (-22)
dmaengine: failed to get dma1chan18: (-22)
dmaengine: failed to get dma1chan19: (-22)
dmaengine: failed to get dma1chan20: (-22)
dmaengine: failed to get dma1chan21: (-22)
dmaengine: failed to get dma1chan22: (-22)
dmaengine: failed to get dma1chan23: (-22)
dmaengine: failed to get dma1chan24: (-22)
dmaengine: failed to get dma1chan25: (-22)
dmaengine: failed to get dma1chan26: (-22)
dmaengine: failed to get dma1chan27: (-22)
dmaengine: failed to get dma1chan28: (-22)
dmaengine: failed to get dma1chan29: (-22)
dmaengine: failed to get dma1chan30: (-22)
...

Then I start the following Gstreamer pipeline:

$ gst-launch v4l2src ! fbdevsink
Setting pipeline to PAUSED ...
mx3-camera mx3-camera.0: MX3 Camera driver attached to camera 0
Pipeline is live and does not need PREROLL ...
WARNING: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Could not get
parameters on device '/dev/video0'
Additional debug info:
v4l2src_calls.c(225): gst_v4l2src_set_capture (): /GstPipeline:pipeline0/GstV4l2
Src:v4l2src0:
system error: Invalid argument
Setting pipeline to PLAYING ...
New clock: GstSystemClock

, and I start to see the captured image in the LCD, but after about
10-15 seconds I get:


dma dma0chan7: NFB4EOF on channel 7, ready 0, 0, cur 80

,and the display gets frozen with the last captured frame from the camera.

Are there known patches that fix this issue?

Thanks,

Fabio Estevam
