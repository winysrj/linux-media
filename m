Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36669 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab2EMMSN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 08:18:13 -0400
Received: by wibhm6 with SMTP id hm6so732019wib.1
        for <linux-media@vger.kernel.org>; Sun, 13 May 2012 05:18:12 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 2/8] fixed off by one parameter check error
Date: Sun, 13 May 2012 14:17:24 +0200
Message-Id: <1336911450-23661-2-git-send-email-neolynx@gmail.com>
In-Reply-To: <1336911450-23661-1-git-send-email-neolynx@gmail.com>
References: <1336911450-23661-1-git-send-email-neolynx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 utils/dvb/dvbv5-scan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
index d785998..d54aa8c 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -548,9 +548,9 @@ int main(int argc, char **argv)
 	parms = dvb_fe_open(args.adapter, args.frontend, verbose, 0);
 	if (!parms)
 		return -1;
-	if (lnb)
+	if (lnb >= 0)
 		parms->lnb = get_lnb(lnb);
-	if (args.sat_number > 0)
+	if (args.sat_number >= 0)
 		parms->sat_number = args.sat_number % 3;
 	parms->diseqc_wait = args.diseqc_wait;
 	parms->freq_bpf = args.freq_bpf;
-- 
1.7.2.5

