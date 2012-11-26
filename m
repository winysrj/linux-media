Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48955 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab2KZG0u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Nov 2012 01:26:50 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so4795776pad.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 22:26:50 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: shaik.ameer@samsung.com, sylvester.nawrocki@gmail.com,
	s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH v2 0/3] [media] exynos-gsc: Some fixes and updates
Date: Mon, 26 Nov 2012 11:50:18 +0530
Message-Id: <1353910821-21408-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

I have re-organised this series as per your suggestion and included your patch
"exynos-gsc: Correct clock handling". However, I have created 3 patches as I
found making them into 2 a little cumbersome. Hope they look good.
This series is based on samsung/for_v3.8 branch of
git://linuxtv.org/snawrocki/media.git

Shaik,
Please test this series at your end.

Sachin Kamat (2):
  [media] exynos-gsc: Rearrange error messages for valid prints
  [media] exynos-gsc: Use devm_clk_get()

Sylwester Nawrocki (1):
  [media] exynos-gsc: Correct clock handling

 drivers/media/platform/exynos-gsc/gsc-core.c |   35 ++++++++++---------------
 1 files changed, 14 insertions(+), 21 deletions(-)

-- 
1.7.4.1

