Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51252 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2ASOR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 09:17:57 -0500
Received: by yenm6 with SMTP id m6so1401862yen.19
        for <linux-media@vger.kernel.org>; Thu, 19 Jan 2012 06:17:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F182013.90401@mlbassoc.com>
References: <EBE38CF866F2F94F95FA9A8CB3EF2284069CAE@singex1.aptina.com>
	<201201191350.51761.laurent.pinchart@ideasonboard.com>
	<4F181711.1020201@mlbassoc.com>
	<201201191428.35340.laurent.pinchart@ideasonboard.com>
	<4F181C24.9030806@mlbassoc.com>
	<4F182013.90401@mlbassoc.com>
Date: Thu, 19 Jan 2012 15:17:57 +0100
Message-ID: <CA+2YH7vMFgzwrdBsXzBdYKG5kb8bTwtPnAnp8z_zjFFQenzzFQ@mail.gmail.com>
Subject: Re: [PATCH] Adding YUV input support for OMAP3ISP driver
From: Enrico <ebutera@users.berlios.de>
To: Gary Thomas <gary@mlbassoc.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 19, 2012 at 2:52 PM, Gary Thomas <gary@mlbassoc.com> wrote:
> On 2012-01-19 06:35, Gary Thomas wrote:
>> My camera init code is attached. In the previous kernel, the I2C bus was
>> probed implicitly when I initialized the OMAP3ISP. I thought I remembered
>> some discussion about how that worked (maybe changing), so this is
>> probably
>> where the problem starts.
>>
>> If you have an example, I can check my setup against it.
>
>
> Note: I reworked how the sensor+I2C was initialized to be
>        omap3_init_camera(&cobra3530p73_isp_platform_data);
>
>  omap_register_i2c_bus(cobra3530p73_isp_platform_data.subdevs->subdevs[0].i2c_adapter_id,
> 400,
>
>  cobra3530p73_isp_platform_data.subdevs->subdevs[0].board_info, 1);
>
> The TVP5150 is now found, but 'media-ctl -p' still dies :-(

Have a look at [1] (the linux_3.2.bb file to see the list of
patches,inside linux-3.2 directory for the actual patches), it's based
on mainline kernel 3.2 and the bt656 patches i submitted months ago,
it should be easy to adapt it for you board.

<rant>
Really, there are patches for all these problems since months (from
me, Javier, TI), but because no maintainer cared (apart from Laurent)
they were never reviewed/applied and there is always someone who comes
back with all the usual problems (additional yuv format, bt656 mode,
tvp5150 that doesn't work...).
</rant>

Enrico

[1]: https://github.com/ebutera/meta-igep/tree/master/recipes-kernel/linux
