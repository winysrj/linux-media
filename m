Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:43783 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751911AbdKWM6j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Nov 2017 07:58:39 -0500
Received: by mail-wm0-f67.google.com with SMTP id x63so16667918wmf.2
        for <linux-media@vger.kernel.org>; Thu, 23 Nov 2017 04:58:39 -0800 (PST)
From: =?UTF-8?q?Rafa=C3=ABl=20Carr=C3=A9?= <funman@videolan.org>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Rafa=C3=ABl=20Carr=C3=A9?= <funman@videolan.org>
Subject: [PATCH] dvb_local_read: ignore EAGAIN
Date: Thu, 23 Nov 2017 12:58:28 +0000
Message-Id: <20171123125828.24380-1-funman@videolan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the device has been opened with O_NONBLOCK, EAGAIN is a legitimate error

Signed-off-by: Rafaël Carré <funman@videolan.org>
---
 lib/libdvbv5/dvb-dev-local.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/libdvbv5/dvb-dev-local.c b/lib/libdvbv5/dvb-dev-local.c
index eb2f0775..a9571ca5 100644
--- a/lib/libdvbv5/dvb-dev-local.c
+++ b/lib/libdvbv5/dvb-dev-local.c
@@ -577,7 +577,7 @@ static ssize_t dvb_local_read(struct dvb_open_descriptor *open_dev,
 
 	ret = read(fd, buf, count);
 	if (ret == -1) {
-		if (errno != EOVERFLOW)
+		if (errno != EOVERFLOW && errno != EAGAIN)
 			dvb_perror("read()");
 		return -errno;
 	}
-- 
2.14.1
