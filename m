Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab0DWMWk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Apr 2010 08:22:40 -0400
Message-ID: <4BD1910B.40400@redhat.com>
Date: Fri, 23 Apr 2010 09:22:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Bee Hock Goh <beehock@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Help needed in understanding v4l2_device_call_all
References: <x2m6e8e83e21004062310ia0eef09fgf97bcfafcdf25737@mail.gmail.com>	 <4BD0B32B.8060505@redhat.com> <i2k6e8e83e21004221920q3f687324z8d8aba7ca26978ad@mail.gmail.com>
In-Reply-To: <i2k6e8e83e21004221920q3f687324z8d8aba7ca26978ad@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bee Hock Goh wrote:
> Mauro,
> 
> Thanks.
> 
> Previously, I have done some limited test and it seem that
> xc2028_signal seem to be getting the correct registered value for the
> detected a signal locked.

With the i2c reads working perfectly, it should be already providing the
signal strength with the current code. Dmitri submitted an interesting
patch that it is probably improving the i2c code. It is a worthy trial.

> Since I am now able to get video working(though somewhat limited since
> it still crashed if i change channel from mythtv), i will be spending
> more time to look getting a lock on the signal.

There are still troubles on video. I tested yesterday, and it still crashing.
Tested on a tm6010 device. Unfortunately, some patch broke support for my
10moons device: it is now failing when reading the firmware. Probably, the
GPIO code is wrong.

> Is line 139,140,155,156 needed? Its slowing down the loading of
> firmware and it working for me with the additional register setting.
> 
>  138 if (addr == dev->tuner_addr << 1) {
> 139 tm6000_set_reg(dev, 0x32, 0,0);
> 140 tm6000_set_reg(dev, 0x33, 0,0);

On my tests with HVR-950H, it makes no difference. Probably, Dmitri approach
should be enough, but it won't solve the slow down, as it adds some delay
on i2c operations.

Cheers,
Mauro
