Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50542 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756154Ab0EDGnr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 May 2010 02:43:47 -0400
Date: Tue, 4 May 2010 08:43:48 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Charles D. Krebs" <ckrebs@therealtimegroup.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>
Subject: Re: CEU / Camera Driver Question
In-Reply-To: <F528C77ECD244EC8ADEEE5DEF504EB88@RSI45>
Message-ID: <Pine.LNX.4.64.1005040811010.4925@axis700.grange>
References: <C5F5A45C8EB6446BA837800AC37D53A2@RSI45>
 <h2laec7e5c31004071719m4a6551c7w8afdca6bdcf49eae@mail.gmail.com>
 <Pine.LNX.4.64.1004080814370.4621@axis700.grange> <7554DA9455F6445CB94B84859EEDCE57@RSI45>
 <Pine.LNX.4.64.1004140827550.6386@axis700.grange> <F528C77ECD244EC8ADEEE5DEF504EB88@RSI45>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Charles

On Mon, 3 May 2010, Charles D. Krebs wrote:

> Guennadi,
> 
> As per your recommendation I reviewed the "soc_camera_platform" driver, and
> have chosen to implement the new camera by simply modifying it.
> 
> Sure enough, I can boot up and properly register a device under /dev/video0.
> 
> The camera provides 8-bit Grayscale data corresponding to pixel format
> V4L2_PIX_FMT_GREY.  I can't seem to find any example of a device driver that
> uses this format, so I've been taking my best guess as how to setup
> "soc_camera_platform_info".  So far I have:
> 
> static struct soc_camera_platform_info mycam_camera_info = {
> 	.format_name = "GREY",
> 	.format_depth = 8,
> 	.format = {
> 		.code = V4L2_MBUS_FMT_YUYV8_2X8_BE,

No, you should be using V4L2_MBUS_FMT_GREY8_1X8 for grey.

> 		.colorspace = V4L2_COLORSPACE_JPEG,
> 		.field = V4L2_FIELD_NONE,
> 		.width = 320,
> 		.height = 240,
> 	},
> 	.bus_param = SOCAM_PCLK_SAMPLE_RISING | SOCAM_HSYNC_ACTIVE_HIGH |
> 	SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_MASTER | SOCAM_DATAWIDTH_8 |
> 	SOCAM_DATA_ACTIVE_HIGH,
> };
> 
> It looks like I'll need to modify "soc_camera_platform" it in a way to at
> least add a "fourcc" field that can be interpreted by the ceu driver for the
> "sh_mobile_ceu_set_bus_param" call to setup the hardware correctly.

No, subdevice drivers, using the mediabus API, know nothing about fourcc 
codes, that belongs to the user side of the pixel format handling API. The 
path, e.g., for the VIDIOC_S_FMT ioctl() is

soc_camera.c::soc_camera_s_fmt_vid_cap(V4L2_PIX_FMT_GREY)
sh_mobile_ceu_camera.c::sh_mobile_ceu_set_fmt(V4L2_PIX_FMT_GREY)

the latter will try to call the .s_mbus_fmt() method from 
soc_camera_platform.c and will fail, because that got lost during the 
v4l2-subdev conversion, which is a bug and has to be fixed, patch welcome.

> But regardless of how I set this structure up, I don't see any direct support
> for a Grayscale mode data capture in the ceu driver.  For example,
> "sh_mobile_ceu_set_bus_param" does not contain V4L2_PIX_FMT_GREY in its list
> of fourcc formats.  Yet based on the 7724 hardware manual, and from the
> information I have received from Renesas, I'm not seeing any reason why this
> format should not be supported.
> 
> Is grayscale somehow supported under the current CEU driver?

Sure, that's what the pass-through mode with a standard soc-mbus format 
conversion is for (see soc_mbus_get_fmtdesc()).

> Any suggestions on how I might go about implementing support?  I'm having
> trouble seeing the dataflow through the driver at the moment...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
