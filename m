Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37016 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582AbbLRO3e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 09:29:34 -0500
Received: by mail-wm0-f50.google.com with SMTP id p187so66900171wmp.0
        for <linux-media@vger.kernel.org>; Fri, 18 Dec 2015 06:29:33 -0800 (PST)
From: Jemma Denson <jdenson@gmail.com>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org
Subject: [v4l-utils PATCH-v2 3/4] dvbv5-zap.c: fix wrong signal
Date: Fri, 18 Dec 2015 14:28:25 +0000
Message-Id: <1450448906-17000-4-git-send-email-jdenson@gmail.com>
In-Reply-To: <1450448906-17000-1-git-send-email-jdenson@gmail.com>
References: <1450448906-17000-1-git-send-email-jdenson@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signal here should be SIGALRM and not SIGINT in order to call do_timeout().

Signed-off-by: Jemma Denson <jdenson@gmail.com>
---
 utils/dvb/dvbv5-zap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index 2d19d45..2d71307 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -871,7 +871,7 @@ int main(int argc, char **argv)
 		signal(SIGTERM, do_timeout);
 		signal(SIGINT, do_timeout);
 		if (args.timeout > 0) {
-			signal(SIGINT, do_timeout);
+			signal(SIGALRM, do_timeout);
 			alarm(args.timeout);
 		}
 
-- 
2.1.0

