Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40138 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab1KFUc2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 15:32:28 -0500
Received: by mail-fx0-f46.google.com with SMTP id o14so4498572faa.19
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 12:32:27 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH 09/13] staging: as102: Remove linkage specifiers for C++
Date: Sun,  6 Nov 2011 21:31:46 +0100
Message-Id: <1320611510-3326-10-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
References: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The as10x_cmd.h header is not public so there should be no need
for an "extern "C"" in it.

Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as10x_cmd.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/as102/as10x_cmd.h b/drivers/staging/media/as102/as10x_cmd.h
index 9af8862..da31c6d 100644
--- a/drivers/staging/media/as102/as10x_cmd.h
+++ b/drivers/staging/media/as102/as10x_cmd.h
@@ -488,10 +488,6 @@ void as10x_cmd_build(struct as10x_cmd_t *pcmd, uint16_t proc_id,
 		      uint16_t cmd_len);
 int as10x_rsp_parse(struct as10x_cmd_t *r, uint16_t proc_id);
 
-#ifdef __cplusplus
-extern "C" {
-#endif
-
 /* as10x cmd */
 int as10x_cmd_turn_on(as10x_handle_t *phandle);
 int as10x_cmd_turn_off(as10x_handle_t *phandle);
@@ -530,7 +526,4 @@ int as10x_cmd_get_context(as10x_handle_t *phandle,
 
 int as10x_cmd_eLNA_change_mode(as10x_handle_t *phandle, uint8_t mode);
 int as10x_context_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id);
-#ifdef __cplusplus
-}
-#endif
 #endif
-- 
1.7.5.4

