Return-path: <linux-media-owner@vger.kernel.org>
Received: from infernal.debian.net ([176.28.9.132]:44715 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab3BRAvQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Feb 2013 19:51:16 -0500
Date: Mon, 18 Feb 2013 01:10:02 +0100
From: Andreas Bombe <aeb@debian.org>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [media-ctl PATCH] configure.ac: Respect CPPFLAGS from environment
Message-ID: <20130218001002.GA7885@amos.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andreas Bombe <aeb@debian.org>
---
 configure.ac |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 98459d4..a749794 100644
--- a/configure.ac
+++ b/configure.ac
@@ -48,7 +48,7 @@ AC_ARG_WITH(kernel-headers,
      esac],
     [KERNEL_HEADERS_DIR="/usr/src/kernel-headers"])
 
-CPPFLAGS="-I$KERNEL_HEADERS_DIR/include"
+CPPFLAGS="$CPPFLAGS -I$KERNEL_HEADERS_DIR/include"
 
 # Checks for header files.
 AC_CHECK_HEADERS([linux/media.h \
-- 
1.7.10.4


-- 
Andreas Bombe
