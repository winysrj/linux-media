Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:43282 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3F0VLo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 17:11:44 -0400
Received: by mail-ee0-f41.google.com with SMTP id d17so663428eek.28
        for <linux-media@vger.kernel.org>; Thu, 27 Jun 2013 14:11:43 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH 1/2] libv4lconvert: Prevent integer overflow by checking width and height
Date: Thu, 27 Jun 2013 23:11:30 +0200
Message-Id: <1372367491-13187-2-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1372367491-13187-1-git-send-email-gjasny@googlemail.com>
References: <1372367491-13187-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Mayhem Team found a crash caused by an integer overflow.
Details are here:
http://www.forallsecure.com/bug-reports/8aae67d864bce76993f3f9812b4a2aeea0eb38da/

Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
---
 lib/libv4lconvert/ov511-decomp.c | 7 ++++++-
 lib/libv4lconvert/ov518-decomp.c | 7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/lib/libv4lconvert/ov511-decomp.c b/lib/libv4lconvert/ov511-decomp.c
index 90fc4b1..971d497 100644
--- a/lib/libv4lconvert/ov511-decomp.c
+++ b/lib/libv4lconvert/ov511-decomp.c
@@ -14,6 +14,7 @@
  * Free Software Foundation; version 2 of the License.
  */
 
+#include <limits.h>
 #include <string.h>
 #include <unistd.h>
 #include "helper-funcs.h"
@@ -640,7 +641,11 @@ int main(int argc, char *argv[])
 
 
 		dest_size = width * height * 3 / 2;
-		if (dest_size > sizeof(dest_buf)) {
+		if (width <= 0 || width > SHRT_MAX || height <= 0 || height > SHRT_MAX) {
+			fprintf(stderr, "%s: error: width or height out of bounds\n",
+					argv[0]);
+			dest_size = -1;
+		} else if (dest_size > sizeof(dest_buf)) {
 			fprintf(stderr, "%s: error: dest_buf too small, need: %d\n",
 					argv[0], dest_size);
 			dest_size = -1;
diff --git a/lib/libv4lconvert/ov518-decomp.c b/lib/libv4lconvert/ov518-decomp.c
index 47b5cbb..91d908c 100644
--- a/lib/libv4lconvert/ov518-decomp.c
+++ b/lib/libv4lconvert/ov518-decomp.c
@@ -15,6 +15,7 @@
  * Free Software Foundation; version 2 of the License.
  */
 
+#include <limits.h>
 #include <string.h>
 #include <unistd.h>
 #include "helper-funcs.h"
@@ -1454,7 +1455,11 @@ int main(int argc, char *argv[])
 
 
 		dest_size = width * height * 3 / 2;
-		if (dest_size > sizeof(dest_buf)) {
+		if (width <= 0 || width > SHRT_MAX || height <= 0 || height > SHRT_MAX) {
+			fprintf(stderr, "%s: error: width or height out of bounds\n",
+					argv[0]);
+			dest_size = -1;
+		} else if (dest_size > sizeof(dest_buf)) {
 			fprintf(stderr, "%s: error: dest_buf too small, need: %d\n",
 					argv[0], dest_size);
 			dest_size = -1;
-- 
1.8.3.1

