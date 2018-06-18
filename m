Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:40970 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754865AbeFRGqG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 02:46:06 -0400
Received: by mail-yw0-f193.google.com with SMTP id s201-v6so5283242ywg.8
        for <linux-media@vger.kernel.org>; Sun, 17 Jun 2018 23:46:05 -0700 (PDT)
Received: from mail-yb0-f178.google.com (mail-yb0-f178.google.com. [209.85.213.178])
        by smtp.gmail.com with ESMTPSA id w6-v6sm5431011ywg.98.2018.06.17.23.46.03
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 Jun 2018 23:46:04 -0700 (PDT)
Received: by mail-yb0-f178.google.com with SMTP id m137-v6so5578949ybm.6
        for <linux-media@vger.kernel.org>; Sun, 17 Jun 2018 23:46:03 -0700 (PDT)
MIME-Version: 1.0
References: <1522376100-22098-1-git-send-email-yong.zhi@intel.com> <1522376100-22098-4-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1522376100-22098-4-git-send-email-yong.zhi@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 18 Jun 2018 15:45:51 +0900
Message-ID: <CAAFQd5A-sSubuGK0gFDnTr9+cF5D6-KJPgM-O0Uv=AJv6cztCQ@mail.gmail.com>
Subject: Re: [PATCH v6 03/12] intel-ipu3: mmu: Implement driver
To: Yong Zhi <yong.zhi@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 30, 2018 at 11:15 AM Yong Zhi <yong.zhi@intel.com> wrote:
>
> From: Tomasz Figa <tfiga@chromium.org>
>
> This driver translates IO virtual address to physical
> address based on two levels page tables.
>
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  drivers/media/pci/intel/ipu3/ipu3-mmu.c | 560 ++++++++++++++++++++++++++++++++
>  drivers/media/pci/intel/ipu3/ipu3-mmu.h |  28 ++
>  2 files changed, 588 insertions(+)
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-mmu.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-mmu.h
>
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-mmu.c b/drivers/media/pci/intel/ipu3/ipu3-mmu.c
> new file mode 100644
> index 000000000000..a4b3e1680bbb
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3-mmu.c
> @@ -0,0 +1,560 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2018 Intel Corporation.
> + * Copyright (C) 2018 Google, Inc.

I followed wrong guide when adding this one. Could you fix it up to
the following?

Copyright 2018 Google LLC.

[snip]
> +/**
> + * ipu3_mmu_exit() - clean up IPU3 MMU block
> + * @mmu: IPU3 MMU private data
> + */
> +void ipu3_mmu_exit(struct ipu3_mmu_info *info)
> +{
> +       struct ipu3_mmu *mmu = to_ipu3_mmu(info);
> +
> +       /* We are going to free our page tables, no more memory access. */
> +       ipu3_mmu_set_halt(mmu, true);
> +       ipu3_mmu_tlb_invalidate(mmu);
> +
> +       ipu3_mmu_free_page_table(mmu->l1pt);
> +       vfree(mmu->l2pts);
> +       ipu3_mmu_free_page_table(mmu->dummy_l2pt);
> +       kfree(mmu->dummy_page);

Should be free_page(). (Might be already included in your tree as per
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/1084522)

> +       kfree(mmu);
> +}
> +
> +void ipu3_mmu_suspend(struct ipu3_mmu_info *info)
> +{
> +       struct ipu3_mmu *mmu = to_ipu3_mmu(info);
> +
> +       ipu3_mmu_set_halt(mmu, true);
> +}
> +
> +void ipu3_mmu_resume(struct ipu3_mmu_info *info)
> +{
> +       struct ipu3_mmu *mmu = to_ipu3_mmu(info);
> +       u32 pteval;
> +
> +       ipu3_mmu_set_halt(mmu, true);
> +
> +       pteval = IPU3_ADDR2PTE(virt_to_phys(mmu->l1pt));
> +       writel(pteval, mmu->base + REG_L1_PHYS);
> +
> +       ipu3_mmu_tlb_invalidate(mmu);
> +       ipu3_mmu_set_halt(mmu, false);
> +}
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-mmu.h b/drivers/media/pci/intel/ipu3/ipu3-mmu.h
> new file mode 100644
> index 000000000000..4976187c18f6
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3-mmu.h
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2018 Intel Corporation */
> +/* Copyright (C) 2018 Google, Inc. */
> +
> +#ifndef __IPU3_MMU_H
> +#define __IPU3_MMU_H
> +
> +struct ipu3_mmu_info {
> +       dma_addr_t aperture_start; /* First address that can be mapped    */
> +       dma_addr_t aperture_end;   /* Last address that can be mapped     */
> +       unsigned long pgsize_bitmap;    /* Bitmap of page sizes in use */

If documenting the fields, why not use a kerneldoc comment above the
struct instead?

Best regards,
Tomasz
