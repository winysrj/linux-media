Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:43965 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaENGqN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 May 2014 02:46:13 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, posciak@chromium.org,
	avnd.kiran@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH v2 0/4] Add MFCv8 support
Date: Wed, 14 May 2014 12:16:01 +0530
Message-Id: <1400049965-1022-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds MFCv8 support to the s5p-mfc driver.
MFCv8 has the same operation sequence as that of v6+, but
there is some shuffling of the registers happened. So to
re-use the exisiting code, register access uses context
variables instead of macros.
The patchset modifies opr_v6 file to use register variables
and is tested on mfc v5, v6, v7 and v8 based boards.

The patchset is based on the following set of patches
posted for MFC which are currently under review:

s5p-mfc: Update scratch buffer size for MPEG4
s5p-mfc: Add support for resolution change event
v4l: Add source change event
s5p-mfc: Don't try to resubmit VP8 bitstream buffer for decode.
s5p-mfc: Update scratch buffer size for VP8 encoder
s5p-mfc: Dequeue sequence header after STREAMON
s5p-mfc: Don't allocate codec buffers on STREAMON.
s5p-mfc: Extract open/close MFC instance commands.
s5p-mfc: Fixes for decode REQBUFS.
s5p-mfc: Copy timestamps only when a frame is produced.
s5p-mfc: add init buffer cmd to MFCV6
s5p-mfc: Add a control for IVF format for VP8 encoder

Changes from v1
- Included encoder support for v8 patch
- Addressed review comments from Kamil & Sachin
  https://patchwork.linuxtv.org/patch/23770/
  https://patchwork.linuxtv.org/patch/23768/

Arun Kumar K (1):
  [media] s5p-mfc: Rename IS_MFCV7 macro

Kiran AVND (3):
  [media] s5p-mfc: Add variants to access mfc registers
  [media] s5p-mfc: Core support to add v8 decoder
  [media] s5p-mfc: Core support for v8 encoder

 .../devicetree/bindings/media/s5p-mfc.txt          |    3 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v8.h       |  124 +++
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   33 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    7 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |    4 +
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c       |    6 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h       |  254 ++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |  849 +++++++++++++-------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h    |    7 +-
 10 files changed, 1007 insertions(+), 282 deletions(-)
 create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v8.h

-- 
1.7.9.5

