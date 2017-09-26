Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:50075 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968950AbdIZQfz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 12:35:55 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Adam Jackson <ajax@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 2/3] edid-decode: detailed_block: fix maybe uninitialized warning
Date: Tue, 26 Sep 2017 19:33:39 +0300
Message-Id: <0a16965a4be05dfd4e6c6425a12597f18261c8dc.1506443620.git.baruch@tkos.co.il>
In-Reply-To: <07a4901aea4f30db053028fd3a84806b7777ef64.1506443620.git.baruch@tkos.co.il>
References: <07a4901aea4f30db053028fd3a84806b7777ef64.1506443620.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following warnings:

edid-decode.c: In function ‘detailed_block’:
edid-decode.c:394:2: warning: ‘width’ may be used uninitialized in this function [-Wmaybe-uninitialized]
edid-decode.c:394:2: warning: ‘ratio’ may be used uninitialized in this function [-Wmaybe-uninitialized]

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 edid-decode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/edid-decode.c b/edid-decode.c
index 3df35ec6d07f..4abd79333d61 100644
--- a/edid-decode.c
+++ b/edid-decode.c
@@ -348,6 +348,10 @@ detailed_cvt_descriptor(unsigned char *x, int first)
 	width = 8 * (((height * 15) / 9) / 8);
 	ratio = "15:9";
 	break;
+    default:
+	width = 0;
+	ratio = "unknown";
+	break;
     }
 
     if (x[1] & 0x03)
-- 
2.14.1
