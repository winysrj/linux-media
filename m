Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:38001 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753110AbdHTOgx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 10:36:53 -0400
Received: by mail-wr0-f193.google.com with SMTP id k10so884152wre.5
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 07:36:53 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: jasmin@anw.at, mchehab@kernel.org
Subject: [PATCH 3/3] [media_build] add compat for __GFP_RETRY_MAYFAIL
Date: Sun, 20 Aug 2017 16:36:48 +0200
Message-Id: <20170820143648.27669-4-d.scheller.oss@gmail.com>
In-Reply-To: <20170820143648.27669-1-d.scheller.oss@gmail.com>
References: <20170820143648.27669-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

required for building ddbridge on <4.13-rc1 wrt

  commit dcda9b04713c ("mm, tree wide: replace __GFP_REPEAT by __GFP_RETRY_MAYFAIL with more useful semantic")

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 v4l/compat.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/v4l/compat.h b/v4l/compat.h
index b5b0846..a28ce76 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -2099,4 +2099,8 @@ static inline int pm_runtime_get_if_in_use(struct device *dev)
 }
 #endif
 
+#ifndef __GFP_RETRY_MAYFAIL
+#define __GFP_RETRY_MAYFAIL __GFP_REPEAT
+#endif
+
 #endif /*  _COMPAT_H */
-- 
2.13.0
