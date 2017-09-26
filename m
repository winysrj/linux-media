Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:50074 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965387AbdIZQfz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 12:35:55 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Adam Jackson <ajax@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 1/3] edid-decode: parse_cta: fix maybe uninitialized warning
Date: Tue, 26 Sep 2017 19:33:38 +0300
Message-Id: <07a4901aea4f30db053028fd3a84806b7777ef64.1506443620.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following warning:

edid-decode.c: In function ‘parse_cta’:
edid-decode.c:142:5: warning: ‘v’ may be used uninitialized in this function [-Wmaybe-uninitialized]

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 edid-decode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/edid-decode.c b/edid-decode.c
index 5592227d1db5..3df35ec6d07f 100644
--- a/edid-decode.c
+++ b/edid-decode.c
@@ -124,7 +124,7 @@ struct field {
 static void
 decode_value(struct field *field, int val, const char *prefix)
 {
-    struct value *v;
+    struct value *v = NULL;
     int i;
 
     for (i = 0; i < field->n_values; i++) {
@@ -139,7 +139,8 @@ decode_value(struct field *field, int val, const char *prefix)
        return;
     }
 
-    printf("%s%s: %s (%d)\n", prefix, field->name, v->description, val);
+    printf("%s%s: %s (%d)\n", prefix, field->name,
+         v ? v->description : "unknown", val);
 }
 
 static void
-- 
2.14.1
