Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:57141 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3JJRVY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Oct 2013 13:21:24 -0400
Received: by mail-ee0-f43.google.com with SMTP id e52so1309660eek.2
        for <linux-media@vger.kernel.org>; Thu, 10 Oct 2013 10:21:23 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/2] v4l2-ctrls: fix typo in header file media/v4l2-ctrls.h
Date: Thu, 10 Oct 2013 19:21:32 +0200
Message-Id: <1381425692-5023-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 include/media/v4l2-ctrls.h |    2 +-
 1 Datei geändert, 1 Zeile hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 47ada23..16f7f26 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -571,7 +571,7 @@ static inline void v4l2_ctrl_lock(struct v4l2_ctrl *ctrl)
 	mutex_lock(ctrl->handler->lock);
 }
 
-/** v4l2_ctrl_lock() - Helper function to unlock the handler
+/** v4l2_ctrl_unlock() - Helper function to unlock the handler
   * associated with the control.
   * @ctrl:	The control to unlock.
   */
-- 
1.7.10.4

