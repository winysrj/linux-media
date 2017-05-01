Return-path: <linux-media-owner@vger.kernel.org>
Received: from bubo.tul.cz ([147.230.16.1]:50448 "EHLO bubo.tul.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968866AbdEAEUF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 00:20:05 -0400
From: Petr Cvek <petr.cvek@tul.cz>
Subject: [PATCH 2/4] [media] pxa_camera: Fix incorrect test in the image size
 generation
To: robert.jarzmik@free.fr
References: <cover.1493612057.git.petr.cvek@tul.cz>
Cc: linux-media@vger.kernel.org
Message-ID: <1e599794-36e7-3b26-8bb0-57c5b31d3956@tul.cz>
Date: Mon, 1 May 2017 06:21:10 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1493612057.git.petr.cvek@tul.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During the transfer from the soc_camera a test in pxa_mbus_image_size()
got removed. Without it any PXA_MBUS_LAYOUT_PACKED format causes either
the return of a wrong value (PXA_MBUS_PACKING_2X8_PADHI doubles
the correct value) or EINVAL (PXA_MBUS_PACKING_NONE and
PXA_MBUS_PACKING_EXTEND16). This was observed in an error from the ffmpeg
(for some of the YUYV subvariants).

This patch re-adds the same test as in soc_camera version.

Signed-off-by: Petr Cvek <petr.cvek@tul.cz>
---
 drivers/media/platform/pxa_camera.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 5f007713417e..f71e7e0a652b 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -575,6 +575,9 @@ static s32 pxa_mbus_bytes_per_line(u32 width, const struct pxa_mbus_pixelfmt *mf
 static s32 pxa_mbus_image_size(const struct pxa_mbus_pixelfmt *mf,
 			u32 bytes_per_line, u32 height)
 {
+	if (mf->layout == PXA_MBUS_LAYOUT_PACKED)
+		return bytes_per_line * height;
+
 	switch (mf->packing) {
 	case PXA_MBUS_PACKING_2X8_PADHI:
 		return bytes_per_line * height * 2;
-- 
2.11.0
