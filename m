Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:55879 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab3L1Pq0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 10:46:26 -0500
Received: by mail-ee0-f44.google.com with SMTP id b57so4480886eek.3
        for <linux-media@vger.kernel.org>; Sat, 28 Dec 2013 07:46:25 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 09/13] libdvbv5: fix section counting
Date: Sat, 28 Dec 2013 16:45:57 +0100
Message-Id: <1388245561-8751-9-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
References: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/dvb-scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index bd9d2fb..6f3def6 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -208,7 +208,7 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
 		else if (start_id == h->id && h->section_id == first_section)
 			break;
 
-		if (last_section == -1)
+		if (last_section == -1 || h->last_section > last_section)
 			last_section = h->last_section;
 
 		if (!tbl) {
-- 
1.8.3.2

