Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53739 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab2KZEze (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 23:55:34 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so4742413pad.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 20:55:33 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 0/9] [media] s5p-tv: Checkpatch Fixes and cleanup
Date: Mon, 26 Nov 2012 10:18:59 +0530
Message-Id: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Build tested based on samsung/for_v3.8 branch of
git://linuxtv.org/snawrocki/media.git tree.

Sachin Kamat (9):
  [media] s5p-tv: Add missing braces around sizeof in sdo_drv.c
  [media] s5p-tv: Add missing braces around sizeof in mixer_video.c
  [media] s5p-tv: Add missing braces around sizeof in mixer_reg.c
  [media] s5p-tv: Add missing braces around sizeof in mixer_drv.c
  [media] s5p-tv: Add missing braces around sizeof in hdmiphy_drv.c
  [media] s5p-tv: Add missing braces around sizeof in hdmi_drv.c
  [media] s5p-tv: Use devm_clk_get APIs in sdo_drv.c
  [media] s5p-tv: Use devm_* APIs in mixer_drv.c
  [media] s5p-tv: Use devm_clk_get APIs in hdmi_drv

 drivers/media/platform/s5p-tv/hdmi_drv.c    |   28 +++------
 drivers/media/platform/s5p-tv/hdmiphy_drv.c |    2 +-
 drivers/media/platform/s5p-tv/mixer_drv.c   |   87 +++++++--------------------
 drivers/media/platform/s5p-tv/mixer_reg.c   |    6 +-
 drivers/media/platform/s5p-tv/mixer_video.c |   18 +++---
 drivers/media/platform/s5p-tv/sdo_drv.c     |   43 ++++---------
 6 files changed, 57 insertions(+), 127 deletions(-)

-- 
1.7.4.1

