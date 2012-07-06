Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47661 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757567Ab2GFTXz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 15:23:55 -0400
Received: by wibhr14 with SMTP id hr14so1171001wib.1
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2012 12:23:54 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 2/5] libdvbv5: Fix set delsys other than current
Date: Fri,  6 Jul 2012 21:23:09 +0200
Message-Id: <1341602592-29508-2-git-send-email-neolynx@gmail.com>
In-Reply-To: <1341602592-29508-1-git-send-email-neolynx@gmail.com>
References: <1341602592-29508-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/dvb-fe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 4fb927a..9b18226 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -392,8 +392,8 @@ int dvb_set_compat_delivery_system(struct dvb_v5_fe_parms *parms,
 	for (i = 0; i < parms->num_systems; i++) {
 		if (parms->systems[i] == desired_system) {
 			dvb_set_sys(parms, desired_system);
+			return 0;
 		}
-		return 0;
 	}
 
 	/*
-- 
1.7.2.5

