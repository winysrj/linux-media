Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51332 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab3AWLFf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 06:05:35 -0500
Received: by mail-wi0-f174.google.com with SMTP id hq4so575874wib.1
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2013 03:05:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2582320.50e9nd63SM@avalon>
References: <CAJRKTVqnB6-8itbr3Cu-jnJo-zz3dYQeJ98sLnD-Eo9hvNS5iQ@mail.gmail.com>
 <2391937.KLGgbijk6r@avalon> <CAJRKTVphZiZyUTzmxaG_rU0Ba_08jRZAqADeFQNdQR+pZX1YQg@mail.gmail.com>
 <2582320.50e9nd63SM@avalon>
From: Adriano Martins <adrianomatosmartins@gmail.com>
Date: Wed, 23 Jan 2013 09:05:13 -0200
Message-ID: <CAJRKTVrDFHYFbc+Uur1AjU5=1hY7+TFsf7zcHW18LjXdn6Cj_w@mail.gmail.com>
Subject: Re: yavta - Broken pipe
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

2013/1/22 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> On Tuesday 22 January 2013 13:48:40 Adriano Martins wrote:
>> 2013/1/22 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> > On Tuesday 22 January 2013 09:31:58 Adriano Martins wrote:
>> >> Hello Laurent and all.
>> >>
>> >> Can you explain me what means the message in yavta output:
>> >>
>> >> "Unable to start streaming: Broken pipe (32)."
>> >
>> > This means that the ISP hardware pipeline hasn't been properly configured.
>>
>> well, I already configured it before, with:
>>
>> media-ctl -V '"OMAP3 ISP CCDC":2 [UYVY 640x480], "OMAP3 ISP preview":1
>> [UYVY 640x480], "OMAP3 ISP resizer":1 [UYVY 640x480]'
>> and
>> media-ctl -r -l '"ov5640 3-003c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP
>> CCDC":2->"OMAP3 ISP preview":0[1], "OMAP3 ISP \
>> preview":1->"OMAP3 ISP resizer":0[1], "OMAP3 ISP resizer":1->"OMAP3
>> ISP resizer output":0[1]'
>> Do you think it can be a hardware problem or wrong frame format from
>> sensor? Or media-ctl commands is wrong.
>
> The ISP doesn't support YUV formats at its input. If you sensor generates UYVY
> 640x480 you should capture video directly at the output of the CCDC. You will
> need a recent version of the OMAP3 ISP driver (v3.6 or newer).
>

Ok, I will try change the sensor output format, if it is not possible,
I will get the recent version of the OMAP3 ISP driver and try capture
directly from CCDC output.

>> > Unlike most V4L2 devices, the OMAP3 ISP requires userspace to configure
>> > the hardware pipeline before starting the video stream. You can do so with
>> > the media-ctl utility (available at
>> > http://git.ideasonboard.org/media-ctl.git). Plenty of examples should be
>> > available online.
>> >
>> >> I'm using omap3isp driver on DM3730 processor and a ov5640 sensor. I
>> >> configured it as parallel mode, but I can't get data from /dev/video6
>> >> (OMAP3 ISP resizer output)

Thanks
Regards
Adriano Martins
