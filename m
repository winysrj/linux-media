Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:57783 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab1CFTNx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2011 14:13:53 -0500
Date: Sun, 6 Mar 2011 20:13:49 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Andy Walls <awalls@md.metrocast.net>
cc: "Aguirre, Sergio" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [Query] What is the best way to handle V4L2_PIX_FMT_NV12 buffers?
In-Reply-To: <1299434124.2310.12.camel@localhost>
Message-ID: <Pine.LNX.4.64.1103062008350.27091@axis700.grange>
References: <A24693684029E5489D1D202277BE89448861F7E6@dlee02.ent.ti.com>
 <1299434124.2310.12.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 6 Mar 2011, Andy Walls wrote:

> On Sat, 2011-03-05 at 22:49 -0600, Aguirre, Sergio wrote:
> > Hi,
> > 
> > I was curious in how to handle properly buffers of pixelformat V4L2_PIX_FMT_NV12.
> > 
> > I see that the standard convention for determining a bytesize of an image buffer is:
> > 
> > bytesperline * height
> > 
> > However, for NV12 case, the bytes per line is equal to the width, _but_ the actual buffer size is:
> > 
> > For the Y buffer: width * height
> > For the UV buffer: width * (height / 2)
> > Total size = width * (height + height / 2)
> > 
> > Which I think renders the bytesperline * height formula not valid for this case.
> > 
> > Any ideas how this should be properly handled?
> 
> For the HM12 macroblock format:
> 
> http://git.linuxtv.org/media_tree.git?a=blob;f=Documentation/video4linux/cx2341x/README.hm12;h=b36148ea07501bdac37ae74b31cc258150f75a81;hb=staging/for_v2.6.39
> 
> ivtv and cx18 do this in cx18-ioctl.c and ivtv-ioctl.c:
> 
> ...
> 	if (id->type == xxxx_ENC_STREAM_TYPE_YUV) {
>                 pixfmt->pixelformat = V4L2_PIX_FMT_HM12;
>                 /* YUV size is (Y=(h*720) + UV=(h*(720/2))) */
>                 pixfmt->sizeimage = pixfmt->height * 720 * 3 / 2;
>                 pixfmt->bytesperline = 720;
> 	}
> ...

Yep, the height * width formula is in no way "standard" or "compulsory" - 
that's exactly the reason why this calculation is left to the individual 
drivers. You can also look at sh_mobile_ceu_camera.c, which also supports 
this format, and effectively also calculates height * width * 3 / 2.

Thanks
Guennadi

> 
> Note that the wdith is fixed at 720 because the CX2341x chips always
> build HM12 planes assuming a width of 720, even though it isn't going to
> actually fill in the off-sceen pixels for widths less than 720.
> 
> 
> Note that "pixfmt->height * 3 / 2" is just "(height + height / 2)".
> 
> It's not a definitive answer; only an example of what two drivers do for
> a very uncommon macroblock format.
> 
> Regards,
> Andy
> 
> > NOTE: See here for more details: http://www.fourcc.org/yuv.php#NV12
> > 
> > Regards,
> > Sergio--
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
