Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:45076 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932294AbdKOLdo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 06:33:44 -0500
Received: by mail-wr0-f181.google.com with SMTP id w95so1349066wrc.2
        for <linux-media@vger.kernel.org>; Wed, 15 Nov 2017 03:33:43 -0800 (PST)
Received: from localhost.localdomain ([62.147.246.169])
        by smtp.gmail.com with ESMTPSA id m37sm24217424wrm.4.2017.11.15.03.33.41
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Nov 2017 03:33:41 -0800 (PST)
From: =?UTF-8?q?Rafa=C3=ABl=20Carr=C3=A9?= <funman@videolan.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] dvbv5-daemon: 0 is a valid fd
Date: Wed, 15 Nov 2017 12:33:36 +0100
Message-Id: <20171115113336.3756-2-funman@videolan.org>
In-Reply-To: <20171115113336.3756-1-funman@videolan.org>
References: <20171115113336.3756-1-funman@videolan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 utils/dvb/dvbv5-daemon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/dvb/dvbv5-daemon.c b/utils/dvb/dvbv5-daemon.c
index 58485ac6..711694e0 100644
--- a/utils/dvb/dvbv5-daemon.c
+++ b/utils/dvb/dvbv5-daemon.c
@@ -570,7 +570,7 @@ void dvb_remote_log(void *priv, int level, const char *fmt, ...)
 
 	va_end(ap);
 
-	if (fd > 0)
+	if (fd >= 0)
 		send_data(fd, "%i%s%i%s", 0, "log", level, buf);
 	else
 		local_log(level, buf);
-- 
2.14.1
