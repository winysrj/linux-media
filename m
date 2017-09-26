Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:50082 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968951AbdIZQf4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 12:35:56 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Adam Jackson <ajax@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 3/3] edid-decode: parse_extension: fix maybe uninitialized warning
Date: Tue, 26 Sep 2017 19:33:40 +0300
Message-Id: <93ffb19c3563c5f7fdd0bdb134de1c9e0c1956ba.1506443620.git.baruch@tkos.co.il>
In-Reply-To: <07a4901aea4f30db053028fd3a84806b7777ef64.1506443620.git.baruch@tkos.co.il>
References: <07a4901aea4f30db053028fd3a84806b7777ef64.1506443620.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following warning:

edid-decode.c: In function ‘main’:
edid-decode.c:2962:26: warning: ‘conformant_extension’ may be used uninitialized in this function [-Wmaybe-uninitialized]

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 edid-decode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/edid-decode.c b/edid-decode.c
index 4abd79333d61..d3aafa926900 100644
--- a/edid-decode.c
+++ b/edid-decode.c
@@ -2397,7 +2397,7 @@ extension_version(unsigned char *x)
 static int
 parse_extension(unsigned char *x)
 {
-    int conformant_extension;
+    int conformant_extension = 0;
     printf("\n");
 
     switch(x[0]) {
-- 
2.14.1
