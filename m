Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50154 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752780AbZJBX05 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2009 19:26:57 -0400
Date: Sat, 3 Oct 2009 01:27:04 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Antonio Ospite <ospite@studenti.unina.it>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: pxa_camera + mt9m1111:  Failed to configure for format 50323234
In-Reply-To: <20091002213530.104a5009.ospite@studenti.unina.it>
Message-ID: <Pine.LNX.4.64.0910030116270.12093@axis700.grange>
References: <20091002213530.104a5009.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2 Oct 2009, Antonio Ospite wrote:

> Hi,
> 
> after updating to 2.6.32-rc2 I can't capture anymore with the setup in the
> subject.

Indeed:-( Please, verify, that this patch fixes your problem (completely 
untested), if it does, I'll push it for 2.6.32:

pxa_camera: fix camera pixel format configuration

A typo prevents correct picel format negotiation with client drivers.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 6952e96..aa831d5 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1432,7 +1432,9 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
 		icd->sense = &sense;
 
 	cam_f.fmt.pix.pixelformat = cam_fmt->fourcc;
-	ret = v4l2_subdev_call(sd, video, s_fmt, f);
+	ret = v4l2_subdev_call(sd, video, s_fmt, &cam_f);
+	cam_f.fmt.pix.pixelformat = pix->pixelformat;
+	*pix = cam_f.fmt.pix;
 
 	icd->sense = NULL;
 

Thanks
Guennadi


> 
> Here's the message from userspace:
>   # ./capture-example 
>   Cannot open '/dev/video0': 22, Invalid argument
> which is from the very first open() call.
> 
> Here's the relevant snippet from dmesg with debug enabled:
> [   15.613749] i2c /dev entries driver
> [   15.626308] Linux video capture interface: v2.00
> [   15.640834] pxa27x-camera pxa27x-camera.0: Limiting master clock to 26000000
> [   15.648696] pxa27x-camera pxa27x-camera.0: LCD clock 104000000Hz, target freq 26000000Hz, divisor 1
> [   15.656494] pxa27x-camera pxa27x-camera.0: got DMA channel 1
> [   15.665398] pxa27x-camera pxa27x-camera.0: got DMA channel (U) 2
> [   15.673461] pxa27x-camera pxa27x-camera.0: got DMA channel (V) 3
> [   15.686771] camera 0-0: Probing 0-0
> [   15.707545] pxa27x-camera pxa27x-camera.0: Registered platform device at cc889380 data c03a1e98
> [   15.715265] pxa27x-camera pxa27x-camera.0: pxa_camera_activate: Init gpios
> [   15.723488] pxa27x-camera pxa27x-camera.0: PXA Camera driver attached to camera 0
> [   15.739092] mt9m111 0-005d: read  reg.00d -> 0008
> [   15.743812] mt9m111 0-005d: write reg.00d = 0008 -> 0
> [   15.748702] mt9m111 0-005d: read  reg.00d -> 0008
> [   15.753237] mt9m111 0-005d: write reg.00d = 0009 -> 0
> [   15.757864] mt9m111 0-005d: read  reg.00d -> 0009
> [   15.762386] mt9m111 0-005d: write reg.00d = 0029 -> 0
> [   15.766938] mt9m111 0-005d: read  reg.00d -> 0029
> [   15.771670] mt9m111 0-005d: write reg.00d = 0008 -> 0
> [   15.776136] mt9m111 0-005d: write reg.0c8 = 970b -> 0
> [   15.781325] mt9m111 0-005d: read  reg.106 -> 700e
> [   15.785695] mt9m111 0-005d: write reg.106 = 700e -> 0
> [   15.792896] mt9m111 0-005d: read  reg.000 -> 143a
> [   15.796790] mt9m111 0-005d: Detected a MT9M11x chip ID 143a
> [   15.805505] pxa27x-camera pxa27x-camera.0: Providing format Planar YUV422 16 bit using CbYCrY 16 bit
> [   15.813285] pxa27x-camera pxa27x-camera.0: Providing format CbYCrY 16 bit packed
> [   15.820729] pxa27x-camera pxa27x-camera.0: Providing format CrYCbY 16 bit packed
> [   15.828221] pxa27x-camera pxa27x-camera.0: Providing format YCbYCr 16 bit packed
> [   15.835484] pxa27x-camera pxa27x-camera.0: Providing format YCrYCb 16 bit packed
> [   15.842888] pxa27x-camera pxa27x-camera.0: Providing format RGB 565 packed
> [   15.850455] pxa27x-camera pxa27x-camera.0: Providing format RGB 555 packed
> [   15.858077] pxa27x-camera pxa27x-camera.0: Providing format Bayer (sRGB) 8 bit in pass-through mode
> [   15.872455] pxa27x-camera pxa27x-camera.0: PXA Camera driver detached from camera 0
> ...
> [   70.377781] pxa27x-camera pxa27x-camera.0: Registered platform device at cc889380 data c03a1e98
> [   70.377866] pxa27x-camera pxa27x-camera.0: pxa_camera_activate: Init gpios
> [   70.378259] pxa27x-camera pxa27x-camera.0: PXA Camera driver attached to camera 0
> [   70.378336] mt9m111 0-005d: mt9m111_s_fmt fmt=50323234 left=24, top=8, width=1280, height=1024
> [   70.379630] mt9m111 0-005d: write reg.002 = 0018 -> 0
> [   70.380589] mt9m111 0-005d: write reg.001 = 0008 -> 0
> [   70.382382] mt9m111 0-005d: write reg.1a0 = 0500 -> 0
> [   70.383347] mt9m111 0-005d: write reg.1a3 = 0400 -> 0
> [   70.384312] mt9m111 0-005d: write reg.1a1 = 0500 -> 0
> [   70.385267] mt9m111 0-005d: write reg.1a4 = 0400 -> 0
> [   70.386227] mt9m111 0-005d: write reg.1a6 = 0500 -> 0
> [   70.387188] mt9m111 0-005d: write reg.1a9 = 0400 -> 0
> [   70.393180] mt9m111 0-005d: write reg.1a7 = 0500 -> 0
> [   70.394155] mt9m111 0-005d: write reg.1aa = 0400 -> 0
> [   70.394224] mt9m111 0-005d: Pixel format not handled : 50323234
> [   70.394265] pxa27x-camera pxa27x-camera.0: Failed to configure for format 50323234
> [   70.394310] pxa27x-camera pxa27x-camera.0: PXA Camera driver detached from camera 0
> 
> Format 50323234 is 422P, it looks like pxa-camera is trying to force
> its native format to the sensor, but I am still investigating; I'll come
> back when I find more or if I come up with a solution.
> 
> Thanks,
>    Antonio
> 
> -- 
> Antonio Ospite
> http://ao2.it
> 
> PGP public key ID: 0x4553B001
> 
> A: Because it messes up the order in which people normally read text.
>    See http://en.wikipedia.org/wiki/Posting_style
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
