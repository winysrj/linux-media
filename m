Return-path: <mchehab@pedra>
Received: from psmtp30.wxs.nl ([195.121.247.32]:37520 "EHLO psmtp30.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754239Ab0I1Rso (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 13:48:44 -0400
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp30.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0L9G00C4HXH6Z0@psmtp30.wxs.nl> for linux-media@vger.kernel.org;
 Tue, 28 Sep 2010 19:48:42 +0200 (MEST)
Date: Tue, 28 Sep 2010 19:48:41 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: updated make_kconfig.pl for Ubuntu
In-reply-to: <4CA11E25.5030206@gmail.com>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: "Ole W. Saastad" <olewsaa@online.no>, linux-media@vger.kernel.org
Message-id: <4CA22A79.9020309@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <1284493110.1801.57.camel@sofia> <4C924EB8.9070500@hoogenraad.net>
 <4C93364C.3040606@hoogenraad.net> <4C934806.7050503@gmail.com>
 <4C934C10.2060801@hoogenraad.net> <4C93800B.8070902@gmail.com>
 <4C9F7267.7000707@hoogenraad.net> <4CA018C4.9000507@gmail.com>
 <4CA0E554.40406@hoogenraad.net> <4CA0ECA9.30208@gmail.com>
 <4CA10262.6060206@hoogenraad.net> <4CA11E25.5030206@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Douglas:

I have an updated make_kconfig.pl for Ububtu on:
http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2/file/cb34ee1c29fc/v4l/scripts/make_kconfig.pl

Could you test if make allyesconfig actually keeps FIREDTV enabled on a 
non-Ubuntu system ?

If so, can you merge this version into the main stream ?


Mauro:

You are very right. I did not look far enough.

The expanded place where I expect the dma.h file would be (as I
/lib/modules/2.6.28-19-generic/build/include/config/ieee1394/dma.h

note that the letters "el" should be removed from your first expression
$dmahplace="$kernelsrc/include/config/ieee1394/dma.h";
needs to be:
$dmahplace="$kernsrc/include/config/ieee1394/dma.h";

Thanks a lot for helping !


As patch, relative to the diff you sent:

# HG changeset patch
# User Jan Hoogenraad <jan-conceptronic@h-i-s.nl>
# Date 1285695899 -7200
# Node ID 891128e7c3334e41f6c173ee5c01fddbce493b73
# Parent  cb34ee1c29fc8891ad3792b3df76031a72e39b9d
Location fix

From: Jan Hoogenraad <jan-conceptronic@h-i-s.nl>

Location fix

Priority: normal

Signed-off-by: Jan Hoogenraad <jan-conceptronic@h-i-s.nl>

diff -r cb34ee1c29fc -r 891128e7c333 v4l/scripts/make_kconfig.pl
--- a/v4l/scripts/make_kconfig.pl	Mon Sep 27 20:27:20 2010 +0200
+++ b/v4l/scripts/make_kconfig.pl	Tue Sep 28 19:44:59 2010 +0200
@@ -688,10 +688,7 @@
  # Check for full kernel sources and print a warning
  sub dmahcheck()
  {
-	my $dmahplace= "".$kernsrc;
-	$dmahplace =~ s-^/lib/modules/--g;
-	$dmahplace =~ s-/.*$--g;
- 
$dmahplace="/usr/src/linux-headers-$dmahplace/include/config/ieee1394/dma.h";
+	my $dmahplace="$kernsrc/include/config/ieee1394/dma.h";
  	if (! -e $dmahplace) {
  		print <<"EOF2";


Mauro Carvalho Chehab wrote:
> Em 27-09-2010 17:45, Jan Hoogenraad escreveu:
>> Mauro:
>>
>> On my system, the call to make_kconfig reads:
>> ./scripts/make_kconfig.pl /lib/modules/2.6.28-19-generic/build /lib/modules/2.6.28-19-generic/build 1
>>
>> Using $kernelsrc yields the following error:
>> Global symbol "$kernelsrc" requires explicit package name at ./scripts/make_kconfig.pl line 694.
>>
>> Using
>> $dmahplace="$kernsrc/include/config/ieee1394/dma.h";
>> yields the following INCORRECT expansion:
>> /lib/modules/2.6.28-19-generic/build/include/config/ieee1394/dma.h
>> this is the place where I am building into, which is different from the place where Ubuntu places the include files from the package
>>
>> Thus I built an expression to get:
>> /usr/src/linux-headers-2.6.28-19-generic/include/config/ieee1394/dma.h
>> as I described in the mail of yesterday.
>
>
> Huh? Are you sure that Ubuntu doesn't have a symbolic link at /lib/modules/2.6.28-19-generic/build pointing
> to /usr/src/linux-headers-2.6.28-19-generic/?
>
> If it doesn't have, then all compat checks done by make_config_compat.pl would fail.
>
>> Now, I realize that the header files could ALSO be present in the build directory, so there should be a check on that as well, as otherwise the FIREDTV is incorrectly disabled on other distros, or source builds.
>>
>> Yes, and I know all of this is ugly ....
>
> It is not just ugly. It will break compilation on Ubuntu with:
> 	$ make release DIR=<some dir>
>
> Cheers,
> Mauro
>


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
