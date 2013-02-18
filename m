Return-path: <linux-media-owner@vger.kernel.org>
Received: from infernal.debian.net ([176.28.9.132]:44722 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164Ab3BRAvR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Feb 2013 19:51:17 -0500
Date: Mon, 18 Feb 2013 01:12:44 +0100
From: Andreas Bombe <aeb@debian.org>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [media-ctl PATCH] Add missing stdlib.h and ctype.h includes
Message-ID: <20130218001244.GA7932@amos.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

src/mediactl.c needs ctype.h for its use of isspace().

src/v4l2subdev.c needs stdlib.h for strtoul() and ctype.h for isspace()
and isupper().

Signed-off-by: Andreas Bombe <aeb@debian.org>
---
 src/mediactl.c   |    1 +
 src/v4l2subdev.c |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/src/mediactl.c b/src/mediactl.c
index 46562de..c2f985a 100644
--- a/src/mediactl.c
+++ b/src/mediactl.c
@@ -29,6 +29,7 @@
 #include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include <ctype.h>
 #include <string.h>
 #include <fcntl.h>
 #include <errno.h>
diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
index d0c37f3..87d7eb7 100644
--- a/src/v4l2subdev.c
+++ b/src/v4l2subdev.c
@@ -26,6 +26,8 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <stdbool.h>
+#include <stdlib.h>
+#include <ctype.h>
 #include <stdio.h>
 #include <string.h>
 #include <unistd.h>
-- 
1.7.10.4
