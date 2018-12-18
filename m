Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0892FC43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 23:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEE98218AF
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 23:50:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EOTjhSYR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbeLRXuB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 18:50:01 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34671 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727854AbeLRXuA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 18:50:00 -0500
Received: by mail-wr1-f68.google.com with SMTP id j2so17717528wrw.1
        for <linux-media@vger.kernel.org>; Tue, 18 Dec 2018 15:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fx1fe4zU1kCY0DDgG+0ToW4RVaMqfO3+mcrczkMDn8E=;
        b=EOTjhSYRR56YROHUGA5KMg6jEXtKLMzU/8ByY2tdMoc5NHWes8Iq+SBhsH7kRWcRdD
         vSFdDeXEtpRwO7xyNtyOhcDRWVZ6EQSKEet5NS4sKXUYdkGvvnc/ybNfTovYMCH1K9Yt
         QzvIEzFMvhi5xZXYYta3LNG2dlSzisdX3ic1KubZJxkc71G4i06k+vDArFXAvgCMoQ6k
         HlPT6YS7o3wSirihxo49+jas4qgaYr2iSytodKtHRQ286923wgKiQRFNXIA3i8cUp850
         +0njBaJ89FvD88e0V8p8CZYzCO+6kab2LAYhiffq51MXfItiYB928OLdBN/eU6si4IPI
         QpbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fx1fe4zU1kCY0DDgG+0ToW4RVaMqfO3+mcrczkMDn8E=;
        b=qxpefBZr8plwSMLiGSPHGrObYGsAf9Zg376EHb6NHiF0XIqvb3KTm3YFvK0JhjYaf3
         fW864y7wx0TaMaBWxcLiPN5MQnSBJ67uhc05QL7IaQhLSUxsXvsQNvmDDha+lnob8e8w
         rj1N7cQewQqeMa+h66ofolRDlDpnmfyKrAajT7iqfL8xoq/J3FhOOS1YqmLRXpuWu7p0
         2vfKN4kUtsosvZQNg8bA4SS5cnBd5PQlUAKZt0DwCgkeQ6LTeP8fzEVdMGtWIXHIAYGI
         pXSwtKl84EGzxrccpaUBI+0h2z5yUX+R8v6qql3B2tD5vN0lNd6mH8cjOSzK7mWb0a9M
         f6Zw==
X-Gm-Message-State: AA+aEWY/zf4IfwhvHcQExBlGGwZSzRlcbtxMAHsHS5XolHnX/YvzTd2k
        RWC6wpPJeuXSN1Q1D9Tev1YsuM79I4u4ThBIPbw=
X-Google-Smtp-Source: AFSGD/WsQcM241eF51ly0QxsCusv5T0sWdADn6job5nNfChCEvpZ5GFb0SG/XCGT0/aMyvSVmFR1F37DQzNtP/+GpOk=
X-Received: by 2002:adf:8506:: with SMTP id 6mr17222212wrh.128.1545176998222;
 Tue, 18 Dec 2018 15:49:58 -0800 (PST)
MIME-Version: 1.0
References: <20181206173204.21b9366e@coco.lan> <1545173976-16992-1-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1545173976-16992-1-git-send-email-brad@nextdimension.cc>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Tue, 18 Dec 2018 18:49:46 -0500
Message-ID: <CADnq5_P8-7crcjcoOqNbHgkMzk-x6nGERXPNhuW=wny0WTt3wQ@mail.gmail.com>
Subject: Re: [PATCH v2] cx23885: only reset DMA on problematic CPUs
To:     Brad Love <brad@nextdimension.cc>
Cc:     linux-media <linux-media@vger.kernel.org>, mchehab@kernel.org,
        Markus Dobel <markus.dobel@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Dec 18, 2018 at 5:59 PM Brad Love <brad@nextdimension.cc> wrote:
