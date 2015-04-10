Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:62329 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbbDJDV6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Apr 2015 23:21:58 -0400
MIME-Version: 1.0
Message-ID: <trinity-ae8b4068-9fe5-4516-ab2f-1e8f7c02436a-1428636115681@msvc021>
From: TCMaps@gmx.net
To: linux-media@vger.kernel.org
Subject: [PATCH] fix: make menuconfig breaks due to whitespaces in Kconfig
Content-Type: text/plain; charset=UTF-8
Date: Fri, 10 Apr 2015 05:21:55 +0200
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: TC <tcmaps@gmx.net>
Date: Fri, 10 Apr 2015 04:29:20 +0200
Subject: on some systems like Ubuntu 14.04, whitespaces are added from make_kconfig.pl to Kconfig script during make menuconfig
causing it to fail with "./Kconfig:778: syntax error"!
this patch just removes the originating spaces in two lines


---
 v4l/scripts/make_kconfig.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/v4l/scripts/make_kconfig.pl b/v4l/scripts/make_kconfig.pl
index 28b56d0..9228a7b 100755
--- a/v4l/scripts/make_kconfig.pl
+++ b/v4l/scripts/make_kconfig.pl
@@ -252,8 +252,8 @@ sub checkdeps()
 # Text to be added to disabled options
 my $disabled_msg = <<'EOF';
 	---help---
-	  WARNING! This driver needs at least kernel %s!  It may not
-	  compile or work correctly on your kernel, which is too old.
+	WARNING! This driver needs at least kernel %s!  It may not
+	compile or work correctly on your kernel, which is too old.
 
 EOF
 
-- 
1.9.5.msysgit.0
