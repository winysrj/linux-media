Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56796 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab2KWEvW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 23:51:22 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so6266460pbc.19
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2012 20:51:22 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 0/4] [media] exynos-gsc: Some fixes
Date: Fri, 23 Nov 2012 10:14:58 +0530
Message-Id: <1353645902-7467-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch series build tested and based on samsung/for_v3.8 branch of
git://linuxtv.org/snawrocki/media.git.

Sachin Kamat (4):
  [media] exynos-gsc: Rearrange error messages for valid prints
  [media] exynos-gsc: Remove gsc_clk_put call from gsc_clk_get
  [media] exynos-gsc: Use devm_clk_get()
  [media] exynos-gsc: Fix checkpatch warning in gsc-m2m.c

 drivers/media/platform/exynos-gsc/gsc-core.c |   21 ++++++++-------------
 drivers/media/platform/exynos-gsc/gsc-m2m.c  |    2 +-
 2 files changed, 9 insertions(+), 14 deletions(-)

-- 
1.7.4.1

