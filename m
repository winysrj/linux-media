Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35888 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933164AbbLRO3c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 09:29:32 -0500
Received: by mail-wm0-f46.google.com with SMTP id p187so65899700wmp.1
        for <linux-media@vger.kernel.org>; Fri, 18 Dec 2015 06:29:31 -0800 (PST)
From: Jemma Denson <jdenson@gmail.com>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org
Subject: [v4l-utils PATCH-v2 1/4] dvbv5-zap.c: fix setting signal handlers
Date: Fri, 18 Dec 2015 14:28:23 +0000
Message-Id: <1450448906-17000-2-git-send-email-jdenson@gmail.com>
In-Reply-To: <1450448906-17000-1-git-send-email-jdenson@gmail.com>
References: <1450448906-17000-1-git-send-email-jdenson@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signal handlers are currently out of order - SIGALRM is always set, and
SIGINT only set when timeout is set. These should be the other way round.

Signed-off-by: Jemma Denson <jdenson@gmail.com>
---
 utils/dvb/dvbv5-zap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index e19d7c2..e927383 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -959,10 +959,10 @@ int main(int argc, char **argv)
 			goto err;
 	}
 
-	signal(SIGALRM, do_timeout);
 	signal(SIGTERM, do_timeout);
+	signal(SIGINT, do_timeout);
 	if (args.timeout > 0) {
-		signal(SIGINT, do_timeout);
+		signal(SIGALRM, do_timeout);
 		alarm(args.timeout);
 	}
 
-- 
2.1.0

