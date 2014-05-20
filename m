Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:39716 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaETKRQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 May 2014 06:17:16 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, posciak@chromium.org,
	avnd.kiran@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH 0/3] Support for multiple MFC FW sub-versions
Date: Tue, 20 May 2014 15:47:06 +0530
Message-Id: <1400581029-3475-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset is for supporting multple firmware sub-versions
for MFC. Newer firmwares come with changed interfaces and fixes
without any change in the fw version number.
So this implementation is as per Tomasz Figa's suggestion [1].
[1] http://permalink.gmane.org/gmane.linux.kernel.samsung-soc/31735

Arun Kumar K (3):
  [media] s5p-mfc: Remove duplicate function s5p_mfc_reload_firmware
  [media] s5p-mfc: Support multiple firmware sub-versions
  [media] s5p-mfc: Add init buffer cmd to MFCV6

 drivers/media/platform/s5p-mfc/s5p_mfc.c        |   11 +++---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |   11 +++++-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |   44 ++++++-----------------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    6 ++--
 4 files changed, 30 insertions(+), 42 deletions(-)

-- 
1.7.9.5

