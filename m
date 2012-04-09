Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout.karoo.kcom.com ([212.50.160.34]:24518 "EHLO
	smtpout.karoo.kcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2DINVj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2012 09:21:39 -0400
Date: Mon, 9 Apr 2012 14:10:33 +0100
From: David <linux-media@maxwell.homeunix.net>
To: linux-media@vger.kernel.org
Subject: media-build patch: distro-specific hint
Message-ID: <20120409131033.GA18200@maxwell.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Debian I did:

  $ git clone git://linuxtv.org/media_build.git
  $ ./media_build/build
  Checking if the needed tools are present
  ...
  I don't know distro . So, I can't provide you a hint with the package names.


Debian uses /etc/issue to store the distro name, patch below:


$ diff -Naur media_build/build.orig media_build/build
--- media_build/build.orig      2012-04-09 12:48:39.000000000 +0100
+++ media_build/build   2012-04-09 14:01:02.000000000 +0100
@@ -307,6 +307,7 @@
 $system_release = catcheck("/etc/redhat-release") if !$system_release;
 $system_release = catcheck("/etc/lsb-release") if !$system_release;
 $system_release = catcheck("/etc/gentoo-release") if !$system_release;
+$system_release = catcheck("/etc/issue") if !$system_release;
 $system_release =~ s/\s+$//;
 
 check_needs;

