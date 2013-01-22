Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60216 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab3AVP4A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 10:56:00 -0500
Received: by mail-wi0-f176.google.com with SMTP id hm6so8274616wib.3
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 07:55:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2391937.KLGgbijk6r@avalon>
References: <CAJRKTVqnB6-8itbr3Cu-jnJo-zz3dYQeJ98sLnD-Eo9hvNS5iQ@mail.gmail.com>
 <2391937.KLGgbijk6r@avalon>
From: Adriano Martins <adrianomatosmartins@gmail.com>
Date: Tue, 22 Jan 2013 13:48:40 -0200
Message-ID: <CAJRKTVphZiZyUTzmxaG_rU0Ba_08jRZAqADeFQNdQR+pZX1YQg@mail.gmail.com>
Subject: Re: yavta - Broken pipe
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

2013/1/22 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Adriano,
>
> On Tuesday 22 January 2013 09:31:58 Adriano Martins wrote:
>> Hello Laurent and all.
>>
>> Can you explain me what means the message in yavta output:
>>
>> "Unable to start streaming: Broken pipe (32)."
>
> This means that the ISP hardware pipeline hasn't been properly configured.

well, I already configured it before, with:
media-ctl -V '"OMAP3 ISP CCDC":2 [UYVY 640x480], "OMAP3 ISP preview":1
[UYVY 640x480], "OMAP3 ISP resizer":1 [UYVY 640x480]'
and
media-ctl -r -l '"ov5640 3-003c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP
CCDC":2->"OMAP3 ISP preview":0[1], "OMAP3 ISP \
preview":1->"OMAP3 ISP resizer":0[1], "OMAP3 ISP resizer":1->"OMAP3
ISP resizer output":0[1]'
Do you think it can be a hardware problem or wrong frame format from
sensor? Or media-ctl commands is wrong.

> Unlike most V4L2 devices, the OMAP3 ISP requires userspace to configure the
> hardware pipeline before starting the video stream. You can do so with the
> media-ctl utility (available at http://git.ideasonboard.org/media-ctl.git).
> Plenty of examples should be available online.
>
>> I'm using omap3isp driver on DM3730 processor and a ov5640 sensor. I
>> configured it as parallel mode, but I can't get data from /dev/video6
>> (OMAP3 ISP resizer output)
>
> --
> Regards,
>
> Laurent Pinchart
>

Regards
Adriano
