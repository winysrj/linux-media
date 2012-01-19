Return-path: <linux-media-owner@vger.kernel.org>
Received: from wynent02.readytalk.com ([63.239.148.244]:9667 "EHLO
	WYNENT02.readytalk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab2ASXJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 18:09:31 -0500
From: Benjamin Limmer <benjamin.limmer@readytalk.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Build change in media_build to support Debian
Date: Thu, 19 Jan 2012 23:04:10 +0000
Message-ID: <52FE2DCC5CDB044F8C0070326FFDFBF30A3542@WYNENT02.readytalk.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit 2949a7393f3e2598d4de49b408587462b11f819f
Author: Ben Limmer <benjamin.limmer@readytalk.com>
Date:   Thu Jan 19 16:01:15 2012 -0700

    Update to build script to give Debian users the Ubunutu package hints. The aptitude package names are the same.

diff --git a/build b/build
index c3947b3..6843033 100755
--- a/build
+++ b/build
@@ -134,6 +134,10 @@ sub give_hints()
                give_arch_linux_hints;
                return;
        }
+       if ($system_release =~ /Debian/) {
+               give_ubuntu_hints;
+               return; 
+       }
 
        # Fall-back to generic hint code
        foreach my $prog (@missing) {


Please see the above commit message. This is an easy change to support hints for debian users. I've confirmed these changes work on Debian Squeeze.

-Ben Limmer