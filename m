Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:44334 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab3HRLiD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Aug 2013 07:38:03 -0400
Received: by mail-ea0-f178.google.com with SMTP id a15so1756138eae.23
        for <linux-media@vger.kernel.org>; Sun, 18 Aug 2013 04:38:01 -0700 (PDT)
Message-ID: <5210B2A9.1030803@googlemail.com>
Date: Sun, 18 Aug 2013 13:40:25 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx + ov2640 and v4l2-clk
References: <520E76E7.30201@googlemail.com> <74016946-c59e-4b0b-a25b-4c976f60ae43.maildroid@localhost>
In-Reply-To: <74016946-c59e-4b0b-a25b-4c976f60ae43.maildroid@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 17.08.2013 12:51, schrieb Guennadi Liakhovetski:
> Hi Frank,
> As I mentioned on the list, I'm currently on a holiday, so, replying briefly. 
Sorry, I missed that (can't read all mails on the list).

> Since em28xx is a USB device, I conclude, that it's supplying clock to its components including the ov2640 sensor. So, yes, I think the driver should export a V4L2 clock.
Ok, so it's mandatory on purpose ?
I'll take a deeper into the v4l2-clk code and the
em28xx/ov2640/soc-camera interaction this week.
Have a nice holiday !

Regards,
Frank
> Thanks
> Guennadi
>
>
> -----Original Message-----
> From: "Frank Schäfer" <fschaefer.oss@googlemail.com>
> To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Linux Media Mailing List <linux-media@vger.kernel.org>
> Sent: Fr., 16 Aug 2013 21:03
> Subject: em28xx + ov2640 and v4l2-clk
>
> Hi Guennadi,
>
> since commit 9aea470b399d797e88be08985c489855759c6c60 "soc-camera:
> switch I2C subdevice drivers to use v4l2-clk", the em28xx driver fails
> to register the ov2640 subdevice (if needed).
> The reason is that v4l2_clk_get() fails in ov2640_probe().
> Does the em28xx driver have to register a (pseudo ?) clock first ?
>
> Regards,
> Frank

