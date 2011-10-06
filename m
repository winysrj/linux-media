Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:21846 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab1JFInb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 04:43:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC PATCH] media_build: two fixes + one unresolved issue
Date: Thu, 6 Oct 2011 10:43:24 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201110051123.39783.hverkuil@xs4all.nl> <201110051545.27427.hverkuil@xs4all.nl> <4E8C852C.7000206@redhat.com>
In-Reply-To: <4E8C852C.7000206@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110061043.24652.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 05 October 2011 18:26:20 Mauro Carvalho Chehab wrote:
> Em 05-10-2011 10:45, Hans Verkuil escreveu:
> > I'll see if I can make a patch for this.
> 
> Ok, thanks!

Mauro, can you test this patch? It should translate 2.4x naming convention to 3.x.

Regards,

	Hans

diff --git a/linux/patches_for_kernel.pl b/linux/patches_for_kernel.pl
index 33348d9..00d8b7f 100755
--- a/linux/patches_for_kernel.pl
+++ b/linux/patches_for_kernel.pl
@@ -13,11 +13,15 @@ my $file = "../backports/backports.txt";
 open IN, $file or die "can't find $file\n";
 
 sub kernel_version($) {
-	my $sublevel;
+	my ($version, $patchlevel, $sublevel) = $_[0] =~ m/^(\d+)\.(\d+)\.?(\d*)/;
 
-	$_[0] =~ m/^(\d+)\.(\d+)\.?(\d*)/;
-	$sublevel = $3 == "" ? 0 : $3;
-	return ($1*65536 + $2*256 + $sublevel);
+	# fix kernel version for distros that 'translated' 3.0 to 2.40
+	if ($version == 2 && $patchlevel >= 40) {
+		$version = 3;
+		$patchlevel -= 40;
+	}
+	$sublevel = 0 if ($sublevel == "");
+	return ($version * 65536 + $patchlevel * 256 + $sublevel);
 }
 
 my $kernel = kernel_version($version);
diff --git a/v4l/Makefile b/v4l/Makefile
index 311924e..57302cc 100644
--- a/v4l/Makefile
+++ b/v4l/Makefile
@@ -248,7 +248,7 @@ ifneq ($(VER),)
 	@echo $(VER)|perl -ne 'if (/^([0-9]*)\.([0-9])*\.([0-9]*)(.*)$$/) { printf 
("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s.%s.%s%s\n",$$1,$$2,$$3,$$1,$$2,$$3,$$4); };' > $(obj)/.version
 else
 	@echo No version yet, using `uname -r`
-	@uname -r|perl -ne 'if (/^([0-9]*)\.([0-9])*\.?([0-9]*)(.*)$$/) { printf 
("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s",$$1,$$2,$$3==""?"0":$$3,$$_); };' > $(obj)/.version
+	@uname -r|perl -ne 'if (/^([0-9]*)\.([0-9])*\.?([0-9]*)(.*)$$/) { $$ver = $$1; $$patch = $$2; $$sub = $$3; if ($$ver == 2 && $$patch >= 40) { 
$$ver = 3; $$patch -= 40; }; printf ("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s",$$ver,$$patch,$$sub==""?"0":
$$sub,$$_); };' > $(obj)/.version
 endif
 endif
 
