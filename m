Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:34425 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933180AbbLRO3d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 09:29:33 -0500
Received: by mail-wm0-f54.google.com with SMTP id l126so67894845wml.1
        for <linux-media@vger.kernel.org>; Fri, 18 Dec 2015 06:29:32 -0800 (PST)
From: Jemma Denson <jdenson@gmail.com>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org
Subject: [v4l-utils PATCH-v2 2/4] dvbv5-zap.c: allow timeout with -x
Date: Fri, 18 Dec 2015 14:28:24 +0000
Message-Id: <1450448906-17000-3-git-send-email-jdenson@gmail.com>
In-Reply-To: <1450448906-17000-1-git-send-email-jdenson@gmail.com>
References: <1450448906-17000-1-git-send-email-jdenson@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Timeout handlers aren't set when running with -x (exit after tuning).
This patch adds handlers so -t can be used with -x.

Without a timeout dvbv5-zap will run forever if there's no signal,
preventing it's use by scripts to obtain signal stats.

Signed-off-by: Jemma Denson <jdenson@gmail.com>
---
 utils/dvb/dvbv5-zap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index e927383..2d19d45 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -855,6 +855,13 @@ int main(int argc, char **argv)
 		goto err;
 
 	if (args.exit_after_tuning) {
+		signal(SIGTERM, do_timeout);
+		signal(SIGINT, do_timeout);
+		if (args.timeout > 0) {
+			signal(SIGALRM, do_timeout);
+			alarm(args.timeout);
+		}
+
 		err = 0;
 		check_frontend(&args, parms);
 		goto err;
-- 
2.1.0

