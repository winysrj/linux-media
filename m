Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19266 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdBWHmQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Feb 2017 02:42:16 -0500
Subject: Re: [PATCH v2 08/15] media: s5p-mfc: Move firmware allocation to DMA
 configure function
To: Shuah Khan <shuahkhan@gmail.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>, shuahkh@osg.samsung.com
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <84a7701f-b266-7084-c14b-be26a5f91a23@samsung.com>
Date: Thu, 23 Feb 2017 08:30:12 +0100
MIME-version: 1.0
In-reply-to: <CAKocOOPjYj+0yuMeGmR0-pnzzmoNBWeMRfZvcDw8N9_s3KjmyA@mail.gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
References: <CGME20170220133914eucas1p1ed7898e67e5d580742875aceaac278e6@eucas1p1.samsung.com>
 <1487597944-2000-1-git-send-email-m.szyprowski@samsung.com>
 <1487597944-2000-9-git-send-email-m.szyprowski@samsung.com>
 <CAKocOOPjYj+0yuMeGmR0-pnzzmoNBWeMRfZvcDw8N9_s3KjmyA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,


On 2017-02-22 19:07, Shuah Khan wrote:
> On Mon, Feb 20, 2017 at 6:38 AM, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
>> To complete DMA memory configuration for MFC device, allocation of the
>> firmware buffer is needed, because some parameters are dependant on its base
>> address. Till now, this has been handled in the s5p_mfc_alloc_firmware()
>> function. This patch moves that logic to s5p_mfc_configure_dma_memory() to
>> keep DMA memory related operations in a single place. This way
>> s5p_mfc_alloc_firmware() is simplified and does what it name says. The
>> other consequence of this change is moving s5p_mfc_alloc_firmware() call
>> from the s5p_mfc_probe() function to the s5p_mfc_configure_dma_memory().
> Overall looks good. This patch makes subtle change in the dma and firwmare
> initialization sequence. Might be okay, but wanted to call out just in case,
>
> Before this change:
> vb2_dma_contig_set_max_seg_size() is done for both iommu and non-iommu
> case before s5p_mfc_alloc_firmware(). With this change setting
> dma_contig max size happens after s5p_mfc_alloc_firmware(). From what
> I can tell this might not be an issue.
> vb2_dma_contig_clear_max_seg_size() still happens after
> s5p_mfc_release_firmware(), so that part hasn't changed.
>
> Do any of the dma_* calls made from s5p_mfc_alloc_firmware() and later
> during the dma congiguration sequence depend on dmap_parms being
> allocated? Doesn't looks like it from what I can tell, but safe to
> ask.

Firmware allocation doesn't depend on dma max segment size at all. The only
calls which might depend on it are dma_map_sg(), which are performed much
later as a part of video buffer allocation/preparation in videobuf2, when
dma-buf or user pointer v4l2 modes are selected.

 > [...]

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
