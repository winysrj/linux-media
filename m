Return-path: <linux-media-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.64.118]:47394 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756651AbZGHWbm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jul 2009 18:31:42 -0400
Received: from chimera.site ([98.108.130.97]) by xenotime.net for <linux-media@vger.kernel.org>; Wed, 8 Jul 2009 15:31:37 -0700
Date: Wed, 8 Jul 2009 15:31:40 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-media@vger.kernel.org
Cc: Mhayk Whandson <eu@mhayk.com.br>
Subject: [PATCH] v4l doc: fix cqcam source code path
Message-Id: <20090708153140.43079cba.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mhayk Whandson <eu@mhayk.com.br>

Fixed the c-qcam source code path in the linux kernel tree.

Signed-off-by: Mhayk Whandson <eu@mhayk.com.br>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/video4linux/CQcam.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.31-rc2-git2.orig/Documentation/video4linux/CQcam.txt
+++ linux-2.6.31-rc2-git2/Documentation/video4linux/CQcam.txt
@@ -18,8 +18,8 @@ Table of Contents
 
 1.0 Introduction
 
-  The file ../drivers/char/c-qcam.c is a device driver for the
-Logitech (nee Connectix) parallel port interface color CCD camera.
+  The file ../../drivers/media/video/c-qcam.c is a device driver for
+the Logitech (nee Connectix) parallel port interface color CCD camera.
 This is a fairly inexpensive device for capturing images.  Logitech
 does not currently provide information for developers, but many people
 have engineered several solutions for non-Microsoft use of the Color
