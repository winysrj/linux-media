Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34909 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdFJCNt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Jun 2017 22:13:49 -0400
Received: by mail-pg0-f68.google.com with SMTP id f127so9102560pgc.2
        for <linux-media@vger.kernel.org>; Fri, 09 Jun 2017 19:13:49 -0700 (PDT)
Received: from ubuntu.windy (c122-106-153-7.carlnfd1.nsw.optusnet.com.au. [122.106.153.7])
        by smtp.gmail.com with ESMTPSA id x30sm6045358pge.23.2017.06.09.19.13.46
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Jun 2017 19:13:47 -0700 (PDT)
Date: Sat, 10 Jun 2017 12:14:09 +1000
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Subject: [patch] [media_build] make check_git() give more information in
 verbose mode (resend)
Message-ID: <20170610021407.GC12764@ubuntu.windy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


While debugging another issue I found this change helpful.
Original send Date: Thu, 1 Jun 2017 20:44:27 +1000



Make check_git() give more information in verbose mode.

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


----- End forwarded message -----
