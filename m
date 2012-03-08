Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51935 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab2CHNq0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2012 08:46:26 -0500
Received: from localhost.localdomain (unknown [91.178.21.97])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id DB3687AAE
	for <linux-media@vger.kernel.org>; Thu,  8 Mar 2012 14:46:24 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH - media_build] Add Gentoo to build package hints
Date: Thu,  8 Mar 2012 14:46:44 +0100
Message-Id: <1331214404-8736-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the build script to print package names for Gentoo users.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 build |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/build b/build
index 61bdfd5..308c218 100755
--- a/build
+++ b/build
@@ -114,6 +114,28 @@ sub give_arch_linux_hints()
 	printf("You should install those package(s) (repository/package): $install\n");
 }
 
+sub give_gentoo_hints()
+{
+	my $install;
+
+	my %map = (
+		"lsdiff"		=> "dev-util/patchutils",
+		"Digest::SHA"		=> "dev-perl/Digest-SHA1",
+		"Proc::ProcessTable"	=> "dev-perl/Proc-ProcessTable",
+	);
+
+	foreach my $prog (@missing) {
+		print "ERROR: please install \"$prog\", otherwise, build won't work.\n";
+		if (defined($map{$prog})) {
+			$install .= " " . $map{$prog};
+		} else {
+			$install .= " " . $prog;
+		}
+	}
+
+	printf("You should emerge those package(s): $install\n");
+}
+
 sub give_hints()
 {
 
@@ -138,6 +160,10 @@ sub give_hints()
 		give_ubuntu_hints;
 		return;
 	}
+	if ($system_release =~ /Gentoo/) {
+		give_gentoo_hints;
+		return;
+	}
 	# Fall-back to generic hint code
 	foreach my $prog (@missing) {
 		print "ERROR: please install \"$prog\", otherwise, build won't work.\n";
@@ -280,6 +306,7 @@ $system_release =~ s/Description:\s*// if ($system_release);
 $system_release = catcheck("/etc/system-release") if !$system_release;
 $system_release = catcheck("/etc/redhat-release") if !$system_release;
 $system_release = catcheck("/etc/lsb-release") if !$system_release;
+$system_release = catcheck("/etc/gentoo-release") if !$system_release;
 $system_release =~ s/\s+$//;
 
 check_needs;
-- 
Regards,

Laurent Pinchart

