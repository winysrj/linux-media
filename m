Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	T_MIXED_ES,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE5DC67839
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 01:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 950A92086D
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 01:09:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=jms.id.au header.i=@jms.id.au header.b="A0poBn2e"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 950A92086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jms.id.au
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbeLNBJ1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 20:09:27 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44143 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727638AbeLNBJ0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 20:09:26 -0500
Received: by mail-qk1-f196.google.com with SMTP id n12so2338960qkh.11;
        Thu, 13 Dec 2018 17:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3eJr9O2aEYMtTU2WSqrQ760DaZO5yOh27Q66lC6WD6o=;
        b=A0poBn2eU7av0AnRm78Woeuk+Jf1RBUkCyfebNS/knU8HrQnk+xr2HryPF2xIvWmJv
         GK/OnqDscytSX8ixiGzz6BX38Ygc+BxJVouY/l99KGE1yIJ/WMpJszPfUqbKY0cu2y5I
         VUcrEgaRXbBVrEHo8XmuOlK1v+3sI2Y7fUqyo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3eJr9O2aEYMtTU2WSqrQ760DaZO5yOh27Q66lC6WD6o=;
        b=JQxgCdtWP/TL0Yk1+qUPpg3O9sgmeSniUlffNWiNBYAdUsJGvq4mudNhxixGlAEk76
         Uo5NfMc8khVYOUSYvf82nnZxjROp6mVuTuomEX/2F/+IELM9dxTeM1wCLXmJOi/ly1PS
         RkAcJyRoGU2wr2HmDZ53mmGPMru6MFvVN1RC5cSzSyjCEsMIEXUmlbZovYbxeB3OAVO6
         G47A6mjL5dpLdEHAp2mD55BIdP/jHHOCEUIaVSR+hjHzzGkq6AuF8MZ4owmp0DTT0pew
         1Fa8mNPsqK7NNOHrFaOQGOpQUxvPjnwCWlPtkj2BYIi4oZWlhVn5vN2mhemeFjbCHYyB
         YxKA==
X-Gm-Message-State: AA+aEWYusX6FUC8fGMvyZeiTuINu5WQ88LSOJ5DK1ia3HXzR0W0/Eksq
        VqPja5gK+ZmVIXOOAGuPQ3Fc4GioHEqTZ4fIi5A=
X-Google-Smtp-Source: AFSGD/VVR5PQhOAKZ+xnZSIzeLQmYHIIZL4k4aS+V7bDK32MftEs8KWvpAY1pB5h7vkchuu/GJFMl04wtO3DoNsUOTo=
X-Received: by 2002:a37:781:: with SMTP id 123mr887498qkh.231.1544749765265;
 Thu, 13 Dec 2018 17:09:25 -0800 (PST)
MIME-Version: 1.0
References: <1544547421-25724-1-git-send-email-eajames@linux.ibm.com> <1544547421-25724-3-git-send-email-eajames@linux.ibm.com>
In-Reply-To: <1544547421-25724-3-git-send-email-eajames@linux.ibm.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Fri, 14 Dec 2018 11:39:14 +1030
Message-ID: <CACPK8XdQbq-9MbP7uMemyp0=Q+t1qnWNREdZRiyEcrART9vRig@mail.gmail.com>
Subject: Re: [PATCH v8 2/2] media: platform: Add Aspeed Video Engine driver
To:     eajames@linux.ibm.com
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-aspeed@lists.ozlabs.org, hverkuil@xs4all.nl,
        Rob Herring <robh+dt@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, 12 Dec 2018 at 04:09, Eddie James <eajames@linux.ibm.com> wrote:
>
> The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
> can capture and compress video data from digital or analog sources. With
> the Aspeed chip acting a service processor, the Video Engine can capture
> the host processor graphics output.

> +ASPEED VIDEO ENGINE DRIVER
> +M:     Eddie James <eajames@linux.ibm.com>
> +L:     linux-media@vger.kernel.org
> +L:     openbmc@lists.ozlabs.org (moderated for non-subscribers)

