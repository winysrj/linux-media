Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:55019 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab3L1PqU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 10:46:20 -0500
Received: by mail-ea0-f173.google.com with SMTP id o10so4355776eaj.18
        for <linux-media@vger.kernel.org>; Sat, 28 Dec 2013 07:46:19 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 04/13] libdvbv5: fix deadlock on missing table sections
Date: Sat, 28 Dec 2013 16:45:52 +0100
Message-Id: <1388245561-8751-4-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
References: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/dvb-scan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index 76712d4..9751f9d 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -96,6 +96,10 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
 	uint8_t *buf = NULL;
 	uint8_t *tbl = NULL;
 	ssize_t table_length = 0;
+
+	// handle sections
+	int start_id = -1;
+	int start_section = -1;
 	int first_section = -1;
 	int last_section = -1;
 	int table_id = -1;
-- 
1.8.3.2

