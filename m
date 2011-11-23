Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48488 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab1KWMcc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 07:32:32 -0500
Received: by ywt32 with SMTP id 32so1294498ywt.19
        for <linux-media@vger.kernel.org>; Wed, 23 Nov 2011 04:32:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111122205552.GO27267@pengutronix.de>
References: <1321963316-9058-1-git-send-email-javier.martin@vista-silicon.com>
	<1321963316-9058-3-git-send-email-javier.martin@vista-silicon.com>
	<20111122205552.GO27267@pengutronix.de>
Date: Wed, 23 Nov 2011 13:32:29 +0100
Message-ID: <CACKLOr0-GzO0r0ERCQvqCn2oDkDE816+MHsu=bLbA5BkEBAqYA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] MEM2MEM: Add support for eMMa-PrP mem2mem operations.
From: javier Martin <javier.martin@vista-silicon.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	m.szyprowski@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, shawn.guo@linaro.org,
	richard.zhao@linaro.org, fabio.estevam@freescale.com,
	kernel@pengutronix.de, r.schwebel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sascha,
I was just trying to fix the issues you pointed previously and I have
a question for you.

On 22 November 2011 21:55, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> Hi Javier,
>> +
>> +static int emmaprp_probe(struct platform_device *pdev)
>> +{
>> +     struct emmaprp_dev *pcdev;
>> +     struct video_device *vfd;
>> +     struct resource *res_emma;
>> +     int irq_emma;
>> +     int ret;
>> +
>> +     pcdev = kzalloc(sizeof *pcdev, GFP_KERNEL);
>> +     if (!pcdev)
>> +             return -ENOMEM;
>> +
>> +     spin_lock_init(&pcdev->irqlock);
>> +
>> +     pcdev->clk_emma = clk_get(NULL, "emma");
>
> You should change the entry for the emma in
> arch/arm/mach-imx/clock-imx27.c to the following:
>
> _REGISTER_CLOCK("m2m-emmaprp", NULL, emma_clk)
>
> and use clk_get(&pdev->dev, NULL) here.
>

Is this what you are asking for?

--- a/arch/arm/mach-imx/clock-imx27.c
+++ b/arch/arm/mach-imx/clock-imx27.c
@@ -661,7 +661,7 @@ static struct clk_lookup lookups[] = {
        _REGISTER_CLOCK(NULL, "dma", dma_clk)
        _REGISTER_CLOCK(NULL, "rtic", rtic_clk)
        _REGISTER_CLOCK(NULL, "brom", brom_clk)
-       _REGISTER_CLOCK(NULL, "emma", emma_clk)
+       _REGISTER_CLOCK("m2m-emmaprp", NULL, emma_clk)
        _REGISTER_CLOCK(NULL, "slcdc", slcdc_clk)
        _REGISTER_CLOCK("imx27-fec.0", NULL, fec_clk)
        _REGISTER_CLOCK(NULL, "emi", emi_clk)

If I do that, mx2_camera.c will stop working.
Furthermore it does not work for this driver either (I get an error on
clk_get() ).

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
