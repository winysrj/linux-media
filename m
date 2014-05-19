Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:49932 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbaESMdM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 May 2014 08:33:12 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, posciak@chromium.org, avnd.kiran@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH 00/10] Re-send MFC patches
Date: Mon, 19 May 2014 18:02:56 +0530
Message-Id: <1400502786-4826-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches for s5p-mfc are completed review and
accepted. These are rebased onto [1] and fixed conflicts
for merging.

[1] http://git.linuxtv.org/cgit.cgi/kdebski/media_tree_2.git/?h=for-3.16-2

Arun Kumar K (3):
  [media] s5p-mfc: Update scratch buffer size for MPEG4
  [media] s5p-mfc: Move INIT_BUFFER_OPTIONS from v7 to v6
  [media] s5p-mfc: Rename IS_MFCV7 macro

Kiran AVND (2):
  [media] s5p-mfc: Update scratch buffer size for VP8 encoder
  [media] s5p-mfc: Add variants to access mfc registers

Pawel Osciak (5):
  [media] s5p-mfc: Copy timestamps only when a frame is produced.
  [media] s5p-mfc: Fixes for decode REQBUFS.
  [media] s5p-mfc: Extract open/close MFC instance commands.
  [media] s5p-mfc: Don't allocate codec buffers on STREAMON.
  [media] s5p-mfc: Don't try to resubmit VP8 bitstream buffer for
    decode.

 drivers/media/platform/s5p-mfc/regs-mfc-v6.h    |    4 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v7.h    |    5 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |   35 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    3 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |   62 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h   |    3 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |  216 +++----
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   20 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c    |    6 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |  254 ++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |  703 +++++++++++++++--------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h |    7 +-
 12 files changed, 904 insertions(+), 414 deletions(-)

-- 
1.7.9.5

