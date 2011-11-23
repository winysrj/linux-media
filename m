Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48492 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab1KWKFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 05:05:42 -0500
Received: by ggnr5 with SMTP id r5so1221675ggn.19
        for <linux-media@vger.kernel.org>; Wed, 23 Nov 2011 02:05:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ECBF80C.20701@gmail.com>
References: <1321963316-9058-1-git-send-email-javier.martin@vista-silicon.com>
	<1321963316-9058-2-git-send-email-javier.martin@vista-silicon.com>
	<4ECBF80C.20701@gmail.com>
Date: Wed, 23 Nov 2011 11:05:41 +0100
Message-ID: <CACKLOr1om8qwXL_pFr+aFGCh7paH-px9+FpmKNCPJyQmjf-zvA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] MX2: Add platform definitions for eMMa-PrP device.
From: javier Martin <javier.martin@vista-silicon.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	m.szyprowski@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, shawn.guo@linaro.org,
	richard.zhao@linaro.org, fabio.estevam@freescale.com,
	kernel@pengutronix.de, s.hauer@pengutronix.de,
	r.schwebel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22 November 2011 20:29, Sylwester Nawrocki <snjw23@gmail.com> wrote:
> Hi Javier,
>> +struct platform_device *__init imx_alloc_mx2_emmaprp(
>> +             const struct imx_mx2_camera_data *data)
>> +{
>> +     struct resource res[] = {
>> +             {
>> +                     .start = data->iobaseemmaprp,
>> +                     .end = data->iobaseemmaprp + data->iosizeemmaprp - 1,
>> +                     .flags = IORESOURCE_MEM,
>> +             }, {
>> +                     .start = data->irqemmaprp,
>> +                     .end = data->irqemmaprp,
>> +                     .flags = IORESOURCE_IRQ,
>> +             },
>> +     };
>> +     struct platform_device *pdev;
>> +     int ret = -ENOMEM;
>> +
>> +     pdev = platform_device_alloc("m2m-emmaprp", 0);
>> +     if (!pdev)
>> +             goto err;
>> +
>> +     ret = platform_device_add_resources(pdev, res, ARRAY_SIZE(res));
>> +     if (ret)
>> +             goto err;
>> +
>> +     return pdev;
>> +err:
>> +     platform_device_put(pdev);
>> +     return ERR_PTR(-ENODEV);
>
> I guess you intended to have
>
> +       return ERR_PTR(ret);

Sure, thanks for the tip.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
