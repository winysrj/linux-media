Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:63371 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab3HDVCp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Aug 2013 17:02:45 -0400
Date: Sun, 4 Aug 2013 23:02:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Su Jiaquan <jiaquan.lnx@gmail.com>
cc: linux-media <linux-media@vger.kernel.org>, jqsu@marvell.com,
	xzhao10@marvell.com
Subject: Re: How to express planar formats with mediabus format code?
In-Reply-To: <CALxrGmW86b4983Ud5hftjpPkc-KpcPTWiMeDEf1-zSt5POsHBg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1308042252010.19244@axis700.grange>
References: <CALxrGmW86b4983Ud5hftjpPkc-KpcPTWiMeDEf1-zSt5POsHBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Su Jiaquan

On Sun, 4 Aug 2013, Su Jiaquan wrote:

> Hi,
> 
> I know the title looks crazy, but here is our problem:
> 
> In our SoC based ISP, the hardware can be divide to several blocks.
> Some blocks can do color space conversion(raw to YUV
> interleave/planar), others can do the pixel
> re-order(interleave/planar/semi-planar conversion, UV planar switch).
> We use one subdev to describe each of them, then came the problem: How
> can we express the planar formats with mediabus format code?

Could you please explain more exactly what you mean? How are those your 
blocks connected? How do they exchange data? If they exchange data over a 
serial bus, then I don't think planar formats make sense, right? Or do 
your blocks really output planes one after another, reordering data 
internally? That would be odd... If OTOH your blocks output data to RAM, 
and the next block takes data from there, then you use V4L2_PIX_FMT_* 
formats to describe them and any further processing block should be a 
mem2mem device. Wouldn't this work?

Thanks
Guennadi

> I understand at beginning, media-bus was designed to describe the data
> link between camera sensor and camera controller, where sensor is
> described in subdev. So interleave formats looks good enough at that
> time. But now as Media-controller is introduced, subdev can describe a
> much wider range of hardware, which is not limited to camera sensor.
> So now planar formats are possible to be passed between subdevs.
> 
> I think the problem we meet can be very common for SoC based ISP
> solutions, what do you think about it?
> 
> there are many possible solution for it:
> 
> 1> change the definition of v4l2_subdev_format::format, use v4l2_format;
> 
> 2> extend the mediabus format code, add planar format code;
> 
> 3> use a extra bit to tell the meaning of v4l2_mbus_framefmt::code, is
> it in mediabus-format or in fourcc
> 
>  Do you have any suggestions?
> 
>  Thanks a lot!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
