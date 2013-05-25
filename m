Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:62486 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab3EYL1h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 May 2013 07:27:37 -0400
Received: by mail-bk0-f51.google.com with SMTP id ji1so833218bkc.38
        for <linux-media@vger.kernel.org>; Sat, 25 May 2013 04:27:35 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	t.stanislaws@samsung.com,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH 5/5] s5p-mfc: Remove unused s5p_mfc_get_decoded_status_v6() function
Date: Sat, 25 May 2013 13:25:55 +0200
Message-Id: <1369481155-30446-6-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1369481155-30446-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <1369481155-30446-1-git-send-email-sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes following compilation warning:

  CC [M]  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.o
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:1733:12: warning: ‘s5p_mfc_get_decoded_status_v6’ defined but not used

It assigns existing but not used s5p_mfc_get_dec_status_v6() function to the
get_dec_status callback. It seems the get_dec_status callback is not used
anyway, as there is no corresponding s5p_mfc_hw_call().

Cc: Kamil Debski <k.debski@samsung.com>
Cc: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
WARNING: This patch has not been tested.
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 7e76fce..3f97363 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -62,12 +62,6 @@ static void s5p_mfc_release_dec_desc_buffer_v6(struct s5p_mfc_ctx *ctx)
 	/* NOP */
 }
 
-static int s5p_mfc_get_dec_status_v6(struct s5p_mfc_dev *dev)
-{
-	/* NOP */
-	return -1;
-}
-
 /* Allocate codec buffers */
 static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 {
@@ -1730,7 +1724,7 @@ static int s5p_mfc_get_dspl_status_v6(struct s5p_mfc_dev *dev)
 	return mfc_read(dev, S5P_FIMV_D_DISPLAY_STATUS_V6);
 }
 
-static int s5p_mfc_get_decoded_status_v6(struct s5p_mfc_dev *dev)
+static int s5p_mfc_get_dec_status_v6(struct s5p_mfc_dev *dev)
 {
 	return mfc_read(dev, S5P_FIMV_D_DECODED_STATUS_V6);
 }
-- 
1.7.4.1

