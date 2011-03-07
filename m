Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:54928 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab1CGV3S (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 16:29:18 -0500
Date: Mon, 7 Mar 2011 22:29:16 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sergio Aguirre <saaguirre@ti.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [Query][soc_camera] How to handle hosts w/color conversion built
 in?
In-Reply-To: <4D754BD3.7090204@ti.com>
Message-ID: <Pine.LNX.4.64.1103072224460.29543@axis700.grange>
References: <4D75430E.8070001@ti.com> <Pine.LNX.4.64.1103072202070.29543@axis700.grange>
 <4D754BD3.7090204@ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 7 Mar 2011, Sergio Aguirre wrote:

> > Of course, this is supported. See sh_mobile_ceu.c, mx3_camera, pxa_camera,
> > omap1_camera. Just search for the format array defined with "static const
> > struct soc_mbus_pixelfmt" and see how it is used. Feel free to ask again,
> > if you have more questions.
> 
> Ahh... OK. I understand now :)
> 
> So, you basically first determine the count of sensor formats, by looping
> through enum_mbus_fmt in the sensor, and with every call to get_formats with
> the index range, you can return 2 or more formats.

Actually 0 or more. Usually you return 1 if you just support the sensor 
format in pass-through mode. If you return more, that usually means, that 
in addition to pass-through you can also convert that sensor format to 
some other format.

> In my case, when the sensor supports YUYV, I'll return 2 and update the xlate
> array with 2 entries, instead of just one, is that right?

Right - because you can pass YUYV 1-to-1 and also convert it to nv12.

Thanks
Guennadi

> Sorry for the noise, and thanks for the patience :)
> 
> I've been focusing more on the actual HW functionality, rather than the clean
> design. But now it's time to clean things up and prepare for upstreaming :)
> 
> Regards,
> Sergio
> 
> > 
> > Thanks
> > Guennadi
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
