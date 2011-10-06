Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756723Ab1JFTjj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Oct 2011 15:39:39 -0400
Message-ID: <4E8E03F2.5040103@redhat.com>
Date: Thu, 06 Oct 2011 16:39:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Michal Donat <michal.donat@atlas.cz>
CC: linux-media@vger.kernel.org
Subject: Re: Arch Linux package names for media-build
References: <op.v2xzjjzd1s61x9@arch-laptop>
In-Reply-To: <op.v2xzjjzd1s61x9@arch-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 06-10-2011 15:12, Michal Donat escreveu:
> Hi,
> see the console output below. The mentioned packages in Arch Linux are:
>
> Digest::SHA1: repository/package = extra/perl-digest-sha1
> Proc::ProcessTable: repository/package = aur/perl-proc-processtable
> Also there was missing lsdiff: repository/package = community/patchutils
>
>
>> /tmp/src $ git clone git://linuxtv.org/media_build.git
>> /tmp/src/media_build $ ./build Checking if the needed tools for Arch Linux are available ERROR: please install "Digest::SHA1", otherwise, build won't work. ERROR: please install "Proc::ProcessTable", otherwise, build won't work. I don't know distro Arch Linux. So, I can't provide you a hint with the package names. Be welcome to contribute with a patch for media-build, by submitting a distro-specific hint to linux-media@vger.kernel.org
>

Could you please test if the patch bellow works properly with Arch Linux?

Thanks,
Mauro

-

Add hints for Arch Linux

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


diff --git a/build b/build
index 052ecff..5b6ca15 100755
--- a/build
+++ b/build
@@ -91,6 +91,29 @@ sub give_ubuntu_hints()
  	printf("You should run:\n\tsudo apt-get install $install\n");
  }
  
+
+sub give_arch_linux_hints()
+{
+	my $install;
+
+	my %map = (
+		"lsdiff"		=> "community/patchutils",
+		"Digest::SHA1"		=> "extra/perl-digest-sha1",
+		"Proc::ProcessTable"	=> "aur/perl-proc-processtable",
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
+	printf("You should install those package(s) (repository/package): $install\n");
+}
+
  sub give_hints()
  {
  
@@ -107,6 +130,10 @@ sub give_hints()
  		give_ubuntu_hints;
  		return;
  	}
+	if ($system_release =~ /Arch Linux/) {
+		give_arch_linux_hints;
+		return;
+	}
  
  	# Fall-back to generic hint code
  	foreach my $prog (@missing) {
