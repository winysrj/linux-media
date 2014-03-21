Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:59587 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbaCUIhY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Mar 2014 04:37:24 -0400
Received: by mail-pd0-f175.google.com with SMTP id x10so2069304pdj.20
        for <linux-media@vger.kernel.org>; Fri, 21 Mar 2014 01:37:23 -0700 (PDT)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, posciak@chromium.org,
	arunkk.samsung@gmail.com
Subject: [PATCH 0/3] MFC cleanup of reqbuf, streamon, open and close
Date: Fri, 21 Mar 2014 14:07:12 +0530
Message-Id: <1395391035-27349-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series contain some fixes and cleanups done to the
s5p-mfc decoder in reqbuf, streamon and open/close commands. These
patches are present in the ChromeOS tree and just rebased onto the
media-tree and tested.

Pawel Osciak (3):
  [media] s5p-mfc: Fixes for decode REQBUFS.
  [media] s5p-mfc: Extract open/close MFC instance commands.
  [media] s5p-mfc: Don't allocate codec buffers on STREAMON.

 drivers/media/platform/s5p-mfc/s5p_mfc.c      |   29 +---
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c |   62 +++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h |    3 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c  |  216 ++++++++++++-------------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c  |   18 +--
 5 files changed, 182 insertions(+), 146 deletions(-)

-- 
1.7.9.5

