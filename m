Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:56193 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3HRUF2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Aug 2013 16:05:28 -0400
Received: by mail-ee0-f50.google.com with SMTP id d51so1807481eek.9
        for <linux-media@vger.kernel.org>; Sun, 18 Aug 2013 13:05:27 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Arun Kumar K <arun.kk@samsung.com>
Subject: [PATCH] v4l2-ctrl: Suppress build warning from v4l2_ctrl_new_std_menu()
Date: Sun, 18 Aug 2013 22:05:19 +0200
Message-Id: <1376856319-5110-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prevent following build warning:

drivers/media/v4l2-core/v4l2-ctrls.c: In function ‘v4l2_ctrl_new_std_menu’:
drivers/media/v4l2-core/v4l2-ctrls.c:1768:15: warning: 'qmenu_int_len’ may be used uninitialized in this function

Cc: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index c6dc1fd..c3f0803 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1763,9 +1763,9 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 {
 	const char * const *qmenu = NULL;
 	const s64 *qmenu_int = NULL;
+	unsigned int qmenu_int_len = 0;
 	const char *name;
 	enum v4l2_ctrl_type type;
-	unsigned int qmenu_int_len;
 	s32 min;
 	s32 step;
 	u32 flags;
-- 
1.7.4.1

