Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63057 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbbCIMcy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 08:32:54 -0400
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCHv3 0/2] Support for JPEG IP on Exynos542x
Date: Mon, 09 Mar 2015 13:32:44 +0100
Message-id: <1425904366-14447-1-git-send-email-andrzej.p@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This short series adds support for JPEG IP on Exynos542x SoC.
The first patch adds necessary device tree nodes and the second
one does JPEG IP support proper. The JPEG IP on Exynos542x is
similar to what is on Exynos3250, there just slight differences.

v2..v3:
- added commit message to patch 1/2

v1..v2:
- implemented changes resulting from Jacek's review
- removed iommu entries in device tree nodes as iommu is
not available at this moment
- added hw3250_compat and htbl_reinit flags to s5p_jpeg_variant,
which simplifies the code a bit

Andrzej Pietrasiewicz (2):
  ARM: dts: exynos5420: add nodes for jpeg codec
  media: s5p-jpeg: add 5420 family support

 .../bindings/media/exynos-jpeg-codec.txt           |  2 +-
 arch/arm/boot/dts/exynos5420.dtsi                  | 16 ++++++
 drivers/media/platform/s5p-jpeg/jpeg-core.c        | 59 +++++++++++++++-------
 drivers/media/platform/s5p-jpeg/jpeg-core.h        | 12 +++--
 4 files changed, 67 insertions(+), 22 deletions(-)

-- 
1.9.1

