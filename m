Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:45185 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752509AbdLMLCW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 06:02:22 -0500
Received: by mail-wm0-f65.google.com with SMTP id 9so4141666wme.4
        for <linux-media@vger.kernel.org>; Wed, 13 Dec 2017 03:02:21 -0800 (PST)
From: =?UTF-8?q?Rafa=C3=ABl=20Carr=C3=A9?= <funman@videolan.org>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Rafa=C3=ABl=20Carr=C3=A9?= <funman@videolan.org>
Subject: [PATCH] dvbv5-zap: accept -S 0 option
Date: Wed, 13 Dec 2017 12:02:13 +0100
Message-Id: <20171213110213.7219-1-funman@videolan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Rafaël Carré <funman@videolan.org>
---
 utils/dvb/dvbv5-zap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index a88500d1..1b6dabd0 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -930,7 +930,7 @@ int main(int argc, char **argv)
 		goto err;
 	if (lnb >= 0)
 		parms->lnb = dvb_sat_get_lnb(lnb);
-	if (args.sat_number > 0)
+	if (args.sat_number >= 0)
 		parms->sat_number = args.sat_number;
 	parms->diseqc_wait = args.diseqc_wait;
 	parms->freq_bpf = args.freq_bpf;
-- 
2.14.1
