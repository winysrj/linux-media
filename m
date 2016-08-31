Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41336 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758851AbcHaNZd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 09:25:33 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 0/3] Exynos4-IS: improve clock management
Date: Wed, 31 Aug 2016 15:25:15 +0200
Message-id: <1472649918-10371-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear All,

This is a set of a few patches for Exynos4-IS driver, which improve clock
management. Those patches are needed for improved runtime pm
management for Exynos clocks driver, which will be posted in a
separate thread.

Best regards
Marek Szyprowski
Samsung R&D Institute Poland


Marek Szyprowski (3):
  exynos4-is: Add support for all required clocks
  exynos4-is: Improve clock management
  ARM: exynos: add all required FIMC-IS clocks to exynos4x12 dtsi

 .../devicetree/bindings/media/exynos4-fimc-is.txt        |  7 ++++---
 arch/arm/boot/dts/exynos4x12.dtsi                        |  5 ++++-
 drivers/media/platform/exynos4-is/fimc-is.c              |  3 +++
 drivers/media/platform/exynos4-is/fimc-is.h              |  3 +++
 drivers/media/platform/exynos4-is/fimc-lite.c            | 16 ++++------------
 5 files changed, 18 insertions(+), 16 deletions(-)

-- 
1.9.1

