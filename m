Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:34903 "EHLO
        homiemail-a80.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756865AbeDZR1m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 13:27:42 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 6/7] Fix frame vector wildcard file check
Date: Thu, 26 Apr 2018 12:19:21 -0500
Message-Id: <1524763162-4865-7-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
References: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This check was consistently failing on all systems tested.
The path to object directory is used here to explicitly override
CWD. The thought is, if frame_vector.c exists in the build
directory then the build system has determined it is required,
and the source therefore should be compiled. The module will
not be built unless the build system has enabled it's config
option anyways, so this change should be safe in all circumstances.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 v4l/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/v4l/Makefile b/v4l/Makefile
index b512600..270a624 100644
--- a/v4l/Makefile
+++ b/v4l/Makefile
@@ -88,7 +88,7 @@ ifneq ($(filter $(no-makefile-media-targets), $(MAKECMDGOALS)),)
 endif
 
 makefile-mm := 1
-ifeq ($(wildcard ../linux/mm/frame_vector.c),)
+ifeq ("$(wildcard $(obj)/frame_vector.c)","")
 	makefile-mm := 0
 endif
 
-- 
2.7.4