We tend to use the linux-aspeed list for upstream kernel discussions.
Up to you if you want to use the openbmc list though.

>  source "drivers/media/platform/omap/Kconfig"
>
> +config VIDEO_ASPEED
> +       tristate "Aspeed AST2400 and AST2500 Video Engine driver"
> +       depends on VIDEO_V4L2
> +       select VIDEOBUF2_DMA_CONTIG
> +       help
> +         Support for the Aspeed Video Engine (VE) embedded in the Aspeed
> +         AST2400 and AST2500 SOCs. The VE can capture and compress video data
> +         from digital or analog sources.

This might need updating in response to my questions below about
ast2400 testing.

> +++ b/drivers/media/platform/aspeed-video.c
> @@ -0,0 +1,1729 @@
> +// SPDX-License-Identifier: GPL-2.0+

You need to put this there as well:

// Copyright 2018 IBM Corp


> +static int aspeed_video_init(struct aspeed_video *video)
> +{
> +       int irq;
> +       int rc;
> +       struct device *dev = video->dev;
> +
> +       irq = irq_of_parse_and_map(dev->of_node, 0);
> +       if (!irq) {
> +               dev_err(dev, "Unable to find IRQ\n");
> +               return -ENODEV;
> +       }
> +
> +       rc = devm_request_irq(dev, irq, aspeed_video_irq, IRQF_SHARED,

The datasheet indicates this IRQ is for the video engline only, so I
don't think you want IRQF_SHARED.

> +                             DEVICE_NAME, video);
> +       if (rc < 0) {
> +               dev_err(dev, "Unable to request IRQ %d\n", irq);
> +               return rc;
> +       }
> +
> +       video->eclk = devm_clk_get(dev, "eclk");
> +       if (IS_ERR(video->eclk)) {
> +               dev_err(dev, "Unable to get ECLK\n");
> +               return PTR_ERR(video->eclk);
> +       }
> +
> +       video->vclk = devm_clk_get(dev, "vclk");
> +       if (IS_ERR(video->vclk)) {
> +               dev_err(dev, "Unable to get VCLK\n");
> +               return PTR_ERR(video->vclk);
> +       }
> +
> +       video->rst = devm_reset_control_get_exclusive(dev, NULL);
> +       if (IS_ERR(video->rst)) {
> +               dev_err(dev, "Unable to get VE reset\n");
> +               return PTR_ERR(video->rst);
> +       }

As discussed in the clock driver, this can go as you've already
released the reset when enabling the eclk.

However, you're requesting the clock without enabling it. You need to
do a clk_prepare_enable().

> +
> +       rc = of_reserved_mem_device_init(dev);
> +       if (rc) {
> +               dev_err(dev, "Unable to reserve memory\n");
> +               return rc;
> +       }
> +
> +       rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
> +       if (rc) {
> +               dev_err(dev, "Failed to set DMA mask\n");
> +               of_reserved_mem_device_release(dev);
> +               return rc;
> +       }
> +
> +       if (!aspeed_video_alloc_buf(video, &video->jpeg,
> +                                   VE_JPEG_HEADER_SIZE)) {
> +               dev_err(dev, "Failed to allocate DMA for JPEG header\n");
> +               of_reserved_mem_device_release(dev);
> +               return rc;
> +       }
> +
> +       aspeed_video_init_jpeg_table(video->jpeg.virt, video->yuv420);
> +
> +       return 0;
> +}

> +
> +static const struct of_device_id aspeed_video_of_match[] = {
> +       { .compatible = "aspeed,ast2400-video-engine" },

I noticed the clock driver did not have the changed required for the
2400. Have you tested this on the ast2400?


> +       { .compatible = "aspeed,ast2500-video-engine" },
> +       {}
> +};
> +MODULE_DEVICE_TABLE(of, aspeed_video_of_match);
> +
> +static struct platform_driver aspeed_video_driver = {
> +       .driver = {
> +               .name = DEVICE_NAME,
> +               .of_match_table = aspeed_video_of_match,
> +       },
> +       .probe = aspeed_video_probe,
> +       .remove = aspeed_video_remove,
> +};
