Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:20605 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbaIZE51 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 00:57:27 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NCH000G6SFNCG10@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 26 Sep 2014 13:57:24 +0900 (KST)
From: Kiran AVND <avnd.kiran@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	arun.kk@samsung.com, kiran@chromium.org
Subject: [PATCH v2 00/14] Fixes from Chrome OS tree for MFC driver
Date: Fri, 26 Sep 2014 10:22:08 +0530
Message-id: <1411707142-4881-1-git-send-email-avnd.kiran@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Upstreaming the fixes which have gone in to Chrome OS tree for MFC driver.
Tested on MFCV8, MFCV7 and MFCV6 based Exynos5 based boards, peach-pi
(5800), peach-pit (5420) and snow (5250).

These are all independent fixes and hence posting them as a patchset.

Changes from v1:
1) Addressed all review comments from Kamil.
2) Dropped patches
   [media] s5p-mfc: set B-frames as 2 while encoding
   [media] s5p-mfc: remove reduntant clock on & clock off
   [media] s5p-mfc: don't disable clock when next ctx is pending
3) Rebased on media-tree

Arun Mankuzhi (2):
  [media] s5p-mfc: modify mfc wakeup sequence for V8
  [media] s5p-mfc: De-init MFC when watchdog kicks in

Ilja Friedel (1):
  [media] s5p-mfc: Only set timestamp/timecode for new frames.

Kiran AVND (4):
  [media] s5p-mfc: support MIN_BUFFERS query for encoder
  [media] s5p-mfc: keep RISC ON during reset for V7/V8
  [media] s5p-mfc: check mfc bus ctrl before reset
  [media] s5p-mfc: flush dpbs when resolution changes

Pawel Osciak (5):
  [media] s5p-mfc: Fix REQBUFS(0) for encoder.
  [media] s5p-mfc: Don't crash the kernel if the watchdog kicks in.
  [media] s5p-mfc: Remove unused alloc field from private buffer
    struct.
  [media] s5p-mfc: fix V4L2_CID_MIN_BUFFERS_FOR_CAPTURE on resolution
    change.
  [media] s5p-mfc: fix a race in interrupt flags handling

Prathyush K (1):
  [media] s5p-mfc: clear 'enter_suspend' flag if suspend fails

Wu-Cheng Li (1):
  [media] s5p-mfc: Don't change the image size to smaller than the
    request.

 drivers/media/platform/s5p-mfc/regs-mfc-v6.h    |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |   49 +++++----
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |  122 ++++++++++++++++++-----
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |    6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   67 ++++++++++++-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |   13 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   32 +-----
 8 files changed, 199 insertions(+), 95 deletions(-)

-- 
1.7.9.5

