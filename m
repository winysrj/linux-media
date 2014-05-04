Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep15.mx.upcmail.net ([62.179.121.35]:54215 "EHLO
	fep15.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbaEDCJ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 May 2014 22:09:57 -0400
From: Jonathan McCrohan <jmccrohan@gmail.com>
To: linux-media@vger.kernel.org,
	pkg-vdr-dvb-devel@lists.alioth.debian.org
Cc: Jonathan McCrohan <jmccrohan@gmail.com>
Subject: [PATCH 2/6] [dvb-apps] dvbscan: fix infinite loop parsing arguments
Date: Sun,  4 May 2014 02:51:17 +0100
Message-Id: <1399168281-20626-3-git-send-email-jmccrohan@gmail.com>
In-Reply-To: <1399168281-20626-1-git-send-email-jmccrohan@gmail.com>
References: <1399168281-20626-1-git-send-email-jmccrohan@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reproducible using 'dvbscan -out raw - some_file'

Bug-Debian: http://bugs.debian.org/606728

Signed-off-by: Jonathan McCrohan <jmccrohan@gmail.com>
---
 util/dvbscan/dvbscan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/util/dvbscan/dvbscan.c b/util/dvbscan/dvbscan.c
index f23411f..462c275 100644
--- a/util/dvbscan/dvbscan.c
+++ b/util/dvbscan/dvbscan.c
@@ -198,6 +198,7 @@ int main(int argc, char *argv[])
 		} else if (!strcmp(argv[argpos], "-out")) {
 			if ((argc - argpos) < 3)
 				usage();
+				argpos+=3;
 		} else {
 			if ((argc - argpos) != 1)
 				usage();
-- 
1.9.2

