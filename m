Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:36026 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbcEXKW1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 06:22:27 -0400
Subject: Re: [PATCH 0/3] [media] s5p-mfc: Fixes for issues when module is
 removed
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org
References: <1462307238-21815-1-git-send-email-javier@osg.samsung.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <a64533b5-9af2-5f15-0ed3-28015b695ee0@samsung.com>
Date: Tue, 24 May 2016 12:22:22 +0200
MIME-version: 1.0
In-reply-to: <1462307238-21815-1-git-send-email-javier@osg.samsung.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,


On 2016-05-03 22:27, Javier Martinez Canillas wrote:
> Hello,
>
> This patch series fixes some issues that I noticed when trying to remove
> the s5p-mfc driver when built as a module.
>
> Some of these issues will be fixed once Marek's patches to convert the
> custom memory region reservation code is replaced by a generic one that
> supports named memory region reservation [0]. But the fixes are trivial
> so we can fix the current code until his rework patch lands.

For the whole series:

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

Please queue it as fixes to v4.7-rcX.

>
> [0]: https://patchwork.linuxtv.org/patch/32287/
>
> Best regards,
> Javier
>
>
> Javier Martinez Canillas (3):
>    [media] s5p-mfc: Set device name for reserved memory region devs
>    [media] s5p-mfc: Add release callback for memory region devs
>    [media] s5p-mfc: Fix race between s5p_mfc_probe() and s5p_mfc_open()
>
>   drivers/media/platform/s5p-mfc/s5p_mfc.c | 50 ++++++++++++++++++++------------
>   1 file changed, 32 insertions(+), 18 deletions(-)
>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

