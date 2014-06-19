Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58475 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932894AbaFSRX0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jun 2014 13:23:26 -0400
Received: from compute1.internal (compute1.nyi.mail.srv.osa [10.202.2.41])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id EC769215C5
	for <linux-media@vger.kernel.org>; Thu, 19 Jun 2014 13:23:23 -0400 (EDT)
From: Ramakrishnan Muthukrishnan <ram@fastmail.in>
To: linux-media@vger.kernel.org
Cc: Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>
Subject: [REVIEW PATCH 3/4] media: v4l2-dev.h: remove V4L2_FL_USE_FH_PRIO flag.
Date: Thu, 19 Jun 2014 22:52:59 +0530
Message-Id: <1403198580-3126-4-git-send-email-ram@fastmail.in>
In-Reply-To: <1403198580-3126-1-git-send-email-ram@fastmail.in>
References: <1403198580-3126-1-git-send-email-ram@fastmail.in>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>

Since none of the drivers are using it, this flag can be removed.

Signed-off-by: Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>
---
 include/media/v4l2-dev.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index eec6e46..eb76cfd 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -44,8 +44,6 @@ struct v4l2_ctrl_handler;
 #define V4L2_FL_REGISTERED	(0)
 /* file->private_data points to struct v4l2_fh */
 #define V4L2_FL_USES_V4L2_FH	(1)
-/* Use the prio field of v4l2_fh for core priority checking */
-#define V4L2_FL_USE_FH_PRIO	(2)
 
 /* Priority helper functions */
 
-- 
2.0.0

