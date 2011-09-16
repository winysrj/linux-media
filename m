Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:58131 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab1IPIrv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Sep 2011 04:47:51 -0400
Date: Fri, 16 Sep 2011 10:46:42 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Scott Jiang <scott.jiang.linux@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 4/4] v4l2: add blackfin capture bridge driver
In-Reply-To: <CAHG8p1DS2UcJ16YuMaeK4B7=D3GH-sbwwoBC8fwhovV9Sgu-zA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1109161023080.28447@axis700.grange>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
 <1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
 <Pine.LNX.4.64.1109130943021.17902@axis700.grange>
 <CAHG8p1AYXg9zHjoYk6H1pGwUnSzmBTvazWDJuco8nQbFkHOtuw@mail.gmail.com>
 <Pine.LNX.4.64.1109131312370.17902@axis700.grange>
 <CAHG8p1DS2UcJ16YuMaeK4B7=D3GH-sbwwoBC8fwhovV9Sgu-zA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 16 Sep 2011, Scott Jiang wrote:

> 2011/9/13 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> > On Tue, 13 Sep 2011, Scott Jiang wrote:
> >
> >> >> +
> >> >> +struct bcap_format {
> >> >> +     u8 *desc;
> >> >> +     u32 pixelformat;
> >> >> +     enum v4l2_mbus_pixelcode mbus_code;
> >> >> +     int bpp; /* bytes per pixel */
> >> >
> >> > Don't you think you might have to process 12 bpp formats at some point,
> >> > like YUV 4:2:0, or NV12? Maybe better calculate in bits from the beginning?
> >> >
> ppi only stores raw format into memory. I wonder if there is sensor
> transmit data in planar format?
> If planar format only exists in memory, I think I don't need to modify this.

There are also packed 12-bit formats, like yuv 4:1:1 (V4L2_PIX_FMT_Y41P).

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
