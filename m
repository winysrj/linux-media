Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48727 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbaCJXOq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 19:14:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 28/48] adv7604: Add missing include to linux/types.h
Date: Tue, 11 Mar 2014 00:15:39 +0100
Message-Id: <1394493359-14115-29-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lars-Peter Clausen <lars@metafoo.de>

The file is using u8 which is defined in linux/types.h.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/adv7604.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/media/adv7604.h b/include/media/adv7604.h
index d262a3a..c6b3937 100644
--- a/include/media/adv7604.h
+++ b/include/media/adv7604.h
@@ -21,6 +21,8 @@
 #ifndef _ADV7604_
 #define _ADV7604_
 
+#include <linux/types.h>
+
 /* Analog input muxing modes (AFE register 0x02, [2:0]) */
 enum adv7604_ain_sel {
 	ADV7604_AIN1_2_3_NC_SYNC_1_2 = 0,
-- 
1.8.3.2

