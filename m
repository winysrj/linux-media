Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:45500 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbaDWM5u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Apr 2014 08:57:50 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, posciak@chromium.org,
	avnd.kiran@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH 0/3] Add MFCv8 support
Date: Wed, 23 Apr 2014 18:27:41 +0530
Message-Id: <1398257864-12097-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds MFCv8 support to the s5p-mfc driver.
MFCv8 has the same operation sequence as that of v6+, but
there is some shuffling of the registers happened. So to
re-use the exisiting code, register access uses context
variables instead of macros.
The patchset modifies opr_v6 file to use register variables
and is tested on mfc v6, v7 and v8 based boards.

The patchset is based on the following set of patches
posted for MFC which are currently under review:

[media] s5p-mfc: Add support for resolution change event
v4l: Add resolution change event.
[media] s5p-mfc: Don't allocate codec buffers on STREAMON.
[media] s5p-mfc: Extract open/close MFC instance commands.
[media] s5p-mfc: Fixes for decode REQBUFS.
[media] s5p-mfc: Copy timestamps only when a frame is produced.
[media] s5p-mfc: add init buffer cmd to MFCV6
[media] s5p-mfc: Don't try to resubmit VP8 bitstream buffer for decode.
[media] s5p-mfc: Add a control for IVF format for VP8 encoder

Arun Kumar K (1):
  [media] s5p-mfc: Rename IS_MFCV7 macro

Kiran AVND (2):
  [media] s5p-mfc: Add variants to access mfc registers
  [media] s5p-mfc: Core support to add v8 decoder

 .../devicetree/bindings/media/s5p-mfc.txt          |    3 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v8.h       |   93 +++
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   31 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    7 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |    4 +
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c       |    6 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h       |  254 +++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |  792 +++++++++++++-------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h    |    7 +-
 10 files changed, 926 insertions(+), 273 deletions(-)
 create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v8.h

-- 
1.7.9.5

