Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:54506 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab3L1Pq3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 10:46:29 -0500
Received: by mail-ea0-f173.google.com with SMTP id o10so4355822eaj.18
        for <linux-media@vger.kernel.org>; Sat, 28 Dec 2013 07:46:28 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 12/13] libdvbv5: fix missing includes
Date: Sat, 28 Dec 2013 16:46:00 +0100
Message-Id: <1388245561-8751-12-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
References: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/dvb-file.c     | 1 +
 lib/libdvbv5/dvb-sat.c      | 1 +
 lib/libdvbv5/dvb-scan.c     | 1 +
 lib/libdvbv5/parse_string.c | 1 +
 4 files changed, 4 insertions(+)

diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index 9abb1f7..d5b00e2 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -21,6 +21,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <strings.h> // strcasecmp
 #include <unistd.h>
 
 #include "dvb-file.h"
diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index 3cbcf03..c35e3d7 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -21,6 +21,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include <strings.h> // strcasecmp
 
 #include "dvb-fe.h"
 #include "dvb-v5-std.h"
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index 6f3def6..d0f0b39 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -35,6 +35,7 @@
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <stdlib.h>
+#include <sys/time.h>
 
 #include "dvb-scan.h"
 #include "dvb-frontend.h"
diff --git a/lib/libdvbv5/parse_string.c b/lib/libdvbv5/parse_string.c
index f7b745e..8bd56f3 100644
--- a/lib/libdvbv5/parse_string.c
+++ b/lib/libdvbv5/parse_string.c
@@ -27,6 +27,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <strings.h> // strcasecmp
 
 #include "parse_string.h"
 #include "dvb-log.h"
-- 
1.8.3.2

