Return-path: <mchehab@pedra>
Received: from mail-px0-f174.google.com ([209.85.212.174]:64515 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab0I0TMt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 15:12:49 -0400
Received: by pxi10 with SMTP id 10so1527456pxi.19
        for <linux-media@vger.kernel.org>; Mon, 27 Sep 2010 12:12:48 -0700 (PDT)
Message-ID: <4CA0ECA9.30208@gmail.com>
Date: Mon, 27 Sep 2010 16:12:41 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
CC: Douglas Schilling Landgraf <dougsland@gmail.com>,
	"Ole W. Saastad" <olewsaa@online.no>, linux-media@vger.kernel.org
Subject: Re: updated make_kconfig.pl for Ubuntu
References: <1284493110.1801.57.camel@sofia> <4C924EB8.9070500@hoogenraad.net> <4C93364C.3040606@hoogenraad.net> <4C934806.7050503@gmail.com> <4C934C10.2060801@hoogenraad.net> <4C93800B.8070902@gmail.com> <4C9F7267.7000707@hoogenraad.net> <4CA018C4.9000507@gmail.com> <4CA0E554.40406@hoogenraad.net>
In-Reply-To: <4CA0E554.40406@hoogenraad.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 27-09-2010 15:41, Jan Hoogenraad escreveu:
> I have updated launchpad bug
> 
> https://bugs.launchpad.net/ubuntu/+source/linux-kernel-headers/+bug/134222
> 
> I also created an updated make_kconfig.pl
> 
> http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2/file/cb34ee1c29fc/v4l/scripts/make_kconfig.pl
> 
> Unfortunately, I forgot to commit changes to the main archive the first time. I do not know how to make a patch file for this one file, without have all other changes in the two commits as well.
> I cannot find a hg export command to make a patch for this one file between versions spanning two commits.

You can just do a diff with upstream. Anyway, I'm enclosing the merged patch.

There's one problem on it:

$dmahplace="/usr/src/linux-headers-$dmahplace/include/config/ieee1394/dma.h";

Don't use absolute names here. -hg build system is smart enough to get the directory
where the kernel is installed, depending on what version you're compiling against
(you may change it with "make release").

Based on sub kernelcheck(), were we have:
	my $fullkernel="$kernsrc/fs/fcntl.c";

I suspect that using:
	$dmahplace="$kernelsrc/include/config/ieee1394/dma.h";

should work properly.

---

FYI, this is the diff from the master -hg:

diff -r 1da5fed5c8b2 v4l/scripts/make_kconfig.pl
--- a/v4l/scripts/make_kconfig.pl	Sun Sep 19 02:23:09 2010 -0300
+++ b/v4l/scripts/make_kconfig.pl	Mon Sep 27 16:04:50 2010 -0300
@@ -597,6 +597,9 @@
 disable_config('STAGING_BROKEN');
 $intopt { "DVB_MAX_ADAPTERS" } = 8;
 
+#check broken Ubuntu headers
+dmahcheck();
+
 # Check dependencies
 my %newconfig = checkdeps();
 
@@ -681,3 +684,27 @@
 EOF3
 	sleep 5;
 }
+
+# Check for full kernel sources and print a warning
+sub dmahcheck()
+{
+	my $dmahplace= "".$kernsrc;
+	$dmahplace =~ s-^/lib/modules/--g;
+	$dmahplace =~ s-/.*$--g;
+	$dmahplace="/usr/src/linux-headers-$dmahplace/include/config/ieee1394/dma.h";
+	if (! -e $dmahplace) {
+		print <<"EOF2";
+
+***WARNING:*** File $dmahplace not present.
+This problem is at least present on Ubuntu systems:
+https://bugs.launchpad.net/ubuntu/+source/linux-kernel-headers/+bug/134222
+
+Therefore disabling FIREDTV driver.
+
+EOF2
+
+	disable_config('DVB_FIREDTV');
+
+	}
+	sleep 5;
+}

