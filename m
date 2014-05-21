Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:42753 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaEUJ3l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 May 2014 05:29:41 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, posciak@chromium.org,
	avnd.kiran@samsung.com, sachin.kamat@linaro.org,
	t.figa@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH v2 0/3] Support for multiple MFC FW sub-versions
Date: Wed, 21 May 2014 14:59:28 +0530
Message-Id: <1400664571-13746-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset is for supporting multple firmware sub-versions
for MFC. Newer firmwares come with changed interfaces and fixes
without any change in the fw version number.
So this implementation is as per Tomasz Figa's suggestion [1].
[1] http://permalink.gmane.org/gmane.linux.kernel.samsung-soc/31735

Changes from v1
- Addressed nits pointed by Sachin on PATCH 2/3

Arun Kumar K (3):
  [media] s5p-mfc: Remove duplicate function s5p_mfc_reload_firmware
  [media] s5p-mfc: Support multiple firmware sub-versions
  [media] s5p-mfc: Add init buffer cmd to MFCV6

 drivers/media/platform/s5p-mfc/s5p_mfc.c        |   15 +++++---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |   11 +++++-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |   44 ++++++-----------------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    6 ++--
 4 files changed, 34 insertions(+), 42 deletions(-)

-- 
1.7.9.5

