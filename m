Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:59192 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab1CGVFK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 16:05:10 -0500
Date: Mon, 7 Mar 2011 22:05:06 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sergio Aguirre <saaguirre@ti.com>
cc: linux-media@vger.kernel.org
Subject: Re: [Query][soc_camera] How to handle hosts w/color conversion built
 in?
In-Reply-To: <4D75430E.8070001@ti.com>
Message-ID: <Pine.LNX.4.64.1103072202070.29543@axis700.grange>
References: <4D75430E.8070001@ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 7 Mar 2011, Sergio Aguirre wrote:

> Hi Guennadi and all,
> 
> I've been trying to make my omap4 camera host driver to allow YUYV -> NV12
> color conversion, and add that to the supported host-client formats, but I
> think I have hit the wall with the host design.
> 
> I noticed that the soc_camera seems to be designed to just pass-through the
> client supported formats (i.e. if my sensor supports YUYV and JPEG, those will
> be the supported formats only)

No, this is not the case.

> Now, in my host driver, I have a feature to do a color conversion to NV12, but
> I'm still not sure on how to expand the supported formats to, say: YUYV, JPEG,
> and NV12 (which would be available only if the client outputs YUYV, of
> course).
> 
> I was trying adding a customized get_formats function, but as
> soc_camera_init_user_formats anyways depends heavly on the sensor's
> enum_mbus_fmt, it's hard to add supported formats that the sensor doesn't
> directly support.
> 
> Has this been done before? Any advice?

Of course, this is supported. See sh_mobile_ceu.c, mx3_camera, pxa_camera, 
omap1_camera. Just search for the format array defined with "static const 
struct soc_mbus_pixelfmt" and see how it is used. Feel free to ask again, 
if you have more questions.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
