Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48637 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932646AbaJaNOR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 09:14:17 -0400
Received: by mail-pa0-f53.google.com with SMTP id kx10so7604318pab.26
        for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 06:14:16 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v3 2/7] v4l-utils/libdvbv5: add as many channels as possible in scanning DVB-T2
Date: Fri, 31 Oct 2014 22:13:39 +0900
Message-Id: <1414761224-32761-3-git-send-email-tskd08@gmail.com>
In-Reply-To: <1414761224-32761-1-git-send-email-tskd08@gmail.com>
References: <1414761224-32761-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 lib/libdvbv5/dvb-scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index 31eb78f..690e393 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -925,7 +925,7 @@ static void add_update_nit_dvbt2(struct dvb_table_nit *nit,
 					 t2->centre_frequency[i] * 10,
 					 tr->shift, tr->pol, t2->plp_id);
 		if (!new)
-			return;
+			continue;
 
 		dvb_store_entry_prop(new, DTV_DELIVERY_SYSTEM,
 				     SYS_DVBT2);
-- 
2.1.3

