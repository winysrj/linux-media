Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60294 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab2HCK1o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 06:27:44 -0400
Received: by weyx8 with SMTP id x8so310698wey.19
        for <linux-media@vger.kernel.org>; Fri, 03 Aug 2012 03:27:42 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 5/6] libdvbv5: added abort flag
Date: Fri,  3 Aug 2012 12:26:58 +0200
Message-Id: <1343989619-12928-5-git-send-email-neolynx@gmail.com>
In-Reply-To: <1343989619-12928-1-git-send-email-neolynx@gmail.com>
References: <1343989619-12928-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/dvb-fe.h  |    1 +
 lib/libdvbv5/dvb-fe.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/include/dvb-fe.h b/lib/include/dvb-fe.h
index 8b795cb..b2c3587 100644
--- a/lib/include/dvb-fe.h
+++ b/lib/include/dvb-fe.h
@@ -88,6 +88,7 @@ struct dvb_v5_fe_parms {
 	unsigned			diseqc_wait;
 	unsigned			freq_offset;
 
+	int				abort;
         dvb_logfunc                     logfunc;
 };
 
diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 1636948..8ed73b6 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -69,6 +69,7 @@ struct dvb_v5_fe_parms *dvb_fe_open2(int adapter, int frontend, unsigned verbose
 	parms->verbose = verbose;
 	parms->fd = fd;
 	parms->sat_number = -1;
+        parms->abort = 0;
         parms->logfunc = logfunc;
 
 	if (ioctl(fd, FE_GET_INFO, &parms->info) == -1) {
-- 
1.7.2.5

