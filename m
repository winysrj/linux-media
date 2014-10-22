Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:52448 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbaJVDRF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 23:17:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXDKP=KDzGUqXuPLirPX6Y4BA-n4RC8kdx-8A-e=fa4MQ@mail.gmail.com>
References: <1413267956-8342-1-git-send-email-ykaneko0929@gmail.com>
	<544280E4.20101@cogentembedded.com>
	<CAH1o70JoiJhec6thnQZnQ_99DLjhMrYhypFubkDYNnTcP_02ZQ@mail.gmail.com>
	<CAMuHMdXDKP=KDzGUqXuPLirPX6Y4BA-n4RC8kdx-8A-e=fa4MQ@mail.gmail.com>
Date: Wed, 22 Oct 2014 12:17:04 +0900
Message-ID: <CAH1o70KKBObHxZ+Y2++tgJ4ac=MxvyYoSNe-=d=vxo2OV=YnHw@mail.gmail.com>
Subject: Re: [PATCH] media: soc_camera: rcar_vin: Enable VSYNC field toggle mode
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert-san,

2014-10-21 16:09 GMT+09:00 Geert Uytterhoeven <geert@linux-m68k.org>:
> Hi Kaneko-san,
>
> On Tue, Oct 21, 2014 at 5:30 AM, Yoshihiro Kaneko <ykaneko0929@gmail.com> wrote:
>>>> --- a/drivers/media/platform/soc_camera/rcar_vin.c
>>>> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
>>>> @@ -108,6 +108,7 @@
>>>>   #define VNDMR2_VPS            (1 << 30)
>>>>   #define VNDMR2_HPS            (1 << 29)
>>>>   #define VNDMR2_FTEV           (1 << 17)
>>>> +#define VNDMR2_VLV_1           (1 << 12)
>>>
>>>    Please instead do:
>>>
>>> #define VNDMR2_VLV(n)   ((n & 0xf) << 12)
>>
>> It's unclear to me why the style of the new #define should differ
>> from those of the existing ones.
>
> I think Sergey wants to say that unlike for the other fields, there are
> multiple possible values for the VLV field.
>
> By providing the single macro definition
>
>         #define VNDMR2_VLV(n)   ((n & 0xf) << 12)
>
> you can easily provide a way to set any of VNDMR2_VLV_n.
>
> I hope this explanation makes it clearer.

Thank you for the clarification!
I'll update this patch sooner.

Thanks,
Kaneko

>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
