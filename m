Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:39829 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751171AbdHSS4i (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Aug 2017 14:56:38 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: Added missing "DESTDIR"
Date: Sat, 19 Aug 2017 20:56:33 +0200
Message-Id: <1503168993-23078-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Directory "$DESTDIR" was missing in the "Removing obsolete files"
output. The executed code was correct.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 v4l/scripts/make_makefile.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/v4l/scripts/make_makefile.pl b/v4l/scripts/make_makefile.pl
index aa7d5e8..5f2db9c 100755
--- a/v4l/scripts/make_makefile.pl
+++ b/v4l/scripts/make_makefile.pl
@@ -163,7 +163,7 @@ sub getobsolete()
 sub removeobsolete()
 {
 	while ( my ($dir, $files) = each(%obsolete) ) {
-		print OUT "\t\@echo \"\\nRemoving obsolete files from \$(KDIR26)/$dir:\"\n";
+		print OUT "\t\@echo \"\\nRemoving obsolete files from \$(DESTDIR)\$(KDIR26)/$dir:\"\n";
 		print OUT "\t\@files='", join(' ', keys %$files), "'; ";
 
 		print OUT "for i in \$\$files;do if [ -f \"\$(DESTDIR)\$(KDIR26)/$dir/\$\$i\" ]; then ";
-- 
2.7.4
