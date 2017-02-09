Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:58987 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753333AbdBIPOr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Feb 2017 10:14:47 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec.h: small typo fix
Message-ID: <23711c42-90fd-f815-ef83-efd44c444ad2@xs4all.nl>
Date: Thu, 9 Feb 2017 16:14:13 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ad -> as

It won't bring about world peace, but every little bit helps :-)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/include/uapi/linux/cec.h b/include/uapi/linux/cec.h
index 14b6f24b189e..a0dfe27bc6c7 100644
--- a/include/uapi/linux/cec.h
+++ b/include/uapi/linux/cec.h
@@ -223,7 +223,7 @@ static inline int cec_msg_status_is_ok(const struct cec_msg *msg)
  #define CEC_LOG_ADDR_BACKUP_2		13
  #define CEC_LOG_ADDR_SPECIFIC		14
  #define CEC_LOG_ADDR_UNREGISTERED	15 /* as initiator address */
-#define CEC_LOG_ADDR_BROADCAST		15 /* ad destination address */
+#define CEC_LOG_ADDR_BROADCAST		15 /* as destination address */

  /* The logical address types that the CEC device wants to claim */
  #define CEC_LOG_ADDR_TYPE_TV		0
