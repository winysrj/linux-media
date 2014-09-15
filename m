Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:62322 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbaIOGrn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 02:47:43 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NBX00C5CK7G2L50@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Sep 2014 15:47:40 +0900 (KST)
From: Kiran AVND <avnd.kiran@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	arun.kk@samsung.com
Subject: [PATCH 00/17] Fixes from Chrome OS tree for MFC driver
Date: Mon, 15 Sep 2014 12:12:55 +0530
Message-id: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Upstreaming the fixes which have gone in to Chrome OS tree for MFC driver.
Tested on MFCV8, MFCV7 and MFCV6 based Exynos5 based boards, peach-pi 
(5800), peach-pit (5420) and snow (5250).

These are all independent fixes and hence posting them as a patchset.

Arun Mankuzhi (3):
  [media] s5p-mfc: don't disable clock when next ctx is pending
  [media] s5p-mfc: modify mfc wakeup sequence for V8
  [media] s5p-mfc: De-init MFC when watchdog kicks in

Ilja Friedel (1):
  [media] s5p-mfc: Only set timestamp/timecode for new frames.

Kiran AVND (6):
  [media] s5p-mfc: support MIN_BUFFERS query for encoder
  [media] s5p-mfc: set B-frames as 2 while encoding
  [media] s5p-mfc: keep RISC ON during reset for V7/V8
  [media] s5p-mfc: check mfc bus ctrl before reset
  [media] s5p-mfc: flush dpbs when resolution changes
  [media] s5p-mfc: remove reduntant clock on & clock off

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
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |   73 +++++++-------
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |  122 ++++++++++++++++++-----
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |   12 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   69 ++++++++++++-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |   24 ++---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   48 ++++------
 8 files changed, 235 insertions(+), 120 deletions(-)

-- 
1.7.3.rc2

