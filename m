Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:53091 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932069AbdJJHSu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 03:18:50 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 24/26] media: MAINTAINERS: remove lirc staging area
Date: Tue, 10 Oct 2017 08:18:49 +0100
Message-Id: <0491f13356d1bb6e711505e99521fc6097a9c7a0.1507618841.git.sean@mess.org>
In-Reply-To: <cover.1507618840.git.sean@mess.org>
References: <cover.1507618840.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that lirc is no longer in the staging area, remove the entry.

Signed-off-by: Sean Young <sean@mess.org>
---
 MAINTAINERS | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a8126830829b..fb5f548a568e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12677,12 +12677,6 @@ S:	Odd Fixes
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
