Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39461 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab0EJP4H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 May 2010 11:56:07 -0400
Date: Mon, 10 May 2010 17:55:47 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v2 0/3] [ARM] Add Samsung S5P camera interface driver
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, ben-linux@fluff.org
Message-id: <1273506950-25920-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This is a second version of my patch series adding v4l2 driver 
of the camera interface (FIMC) contained in the Samsung S5PC100 and S5PV210 SoCs.

The changes comparing to previous version:

- removed null power management ops
- multiple minor coding style corrections
- corrected clock handling (missing clk_put)
- pruned included headers list 
- removed changes for arch/arm/mach-s5pv210/mach-aquila.c

The following patches implement memory to memory mode and require v4l2-mem2mem framework,
which has already been merged into the v4l tree. 
This driver was tested on SMDKC100 system and our custom board based on Samsung S5PV210 SOC.

I'm open to any comments and suggestions.


This series contains:
[PATCH v2 1/3] ARM: Samsung S5P: Add FIMC driver register definition and platform helpers
[PATCH v2 2/3] ARM: S5PC100: Add FIMC driver platform helpers
[PATCH v2 3/3] ARM: Samsung S5P: Add Camera Interface (video postprocessor) driver


Best regards,
--
Sylwester Nawrocki
Samsung Poland R&D Center,
Linux Platform Group

