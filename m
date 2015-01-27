Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42332 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbbA0CO3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2015 21:14:29 -0500
Received: by mail-wg0-f46.google.com with SMTP id l2so12272020wgh.5
        for <linux-media@vger.kernel.org>; Mon, 26 Jan 2015 18:14:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1411062249210.25946@axis700.grange>
References: <CAKwPUozkONwkRia6issvfO9S99ZTLC63rAJLvXXz-D2oCiT21Q@mail.gmail.com>
	<Pine.LNX.4.64.1411062249210.25946@axis700.grange>
Date: Tue, 27 Jan 2015 10:14:28 +0800
Message-ID: <CAKwPUowp8MEmvAdLgkqPw-ZXSrAyF+a7PqdKcqVsJp4MxXgbRg@mail.gmail.com>
Subject: Re: SPI interface camera sensor driver for soc_camera framework
From: Kassey <kassey1216@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "d.belimov" <d.belimov@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi:
      I am working on a SPI interface camera sensor now, trying to
work out a patch for soc_camera for you to review.

     thanks.

Kassey

2014-11-07 5:55 GMT+08:00 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> Hi Kassey,
>
> On Mon, 27 Oct 2014, Kassey wrote:
>
>> hi, Dmitri:
>>     is there any sample driver for SPI interface camera sensor driver
>> base don soc_camera framework, other than the i2c interface ?
>
> Currently there are no SPI drivers, used with the soc-camera framework.
> There is however an example of a non-I2C subdevice driver in soc-camera:
> the soc_camera_platform.c driver. You'll see handling of non-I2C
> subdevices in soc_camera_probe() in soc_camera.c. However, that driver
> hasn't been used since a long time and might well be broken by now. Also,
> many newer code paths in soc-camera core unfortunately began to assume,
> that I2C is the only way to access subdevices. So, I suspect fixes might
> be needed when adding support for SPI subdevices.
>
> Thanks
> Guennadi



-- 
Best regards
Kassey
