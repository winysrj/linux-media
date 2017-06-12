Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60259 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753609AbdFLRNo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 13:13:44 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/6] [media] s5p-jpeg: Decode 4:1:1 chroma subsampling format
Date: Mon, 12 Jun 2017 19:13:23 +0200
Message-Id: <1497287605-20074-5-git-send-email-thierry.escande@collabora.com>
In-Reply-To: <1497287605-20074-1-git-send-email-thierry.escande@collabora.com>
References: <1497287605-20074-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tony K Nadackal <tony.kn@samsung.com>

This patch adds support for decoding 4:1:1 chroma subsampling in the
jpeg header parsing function.

Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 0d935f5..7ef7173 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1236,6 +1236,9 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 	case 0x33:
 		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY;
 		break;
+	case 0x41:
+		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_411;
+		break;
 	default:
 		return false;
 	}
-- 
2.7.4
