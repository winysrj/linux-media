Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56814 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab2ELXW7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 May 2012 19:22:59 -0400
Received: by obbtb18 with SMTP id tb18so5245390obb.19
        for <linux-media@vger.kernel.org>; Sat, 12 May 2012 16:22:59 -0700 (PDT)
Message-ID: <4FAEF0D0.4080801@gmail.com>
Date: Sat, 12 May 2012 18:22:56 -0500
From: Mike Slegeir <tehpola@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: atsc_epg 64-bit bug / fault tolerance
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I was looking at using the dvb-apps when I had a hangup with atsc_epg.  
This issue had been previously reported from what I found at 
http://www.mail-archive.com/linux-media@vger.kernel.org/msg44661.html 
but had not been resolved from what I could tell.
Below I'm including a patch to fix the segfault on 64-bit builds and 
also to improve tolerance of the fault I found when a segment was read 
with a mode of '?' (don't ask me why, but I could try to give more 
information if desired).
The first three changes in the patch are about using an appropriately 
sized type rather than casting a pointer to a larger type; this fixes 
the segfault.  The last change involves nulling the title text when it 
fails to parse rather than failing altogether.

Thanks,
Mike Slegeir

diff -r 4030c51d6e7b util/atsc_epg/atsc_epg.c
--- a/util/atsc_epg/atsc_epg.c    Tue Apr 10 16:44:06 2012 +0200
+++ b/util/atsc_epg/atsc_epg.c    Sat May 12 18:15:04 2012 -0500
@@ -60,8 +60,8 @@
  void (*old_handler)(int);

  struct atsc_string_buffer {
-    int buf_len;
-    int buf_pos;
+    size_t buf_len;
+    size_t buf_pos;
      char *string;
  };

@@ -507,8 +507,8 @@
              event->msg_pos = channel->msg_buf.buf_pos;
              if(0 > atsc_text_segment_decode(seg,
                  (uint8_t **)&channel->msg_buf.string,
-                (size_t *)&channel->msg_buf.buf_len,
-                (size_t *)&channel->msg_buf.buf_pos)) {
+ &channel->msg_buf.buf_len,
+ &channel->msg_buf.buf_pos)) {
                  fprintf(stderr, "%s(): error calling "
                      "atsc_text_segment_decode()\n",
                      __FUNCTION__);
@@ -653,15 +653,18 @@
                  e_info->title_pos = curr_info->title_buf.buf_pos;
                  if(0 > atsc_text_segment_decode(seg,
                      (uint8_t **)&curr_info->title_buf.string,
-                    (size_t *)&curr_info->title_buf.buf_len,
-                    (size_t *)&curr_info->title_buf.buf_pos)) {
+ &curr_info->title_buf.buf_len,
+ &curr_info->title_buf.buf_pos)) {
                      fprintf(stderr, "%s(): error calling "
                          "atsc_text_segment_decode()\n",
                          __FUNCTION__);
-                    return -1;
+                    e_info->title_len = 0;
                  }
-                e_info->title_len = curr_info->title_buf.buf_pos -
-                    e_info->title_pos + 1;
+                else
+                {
+                    e_info->title_len = curr_info->title_buf.buf_pos -
+                        e_info->title_pos + 1;
+                }
              }
          }
      }

