Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbcBNPXN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2016 10:23:13 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id AF8D65A4C
	for <linux-media@vger.kernel.org>; Sun, 14 Feb 2016 15:23:13 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 1/2] Fix array out of bounds access in kdetv filter plugins
Date: Sun, 14 Feb 2016 16:23:07 +0100
Message-Id: <1455463388-23954-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a read-only oob access to data on the stack, so likely harmless,
but still lets fix it.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=876948
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 plugins/kdetv_greedyh.c    | 2 +-
 plugins/kdetv_tomsmocomp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/plugins/kdetv_greedyh.c b/plugins/kdetv_greedyh.c
index c567767..f97fd6d 100644
--- a/plugins/kdetv_greedyh.c
+++ b/plugins/kdetv_greedyh.c
@@ -40,7 +40,7 @@ static void deinterlace_frame_di_greedyh( uint8_t *output, int outstride,
                                           int width, int height )
 {
     TDeinterlaceInfo Info;
-    TPicture Picture[ 8 ];
+    TPicture Picture[ MAX_PICTURE_HISTORY ];
     int stride = (width*2);
     int i;
 
diff --git a/plugins/kdetv_tomsmocomp.c b/plugins/kdetv_tomsmocomp.c
index 4f78f3e..b16cf10 100644
--- a/plugins/kdetv_tomsmocomp.c
+++ b/plugins/kdetv_tomsmocomp.c
@@ -39,7 +39,7 @@ static void deinterlace_frame_di_tomsmocomp( uint8_t *output, int outstride,
                                              int width, int height )
 {
     TDeinterlaceInfo Info;
-    TPicture Picture[ 8 ];
+    TPicture Picture[ MAX_PICTURE_HISTORY ];
     int stride = (width*2);
     int i;
 
-- 
2.7.1

