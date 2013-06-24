Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:1912
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751161Ab3FXPfp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jun 2013 11:35:45 -0400
From: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "a.andreyanau@sam-solutions.com" <a.andreyanau@sam-solutions.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: AW: AW: mt9p031 shows purple coloured capture
Date: Mon, 24 Jun 2013 15:35:40 +0000
Message-ID: <6EE9CD707FBED24483D4CB0162E8546745F43748@AMSPRD0711MB532.eurprd07.prod.outlook.com>
References: <6EE9CD707FBED24483D4CB0162E8546745F30330@AMSPRD0711MB532.eurprd07.prod.outlook.com>
 <3299481.jsSH8LsWuG@avalon>
 <6EE9CD707FBED24483D4CB0162E8546745F4216D@AMSPRD0711MB532.eurprd07.prod.outlook.com>
 <1843832.zr84IyNLqN@avalon>
In-Reply-To: <1843832.zr84IyNLqN@avalon>
Content-Language: de-DE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote on 2013-06-22:

>>>> If I use omap3isp-live to capture a stream on my beagleboard, the
>>>> first time I start the app, the picture has always a green taint.
>>>> The second time I start the app, the picture is good. As the camera
>>>> is reset by a gpio upon device open, probably the CCDC or previewer
>>>> is not initialized correctly? @Laurent: As I am unable to test it
>>>> with another cam, does this also happen with your hardware or is it
>>>> a problem specific to the mt9p031?
>>> 
>>> Last time I've tested my MT9P031 sensor with the Beagleboard-xM
>>> there was no such issue.
>> 
>> If I test it with yavta, it works also from the very first start. So
>> there must be an issue in my (adapted) omap3-isp-live.
> 
> Have you tested the unmodified omap3-is-live ?
I did today and indeed, with the unmodified app there is no
green taint on the first start. I have now tracked down the issue
to my implemented rotation on the video-out:

diff --git a/videoout.c b/videoout.c
index 51bed8b..627363a 100644
--- a/videoout.c
+++ b/videoout.c
@@ -76,6 +76,14 @@ struct videoout *vo_init(const char *devname,
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

I do a rotation by 90 or 270 degrees. So there seems to be an issue with
the vrfb-rotation in omap_vout?
I am already rotating the omapfb - is this a problem?
omapfb.rotate=1 omapfb.vrfb=y
Another possibility to rotate the captured stream?

>> The color problem goes away nearly completely, if I do a power-off and
>> on in the mt9p031_s_stream function. It then happens only 1 out of 10
>> times. At least an improvement ;) I have the feeling, that the CCDC
>> doesn't get all data on a stream restart and that causes a buffer
>> corruption. Probably the sensor doesn't start outputting from the
>> beginning (even with a frame restart).
>> Any ideas on this?

Probably this issue is in relation with omap_vout as well.
I will do more tests.

Regards,
Florian


