Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:60811 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab3JHQV1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Oct 2013 12:21:27 -0400
Received: by mail-ee0-f51.google.com with SMTP id c1so4142873eek.10
        for <linux-media@vger.kernel.org>; Tue, 08 Oct 2013 09:21:25 -0700 (PDT)
Message-ID: <52543116.60509@googlemail.com>
Date: Tue, 08 Oct 2013 18:21:42 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx + ov2640 and v4l2-clk
References: <520E76E7.30201@googlemail.com> <74016946-c59e-4b0b-a25b-4c976f60ae43.maildroid@localhost> <5210B2A9.1030803@googlemail.com> <20130818122008.38fac218@samsung.com>
In-Reply-To: <20130818122008.38fac218@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 18.08.2013 17:20, schrieb Mauro Carvalho Chehab:
> Em Sun, 18 Aug 2013 13:40:25 +0200
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 17.08.2013 12:51, schrieb Guennadi Liakhovetski:
>>> Hi Frank,
>>> As I mentioned on the list, I'm currently on a holiday, so, replying briefly. 
>> Sorry, I missed that (can't read all mails on the list).
>>
>>> Since em28xx is a USB device, I conclude, that it's supplying clock to its components including the ov2640 sensor. So, yes, I think the driver should export a V4L2 clock.
>> Ok, so it's mandatory on purpose ?
>> I'll take a deeper into the v4l2-clk code and the
>> em28xx/ov2640/soc-camera interaction this week.
>> Have a nice holiday !
> commit 9aea470b399d797e88be08985c489855759c6c60
> Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Date:   Fri Dec 21 13:01:55 2012 -0300
>
>     [media] soc-camera: switch I2C subdevice drivers to use v4l2-clk
>     
>     Instead of centrally enabling and disabling subdevice master clocks in
>     soc-camera core, let subdevice drivers do that themselves, using the
>     V4L2 clock API and soc-camera convenience wrappers.
>     
>     Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>     Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>     Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
>
> (c/c the ones that acked with this broken changeset)
>
> We need to fix it ASAP or to revert the ov2640 changes, as some em28xx
> cameras are currently broken on 3.10.
>
> I'll also reject other ports to the async API if the drivers are
> used outside an embedded driver, as no PC driver currently defines 
> any clock source. The same applies to regulators.
>
> Guennadi,
>
> Next time, please check if the i2c drivers are used outside soc_camera
> and apply the fixes where needed, as no regressions are allowed.
>
> Regards,
> Mauro

FYI: 8 weeks have passed by now and this regression has still not been
fixed.
Does anybody care about it ? WONTFIX ?

Regards,
Frank

>> Regards,
>> Frank
>>> Thanks
>>> Guennadi
>>>
>>>
>>> -----Original Message-----
>>> From: "Frank Schäfer" <fschaefer.oss@googlemail.com>
>>> To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Linux Media Mailing List <linux-media@vger.kernel.org>
>>> Sent: Fr., 16 Aug 2013 21:03
>>> Subject: em28xx + ov2640 and v4l2-clk
>>>
>>> Hi Guennadi,
>>>
>>> since commit 9aea470b399d797e88be08985c489855759c6c60 "soc-camera:
>>> switch I2C subdevice drivers to use v4l2-clk", the em28xx driver fails
>>> to register the ov2640 subdevice (if needed).
>>> The reason is that v4l2_clk_get() fails in ov2640_probe().
>>> Does the em28xx driver have to register a (pseudo ?) clock first ?
>>>
>>> Regards,
>>> Frank
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

