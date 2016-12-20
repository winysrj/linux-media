Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:12407 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752329AbcLTL6P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Dec 2016 06:58:15 -0500
Subject: Re: [PATCH 0/2] s5p-mfc fix for using reserved memory
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kyungmin.park@samsung.com, jtp.park@samsung.com,
        mchehab@kernel.org, mchehab@osg.samsung.com,
        hans.verkuil@cisco.com, krzk@kernel.org, kgene@kernel.org,
        javier@osg.samsung.com
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <ea03c72a-a0f4-46e6-bd29-474549a0f145@samsung.com>
Date: Tue, 20 Dec 2016 12:58:08 +0100
MIME-version: 1.0
In-reply-to: <1481888915-19624-1-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
References: <CGME20161216115004epcas1p276eddca803dcafe3470e223386b86da0@epcas1p2.samsung.com>
 <1481888915-19624-1-git-send-email-pankaj.dubey@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pankaj


On 2016-12-16 12:48, Pankaj Dubey wrote:
> It has been observed on ARM64 based Exynos SoC, if IOMMU is not enabled
> and we try to use reserved memory for MFC, reqbufs fails with below
> mentioned error
> ---------------------------------------------------------------------------
> V4L2 Codec decoding example application
> Kamil Debski <k.debski@samsung.com>
> Copyright 2012 Samsung Electronics Co., Ltd.
>
> Opening MFC.
> (mfc.c:mfc_open:58): MFC Info (/dev/video0): driver="s5p-mfc" \
> bus_info="platform:12c30000.mfc0" card="s5p-mfc-dec" fd=0x4[
> 42.339165] Remapping memory failed, error: -6
>
> MFC Open Success.
> (main.c:main:711): Successfully opened all necessary files and devices
> (mfc.c:mfc_dec_setup_output:103): Setup MFC decoding OUTPUT buffer \
> size=4194304 (requested=4194304)
> (mfc.c:mfc_dec_setup_output:120): Number of MFC OUTPUT buffers is 2 \
> (requested 2)
>
> [App] Out buf phy : 0x00000000, virt : 0xffffffff
> Output Length is = 0x300000
> Error (mfc.c:mfc_dec_setup_output:145): Failed to MMAP MFC OUTPUT buffer
> -------------------------------------------------------------------------
> This is because the device requesting for memory is mfc0.left not the parent mfc0.
> Hence setting of alloc_devs need to be done only if IOMMU is enabled
> and in that case both the left and right device is treated as mfc0 only.
> Also we need to populate vb2_queue's dev pointer with mfc dev pointer.

I also got this issue but Your solution is imho not the proper approach.
Too much hacking in the driver, while the issue is in the core. ARM64 
requires
to call arch_setup_dma_ops() for each device that will be used for 
dma-mapping.
So the issue is in drivers/of/of_reserved_mem.c - in
of_reserved_mem_device_init_by_idx() function, which should ensure that
arch_setup_dma_ops() is called also for the virtual devices for reserved 
memory.

s5p-mfc driver however still requires some patching for 
dma-mapping/iommu glue
used on ARM64 architecture.

> Smitha T Murthy (2):
>    media: s5p-mfc: convert drivers to use the new vb2_queue dev field
>    media: s5p-mfc: fix MMAP of mfc buffer during reqbufs
>
>   drivers/media/platform/s5p-mfc/s5p_mfc.c     |  2 ++
>   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 17 ++++++++++-------
>   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 18 +++++++++++-------
>   3 files changed, 23 insertions(+), 14 deletions(-)
>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

