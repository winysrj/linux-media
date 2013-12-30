Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:48959 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab3L3Mtd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 07:49:33 -0500
Received: by mail-ee0-f41.google.com with SMTP id t10so5091127eei.14
        for <linux-media@vger.kernel.org>; Mon, 30 Dec 2013 04:49:32 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 12/18] libdvbv5: fix missing includes
Date: Mon, 30 Dec 2013 13:48:45 +0100
Message-Id: <1388407731-24369-12-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/dvb-file.c     | 1 +
 lib/libdvbv5/dvb-sat.c      | 3 ++-
 lib/libdvbv5/dvb-scan.c     | 1 +
 lib/libdvbv5/parse_string.c | 1 +
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index 9abb1f7..1e41fbb 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -21,6 +21,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <strings.h> /* strcasecmp */
 #include <unistd.h>
 
 #include "dvb-file.h"
diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index 3cbcf03..09eb4d1 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -21,6 +21,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include <strings.h> /* strcasecmp */
 
 #include "dvb-fe.h"
 #include "dvb-v5-std.h"
@@ -302,7 +303,7 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms *parms, uint16_t t)
 	rc = dvb_fe_sec_voltage(parms, 1, vol_high);
 	if (rc)
 		return rc;
-	
+
 	if (parms->sat_number > 0) {
 		rc = dvb_fe_sec_tone(parms, SEC_TONE_OFF);
 		if (rc)
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
index f7b745e..5ae5a18 100644
--- a/lib/libdvbv5/parse_string.c
+++ b/lib/libdvbv5/parse_string.c
@@ -27,6 +27,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <strings.h> /* strcasecmp */
 
 #include "parse_string.h"
 #include "dvb-log.h"
-- 
1.8.3.2

