Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:52323 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab0BAWNN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Feb 2010 17:13:13 -0500
Message-ID: <4B6751F3.3040407@freemail.hu>
Date: Mon, 01 Feb 2010 23:13:07 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
	Luc Saillard <luc@saillard.org>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH ] libv4l: skip false Pixart markers
References: <4B67466F.1030301@freemail.hu>
In-Reply-To: <4B67466F.1030301@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The byte sequence 0xff, 0xff, 0xff 0xff is not a real marker to skip, instead
it is one byte from the image and the following three 0xff bytes might belong
to a real marker. Modify pixart_fill_nbits() macro to pass the first 0xff byte
as an image data.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r f23c5a878fb1 v4l2-apps/libv4l/libv4lconvert/tinyjpeg.c
--- a/v4l2-apps/libv4l/libv4lconvert/tinyjpeg.c	Mon Feb 01 13:32:46 2010 +0100
+++ b/v4l2-apps/libv4l/libv4lconvert/tinyjpeg.c	Mon Feb 01 23:05:39 2010 +0100
@@ -339,10 +339,15 @@
 	    } \
 	    break; \
 	  case 0xff: \
-	    if (stream[1] == 0xff && (stream[2] < 7 || stream[2] == 0xff)) { \
-	      stream += 3; \
-	      c = *stream++; \
-	      break; \
+	    if (stream[1] == 0xff) { \
+		if (stream[2] < 7) { \
+		    stream += 3; \
+		    c = *stream++; \
+		    break; \
+		} else if (stream[2] == 0xff) { \
+		    /* four 0xff in a row: the first belongs to the image data */ \
+		    break; \
+		}\
 	    } \
 	    /* Error fall through */ \
 	  default: \
