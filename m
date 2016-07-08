Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:55714 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752537AbcGHTL1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2016 15:11:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: tiffany.lin@mediatek.com
Subject: [PATCH 0/2] mtk-vcodec fixups
Date: Fri,  8 Jul 2016 21:11:17 +0200
Message-Id: <1468005079-28636-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Two patches: the first converts the driver to use the new vb2_queue dev
field (this came in after the pull request of this driver was posted).

The second allows this driver to be built when COMPILE_TEST is set and
MTK_IOMMU is not set.

Regards,

	Hans

Hans Verkuil (2):
  mtk-vcodec: convert driver to use the new vb2_queue dev field
  drivers/media/platform/Kconfig: fix VIDEO_MEDIATEK_VCODEC dependency

 drivers/media/platform/Kconfig                         |  2 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h     |  3 ---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c     | 13 ++++++-------
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c | 12 ------------
 4 files changed, 7 insertions(+), 23 deletions(-)

-- 
2.8.1

