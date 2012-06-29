Return-path: <linux-media-owner@vger.kernel.org>
Received: from snail.math.uni-duesseldorf.de ([134.99.156.233]:58236 "EHLO
	snail.math.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755112Ab2F2QiM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 12:38:12 -0400
Received: from p50851618.dip.t-dialin.net ([80.133.22.24] helo=[192.168.101.135])
	by snail.math.uni-duesseldorf.de with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <jansing@am.uni-duesseldorf.de>)
	id 1SkeCw-0004iY-6Y
	for linux-media@vger.kernel.org; Fri, 29 Jun 2012 18:38:10 +0200
Message-ID: <4FEDDB7A.4060701@am.uni-duesseldorf.de>
Date: Fri, 29 Jun 2012 18:44:42 +0200
From: Georg Jansing <jansing@am.uni-duesseldorf.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] openSUSE hints for media_build
References: <4FEDD748.2060506@am.uni-duesseldorf.de>
In-Reply-To: <4FEDD748.2060506@am.uni-duesseldorf.de>
Content-Type: multipart/mixed;
 boundary="------------030301020705060203050004"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030301020705060203050004
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello again,

sorry, attachment missing.

Kind regards,

Georg Jansing

Am 29.06.2012 18:26, schrieb Georg Jansing:
> Hello everybody,
>
> I was trying to install Linux TV Kernel Modules via your media_build 
> git repo/scripts. Since I am on openSUSE and there are no installation 
> hints yet, and I needed to look up the correct packages anyways, here 
> is a small patch that adds the corresponding infomation to your script.
>
> I hope, the formulation for adding the perl buildservice repository 
> (something like Ubuntu's PPAs) is clear enough. Please also be warned, 
> that I never did anything in perl yet, so I don't know if I chose the 
> best/perl way to add the repo message.
>
> Sadly, the media_build drivers did not work for me, but with the 
> script I could at least compile them correctly (I think ;-)).
>
> Kind regards,
>
> Georg Jansing



--------------030301020705060203050004
Content-Type: text/x-patch;
 name="opensuse-hints.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="opensuse-hints.patch"

>From 7c622ca8df674a5b39c3e6c60cc69000f021e395 Mon Sep 17 00:00:00 2001
From: Georg Jansing <jansing@am.uni-duesseldorf.de>
Date: Fri, 29 Jun 2012 18:38:46 +0200
Subject: [PATCH] Add installation hints for openSUSE.

---
 build |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/build b/build
index e023f6b..3384fdd 100755
--- a/build
+++ b/build
@@ -91,6 +91,38 @@ sub give_ubuntu_hints()
 	printf("You should run:\n\tsudo apt-get install $install\n");
 }
 
+sub give_opensuse_hints()
+{
+	my $install;
+
+	my %map = (
+		"lsdiff"		=> "patchutils",
+		"Digest::SHA"		=> "perl-Digest-SHA1",
+		"Proc::ProcessTable"	=> "perl-Proc-ProcessTable",
+	);
+	
+	my $need_perl_repo = 0;
+	
+	foreach my $prog (@missing) {
+		print "ERROR: please install \"$prog\", otherwise, build won't work.\n";
+		if (defined($map{$prog})) {
+			$install .= " " . $map{$prog};
+		} else {
+			$install .= " " . $prog;
+		}
+		if ($prog eq "Proc::ProcessTable") {
+			$need_perl_repo = 1;
+		}
+	}
+	
+	printf("You should run:\n\tsudo zypper install $install\n");
+	
+	if ($need_perl_repo) {
+		printf("\nThe Proc::ProcessTable perl module can be found in the perl buildservice repository. ");
+		printf("Add with the command (replacing 12.1 with your openSUSE release version):\n");
+		printf("\tsudo zypper ar http://download.opensuse.org/repositories/devel:/languages:/perl/openSUSE_12.1/ perl\n");
+	}
+}
 
 sub give_arch_linux_hints()
 {
@@ -152,6 +185,10 @@ sub give_hints()
 		give_ubuntu_hints;
 		return;
 	}
+	if ($system_release =~ /openSUSE/) {
+		give_opensuse_hints;
+		return;
+	}
 	if ($system_release =~ /Arch Linux/) {
 		give_arch_linux_hints;
 		return;
-- 
1.7.7


--------------030301020705060203050004--
