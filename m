Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58270 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab2FLOl3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jun 2012 10:41:29 -0400
Received: by dady13 with SMTP id y13so6954762dad.19
        for <linux-media@vger.kernel.org>; Tue, 12 Jun 2012 07:41:29 -0700 (PDT)
From: "Jiaquan Su" <jiaquan.lnx@gmail.com>
To: "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>
Cc: "'linux-media'" <linux-media@vger.kernel.org>,
	"Albert Wang" <twang13@marvell.com>
References: <CALxrGmVo1TZTdvA_QwzjBvyA4WXYV0Cpavr5mC5d3BXCwm5CMQ@mail.gmail.com> <Pine.LNX.4.64.1206112243590.3390@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1206112243590.3390@axis700.grange>
Subject: RE: [media] soc_camera: suggest to postpone applying default format
Date: Tue, 12 Jun 2012 22:41:00 +0800
Message-ID: <4fd75518.4683440a.7e06.ffffa699@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8BIT
Content-Language: zh-cn
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

-----Original Message-----
From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de] 
Sent: 2012年6月12日 上午 05:00
To: Su Jiaquan
Cc: linux-media; Albert Wang
Subject: Re: [media] soc_camera: suggest to postpone applying default format

Hi Jiaquan

On Mon, 11 Jun 2012, Su Jiaquan wrote:

> Hi Guennadi,
> 
>          I found in soc_camera when video device is opened, default
> format is applied sensor. I think this is the right thing to do, be it
> also means a lot of i2c transactions.

It doesn't have to actually. It is up to the sensor (or any other client) 
driver to decide whether to apply requested formats immediately or only 
check and store them internally. Then the driver can decide to actually 
apply them only at STREAMON time. Doing this would also make the client 
driver better suitable to work outside of the soc-camera framework, where 
it will be expected to preserve its configuration across open() / close() 
cycles, possibly, without its .s_mbus_fmt() being called.

So, I would rather suggest to fix individual client drivers one by one 
instead of changing the soc-camera core, which would immediately affect 
all related drivers.

Thanks
Guennadi

> I think in case of app wants to query drivers capability, it do a
> quick “open-query-close”, expecting only to get some information
> rather than really configuring camera. So maybe this is a point that
> can be optimize.
> 
> Have you consider postpone it to some point later, how about, say,
> before stream_on? At that point we can check if VIDIOC_S_FMT is
> called, if yes, we do nothing, if no, we can configure the default
> format.
> 
>          I simply move some code from soc_camera_open() to
> soc_camera_set_fmt(), just a few changes, do you think it OK to make
> this adjustment?
> 
>          Thanks!
> Jiaquan
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

Thanks for the reply!

I think you are right, changing soc_camera core is too risky.

I took a look at the open source client drivers, it seems applying configure
as soon as set_fmt called is a common practice. So I think I'll hack
soc_camera locally on our platform.

Thanks for the help!

Jiaquan

