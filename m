Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:61943 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaC3QWA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 12:22:00 -0400
Received: by mail-ee0-f44.google.com with SMTP id e49so5785487eek.17
        for <linux-media@vger.kernel.org>; Sun, 30 Mar 2014 09:21:59 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 7/8] libdvbv5: fix lost ressource in atsc_eit
Date: Sun, 30 Mar 2014 18:21:17 +0200
Message-Id: <1396196478-996-7-git-send-email-neolynx@gmail.com>
In-Reply-To: <1396196478-996-1-git-send-email-neolynx@gmail.com>
References: <1396196478-996-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

if the title of the EIT event is longer than the available data,
make sure the allocated buffer is not lost

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/descriptors/atsc_eit.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/libdvbv5/descriptors/atsc_eit.c b/lib/libdvbv5/descriptors/atsc_eit.c
index 92764df..9e1397d 100644
--- a/lib/libdvbv5/descriptors/atsc_eit.c
+++ b/lib/libdvbv5/descriptors/atsc_eit.c
@@ -74,6 +74,11 @@ ssize_t atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
                 atsc_time(event->start_time, &event->start);
 		event->source_id = eit->header.id;
 
+		if(!*head)
+			*head = event;
+		if(last)
+			last->next = event;
+
 		size = event->title_length - 1;
 		if (p + size > endbuf) {
 			dvb_logerr("%s: short read %zd/%zd bytes", __func__,
@@ -83,11 +88,6 @@ ssize_t atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
                 /* TODO: parse title */
                 p += size;
 
-		if(!*head)
-			*head = event;
-		if(last)
-			last->next = event;
-
 		/* get the descriptors for each program */
 		size = sizeof(union atsc_table_eit_desc_length);
 		if (p + size > endbuf) {
-- 
1.8.3.2

