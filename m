Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbcBMSsN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2016 13:48:13 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 92F0B5A4F
	for <linux-media@vger.kernel.org>; Sat, 13 Feb 2016 18:48:13 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 15/17] Do not call videoinput_buffer_invalid with a negative index
Date: Sat, 13 Feb 2016 19:47:36 +0100
Message-Id: <1455389258-13470-15-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
References: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 src/tvtime.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/src/tvtime.c b/src/tvtime.c
index 1905387..d016bac 100644
--- a/src/tvtime.c
+++ b/src/tvtime.c
@@ -2086,17 +2086,20 @@ int tvtime_main( rtctimer_t *rtctimer, int read_stdin, int realtime,
                 } else {
                     /* Make sure our buffers are valid. */
                     if( fieldsavailable == 2 ) {
-                        if( videoinput_buffer_invalid( vidin, lastframeid ) ) {
+                        if( lastframeid == -1 ||
+			        videoinput_buffer_invalid( vidin, lastframeid ) ) {
                             lastframe = curframe;
                             lastframeid = -1;
                         }
                     } else if( fieldsavailable == 4 ) {
-                        if( videoinput_buffer_invalid( vidin,
+                        if( secondlastframeid == -1 ||
+                                videoinput_buffer_invalid( vidin,
                                                        secondlastframeid ) ) {
                             secondlastframe = curframe;
                             secondlastframeid = -1;
                         }
-                        if( videoinput_buffer_invalid( vidin, lastframeid ) ) {
+                        if( lastframeid == -1 ||
+			        videoinput_buffer_invalid( vidin, lastframeid ) ) {
                             lastframe = curframe;
                             lastframeid = -1;
                         }
-- 
2.5.0

