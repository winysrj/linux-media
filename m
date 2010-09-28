Return-path: <mchehab@pedra>
Received: from psmtp13.wxs.nl ([195.121.247.25]:42381 "EHLO psmtp13.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab0I1T6N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 15:58:13 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp13.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0L9H00MMJ3GV4X@psmtp13.wxs.nl> for linux-media@vger.kernel.org;
 Tue, 28 Sep 2010 21:58:08 +0200 (MEST)
Date: Tue, 28 Sep 2010 21:58:04 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: updated make_kconfig.pl for Ubuntu
In-reply-to: <4CA2321C.1020909@infradead.org>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Message-id: <4CA248CC.4040404@hoogenraad.net>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_BB0Km7EFjLrnl5cuNGil+w)"
References: <1284493110.1801.57.camel@sofia> <4C924EB8.9070500@hoogenraad.net>
 <4C93364C.3040606@hoogenraad.net> <4C934806.7050503@gmail.com>
 <4C934C10.2060801@hoogenraad.net> <4C93800B.8070902@gmail.com>
 <4C9F7267.7000707@hoogenraad.net> <4CA018C4.9000507@gmail.com>
 <4CA0E554.40406@hoogenraad.net> <4CA0ECA9.30208@gmail.com>
 <4CA10262.6060206@hoogenraad.net> <4CA11E25.5030206@gmail.com>
 <4CA22A79.9020309@hoogenraad.net> <4CA2321C.1020909@infradead.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.

--Boundary_(ID_BB0Km7EFjLrnl5cuNGil+w)
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT

Douglas:

Can you push the updated make_kconfig.pl ?

It is in its own HG tree on:
http://linuxtv.org/hg/~jhoogenraad/ubuntu-firedtv/

Mauro Carvalho Chehab wrote:
> Em 28-09-2010 14:48, Jan Hoogenraad escreveu:
>> Douglas:
>>
>> I have an updated make_kconfig.pl for Ububtu on:
>> http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2/file/cb34ee1c29fc/v4l/scripts/make_kconfig.pl
>>
>> Could you test if make allyesconfig actually keeps FIREDTV enabled on a non-Ubuntu system ?
>>
>> If so, can you merge this version into the main stream ?
>>
>
> Ok, now it looks correct on my eyes, and it should not hurt compilation
> with make release and with distros that do a good job with their kernel
> packages.
>
> I'll let Douglas review and test, as he is the maintainer.
>
> It would be better if you could send him a diff. you may use hg diff to generate
> it against an older version, in order to merge all your make_kconfig.pl patches,
> or just create a new clone from master and apply it there.
>
> A side question: when do you intend to send us the patches for the Realtek
> rtl2831?
>
> Cheers,
> Mauro.
>


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht

--Boundary_(ID_BB0Km7EFjLrnl5cuNGil+w)
Content-type: text/x-patch; name=ubuntu.patch
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=ubuntu.patch

# HG changeset patch
# User Jan Hoogenraad <jan-conceptronic@h-i-s.nl>
# Date 1285703652 -7200
# Node ID c8e14191e48d98a19405c9f899abca30cd89bc18
# Parent  1da5fed5c8b2c626180b1a0983fe1c960b999525
Disable FIREDTV for debian/ubuntu distributions with bad header files

From: Jan Hoogenraad <jan-conceptronic@h-i-s.nl>

Disable FIREDTV for debian/ubuntu distributions with problems in header files

Priority: normal

Signed-off-by: Jan Hoogenraad <jan-conceptronic@h-i-s.nl>

diff -r 1da5fed5c8b2 -r c8e14191e48d v4l/scripts/make_kconfig.pl
--- a/v4l/scripts/make_kconfig.pl	Sun Sep 19 02:23:09 2010 -0300
+++ b/v4l/scripts/make_kconfig.pl	Tue Sep 28 21:54:12 2010 +0200
@@ -597,6 +597,9 @@
 disable_config('STAGING_BROKEN');
 $intopt { "DVB_MAX_ADAPTERS" } = 8;
 
+#check broken Ubuntu headers
+dmahcheck();
+
 # Check dependencies
 my %newconfig = checkdeps();
 
@@ -681,3 +684,24 @@
 EOF3
 	sleep 5;
 }
+
+# Check for full kernel sources and print a warning
+sub dmahcheck()
+{
+	my $dmahplace="$kernsrc/include/config/ieee1394/dma.h";
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

--Boundary_(ID_BB0Km7EFjLrnl5cuNGil+w)--
