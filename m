Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:57705 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaFVMu0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Jun 2014 08:50:26 -0400
Received: by mail-wg0-f42.google.com with SMTP id z12so5448184wgg.25
        for <linux-media@vger.kernel.org>; Sun, 22 Jun 2014 05:50:24 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH 1/2] Hide parse_string.h content in shared library interface
Date: Sun, 22 Jun 2014 14:49:46 +0200
Message-Id: <1403441387-31604-2-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1403441387-31604-1-git-send-email-gjasny@googlemail.com>
References: <1403441387-31604-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
---
 lib/libdvbv5/parse_string.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/lib/libdvbv5/parse_string.h b/lib/libdvbv5/parse_string.h
index 61d0ed4..39f7dc4 100644
--- a/lib/libdvbv5/parse_string.h
+++ b/lib/libdvbv5/parse_string.h
@@ -17,6 +17,10 @@
  * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
  */
 
+#if HAVE_VISIBILITY
+#pragma GCC visibility push(hidden)
+#endif
+
 struct dvb_v5_fe_parms;
 
 void iconv_to_charset(struct dvb_v5_fe_parms *parms,
@@ -29,3 +33,7 @@ void iconv_to_charset(struct dvb_v5_fe_parms *parms,
 void parse_string(struct dvb_v5_fe_parms *parms, char **dest, char **emph,
 		  const unsigned char *src, size_t len,
 		  char *default_charset, char *output_charset);
+
+#if HAVE_VISIBILITY
+#pragma GCC visibility pop
+#endif
-- 
1.9.1

