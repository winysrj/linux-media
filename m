Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57993 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754501AbdGUQMk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 12:12:40 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] docs-next: update the fe_status documentation for FE_NONE
Date: Fri, 21 Jul 2017 17:12:38 +0100
Message-Id: <20170721161238.22824-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Recently added FE_NONE to the enum fe_status, so update the
documentation accordingly.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 Documentation/media/uapi/dvb/fe-read-status.rst | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/Documentation/media/uapi/dvb/fe-read-status.rst b/Documentation/media/uapi/dvb/fe-read-status.rst
index 812f086c20f5..a0e98694c68c 100644
--- a/Documentation/media/uapi/dvb/fe-read-status.rst
+++ b/Documentation/media/uapi/dvb/fe-read-status.rst
@@ -71,13 +71,21 @@ state changes of the frontend hardware. It is produced using the enum
 
     -  .. row 2
 
+       -  .. _FE-NONE:
+
+	  ``FE_NONE``
+
+       -  The frontend status is in an initialized undefined state
+
+    -  .. row 3
+
        -  .. _FE-HAS-SIGNAL:
 
 	  ``FE_HAS_SIGNAL``
 
        -  The frontend has found something above the noise level
 
-    -  .. row 3
+    -  .. row 4
 
        -  .. _FE-HAS-CARRIER:
 
@@ -85,7 +93,7 @@ state changes of the frontend hardware. It is produced using the enum
 
        -  The frontend has found a DVB signal
 
-    -  .. row 4
+    -  .. row 5
 
        -  .. _FE-HAS-VITERBI:
 
@@ -94,7 +102,7 @@ state changes of the frontend hardware. It is produced using the enum
        -  The frontend FEC inner coding (Viterbi, LDPC or other inner code)
 	  is stable
 
-    -  .. row 5
+    -  .. row 6
 
        -  .. _FE-HAS-SYNC:
 
@@ -102,7 +110,7 @@ state changes of the frontend hardware. It is produced using the enum
 
        -  Synchronization bytes was found
 
-    -  .. row 6
+    -  .. row 7
 
        -  .. _FE-HAS-LOCK:
 
@@ -110,7 +118,7 @@ state changes of the frontend hardware. It is produced using the enum
 
        -  The DVB were locked and everything is working
 
-    -  .. row 7
+    -  .. row 8
 
        -  .. _FE-TIMEDOUT:
 
@@ -118,7 +126,7 @@ state changes of the frontend hardware. It is produced using the enum
 
        -  no lock within the last about 2 seconds
 
-    -  .. row 8
+    -  .. row 9
 
        -  .. _FE-REINIT:
 
-- 
2.11.0
