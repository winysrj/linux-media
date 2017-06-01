Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33178 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751699AbdFAKoV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Jun 2017 06:44:21 -0400
Received: by mail-it0-f66.google.com with SMTP id l145so5249158ita.0
        for <linux-media@vger.kernel.org>; Thu, 01 Jun 2017 03:44:21 -0700 (PDT)
Received: from ubuntu.windy (c122-106-153-7.carlnfd1.nsw.optusnet.com.au. [122.106.153.7])
        by smtp.gmail.com with ESMTPSA id i17sm23663382pgn.60.2017.06.01.03.44.13
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Jun 2017 03:44:14 -0700 (PDT)
Date: Thu, 1 Jun 2017 20:44:29 +1000
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] build: make check_git() give more information in verbose mode
Message-ID: <20170601104427.GD3212@ubuntu.windy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While debugging another issue I found this change helpful.

Signed-off-by: Vincent McIntyre <vincent.mcintyre@gmail.com>
---
 build | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/build b/build
index d7f51c2..4457a73 100755
--- a/build
+++ b/build
@@ -303,12 +303,13 @@ sub check_git($$)
 	my $cmd = shift;
 	my $remote = shift;
 
-	print "\$ git --git-dir media/.git $cmd\n" if ($level);
+	print "\$ git --git-dir media/.git $cmd (checking for '$remote')\n" if ($level);
 	open IN, "git --git-dir media/.git $cmd|" or die "can't run git --git-dir media/.git $cmd";
 	while (<IN>) {
 		return 1 if (m/^[\*]*\s*($remote)\n$/);
 	}
 	close IN;
+	print "check failed\n" if ($level);
 	return 0;
 }
 
-- 
2.7.4
