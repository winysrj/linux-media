Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:35863 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750760AbcGLRLr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 13:11:47 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 0867A180239
	for <linux-media@vger.kernel.org>; Tue, 12 Jul 2016 19:11:41 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] Various fixes
Message-ID: <84a7f883-352c-cb54-391f-00abc65175b7@xs4all.nl>
Date: Tue, 12 Jul 2016 19:11:40 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A bunch of vcodec code improvements and two cec changes: one adds a
sanity check, the other improves timestamping. A patch updating the
doc-rst will be posted separately.

Regards,

	Hans

The following changes since commit 9d01315d132469fd0a92f5a13c0a605d6ce96b21:

  [media] pulse8-cec: declare function as static (2016-07-12 13:46:20 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8j

for you to fetch changes up to 948ae91767dab720d978a3cb835f5b9f23f6f13b:

  mtk-vcodec: fix type mismatches (2016-07-12 19:07:27 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      mtk-vcodec: fix type mismatches

Hans Verkuil (2):
      cec: add sanity check for msg->len
      cec: split the timestamp into an rx and tx timestamp

Wei Yongjun (4):
      VPU: mediatek: fix return value check in mtk_vpu_probe()
      VPU: mediatek: remove redundant dev_err call in mtk_vpu_probe()
      vcodec: mediatek: Fix return value check in mtk_vcodec_init_enc_pm()
      mtk-vcodec: remove redundant dev_err call in mtk_vcodec_probe()

 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c     |  8 ++++----
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |  2 --
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c  | 16 ++++++++--------
 drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c  |  4 ++--
 drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c   |  4 ++--
 drivers/media/platform/mtk-vcodec/venc_vpu_if.c        |  4 ++--
 drivers/media/platform/mtk-vpu/mtk_vpu.c               | 12 ++++--------
 drivers/staging/media/cec/cec-adap.c                   | 27 +++++++++++++++------------
 include/linux/cec.h                                    | 18 ++++++++++--------
 9 files changed, 47 insertions(+), 48 deletions(-)
