Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:32998 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdFJCLf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Jun 2017 22:11:35 -0400
Received: by mail-pg0-f65.google.com with SMTP id a70so9098411pge.0
        for <linux-media@vger.kernel.org>; Fri, 09 Jun 2017 19:11:35 -0700 (PDT)
Received: from ubuntu.windy (c122-106-153-7.carlnfd1.nsw.optusnet.com.au. [122.106.153.7])
        by smtp.gmail.com with ESMTPSA id h68sm1163223pfh.45.2017.06.09.19.11.32
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Jun 2017 19:11:33 -0700 (PDT)
Date: Sat, 10 Jun 2017 12:11:55 +1000
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Subject: [patch] [media_build] small cleanup of build script (resend)
Message-ID: <20170610021153.GB12764@ubuntu.windy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Original send date: Thu, 1 Jun 2017 20:12:32 +1000

Introduce a function to help tracing of system() calls

While debugging a recent issue I wanted more complete information
about the sequencence of events in a series of calls like
  system("foo") or die("BAR")
Adding this helper did that and cleaned things up a little.

Signed-off-by: Vincent McIntyre <vincent.mcintyre@gmail.com>
---
 build | 81 +++++++++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 47 insertions(+), 34 deletions(-)

diff --git a/build b/build
index 4457a73..38ffd4f 100755
--- a/build
+++ b/build
@@ -342,6 +342,19 @@ sub which($)
 	return undef;
 }
 
+sub run($$)
+{
+       my $cmd = shift;
+       my $err = shift;
+       $err = '' unless defined($err);
+
+       my ($pkg,$filename,$line) = caller;
+
+       print "\$ $cmd\n" if ($level);
+       system($cmd) == 0
+               or die($err . " at $filename line $line\n");
+}
+
 ######
 # Main
 ######
@@ -406,11 +419,11 @@ if (@git == 2) {
 		if (!$local) {
 			print "Getting the latest Kernel tree. This will take some time\n";
 			if ($depth) {
-				system("git clone --origin '$rname/$git[1]' git://linuxtv.org/media_tree.git media $depth") == 0
-					or die "Can't clone from the upstream tree";
+				run("git clone --origin '$rname/$git[1]' git://linuxtv.org/media_tree.git media $depth",
+					"Can't clone from the upstream tree");
 			} else {
-				system("git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git media $depth") == 0
-					or die "Can't clone from the upstream tree";
+				run("git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git media $depth",
+					"Can't clone from the upstream tree");
 			}
 			system('git --git-dir media/.git config format.cc "Linux Media Mailing List <linux-media@vger.kernel.org>"');
 			system('git --git-dir media/.git config format.signoff true');
@@ -419,56 +432,54 @@ if (@git == 2) {
 		} else {
 			if ($workdir ne "") {
 				print "Creating a new workdir from $git[0] at media\n";
-				system("git new-workdir $git[0] media") == 0
-					or die "Can't create a new workdir";
+				run("git new-workdir $git[0] media",
+					"Can't create a new workdir");
 			} else {
 				print "Creating a new clone\n";
-				system("git clone -l $git[0] media $depth") == 0
-					or die "Can't create a new clone";
+				run("git clone -l $git[0] media $depth",
+					"Can't create a new clone");
 			}
 		}
 	} elsif ($workdir eq "") {
 		if (check_git("remote", "$rname/$git[1]")) {
-			system("git --git-dir media/.git remote update '$rname/$git[1]'") == 0
-				or die "Can't update from the upstream tree";
+			run("git --git-dir media/.git remote update '$rname/$git[1]'",
+				"Can't update from the upstream tree");
 		} else {
-			system("git --git-dir media/.git remote update origin") == 0
-				or die "Can't update from the upstream tree";
+			run("git --git-dir media/.git remote update origin",
+				"Can't update from the upstream tree");
 		}
 	}
 
 	if ($workdir eq "") {
 		if (!check_git("remote", "$name")) {
 			print "adding remote $name to track $git[0]\n";
-			printf "\$ git --git-dir media/.git remote add $name $git[0]\n" if ($level);
-			system ("git --git-dir media/.git remote add $name $git[0]") == 0
-				or die "Can't create remote $name";
+			run("git --git-dir media/.git remote add $name $git[0]",
+				"Can't create remote $name");
 		}
 		if (!$depth) {
 			print "updating remote $rname\n";
-			system ("git --git-dir media/.git remote update $name") == 0
-					or die "Can't update remote $name";
+			run("git --git-dir media/.git remote update $name",
+					"Can't update remote $name");
 			print "creating a local branch $rname\n";
 			if (!check_git("branch", "$rname/$git[1]")) {
-				print "\$ (cd media; git checkout -b $rname/$git[1] remotes/$name/$git[1])\n" if ($level);
-				system ("(cd media; git checkout -b $rname/$git[1] remotes/$name/$git[1])") == 0
-					or die "Can't create local branch $rname";
+				run("(cd media; git checkout -b $rname/$git[1] remotes/$name/$git[1])",
+					"Can't create local branch $rname");
 			} else {
-				system ("(cd media; git checkout $rname/$git[1])") == 0
-						or die "Can't checkout to branch $rname";
-				system ("(cd media; git pull . remotes/$name/$git[1])") == 0
-						or die "Can't update local branch $name";
+				run("(cd media; git checkout $rname/$git[1])",
+						"Can't checkout to branch $rname");
+				run("(cd media; git pull . remotes/$name/$git[1])",
+						"Can't update local branch $name");
 			}
 		}
 	} else {
 		print "git checkout $git[1]\n";
-		system ("(cd media; git checkout $git[1])") == 0
-			or die "Can't checkout $git[1]";
+		run("(cd media; git checkout $git[1])",
+			"Can't checkout $git[1]");
 	}
 
 
-	system ("make -C linux dir DIR=../media/") == 0
-		or die "Can't link the building system to the media directory.";
+	run("make -C linux dir DIR=../media/",
+		"Can't link the building system to the media directory.");
 } else {
 	print "\n";
 	print "************************************************************\n";
@@ -486,8 +497,8 @@ if (@git == 2) {
 	print "****************************\n";
 	system("git pull git://linuxtv.org/media_build.git master");
 
-	system ("make -C linux/ download") == 0 or die "Download failed";
-	system ("make -C linux/ untar") == 0 or die "Untar failed";
+	run("make -C linux/ download", "Download failed");
+	run("make -C linux/ untar", "Untar failed");
 }
 
 print "**********************************************************\n";
@@ -495,17 +506,19 @@ print "* Downloading firmwares from linuxtv.org.                *\n";
 print "**********************************************************\n";
 
 if (!stat $firmware_tarball) {
-	system ("wget $firmware_url/$firmware_tarball -O $firmware_tarball") == 0 or die "Can't download $firmware_tarball";
+	run("wget $firmware_url/$firmware_tarball -O $firmware_tarball",
+		"Can't download $firmware_tarball");
 }
-system ("(cd v4l/firmware/; tar xvfj ../../$firmware_tarball)") == 0 or die "Can't extract $firmware_tarball";
+run("(cd v4l/firmware/; tar xvfj ../../$firmware_tarball)",
+		"Can't extract $firmware_tarball");
 
 
 print "******************\n";
 print "* Start building *\n";
 print "******************\n";
 
-system ("make allyesconfig") == 0 or die "can't select all drivers";
-system ("make") == 0 or die "build failed";
+run("make allyesconfig", "can't select all drivers");
+run("make", "build failed");
 
 print "**********************************************************\n";
 print "* Compilation finished. Use 'make install' to install them\n";
-- 
