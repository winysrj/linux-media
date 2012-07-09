Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33050 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab2GIG44 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2012 02:56:56 -0400
Received: by weyx8 with SMTP id x8so951130wey.19
        for <linux-media@vger.kernel.org>; Sun, 08 Jul 2012 23:56:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1207061639210.29809@axis700.grange>
References: <1338543105-20322-1-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1207061439090.29809@axis700.grange>
	<Pine.LNX.4.64.1207061639210.29809@axis700.grange>
Date: Mon, 9 Jul 2012 08:56:55 +0200
Message-ID: <CACKLOr07SY2KLwCA_e+-5UASsPvGxa5=aUyx-3OtSckWYrDSBA@mail.gmail.com>
Subject: Re: [PATCH v3][for_v3.5] media: mx2_camera: Fix mbus format handling
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	fabio.estevam@freescale.com, mchehab@infradead.org,
	kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 6 July 2012 17:11, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> hmm... sorry again. It is my fault, that I left this patch without
> attention for full 5 weeks, but I still don't have a sufficiently good
> feeling about it. Look here:
>
> On Fri, 6 Jul 2012, Guennadi Liakhovetski wrote:
>
>> Hi Javier
>>
>> Thanks for the patch, and sorry for delay. I was away first 10 days of
>> June and still haven't come round to cleaning up my todo list since
>> then...
>>
>> On Fri, 1 Jun 2012, Javier Martin wrote:
>
> [snip]
>
>> > @@ -1024,14 +1039,28 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
>> >             return ret;
>> >     }
>> >
>> > +   xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
>> > +   if (!xlate) {
>> > +           dev_warn(icd->parent, "Format %x not found\n", pixfmt);
>> > +           return -EINVAL;
>> > +   }
>> > +
>> > +   if (xlate->code == V4L2_MBUS_FMT_YUYV8_2X8) {
>> > +           csicr1 |= CSICR1_PACK_DIR;
>> > +           csicr1 &= ~CSICR1_SWAP16_EN;
>> > +           dev_dbg(icd->parent, "already yuyv format, don't convert\n");
>> > +   } else if (xlate->code == V4L2_MBUS_FMT_UYVY8_2X8) {
>> > +           csicr1 &= ~CSICR1_PACK_DIR;
>> > +           csicr1 |= CSICR1_SWAP16_EN;
>> > +           dev_dbg(icd->parent, "convert uyvy mbus format into yuyv\n");
>> > +   }
>
> This doesn't look right. From V4L2_MBUS_FMT_YUYV8_2X8 you can produce two
> output formats:
>
> V4L2_PIX_FMT_YUV420 and
> V4L2_PIX_FMT_YUYV
>
> For both of them you set CSICR1_PACK_DIR, which wasn't the default before?
> Next for V4L2_MBUS_FMT_UYVY8_2X8. From this one you can produce 3 formats:
>
> V4L2_PIX_FMT_YUV420,
> V4L2_PIX_FMT_YUYV and
> V4L2_PIX_FMT_UYVY
>
> For all 3 of them you now set CSICR1_SWAP16_EN. Are you sure all the above
> is correct?

No, there's just one thing wrong. With this patch, pass-through mode
for  V4L2_MBUS_FMT_UYVY8_2X8 won't work, since I always convert it to
YUYV.

Let me send a new version of the patch to address this problem.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
