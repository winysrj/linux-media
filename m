Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:56273 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751981AbdJ2U6q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 16:58:46 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 08/28] media: MAINTAINERS: remove lirc staging area
Date: Sun, 29 Oct 2017 20:58:44 +0000
Message-Id: <c933c2ccacc306e730913e9c0b8d6c96b61b5296.1509309834.git.sean@mess.org>
In-Reply-To: <cover.1509309834.git.sean@mess.org>
References: <cover.1509309834.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that lirc is no longer in the staging area, remove the entry.

Signed-off-by: Sean Young <sean@mess.org>
---
 MAINTAINERS | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index adbf69306e9e..59c061d3d61a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12712,12 +12712,6 @@ S:	Odd Fixes
 F:	Documentation/devicetree/bindings/staging/iio/
 F:	drivers/staging/iio/
 
-STAGING - LIRC (LINUX INFRARED REMOTE CONTROL) DRIVERS
-M:	Jarod Wilson <jarod@wilsonet.com>
-W:	http://www.lirc.org/
-S:	Odd Fixes
-F:	drivers/staging/media/lirc/
-
 STAGING - LUSTRE PARALLEL FILESYSTEM
 M:	Oleg Drokin <oleg.drokin@intel.com>
 M:	Andreas Dilger <andreas.dilger@intel.com>
-- 
2.13.6
