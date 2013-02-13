Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:40275 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab3BMSv3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Feb 2013 13:51:29 -0500
Received: by mail-ob0-f182.google.com with SMTP id va7so1568509obc.41
        for <linux-media@vger.kernel.org>; Wed, 13 Feb 2013 10:51:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJRKTVrDdwG=Am6KV0F5d3_ncRO_VcEkkYrBh3sGLrHCZuUvYw@mail.gmail.com>
References: <CAJRKTVoKYyJqP1mE=HTmm2jq9uoSkX9kf0HcMxz7F9wZnD1Y5w@mail.gmail.com>
 <CAJRKTVrDdwG=Am6KV0F5d3_ncRO_VcEkkYrBh3sGLrHCZuUvYw@mail.gmail.com>
From: Adriano Martins <adrianomatosmartins@gmail.com>
Date: Wed, 13 Feb 2013 16:51:08 -0200
Message-ID: <CAJRKTVryjuZwXc8CRLAK0Tb+LcSo82RYhCFgGAQoT2S-2OHJqQ@mail.gmail.com>
Subject: Re: omap3isp IRQs
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2013/2/13 Adriano Martins <adrianomatosmartins@gmail.com>:
> Hi,
>
> Please, help me :-)
>
> I trying capture frames from my new sensor, ov5640. I already capture
> images from a mt9p031 camera, but I have some problems with ov5640.
>
> Someone can explain me what are the CCDC_VD0_IRQ and CCDC_VD1_IRQ?
>
> In the mt9p031 sensor, I get all interrupts (including HS_VS_IRQ) and
> I can capture frames.
>
> In other sensor, I can't capture any frame. I get many HS_VS_IRQ only,
> then yavta app hangs and I need stop it. Then I get CCDC stop timeout!
> Is it necessary get CCDC_VD0_IRQ and CCDC_VD1_IRQ ever to capture a frame?
>
> I think all signal from ov5640 sensor are ok. A question about it:
> vsync may be in high level until the frame is transmitted? On my case
> I see just a pulse of vsync before hsync pulses. Is it correct?

I can capture frames now, and get all interrupts.
But, The image has only green color.

I have configured the CCDC module as V4L2_MBUS_FMT_UYVY8_2X8, and the sensor
output format is configured as YUV422 with sequence UYVY.

somebody has any idea?


Regards
Adriano Martins
