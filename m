Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:56471 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751032AbcGOPSg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 11:18:36 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id C80B0180A30
	for <linux-media@vger.kernel.org>; Fri, 15 Jul 2016 17:18:31 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] CEC and mediatek vcodec fixes
Message-ID: <76a96417-fb57-d88f-3109-8a762f9cbc6a@xs4all.nl>
Date: Fri, 15 Jul 2016 17:18:31 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several mediatek vcodec and CEC fixes.

Regards,

	Hans

The following changes since commit 5cac1f67ea0363d463a58ec2d9118268fe2ba5d6:

  [media] rc: nuvoton: fix hang if chip is configured for alternative EFM IO address (2016-07-13 15:49:01 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8k

for you to fetch changes up to e308f81bbba764789d1ba2b9bf1556d133e5939f:

  s5p-cec/TODO: add TODO item (2016-07-15 17:13:01 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      mtk-vcodec: fix more type mismatches

Hans Verkuil (5):
      cec: don't zero reply and timeout on error
      vivid: fix typo causing incorrect CEC physical addresses
      cec: set timestamp for selfie transmits
      cec/TODO: drop comment about sphinx documentation
      s5p-cec/TODO: add TODO item

Tiffany Lin (1):
      mtk-vcodec: fix default OUTPUT buffer size

 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c    | 13 +++++++++----
 drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c |  4 ++--
 drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c  |  4 ++--
 drivers/media/platform/vivid/vivid-core.c             |  2 +-
 drivers/staging/media/cec/TODO                        |  1 -
 drivers/staging/media/cec/cec-adap.c                  | 20 ++++++--------------
 drivers/staging/media/s5p-cec/TODO                    | 10 +++++++---
 7 files changed, 27 insertions(+), 27 deletions(-)
