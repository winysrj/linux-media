Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:60238 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab1JFLDw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 07:03:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC PATCH] media_build: two fixes + one unresolved issue
Date: Thu, 6 Oct 2011 13:03:45 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201110051123.39783.hverkuil@xs4all.nl> <201110061043.24652.hverkuil@xs4all.nl> <4E8D87F6.10502@redhat.com>
In-Reply-To: <4E8D87F6.10502@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110061303.45629.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 06 October 2011 12:50:30 Mauro Carvalho Chehab wrote:
> Em 06-10-2011 05:43, Hans Verkuil escreveu:
> > On Wednesday 05 October 2011 18:26:20 Mauro Carvalho Chehab wrote:
> >> Em 05-10-2011 10:45, Hans Verkuil escreveu:
> >>> I'll see if I can make a patch for this.
> >> 
> >> Ok, thanks!
> > 
> > Mauro, can you test this patch? It should translate 2.4x naming
> > convention to 3.x.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > diff --git a/linux/patches_for_kernel.pl b/linux/patches_for_kernel.pl
> > index 33348d9..00d8b7f 100755
> > --- a/linux/patches_for_kernel.pl
> > +++ b/linux/patches_for_kernel.pl
> > @@ -13,11 +13,15 @@ my $file = "../backports/backports.txt";
> > 
> >   open IN, $file or die "can't find $file\n";
> >   
> >   sub kernel_version($) {
> > 
> > -	my $sublevel;
> > +	my ($version, $patchlevel, $sublevel) = $_[0] =~
> > m/^(\d+)\.(\d+)\.?(\d*)/;
> > 
> > -	$_[0] =~ m/^(\d+)\.(\d+)\.?(\d*)/;
> > -	$sublevel = $3 == "" ? 0 : $3;
> > -	return ($1*65536 + $2*256 + $sublevel);
> > +	# fix kernel version for distros that 'translated' 3.0 to 2.40
> > +	if ($version == 2&&  $patchlevel>= 40) {
> > +		$version = 3;
> > +		$patchlevel -= 40;
> > +	}
> > +	$sublevel = 0 if ($sublevel == "");
> > +	return ($version * 65536 + $patchlevel * 256 + $sublevel);
> > 
> >   }
> >   
> >   my $kernel = kernel_version($version);
> > 
> > diff --git a/v4l/Makefile b/v4l/Makefile
> > index 311924e..57302cc 100644
> > --- a/v4l/Makefile
> > +++ b/v4l/Makefile
> > @@ -248,7 +248,7 @@ ifneq ($(VER),)
> > 
> >   	@echo $(VER)|perl -ne 'if (/^([0-9]*)\.([0-9])*\.([0-9]*)(.*)$$/) {
> >   	printf
> > 
> > ("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s.%s.%s%s\n",
> > $$1,$$2,$$3,$$1,$$2,$$3,$$4); };'>  $(obj)/.version
> > 
> >   else
> >   
> >   	@echo No version yet, using `uname -r`
> > 
> > -	@uname -r|perl -ne 'if (/^([0-9]*)\.([0-9])*\.?([0-9]*)(.*)$$/) {
> > printf
> > ("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s",$$1,$$2,$
> > $3==""?"0":$$3,$$_); };'>  $(obj)/.version +	@uname -r|perl -ne 'if
> > (/^([0-9]*)\.([0-9])*\.?([0-9]*)(.*)$$/) { $$ver = $$1; $$patch = $$2;
> > $$sub = $$3; if ($$ver == 2&&  $$patch>= 40) { $$ver = 3; $$patch -= 40;
> > }; printf
> > ("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s",$$ver,$$p
> > atch,$$sub==""?"0": $$sub,$$_); };'>  $(obj)/.version
> > 
> >   endif
> >   endif
> 
> Hi Hans,
> 
> The idea was good, but the patch didn't work ;)
> 
> Fixed it. It is now properly recognizing the version 2.40 as 3.0.0 on both
> scripts. See enclosed. I didn't apply it yet.

Yeah, it's 2.6.40 to 3.0 instead of 2.40 to 3.0. It's amazing how quickly you 
forget :-)

> Btw, I just applied another fix upstream. The most noticed effect is that
> calling make -C linux apply_patches will now show:
> 	Patches for 2.6.40.4-5.fc15.x86_64 already applied.
> instead of:
> 	Patches for  already applied.

Nice!

> -
> Fix Name convention for kernels 2.6.40 and upper
> 
> Based on a patch from Hans Verkuil <hverkuil@xs4all.nl>
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/linux/patches_for_kernel.pl b/linux/patches_for_kernel.pl
> index 33348d9..2669e6c 100755
> --- a/linux/patches_for_kernel.pl
> +++ b/linux/patches_for_kernel.pl
> @@ -13,11 +13,18 @@ my $file = "../backports/backports.txt";
>   open IN, $file or die "can't find $file\n";
> 
>   sub kernel_version($) {
> -	my $sublevel;
> +	my ($version, $patchlevel, $sublevel) = $_[0] =~
> m/^(\d+)\.(\d+)\.?(\d*)/;
> 
> -	$_[0] =~ m/^(\d+)\.(\d+)\.?(\d*)/;
> -	$sublevel = $3 == "" ? 0 : $3;
> -	return ($1*65536 + $2*256 + $sublevel);
> +	# fix kernel version for distros that 'translated' 3.0 to 2.40

This comment is wrong, it should be 2.6.40.

> +	$version += 0;
> +	$patchlevel += 0;

These two lines seems to be leftovers from debugging.

I assume you will commit this?

Regards,

	Hans

> +	if ($version == 2 && $patchlevel == 6 && $sublevel >= 40) {
> +		$version = 3;
> +		$patchlevel = $sublevel - 40;
> +		$sublevel = 0;
> +	}
> +	$sublevel = 0 if ($sublevel == "");
> +	return ($version * 65536 + $patchlevel * 256 + $sublevel);
>   }
> 
>   my $kernel = kernel_version($version);
> diff --git a/v4l/Makefile b/v4l/Makefile
> index 311924e..580c997 100644
> --- a/v4l/Makefile
> +++ b/v4l/Makefile
> @@ -248,7 +248,7 @@ ifneq ($(VER),)
>   	@echo $(VER)|perl -ne 'if (/^([0-9]*)\.([0-9])*\.([0-9]*)(.*)$$/) {
> printf
> ("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s.%s.%s%s\n",$
> $1,$$2,$$3,$$1,$$2,$$3,$$4); };' > $(obj)/.version else
>   	@echo No version yet, using `uname -r`
> -	@uname -r|perl -ne 'if (/^([0-9]*)\.([0-9])*\.?([0-9]*)(.*)$$/) { printf
> ("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s",$$1,$$2,$$3
> ==""?"0":$$3,$$_); };' > $(obj)/.version +	@uname -r|perl -ne 'if
> (/^([0-9]*)\.([0-9])*\.?([0-9]*)(.*)$$/) { $$ver = $$1; $$patch = $$2;
> $$sub = $$3; if ($$ver == 2 && $$patch == 6 && $$sub >= 40) { $$ver = 3;
> $$patch = $$sub - 40; $$sub = 0; }; printf
> ("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s",$$ver,$$pat
> ch,$$sub==""?"0":$$sub,$$_); };' > $(obj)/.version endif
>   endif
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
