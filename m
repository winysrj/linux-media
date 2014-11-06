Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:62318 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaKFVzj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Nov 2014 16:55:39 -0500
Date: Thu, 6 Nov 2014 22:55:35 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kassey <kassey1216@gmail.com>
cc: "d.belimov" <d.belimov@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: SPI interface camera sensor driver for soc_camera framework
In-Reply-To: <CAKwPUozkONwkRia6issvfO9S99ZTLC63rAJLvXXz-D2oCiT21Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1411062249210.25946@axis700.grange>
References: <CAKwPUozkONwkRia6issvfO9S99ZTLC63rAJLvXXz-D2oCiT21Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kassey,

On Mon, 27 Oct 2014, Kassey wrote:

> hi, Dmitri:
>     is there any sample driver for SPI interface camera sensor driver
> base don soc_camera framework, other than the i2c interface ?

Currently there are no SPI drivers, used with the soc-camera framework. 
There is however an example of a non-I2C subdevice driver in soc-camera: 
the soc_camera_platform.c driver. You'll see handling of non-I2C 
subdevices in soc_camera_probe() in soc_camera.c. However, that driver 
hasn't been used since a long time and might well be broken by now. Also, 
many newer code paths in soc-camera core unfortunately began to assume, 
that I2C is the only way to access subdevices. So, I suspect fixes might 
be needed when adding support for SPI subdevices.

Thanks
Guennadi
