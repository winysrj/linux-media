Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:55035 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbeKGLwS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Nov 2018 06:52:18 -0500
From: rafaelgoncalves@riseup.net
To: digetx@gmail.com, mchehab@kernel.org, gregkh@linuxfoundation.org,
        thierry.reding@gmail.com, jonathanh@nvidia.com,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        lkcamp@lists.libreplanetbr.org
Cc: Rafael Goncalves <rafaelgoncalves@riseup.net>
Subject: [PATCH] media: staging: tegra-vde: Change from __attribute to __packed.
Date: Wed,  7 Nov 2018 00:23:24 -0200
Message-Id: <20181107022324.11994-1-rafaelgoncalves@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Rafael Goncalves <rafaelgoncalves@riseup.net>

Correct the following warnings from checkpatch.pl:

WARNING: __packed is preferred over __attribute__((packed))
+} __attribute__((packed));

WARNING: __packed is preferred over __attribute__((packed))
+} __attribute__((packed));

Signed-off-by: Rafael Goncalves <rafaelgoncalves@riseup.net>

---

Hi.
It's my first patch submission, please let me know if there is something
that I can improve.
---
 drivers/staging/media/tegra-vde/uapi.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/tegra-vde/uapi.h b/drivers/staging/media/tegra-vde/uapi.h
index a50c7bcae057..5ffa4afa4047 100644
--- a/drivers/staging/media/tegra-vde/uapi.h
+++ b/drivers/staging/media/tegra-vde/uapi.h
@@ -29,7 +29,7 @@ struct tegra_vde_h264_frame {
 	__u32 flags;
 
 	__u32 reserved;
-} __attribute__((packed));
+} __packed;
 
 struct tegra_vde_h264_decoder_ctx {
 	__s32 bitstream_data_fd;
@@ -61,7 +61,7 @@ struct tegra_vde_h264_decoder_ctx {
 	__u8  num_ref_idx_l1_active_minus1;
 
 	__u32 reserved;
-} __attribute__((packed));
+} __packed;
 
 #define VDE_IOCTL_BASE			('v' + 0x20)
 
-- 
2.19.1
