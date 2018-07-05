Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:36185 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753068AbeGEJiH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 05:38:07 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] media: v4l2-ctrls.h: fix v4l2_ctrl field description typos
Date: Thu,  5 Jul 2018 12:38:00 +0300
Message-Id: <19666720ce1c20bcaaa481384db8431fd711b51e.1530783480.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 include/media/v4l2-ctrls.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 5b445b5654f7..f615ba1b29dd 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -181,10 +181,10 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
  *		not freed when the control is deleted. Should this be needed
  *		then a new internal bitfield can be added to tell the framework
  *		to free this pointer.
- * @p_cur:	The control's current value represented via a union with
+ * @p_cur:	The control's current value represented via a union which
  *		provides a standard way of accessing control types
  *		through a pointer.
- * @p_new:	The control's new value represented via a union with provides
+ * @p_new:	The control's new value represented via a union which provides
  *		a standard way of accessing control types
  *		through a pointer.
  */
-- 
2.18.0
