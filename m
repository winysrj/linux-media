Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:37915 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334Ab2L2Wh1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Dec 2012 17:37:27 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH 2/2] contrib/m920x/m920x_parse.pl: silence a warning
Date: Sat, 29 Dec 2012 23:37:08 +0100
Message-Id: <1356820628-24992-3-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1356820628-24992-1-git-send-email-ospite@studenti.unina.it>
References: <1356820628-24992-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Silence a warning due to the way get_line() is supposed to be called:

  Use of uninitialized value $cmd in split at m920x_parse.pl line 118

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 contrib/m920x/m920x_parse.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/contrib/m920x/m920x_parse.pl b/contrib/m920x/m920x_parse.pl
index a6ca80a..19ff71d 100755
--- a/contrib/m920x/m920x_parse.pl
+++ b/contrib/m920x/m920x_parse.pl
@@ -190,7 +190,7 @@ my @bytes;
 if ($mode eq "fw") {
 	open(OUT, ">", "fw") || die "Can't open fw";
 
-	while(@bytes = get_line()) {
+	while(@bytes = get_line("-1")) {
 		if(scalar(@bytes) <= 1) {
 			last;
 		}
-- 
1.7.10.4

