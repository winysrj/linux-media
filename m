Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41345 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751251AbeDDOws (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Apr 2018 10:52:48 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 1/1] cec-ctl: Prepare for __inline__ instead of inline
Date: Wed,  4 Apr 2018 17:51:56 +0300
Message-Id: <1522853516-20468-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Once formatted for user space consumption, inlined functions in
include/uapi/linux/cec-funcs.h have "__inline__" modifier instead of
"inline" at least in some circumstances. msg2ctl.pl gets confused of
__inline__, allow both to avoid trouble.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/cec-ctl/msg2ctl.pl | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/utils/cec-ctl/msg2ctl.pl b/utils/cec-ctl/msg2ctl.pl
index 0e494c5..d95e8af 100755
--- a/utils/cec-ctl/msg2ctl.pl
+++ b/utils/cec-ctl/msg2ctl.pl
@@ -383,14 +383,14 @@ while (<>) {
 	next if /^\s*$/;
 	next if /cec_msg_reply_feature_abort/;
 	next if /cec_msg_htng_init/;
-	if (/^static inline void cec_msg.*\(.*\)/) {
-		s/static\sinline\svoid\s//;
+	if (/^static (__)?inline(__)? void cec_msg.*\(.*\)/) {
+		s/static\s(__)?inline(__)?\svoid\s//;
 		s/struct cec_msg \*msg, //;
 		s/struct cec_msg \*msg//;
 		process_func($feature, $_);
 		next;
 	}
-	if (/^static inline void cec_msg/) {
+	if (/^static (__)?inline(__)? void cec_msg/) {
 		$func = $_;
 		next;
 	}
@@ -398,7 +398,7 @@ while (<>) {
 		$func .= $_;
 		next unless /\)$/;
 		$func =~ s/\s+/ /g;
-		$func =~ s/static\sinline\svoid\s//;
+		$func =~ s/static\s(__)?inline(__)?\svoid\s//;
 		$func =~ s/struct cec_msg \*msg, //;
 		$func =~ s/struct cec_msg \*msg//;
 		process_func($feature, $func);
-- 
2.7.4
