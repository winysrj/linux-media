Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:54749 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3AGF4W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 00:56:22 -0500
Received: by mail-wg0-f46.google.com with SMTP id dr13so9054703wgb.13
        for <linux-media@vger.kernel.org>; Sun, 06 Jan 2013 21:56:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130106113455.329ad868@redhat.com>
References: <20130106113455.329ad868@redhat.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 7 Jan 2013 11:26:01 +0530
Message-ID: <CA+V-a8tD5AEV4EseDky=sdWXKqsCyASk96wwxF=-ZmNQOUcJaA@mail.gmail.com>
Subject: Re: Status of the patches under review at LMML (35 patches)
To: Mauro Carvalho Chehab <mchehab@redhat.com>, tomi.valkeinen@ti.com
Cc: LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sun, Jan 6, 2013 at 7:04 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> This is the summary of the patches that are currently under review at
> Linux Media Mailing List <linux-media@vger.kernel.org>.
> Each patch is represented by its submission date, the subject (up to 70
> chars) and the patchwork link (if submitted via email).
>
<Snip>

>
>                 == Prabhakar Lad <prabhakar.lad@ti.com> ==
>
> Aug,24 2012: Corrected Oops on omap_vout when no manager is connected               http://patchwork.linuxtv.org/patch/14033  Federico Fuga <fuga@studiofuga.com>

Tomi can you take care of this patch ?

> Oct,22 2012: [media] davinci: vpbe: fix missing unlock on error in vpbe_initialize( http://patchwork.linuxtv.org/patch/15106  Wei Yongjun <yongjun_wei@trendmicro.com.cn>
This can be marked as 'Accepted'.

> Oct,24 2012: [media] vpif_display: fix return value check in vpif_reqbufs()         http://patchwork.linuxtv.org/patch/15167  Wei Yongjun <yongjun_wei@trendmicro.com.cn>
This patch can be marked as 'Superseded'.

Regards,
--Prabhakar
>
>                 == Maxim Levitsky <maximlevitsky@gmail.com> ==
>
> Oct,15 2012: [1/4,media] ene-ir: Fix cleanup on probe failure                       http://patchwork.linuxtv.org/patch/15024  Matthijs Kooijman <matthijs@stdin.nl>
>
>                 == Guennadi Liakhovetski <g.liakhovetski@gmx.de> ==
>
> Oct,30 2012: [v2,2/4] media: mx2_camera: Add image size HW limits.                  http://patchwork.linuxtv.org/patch/15298  Javier Martin <javier.martin@vista-silicon.com>
> Nov,13 2012: sh_vou: Move from videobuf to videobuf2                                http://patchwork.linuxtv.org/patch/15433  Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Nov,16 2012: [05/14,media] atmel-isi: Update error check for unsigned variables     http://patchwork.linuxtv.org/patch/15475  Tushar Behera <tushar.behera@linaro.org>
> Jan, 3 2013: [1/3] sh_vou: Don't modify const variable in sh_vou_s_crop()           http://patchwork.linuxtv.org/patch/16095  Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Jan, 3 2013: [2/3] sh_vou: Use video_drvdata()                                      http://patchwork.linuxtv.org/patch/16097  Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Jan, 3 2013: [3/3] sh_vou: Use vou_dev instead of vou_file wherever possible        http://patchwork.linuxtv.org/patch/16096  Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>
>                 == Laurent Pinchart <laurent.pinchart@ideasonboard.com> ==
>
> Dec,12 2012: [v2] ad5820: Voice coil motor controller driver                        http://patchwork.linuxtv.org/patch/15881  Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
> Jan, 4 2013: omap3isp: Add support for interlaced input data                        http://patchwork.linuxtv.org/patch/16133  William Swanson <william.swanson@fuel7.com>
> Sep, 4 2012: [5/5] drivers/media/platform/omap3isp/isp.c: fix error return code     http://patchwork.linuxtv.org/patch/14169  Peter Senna Tschudin <peter.senna@gmail.com>
>
>                 == Sylwester Nawrocki <s.nawrocki@samsung.com> ==
>
> Dec,28 2012: [1/3,media] s5p-mfc: use mfc_err instead of printk                     http://patchwork.linuxtv.org/patch/16012  Sachin Kamat <sachin.kamat@linaro.org>
> Jan, 6 2013: s5p-tv: mixer: fix handling of VIDIOC_S_FMT                            http://patchwork.linuxtv.org/patch/16143  Tomasz Stanislawski <t.stanislaws@samsung.com>
>
>                 == Marek Szyprowski <m.szyprowski@samsung.com> ==
>
> Nov,12 2012: [media] videobuf2-core: print current state of buffer in vb2_buffer_do http://patchwork.linuxtv.org/patch/15420  Tushar Behera <tushar.behera@linaro.org>
>
>                 == Sascha Hauer <s.hauer@pengutronix.de> ==
>
> Sacha is returing next week. He should be addressing this issue
> by them:
> Nov,14 2012: [media] coda: Fix build due to iram.h rename                           http://patchwork.linuxtv.org/patch/15447  Fabio Estevam <fabio.estevam@freescale.com>
>
>                 == Mauro Carvalho Chehab <mchehab@redhat.com> ==
>
> Those are my own RFC patches. I should rework the QoS patches next
> week/weekend:
>
> Dec,28 2012: [RFCv3] dvb: Add DVBv5 properties for quality parameters               http://patchwork.linuxtv.org/patch/16026  Mauro Carvalho Chehab <mchehab@redhat.com>
> Dec,28 2012: [RFC, media] dvb: frontend API: Add a flag to indicate that get_fronte http://patchwork.linuxtv.org/patch/16024  Mauro Carvalho Chehab <mchehab@redhat.com>
> Jan, 1 2013: [RFCv3] dvb: Add DVBv5 properties for quality parameters               http://patchwork.linuxtv.org/patch/16053  Mauro Carvalho Chehab <mchehab@redhat.com>
>
>
> Number of pending patches per reviewer:
>   Manu Abraham <abraham.manu@gmail.com>                                 : 11
>   Guennadi Liakhovetski <g.liakhovetski@gmx.de>                         : 6
>   LinuxTV community                                                     : 4
>   Laurent Pinchart <laurent.pinchart@ideasonboard.com>                  : 3
>   Mauro Carvalho Chehab <mchehab@redhat.com>                            : 3
>   Prabhakar Lad <prabhakar.lad@ti.com>                                  : 3
>   Sylwester Nawrocki <s.nawrocki@samsung.com>                           : 2
>   Sascha Hauer <s.hauer@pengutronix.de>                                 : 1
>   Maxim Levitsky <maximlevitsky@gmail.com>                              : 1
>   Marek Szyprowski <m.szyprowski@samsung.com>                           : 1
>
> Cheers,
> Mauro
>
> ---
>
> If you discover any patch submitted via email that weren't caught by
> kernel.patchwork.org, this means that the patch got mangled by your emailer.
> The more likely cause is that the emailer converted tabs into spaces or broke
> long lines. Please fix your emailer and re-send.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
