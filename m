Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:37914 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323Ab2L2Wh1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Dec 2012 17:37:27 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH 1/2] contrib/m920x/m920x_parse.pl: stricter check when extracting firmware
Date: Sat, 29 Dec 2012 23:37:07 +0100
Message-Id: <1356820628-24992-2-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1356820628-24992-1-git-send-email-ospite@studenti.unina.it>
References: <1356820628-24992-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extract firmware only from the right messages, skip the other messages.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 contrib/m920x/m920x_parse.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
 mode change 100644 => 100755 contrib/m920x/m920x_parse.pl

diff --git a/contrib/m920x/m920x_parse.pl b/contrib/m920x/m920x_parse.pl
old mode 100644
new mode 100755
index b309250..a6ca80a
--- a/contrib/m920x/m920x_parse.pl
+++ b/contrib/m920x/m920x_parse.pl
@@ -195,8 +195,9 @@ if ($mode eq "fw") {
 			last;
 		}
 
+		my $is_fw_msg = $bytes[0] eq "40" && $bytes[1] eq "30";
 		my $len = hex($bytes[6] . $bytes[7]);
-		if ($len < 32) {
+		if (!$is_fw_msg || $len < 32) {
 			next;
 		}
 
-- 
1.7.10.4

