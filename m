Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43773 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaAMK7y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 05:59:54 -0500
Received: by mail-pa0-f46.google.com with SMTP id rd3so1733173pab.33
        for <linux-media@vger.kernel.org>; Mon, 13 Jan 2014 02:59:54 -0800 (PST)
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] Update the link pointing the patch for porting the application to libv4l2
Date: Mon, 13 Jan 2014 16:29:46 +0530
Message-Id: <1389610787-16679-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 README.libv4l |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/README.libv4l b/README.libv4l
index 0be503f..ffe6366 100644
--- a/README.libv4l
+++ b/README.libv4l
@@ -169,4 +169,4 @@ A: Just replace the open call for your device by v4l2_open and all
 Q: I still need an example how to convert my application!
 A: Check out the patches for the VLC media player:
    https://trac.videolan.org/vlc/attachment/ticket/1804/vlc-0.8.6-libv4l1.patch
-   https://trac.videolan.org/vlc/attachment/ticket/1804/vlc-0.8.6-libv4l2.patch
+   https://trac.videolan.org/vlc/attachment/ticket/1804/vlc-0.9.3-libv4l2.patch
-- 
1.7.9.5