>
> It is reported that commit 95f408bbc4e4 ("media: cx23885: Ryzen DMA
> related RiSC engine stall fixes") caused regresssions with other CPUs.
>
> Ensure that the quirk will be applied only for the CPUs that
> are known to cause problems.
>
> A module option is added for explicit control of the behaviour.
>
> Fixes: 95f408bbc4e4 ("media: cx23885: Ryzen DMA related RiSC engine stall fixes")
>
> Signed-off-by: Brad Love <brad@nextdimension.cc>
> ---
> Changes since v1:
> - Added module option for three way control
> - Removed '7' from pci id description, Ryzen 3 is the same id
>
>  drivers/media/pci/cx23885/cx23885-core.c | 54 ++++++++++++++++++++++++++++++--
>  drivers/media/pci/cx23885/cx23885.h      |  2 ++
>  2 files changed, 54 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
> index 39804d8..fb721c7 100644
> --- a/drivers/media/pci/cx23885/cx23885-core.c
> +++ b/drivers/media/pci/cx23885/cx23885-core.c
> @@ -23,6 +23,7 @@
>  #include <linux/moduleparam.h>
>  #include <linux/kmod.h>
>  #include <linux/kernel.h>
> +#include <linux/pci.h>
>  #include <linux/slab.h>
>  #include <linux/interrupt.h>
>  #include <linux/delay.h>
> @@ -41,6 +42,18 @@ MODULE_AUTHOR("Steven Toth <stoth@linuxtv.org>");
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(CX23885_VERSION);
>
> +/*
> + * Some platforms have been found to require periodic resetting of the DMA
> + * engine. Ryzen and XEON platforms are known to be affected. The symptom
> + * encountered is "mpeg risc op code error". Only Ryzen platforms employ
> + * this workaround if the option equals 1. The workaround can be explicitly
> + * disabled for all platforms by setting to 0, the workaround can be forced
> + * on for any platform by setting to 2.
> + */
> +static unsigned int dma_reset_workaround = 1;
> +module_param(dma_reset_workaround, int, 0644);
> +MODULE_PARM_DESC(dma_reset_workaround, "periodic RiSC dma engine reset; 0-force disable, 1-driver detect (default), 2-force enable");
> +
>  static unsigned int debug;
>  module_param(debug, int, 0644);
>  MODULE_PARM_DESC(debug, "enable debug messages");
> @@ -603,8 +616,13 @@ static void cx23885_risc_disasm(struct cx23885_tsport *port,
>
>  static void cx23885_clear_bridge_error(struct cx23885_dev *dev)
>  {
> -       uint32_t reg1_val = cx_read(TC_REQ); /* read-only */
> -       uint32_t reg2_val = cx_read(TC_REQ_SET);
> +       uint32_t reg1_val, reg2_val;
> +
> +       if (!dev->need_dma_reset)
> +               return;
> +
> +       reg1_val = cx_read(TC_REQ); /* read-only */
> +       reg2_val = cx_read(TC_REQ_SET);
>
>         if (reg1_val && reg2_val) {
>                 cx_write(TC_REQ, reg1_val);
> @@ -2058,6 +2076,36 @@ void cx23885_gpio_enable(struct cx23885_dev *dev, u32 mask, int asoutput)
>         /* TODO: 23-19 */
>  }
>
> +static struct {
> +       int vendor, dev;
> +} const broken_dev_id[] = {
> +       /* According with
> +        * https://openbenchmarking.org/system/1703021-RI-AMDZEN08075/Ryzen%207%201800X/lspci,
> +        * 0x1451 is PCI ID for the IOMMU found on Ryzen
> +        */
> +       { PCI_VENDOR_ID_AMD, 0x1451 },

Does this issue only happen with the IOMMU is enabled?  Is it only for
p2p transfers?  Until recently the DMA and PCI subsystems didn't
actually support p2p properly when the IOMMU was enabled.  that might
explain some of the issues.  Additionally, if you match based on the
IOMMU id, you won't match if the user disables the IOMMU in the sbios.
Is this only an issue with the IOMMU enabled?

Alex

> +};
> +
> +static bool cx23885_does_need_dma_reset(void)
> +{
> +       int i;
> +       struct pci_dev *pdev = NULL;
> +
> +       if (dma_reset_workaround == 0)
> +               return false;
> +       else if (dma_reset_workaround == 2)
> +               return true;
> +
> +       for (i = 0; i < sizeof(broken_dev_id); i++) {
> +               pdev = pci_get_device(broken_dev_id[i].vendor, broken_dev_id[i].dev, NULL);
> +               if (pdev) {
> +                       pci_dev_put(pdev);
> +                       return true;
> +               }
> +       }
> +       return false;
> +}
> +
>  static int cx23885_initdev(struct pci_dev *pci_dev,
>                            const struct pci_device_id *pci_id)
>  {
> @@ -2069,6 +2117,8 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
>         if (NULL == dev)
>                 return -ENOMEM;
>
> +       dev->need_dma_reset = cx23885_does_need_dma_reset();
> +
>         err = v4l2_device_register(&pci_dev->dev, &dev->v4l2_dev);
>         if (err < 0)
>                 goto fail_free;
> diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
> index d54c7ee..cf965ef 100644
> --- a/drivers/media/pci/cx23885/cx23885.h
> +++ b/drivers/media/pci/cx23885/cx23885.h
> @@ -451,6 +451,8 @@ struct cx23885_dev {
>         /* Analog raw audio */
>         struct cx23885_audio_dev   *audio_dev;
>
> +       /* Does the system require periodic DMA resets? */
> +       unsigned int            need_dma_reset:1;
>  };
>
>  static inline struct cx23885_dev *to_cx23885(struct v4l2_device *v4l2_dev)
> --
> 2.7.4
>
