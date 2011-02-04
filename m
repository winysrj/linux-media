Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:50064 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab1BDIKx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Feb 2011 03:10:53 -0500
Date: Fri, 4 Feb 2011 09:10:45 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Qing Xu <qingx@marvell.com>
Subject: Re: soc-camera: RGB888, RBG8888 and JPEG formats not supported in
 v4l2_mbus_pixelcode
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384DEE2BDCD0@EAPEX1MAIL1.st.com>
Message-ID: <Pine.LNX.4.64.1102040847330.14717@axis700.grange>
References: <D5ECB3C7A6F99444980976A8C6D896384DEE2BDCD0@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bhupesh

On Fri, 4 Feb 2011, Bhupesh SHARMA wrote:

> Hi Guennadi,
> 
> We are developing a Camera Host and Sensor driver for our ST specific SoC and are
> using the soc-camera framework for the same. Our Camera Host supports a number of
> YUV, RGB formats in addition to JPEG and Mode3C(color filler mode) formats.
> 
> 1. I have a few questions regarding the pixel formats supported in enum v4l2_mbus_pixelcode.
> While formats like RGB888 and RGB8888 are supported by V4L2_PIX_FMT_* macros, I
> couldn't find corresponding support in V4L2_MBUS_FMT_* .

They should be added as required, we didn't aim at adding all possible 
formats to the list, instead we want to add them gradually one by one as 
they get used by specific drivers.

> 2. Similar is the case for JPEG format. I could see a discussion between you and QingXu for
> adding JPEG support in soc-camera framework here http://www.spinics.net/lists/linux-media/msg27980.html
> Could you please let me know if the JPEG support has already been added to the soc-camera framework or
> are there plans to add the same in near future.

It hasn't yet, maybe Qing (CC'ed) could send a patch for it to the list - 
I think, we agreed on the way how it should be done, so, it should be 
pretty easy now.

> 3. Also please let me know which formats should be reported by 
> 
> static const struct soc_mbus_pixelfmt st_camera_formats[]
> 
> in the camera host driver? Are these, the pixel formats supported by:
> 	a. Camera Host
> 	b. Camera sensor
> 	c. Or formats supported both by the Host and Sensor

In the host driver you certainly know nothing about sensor features - your 
host driver should work with "all" sensor drivers. In existing camera host 
drivers these tables are used to specify pixel formats, to which 
the host controller can convert some other formats on the hardware. E.g., 
in pxa_camera.c you find a table pxa_camera_formats[] of one element for 
the V4L2_PIX_FMT_YUV422P format. If you further look into the 
pxa_camera_get_formats() function you see, that while enumerating mediabus 
pixel codes with a certain client (e.g., a sensor), if the client supports 
the V4L2_MBUS_FMT_UYVY8_2X8 mediabus format, the host recognises, that it 
supports that format natively and apart from serving it to the application 
in the pass-through mode to provide the V4L2_PIX_FMT_UYVY format (see 
drivers/media/video/soc_mediabus.c::mbus_fmt[]), it can also convert it to 
the planar V4L2_PIX_FMT_YUV422P format. Similarly in 
sh_mobile_ceu_camera.c::sh_mobile_ceu_formats[] - if the client supports 
one of the four standard YUV 4:2:2 formats, the host can also convert it 
to any of the four NV12 / NV16 formats from the table.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
