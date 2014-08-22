Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:34230 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaHVQmH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Aug 2014 12:42:07 -0400
Received: by mail-lb0-f179.google.com with SMTP id v6so9706774lbi.10
        for <linux-media@vger.kernel.org>; Fri, 22 Aug 2014 09:42:04 -0700 (PDT)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] drivers: media: b2c2: flexcop.h: Fix typo in include guard
Date: Fri, 22 Aug 2014 18:41:56 +0200
Message-Id: <1408725716-2695-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Three trailing underscores is one too many.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/media/common/b2c2/flexcop.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/common/b2c2/flexcop.h b/drivers/media/common/b2c2/flexcop.h
index 897b10c..8942bda 100644
--- a/drivers/media/common/b2c2/flexcop.h
+++ b/drivers/media/common/b2c2/flexcop.h
@@ -4,7 +4,7 @@
  * see flexcop.c for copyright information
  */
 #ifndef __FLEXCOP_H__
-#define __FLEXCOP_H___
+#define __FLEXCOP_H__
 
 #define FC_LOG_PREFIX "b2c2-flexcop"
 #include "flexcop-common.h"
-- 
2.0.4

