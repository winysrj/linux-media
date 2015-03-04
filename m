Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:40235 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbbCDNzg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 08:55:36 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKO00MBSXJ97WA0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 04 Mar 2015 13:59:33 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 0/2] Fix s5p-mfc driver for ARM64
Date: Wed, 04 Mar 2015 14:55:20 +0100
Message-id: <1425477322-5162-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series fixes issues in s5p-mfc driver related to false
assumption that driver will be used only on 32bit architectures. With
those fixes and respective IOMMU driver one can use this driver on
ARM64-based Exynos SoCs, like Exynos 5433.

Best regards
Marek Szyprowski
Samsung Poland R&D Center


Patch summary:

Marek Szyprowski (2):
  media: s5p-mfc: fix mmap support for 64-bit architecture
  media: s5p-mfc: fix broken pointer cast on 64bit arch

 drivers/media/platform/s5p-mfc/s5p_mfc_common.h | 2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    | 2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c | 2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

-- 
1.9.2

