Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:17446 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaIOGtG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 02:49:06 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NBX00KLXK9T5I50@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Sep 2014 15:49:05 +0900 (KST)
From: Kiran AVND <avnd.kiran@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	arun.kk@samsung.com
Subject: [PATCH 13/17] [media] s5p-mfc: Remove unused alloc field from private
 buffer struct.
Date: Mon, 15 Sep 2014 12:13:08 +0530
Message-id: <1410763393-12183-14-git-send-email-avnd.kiran@samsung.com>
In-reply-to: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
References: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

This field is no longer used as MFC driver doesn't use vb2 alloc contexts
anymore.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index c72a338..2dda27d 100644
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
1.7.3.rc2

