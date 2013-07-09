Return-path: <linux-media-owner@vger.kernel.org>
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:10921
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753955Ab3GIO0H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Jul 2013 10:26:07 -0400
From: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: omap_vout: rotation issue on the first start
Date: Tue, 9 Jul 2013 14:25:48 +0000
Message-ID: <6EE9CD707FBED24483D4CB0162E8546745F4BAAA@AMSPRD0711MB532.eurprd07.prod.outlook.com>
Content-Language: de-DE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Sorry to insist on this, but for you it's probably peanuts to see a possible error.
Any hints/workarounds are welcome...

>From the mail with subject
AW: AW: mt9p031 shows purple coloured capture
Florian Neuhaus wrote on 2013-06-24:

>> Have you tested the unmodified omap3-is-live ?
> I did today and indeed, with the unmodified app there is no green taint on
> the first start. I have now tracked down the issue to my implemented
> rotation on the video-out:
> 
diff --git a/videoout.c b/videoout.c
index 51bed8b..6fd8a16 100644
--- a/videoout.c
+++ b/videoout.c
@@ -60,6 +60,7 @@ struct videoout *vo_init(const char *devname,
 	struct v4l2_format fmt;
 	struct videoout *vo;
 	int ret;
+	int rotation = 90; /* rotate for testing purposes */
 
 	/* Allocate the video output object. */
 	vo = malloc(sizeof *vo);
@@ -76,6 +77,14 @@ struct videoout *vo_init(const char *devname,
 		goto error;
 	}
 
+	/* setup the rotation here, we have to do it BEFORE
+	 * setting the format. */
+	ret = v4l2_set_control(vo->dev, V4L2_CID_ROTATE, &rotation);
+	if (ret < 0){
+		perror("Failed to setup rotation\n");
+		goto error;
+	}
+
 	pixfmt.pixelformat = format->pixelformat;
 	pixfmt.width = format->width;
 	pixfmt.height = format->height;

It would be very nice if you could test the above patch with one of
your omap-devices.

> I do a rotation by 90 or 270 degrees. So there seems to be an issue with the
> vrfb-rotation in omap_vout?
> I am already rotating the omapfb - is this a problem?
> omapfb.rotate=1 omapfb.vrfb=y
> Another possibility to rotate the captured stream?

I noticed, that it happens only with 90 or 270 degree rotation
and not with 0 and 180 degree. Also only on the first start of
the stream. All following streamings are correct.

I have a 480x800 Portrait display. I try to rotate the output to
800x480 landscape.

Regards,
Florian


