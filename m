Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:60679 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751421AbdJEIpl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 04:45:41 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 23/25] media: MAINTAINERS: remove lirc staging area
Date: Thu,  5 Oct 2017 09:45:25 +0100
Message-Id: <369f6ef0e377f9e4cd46d5d2be098fab7ff35ec2.1507192752.git.sean@mess.org>
In-Reply-To: <88e30a50734f7d132ac8a6234acc7335cbbb3a56.1507192751.git.sean@mess.org>
References: <88e30a50734f7d132ac8a6234acc7335cbbb3a56.1507192751.git.sean@mess.org>
In-Reply-To: <cover.1507192751.git.sean@mess.org>
References: <cover.1507192751.git.sean@mess.org>
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
