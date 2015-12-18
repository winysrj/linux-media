Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:33721 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933216AbbLRO3e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 09:29:34 -0500
Received: by mail-wm0-f42.google.com with SMTP id p187so67213048wmp.0
        for <linux-media@vger.kernel.org>; Fri, 18 Dec 2015 06:29:34 -0800 (PST)
From: Jemma Denson <jdenson@gmail.com>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org
Subject: [v4l-utils PATCH-v2 4/4] dvbv5-zap.c: Move common signals code into function
Date: Fri, 18 Dec 2015 14:28:26 +0000
Message-Id: <1450448906-17000-5-git-send-email-jdenson@gmail.com>
In-Reply-To: <1450448906-17000-1-git-send-email-jdenson@gmail.com>
References: <1450448906-17000-1-git-send-email-jdenson@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Code repeated 3 times; move to common function.

Signed-off-by: Jemma Denson <jdenson@gmail.com>
---
 utils/dvb/dvbv5-zap.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index 2d71307..ef17be9 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -737,6 +737,16 @@ int do_traffic_monitor(struct arguments *args,
 	return 0;
 }
 
+static void set_signals(struct arguments *args)
+{
+	signal(SIGTERM, do_timeout);
+	signal(SIGINT, do_timeout);
+	if (args->timeout > 0) {
+		signal(SIGALRM, do_timeout);
+		alarm(args->timeout);
+	}
+}
+
 int main(int argc, char **argv)
 {
 	struct arguments args;
@@ -855,26 +865,14 @@ int main(int argc, char **argv)
 		goto err;
 
 	if (args.exit_after_tuning) {
-		signal(SIGTERM, do_timeout);
-		signal(SIGINT, do_timeout);
-		if (args.timeout > 0) {
-			signal(SIGALRM, do_timeout);
-			alarm(args.timeout);
-		}
-
+		set_signals(&args);
 		err = 0;
 		check_frontend(&args, parms);
 		goto err;
 	}
 
 	if (args.traffic_monitor) {
-		signal(SIGTERM, do_timeout);
-		signal(SIGINT, do_timeout);
-		if (args.timeout > 0) {
-			signal(SIGALRM, do_timeout);
-			alarm(args.timeout);
-		}
-
+		set_signals(&args);
 		err = do_traffic_monitor(&args, parms);
 		goto err;
 	}
@@ -966,12 +964,7 @@ int main(int argc, char **argv)
 			goto err;
 	}
 
-	signal(SIGTERM, do_timeout);
-	signal(SIGINT, do_timeout);
-	if (args.timeout > 0) {
-		signal(SIGALRM, do_timeout);
-		alarm(args.timeout);
-	}
+	set_signals(&args);
 
 	if (!check_frontend(&args, parms)) {
 		err = 1;
-- 
2.1.0

