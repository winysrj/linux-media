Return-path: <mchehab@pedra>
Received: from bombadil.infradead.org ([18.85.46.34]:36761 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902Ab0I1SV0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 14:21:26 -0400
Message-ID: <4CA2321C.1020909@infradead.org>
Date: Tue, 28 Sep 2010 15:21:16 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
CC: Douglas Schilling Landgraf <dougsland@gmail.com>,
	"Ole W. Saastad" <olewsaa@online.no>, linux-media@vger.kernel.org
Subject: Re: updated make_kconfig.pl for Ubuntu
References: <1284493110.1801.57.camel@sofia> <4C924EB8.9070500@hoogenraad.net> <4C93364C.3040606@hoogenraad.net> <4C934806.7050503@gmail.com> <4C934C10.2060801@hoogenraad.net> <4C93800B.8070902@gmail.com> <4C9F7267.7000707@hoogenraad.net> <4CA018C4.9000507@gmail.com> <4CA0E554.40406@hoogenraad.net> <4CA0ECA9.30208@gmail.com> <4CA10262.6060206@hoogenraad.net> <4CA11E25.5030206@gmail.com> <4CA22A79.9020309@hoogenraad.net>
In-Reply-To: <4CA22A79.9020309@hoogenraad.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 28-09-2010 14:48, Jan Hoogenraad escreveu:
> Douglas:
> 
> I have an updated make_kconfig.pl for Ububtu on:
> http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2/file/cb34ee1c29fc/v4l/scripts/make_kconfig.pl
> 
> Could you test if make allyesconfig actually keeps FIREDTV enabled on a non-Ubuntu system ?
> 
> If so, can you merge this version into the main stream ?
> 
> 
> Mauro:
> 
> You are very right. I did not look far enough.
> 
> The expanded place where I expect the dma.h file would be (as I
> /lib/modules/2.6.28-19-generic/build/include/config/ieee1394/dma.h
> 
> note that the letters "el" should be removed from your first expression
> $dmahplace="$kernelsrc/include/config/ieee1394/dma.h";
> needs to be:
> $dmahplace="$kernsrc/include/config/ieee1394/dma.h";
> 
> Thanks a lot for helping !
> 
> 
> As patch, relative to the diff you sent:
> 
> # HG changeset patch
> # User Jan Hoogenraad <jan-conceptronic@h-i-s.nl>
> # Date 1285695899 -7200
> # Node ID 891128e7c3334e41f6c173ee5c01fddbce493b73
> # Parent  cb34ee1c29fc8891ad3792b3df76031a72e39b9d
> Location fix
> 
> From: Jan Hoogenraad <jan-conceptronic@h-i-s.nl>
> 
> Location fix
> 
> Priority: normal
> 
> Signed-off-by: Jan Hoogenraad <jan-conceptronic@h-i-s.nl>
> 
> diff -r cb34ee1c29fc -r 891128e7c333 v4l/scripts/make_kconfig.pl
> --- a/v4l/scripts/make_kconfig.pl    Mon Sep 27 20:27:20 2010 +0200
> +++ b/v4l/scripts/make_kconfig.pl    Tue Sep 28 19:44:59 2010 +0200
> @@ -688,10 +688,7 @@
>  # Check for full kernel sources and print a warning
>  sub dmahcheck()
>  {
> -    my $dmahplace= "".$kernsrc;
> -    $dmahplace =~ s-^/lib/modules/--g;
> -    $dmahplace =~ s-/.*$--g;
> - $dmahplace="/usr/src/linux-headers-$dmahplace/include/config/ieee1394/dma.h";
> +    my $dmahplace="$kernsrc/include/config/ieee1394/dma.h";
>      if (! -e $dmahplace) {
>          print <<"EOF2";

Ok, now it looks correct on my eyes, and it should not hurt compilation
with make release and with distros that do a good job with their kernel
packages.

I'll let Douglas review and test, as he is the maintainer.

It would be better if you could send him a diff. you may use hg diff to generate
it against an older version, in order to merge all your make_kconfig.pl patches,
or just create a new clone from master and apply it there.

A side question: when do you intend to send us the patches for the Realtek
rtl2831?

Cheers,
Mauro.

