Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:36467 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751385AbdFAJnm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Jun 2017 05:43:42 -0400
Received: by mail-it0-f45.google.com with SMTP id m47so32102128iti.1
        for <linux-media@vger.kernel.org>; Thu, 01 Jun 2017 02:43:42 -0700 (PDT)
Received: from ubuntu.windy (c122-106-153-7.carlnfd1.nsw.optusnet.com.au. [122.106.153.7])
        by smtp.gmail.com with ESMTPSA id 192sm29624809pfb.10.2017.06.01.02.43.34
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Jun 2017 02:43:35 -0700 (PDT)
Date: Thu, 1 Jun 2017 19:43:45 +1000
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] Small fix to build script
Message-ID: <20170601094343.GA3212@ubuntu.windy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Avoid going splat if --depth is not given

Commit 6b4a9c5 indroduced the --depth parameter to limit the commit history
pulled by when cloning, giving a nice speedup. But in the process it broke
running without the --depth parameter. The first invocation of
'./build --main-git' works fine, but the second falls over like so:

  fatal: No such remote or remote group: media_tree/master
  Can't update from the upstream tree at ./build line 430.

The fix is to check whether that remote has been defined before trying
to update from it.

Signed-off-by: Vincent McIntyre <vincent.mcintyre@gmail.com>
---
 build | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/build b/build
index a4cd38e..d7f51c2 100755
--- a/build
+++ b/build
@@ -427,8 +427,13 @@ if (@git == 2) {
 			}
 		}
 	} elsif ($workdir eq "") {
-		system("git --git-dir media/.git remote update '$rname/$git[1]'") == 0
-			or die "Can't update from the upstream tree";
+		if (check_git("remote", "$rname/$git[1]")) {
+			system("git --git-dir media/.git remote update '$rname/$git[1]'") == 0
+				or die "Can't update from the upstream tree";
+		} else {
+			system("git --git-dir media/.git remote update origin") == 0
+				or die "Can't update from the upstream tree";
+		}
 	}
 
 	if ($workdir eq "") {
-- 
2.7.4
