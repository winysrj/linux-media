Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:36755 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdFJCI2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Jun 2017 22:08:28 -0400
Received: by mail-pg0-f50.google.com with SMTP id a70so31346875pge.3
        for <linux-media@vger.kernel.org>; Fri, 09 Jun 2017 19:08:28 -0700 (PDT)
Received: from ubuntu.windy (c122-106-153-7.carlnfd1.nsw.optusnet.com.au. [122.106.153.7])
        by smtp.gmail.com with ESMTPSA id a28sm5232845pfl.25.2017.06.09.19.08.25
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Jun 2017 19:08:26 -0700 (PDT)
Date: Sat, 10 Jun 2017 12:08:40 +1000
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Subject: [patch] [media_build] Small fix to build script (resend)
Message-ID: <20170610020838.GA12764@ubuntu.windy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This seems to have fallen on the floor...
Original send date: Thu, 1 Jun 2017 19:43:43 +1000

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
