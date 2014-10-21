Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:38658 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347AbaJULIK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 07:08:10 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	kiran@chromium.org, arunkk.samsung@gmail.com
Subject: [PATCH v3 11/13] [media] s5p-mfc: Remove unused alloc field from private buffer struct.
Date: Tue, 21 Oct 2014 16:37:05 +0530
Message-Id: <1413889627-8431-12-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1413889627-8431-1-git-send-email-arun.kk@samsung.com>
References: <1413889627-8431-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

This field is no longer used as MFC driver doesn't use vb2 alloc contexts
anymore.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 5b0c334..15f7663 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -237,8 +237,6 @@ struct s5p_mfc_variant {
 
 /**
  * struct s5p_mfc_priv_buf - represents internal used buffer
- * @alloc:		allocation-specific context for each buffer
- *			(videobuf2 allocator)
  * @ofs:		offset of each buffer, will be used for MFC
  * @virt:		kernel virtual address, only valid when the
  *			buffer accessed by driver
@@ -246,7 +244,6 @@ struct s5p_mfc_variant {
  * @size:		size of the buffer
  */
 struct s5p_mfc_priv_buf {
-	void		*alloc;
 	unsigned long	ofs;
 	void		*virt;
 	dma_addr_t	dma;
-- 
1.7.9.5

