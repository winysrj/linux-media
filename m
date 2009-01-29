Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49664 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754420AbZA2SfS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 13:35:18 -0500
Date: Thu, 29 Jan 2009 19:35:21 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: DongSoo Kim <dongsoo.kim@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?EUC-KR?B?x/zB2CCx6A==?= <riverful.kim@samsung.com>,
	jongse.won@samsung.com, kyungmin.park@samsung.com
Subject: Re: [V4L2] EV control API for digital camera
In-Reply-To: <5e9665e10901281824ibccbf00lcbecba5b01fdcbea@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0901291934300.5474@axis700.grange>
References: <5e9665e10901281824ibccbf00lcbecba5b01fdcbea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[removed redhat list from CC]

On Thu, 29 Jan 2009, DongSoo Kim wrote:

> Hello.
> 
> When we take pictures, sometimes we don't get satisfied with the
> exposure of picture. Too dark or too bright.
> 
> For that reason, we need to bias EV which represents Exposure Value.
> 
> So..if I want to control digital camera module with V4L2 API, which
> API should I take for EV control?
> 
> V4L2 document says that V4L2_CID_BRIGHTNESS is for picture brightness,
> but it is for "Image properties" and that "image" means the image
> frame of TV or PVR things.Am I right?

There's also V4L2_CID_EXPOSURE

> 
> If I may, can I use V4L2_CID_BRIGHTNESS for EV control of digital cameras?
> 
> or..otherwise I should make a new API for that functionality.
> 
> I'm little bit confused, because I think the brightness of picture
> could differ from exposure value of digital camera..help me ;(

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
