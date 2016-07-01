Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:49931 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbcGAIE2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 04:04:28 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Joe Perches <joe@perches.com>, Sean Young <sean@mess.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH v2 15/15] [media] include: lirc: add LIRC_GET_LENGTH command
Date: Fri, 01 Jul 2016 17:01:38 +0900
Message-id: <1467360098-12539-16-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467360098-12539-1-git-send-email-andi.shyti@samsung.com>
References: <1467360098-12539-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added the get length command to allow userspace users to check on
the data length.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 include/uapi/linux/lirc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/lirc.h b/include/uapi/linux/lirc.h
index 4b3ab29..801e5f8 100644
--- a/include/uapi/linux/lirc.h
+++ b/include/uapi/linux/lirc.h
@@ -106,6 +106,7 @@
 
 /* code length in bits, currently only for LIRC_MODE_LIRCCODE */
 #define LIRC_GET_LENGTH                _IOR('i', 0x0000000f, __u32)
+#define LIRC_SET_LENGTH                _IOW('i', 0x00000010, __u32)
 
 #define LIRC_SET_SEND_MODE             _IOW('i', 0x00000011, __u32)
 #define LIRC_SET_REC_MODE              _IOW('i', 0x00000012, __u32)
-- 
2.8.1

