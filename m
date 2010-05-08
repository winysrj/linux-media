Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f183.google.com ([209.85.221.183]:45621 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab0EHT1G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 May 2010 15:27:06 -0400
Received: by qyk13 with SMTP id 13so3645848qyk.1
        for <linux-media@vger.kernel.org>; Sat, 08 May 2010 12:27:05 -0700 (PDT)
From: Mathieu Rene <mrene_lists@avgs.ca>
Content-Type: multipart/mixed; boundary=Apple-Mail-5-834363683
Subject: [PATCH] size_t/int mismatch on 64 bits 
Date: Sat, 8 May 2010 15:27:03 -0400
Message-Id: <448BD493-AE7B-4C7B-B112-14563C8B30D6@avgs.ca>
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1078)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Apple-Mail-5-834363683
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

Hi all,

sizeof(size_t) is 8 on 64 bits, therefore:

struct atsc_event_info {
        uint16_t id;
        struct tm start;
        struct tm end;
        int title_pos;
        int title_len;
        int msg_pos;
        int msg_len;
};

and: (size_t *)&curr_info->title_buf.buf_pos), was segfaulting. 


--Apple-Mail-5-834363683
Content-Disposition: attachment;
	filename=atsc_epg.diff
Content-Type: application/octet-stream;
	name="atsc_epg.diff"
Content-Transfer-Encoding: 7bit

diff -r 5d49967c2184 util/atsc_epg/atsc_epg.c
--- a/util/atsc_epg/atsc_epg.c  Sun May 02 10:31:40 2010 +0200
+++ b/util/atsc_epg/atsc_epg.c  Sat May 08 15:25:07 2010 -0400
@@ -60,8 +60,8 @@
 void (*old_handler)(int);
 
 struct atsc_string_buffer {
-       int buf_len;
-       int buf_pos;
+       size_t buf_len;
+       size_t buf_pos;
        char *string;
 };
 
@@ -71,8 +71,8 @@
        struct tm end;
        int title_pos;
        int title_len;
-       int msg_pos;
-       int msg_len;
+       size_t msg_pos;
+       size_t msg_len;
 };
 
 struct atsc_eit_section_info {
@@ -651,8 +651,8 @@
                                e_info->title_pos = curr_info->title_buf.buf_pos;
                                if(0 > atsc_text_segment_decode(seg,
                                        (uint8_t **)&curr_info->title_buf.string,
-                                       (size_t *)&curr_info->title_buf.buf_len,
-                                       (size_t *)&curr_info->title_buf.buf_pos)) {
+                                       &curr_info->title_buf.buf_len,
+                                       &curr_info->title_buf.buf_pos)) {
                                        fprintf(stderr, "%s(): error calling "
                                                "atsc_text_segment_decode()\n",
                                                __FUNCTION__);

--Apple-Mail-5-834363683
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii


Mathieu Rene
Avant-Garde Solutions Inc
Office: + 1 (514) 664-1044 x100
Cell: +1 (514) 664-1044 x200
mrene@avgs.ca





--Apple-Mail-5-834363683--
