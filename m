Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:48770 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbaESMuH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 May 2014 08:50:07 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, posciak@chromium.org, avnd.kiran@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH 0/2] Re-send MFCv8 support patches
Date: Mon, 19 May 2014 18:20:00 +0530
Message-Id: <1400503802-5543-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These 2 patches for MFCv8 support are rebased onto
[1] with the dependencies as mentioned below.
Changes include adding the MFC_V8 version to formats.

- Re-send MFC patches
  https://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg31051.html
- Adding version information to formats by Kamil
  v4l: s5p-mfc: Fix default pixel format selection for decoder
  v4l: s5p-mfc: Limit enum_fmt to output formats of current version

[1] http://git.linuxtv.org/cgit.cgi/kdebski/media_tree_2.git/?h=for-3.16-2

Kiran AVND (2):
  [media] s5p-mfc: Core support to add v8 decoder
  [media] s5p-mfc: Core support for v8 encoder

 .../devicetree/bindings/media/s5p-mfc.txt          |    3 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v8.h       |  124 +++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   33 +++++
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    5 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   28 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   12 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |  141 +++++++++++++++++---
 7 files changed, 308 insertions(+), 38 deletions(-)
 create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v8.h

-- 
1.7.9.5

