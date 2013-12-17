Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:55174 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab3LQXNz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 18:13:55 -0500
Received: by mail-wg0-f48.google.com with SMTP id z12so6814286wgg.27
        for <linux-media@vger.kernel.org>; Tue, 17 Dec 2013 15:13:54 -0800 (PST)
MIME-Version: 1.0
From: Zafrullah Syed <zafrullahmehdi@gmail.com>
Date: Wed, 18 Dec 2013 00:13:34 +0100
Message-ID: <CAAGt+t1QqKQ28fFvO22hdPZGxgDAvL1DkdhhYsZ-tm74aEm_4w@mail.gmail.com>
Subject: mt9v032 media-ctl wrong commands
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I am facing media-ctl commands problems past some days. My caspa
camera driver is "omap3isp" and using "mt9v032" sensor.

My medi-ctl commands are as follows:

$ media-ctl -r -l '"mt9v032 3-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3
ISP CCDC":2->"OMAP3 ISP preview":0[1], "OMAP3 ISP preview":1->"OMAP3
ISP resizer":0[1], "OMAP3 ISP resizer":1->"OMAP3 ISP resizer
output":0[1]'

$ media-ctl -V '"mt9v032 3-005c":0[SGRBG10 752x480], "OMAP3 ISP
CCDC":2[SGRBG10 752x480], "OMAP3 ISP preview":1[UYVY 752x480], "OMAP3
ISP resizer":1[UYVY 752x480]'

After giving these commands and running gstreamer pipeline, i get

ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Failed
to enumerate possible video formats device '/dev/video6' can work with
and
Failed to get number 0 in pixelformat enumeration for /dev/video6. (25
- Inappropriate ioctl for device)

detailed problem is listed here( http://goo.gl/PSYOjR )

I guess these are because of wrong media-ctl commands? Even if I
change the camera resolution to something else like 734x471 or
640x480, I get these two same errors. Any inputs on where I am doing
wrong?

The output of media device information
is(http://pastebin.com/xKrQMzcL) , entity 12 is my camera sensor,
which has the following pads and sinks:

- entity 12: OMAP3 ISP resizer output (1 pad, 1 link)
             type Node subtype V4L
             device node name /dev/video6
pad0: Sink
<- "OMAP3 ISP resizer":1 [ENABLED]

- entity 13: OMAP3 ISP AEWB (1 pad, 1 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev5
pad0: Sink
<- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]

- entity 14: OMAP3 ISP AF (1 pad, 1 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev6
pad0: Sink
<- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]

- entity 15: OMAP3 ISP histogram (1 pad, 1 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev7
pad0: Sink
<- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]

- entity 16: mt9v032 3-005c (1 pad, 1 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev8
pad0: Source
[fmt:SGRBG10/752x480
 crop:(1,5)/752x480]
-> "OMAP3 ISP CCDC":0 [ENABLED]


Other Info: /dev/Video 6 Lists formats http://pastebin.com/JvjaktsP
                /dev/Video6  all properties http://pastebin.com/ybSUSmBV

Many Thanks & Regards,
Zafrullah
