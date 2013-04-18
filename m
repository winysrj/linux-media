Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:37061 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965239Ab3DRO2e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 10:28:34 -0400
Received: by mail-la0-f47.google.com with SMTP id fk20so2323147lab.6
        for <linux-media@vger.kernel.org>; Thu, 18 Apr 2013 07:28:33 -0700 (PDT)
Message-ID: <517002CC.2000807@cogentembedded.com>
Date: Thu, 18 Apr 2013 18:27:24 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: g.liakhovetski@gmx.de, mchehab@redhat.com,
	linux-media@vger.kernel.org
CC: magnus.damm@gmail.com, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com, matsu@igel.co.jp,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Subject: Re: [PATCH 1/4] V4L2: soc_camera: Renesas R-Car VIN driver
References: <201304180206.39465.sergei.shtylyov@cogentembedded.com> <201304180211.13992.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201304180211.13992.sergei.shtylyov@cogentembedded.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18-04-2013 2:11, Sergei Shtylyov wrote:

> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

> Add Renesas R-Car VIN (Video In) V4L2 driver.

> Based on the patch by Phil Edworthy <phil.edworthy@renesas.com>.

> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> [Sergei: some formatting cleanup]
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

[...]

> +static int rcar_vin_probe(struct platform_device *pdev)
> +{
[...]
> +	ret = devm_request_irq(&pdev->dev, irq, rcar_vin_irq, IRQF_DISABLED,

    I forgot that this flag is deprecated now. Also we need to pass IRQF_SHARED
for the VIN driver to work on R8A7778 where VIN0/1 share the IRQ.

WBR, Sergei

