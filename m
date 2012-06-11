Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:50781 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2FKU7s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 16:59:48 -0400
Date: Mon, 11 Jun 2012 22:59:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Su Jiaquan <jiaquan.lnx@gmail.com>
cc: linux-media <linux-media@vger.kernel.org>,
	twang13 <twang13@marvell.com>
Subject: Re: [media] soc_camera: suggest to postpone applying default format
In-Reply-To: <CALxrGmVo1TZTdvA_QwzjBvyA4WXYV0Cpavr5mC5d3BXCwm5CMQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1206112243590.3390@axis700.grange>
References: <CALxrGmVo1TZTdvA_QwzjBvyA4WXYV0Cpavr5mC5d3BXCwm5CMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
