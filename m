Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34444 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752930AbeCQP2f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Mar 2018 11:28:35 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/5] media: staging: tegra-vde: Silence some of checkpatch warnings
Date: Sat, 17 Mar 2018 18:28:12 +0300
Message-Id: <9ec5460f88ac716d84cc626aa9e8d0a3c2e6acf3.1521300358.git.digetx@gmail.com>
In-Reply-To: <cover.1521300358.git.digetx@gmail.com>
References: <cover.1521300358.git.digetx@gmail.com>
In-Reply-To: <cover.1521300358.git.digetx@gmail.com>
References: <cover.1521300358.git.digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make all strings single line to make them grep'able and add a comment
to the memory barrier.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 drivers/staging/media/tegra-vde/tegra-vde.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c b/drivers/staging/media/tegra-vde/tegra-vde.c
index c2ff2071b23c..14899c887d58 100644
--- a/drivers/staging/media/tegra-vde/tegra-vde.c
+++ b/drivers/staging/media/tegra-vde/tegra-vde.c
@@ -368,6 +368,11 @@ static int tegra_vde_setup_hw_context(struct tegra_vde *vde,
 	tegra_vde_setup_iram_tables(vde, dpb_frames,
 				    ctx->dpb_frames_nb - 1,
 				    ctx->dpb_ref_frames_with_earlier_poc_nb);
+
+	/*
+	 * The IRAM mapping is write-combine, ensure that CPU buffers have
+	 * been flushed at this point.
+	 */
 	wmb();
 
 	VDE_WR(0x00000000, vde->bsev + 0x8C);
@@ -542,15 +547,13 @@ static int tegra_vde_attach_dmabuf(struct device *dev,
 	}
 
 	if (dmabuf->size & (align_size - 1)) {
-		dev_err(dev, "Unaligned dmabuf 0x%zX, "
-			     "should be aligned to 0x%zX\n",
+		dev_err(dev, "Unaligned dmabuf 0x%zX, should be aligned to 0x%zX\n",
 			dmabuf->size, align_size);
 		return -EINVAL;
 	}
 
 	if ((u64)offset + min_size > dmabuf->size) {
-		dev_err(dev, "Too small dmabuf size %zu @0x%lX, "
-			     "should be at least %zu\n",
+		dev_err(dev, "Too small dmabuf size %zu @0x%lX, should be at least %zu\n",
 			dmabuf->size, offset, min_size);
 		return -EINVAL;
 	}
@@ -863,8 +866,7 @@ static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
 		macroblocks_nb = readl_relaxed(vde->sxe + 0xC8) & 0x1FFF;
 		read_bytes = bsev_ptr ? bsev_ptr - bitstream_data_addr : 0;
 
-		dev_err(dev, "Decoding failed: "
-				"read 0x%X bytes, %u macroblocks parsed\n",
+		dev_err(dev, "Decoding failed: read 0x%X bytes, %u macroblocks parsed\n",
 			read_bytes, macroblocks_nb);
 
 		ret = -EIO;
-- 
2.16.1
