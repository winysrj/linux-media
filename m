Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62987 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759179Ab3BGRZP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 12:25:15 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr12so2218799wgb.35
        for <linux-media@vger.kernel.org>; Thu, 07 Feb 2013 09:25:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8504007.0jva5VQ4En@avalon>
References: <CAJRKTVo279P0dqTxqoQLLpyRQYn8HNDpE6=csk1pV46E7hQp4g@mail.gmail.com>
 <8504007.0jva5VQ4En@avalon>
From: Adriano Martins <adrianomatosmartins@gmail.com>
Date: Thu, 7 Feb 2013 15:24:46 -0200
Message-ID: <CAJRKTVo74CMSSL6Yd578z6pHXiPUF5cMwJp6wNFE3SCxGfxe9A@mail.gmail.com>
Subject: Re: omap3isp - set_xclk dont work
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

2013/2/7 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Adriano,
>
> On Wednesday 06 February 2013 11:26:43 Adriano Martins wrote:
>> Hi,
>>
>> I have 2 boards with DM3730 processor, a beagleboard  and a custom board.
>> The omap3isp is working in both boards, any error is seen. On beagleboard I
>> can see the xclka, then the sensor is detected and the driver is load
>> correctly. But, in the custom board, every seem work, there are no errors
>> too. But I can't see the xclka signal.
>>
>> The hardware is ok. Because, I load another driver that uses the camera bus.
>> The xclka is working.
>>
>> it is the same processor, same kernel version, same driver. Why, it work in
>> one, and not another.
>>
>> Someone can help me? please.
>
> The XCLK clocks currently require special handling in board code, with the
> sensor calling back to board code when it wants to turn the clock on/off, and
> board code calling the set_xclk isp operation. Does your board code perform
> that operation ?

Yes, my board code has implemented the function.

I do a stupid mistake. My board code have not the mux settings in
these pins, including the XCLKA.
Now, I can see the clock.

Sorry for spend your time.

Thank you.

Regards
Adriano Martins
