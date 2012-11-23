Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:63829 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab2KWL5A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 06:57:00 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so2614834dak.19
        for <linux-media@vger.kernel.org>; Fri, 23 Nov 2012 03:57:00 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 0/6][media] s5p-*: Use devm_clk_get APIs
Date: Fri, 23 Nov 2012 17:20:37 +0530
Message-Id: <1353671443-2978-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series is based on samsung/for_v3.8 branch of
git://linuxtv.org/snawrocki/media.git tree.

MFC and FIMC have been tested on Origen board.
Others build tested.

Sachin Kamat (6):
  [media] s5p-fimc: Use devm_clk_get in mipi-csis.c
  [media] s5p-fimc: Use devm_clk_get in fimc-core.c
  [media] s5p-fimc: Use devm_clk_get in fimc-lite.c
  [media] s5p-g2d: Use devm_clk_get APIs.
  [media] s5p-jpeg: Use devm_clk_get APIs.
  [media] s5p-mfc: Use devm_clk_get APIs

 drivers/media/platform/s5p-fimc/fimc-core.c |   10 ++--------
 drivers/media/platform/s5p-fimc/fimc-lite.c |    8 +-------
 drivers/media/platform/s5p-fimc/mipi-csis.c |    6 +-----
 drivers/media/platform/s5p-g2d/g2d.c        |   14 ++++----------
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    4 +---
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c |   14 ++++----------
 6 files changed, 13 insertions(+), 43 deletions(-)

-- 
1.7.4.1

