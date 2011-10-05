Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:39820 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934271Ab1JENpc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 09:45:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC PATCH] media_build: two fixes + one unresolved issue
Date: Wed, 5 Oct 2011 15:45:27 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201110051123.39783.hverkuil@xs4all.nl> <4E8C5198.4020107@redhat.com>
In-Reply-To: <4E8C5198.4020107@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110051545.27427.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 05 October 2011 14:46:16 Mauro Carvalho Chehab wrote:
> Em 05-10-2011 06:23, Hans Verkuil escreveu:
> > Hi Mauro,
> > 
> > While doing a compatibility build I found three issues. I've got patches
> > for two, but one issue is still unresolved.
> > 
> > The first is this small patch to get rid of this warning when doing 'make
> > install':
> > 
> > make -C firmware install
> > make[2]: Entering directory `/home/hve/work/media_build/v4l/firmware'
> > Installing firmwares at /lib/firmware: vicam/firmware.fw
> > dabusb/firmware.fw dabusb/bitstream.bin ttusb-budget/dspbootcode.bin
> > cpia2/stv0672_vp4.bin av7110/bootcode.bin *.fw* cp: target
> > `/lib/firmware/v4l-pvrusb2-29xxx-01.fw' is not a directory make[2]:
> > [install] Error 1 (ignored)
> > 
> > The fix is simply to remove '*.fw*' since it doesn't match any files.
> > 
> > diff --git a/v4l/firmware/Makefile b/v4l/firmware/Makefile
> > index fb53ef2..bcbc784 100644
> > --- a/v4l/firmware/Makefile
> > +++ b/v4l/firmware/Makefile
> > @@ -22,7 +22,7 @@ distclean: clean
> > 
> >  install: default
> >  
> >  	@echo -n "Installing firmwares at $(FW_DIR): "
> >  	-@for i in $(DIRS); do if [ ! -d $(FW_DIR)/$$i ]; then mkdir -p
> >  	$(FW_DIR)/$$i; fi; done
> > 
> > -	-@for i in $(TARGETS) *.fw*; do echo -n "$$i "; cp $$i $(FW_DIR)/$$i;
> > done +	-@for i in $(TARGETS); do echo -n "$$i "; cp $$i $(FW_DIR)/$$i;
> > done
> > 
> >  	@echo
> 
> I suspect that, for some unknown reason, you're not capable of downloading
> the firmwares from linuxtv.org, or maybe you never ran the build script.

I never ran the build script. I'm just using 'make dir'.

> The build firmware downloads the latest version of the firmwares from:
> 	http://www.linuxtv.org/downloads/firmware/
> 
> It should be noticed that the install procedure won't fail if you never
> downloaded the firmwares, due to the "-" signal. So, please don't apply
> this patch.

I'll apply this patch instead:

-       -@for i in $(TARGETS) *.fw*; do echo -n "$$i "; cp $$i $(FW_DIR)/$$i; done
+       -@for i in $(TARGETS) $(wildcard *.fw*); do echo -n "$$i "; cp $$i $(FW_DIR)/$$i; done

The make wildcard function resolves to nothing if the pattern can't be matched,
thus avoiding the error.

> 
> >  rminstall:
> > I think this fix is fine, unless this is something you want to have for
> > the future.
> > 
> > The other is a kernel naming issue: my aptosid distro (debian based)
> > running kernel v3.0.0 uses a different naming convention:
> > 
> > $ uname -r
> > 3.0-4.slh.6-aptosid-amd64
> > 
> > So the sublevel is not shown.
> > 
> > This patch makes the sublevel optional (and assumes it to be 0 if
> > absent):
> > 
> > diff --git a/linux/patches_for_kernel.pl b/linux/patches_for_kernel.pl
> > index c19b216..33348d9 100755
> > --- a/linux/patches_for_kernel.pl
> > +++ b/linux/patches_for_kernel.pl
> > @@ -13,8 +13,11 @@ my $file = "../backports/backports.txt";
> > 
> >  open IN, $file or die "can't find $file\n";
> >  
> >  sub kernel_version($) {
> > 
> > -	$_[0] =~ m/^(\d+)\.(\d+)\.(\d+)/;
> > -	return ($1*65536 + $2*256 + $3);
> > +	my $sublevel;
> > +
> > +	$_[0] =~ m/^(\d+)\.(\d+)\.?(\d*)/;
> > +	$sublevel = $3 == "" ? 0 : $3;
> > +	return ($1*65536 + $2*256 + $sublevel);
> > 
> >  }
> >  
> >  my $kernel = kernel_version($version);
> > 
> > diff --git a/v4l/Makefile b/v4l/Makefile
> > index ab07a7a..311924e 100644
> > --- a/v4l/Makefile
> > +++ b/v4l/Makefile
> > @@ -248,7 +248,7 @@ ifneq ($(VER),)
> > 
> >  	@echo $(VER)|perl -ne 'if (/^([0-9]*)\.([0-9])*\.([0-9]*)(.*)$$/) {
> >  	printf
> > 
> > ("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s.%s.%s%s\n",
> > $$1,$$2,$$3,$$1,$$2,$$3,$$4); };' > $(obj)/.version
> > 
> >  else
> >  
> >  	@echo No version yet, using `uname -r`
> > 
> > -	@uname -r|perl -ne 'if (/^([0-9]*)\.([0-9])*\.([0-9]*)(.*)$$/) { printf
> > ("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s.
> > %s.%s%s\n",$$1,$$2,$$3,$$1,$$2,$$3,$$4); };' > $(obj)/.version
> > +	@uname -r|perl -ne 'if (/^([0-9]*)\.([0-9])*\.?([0-9]*)(.*)$$/) {
> > printf
> > ("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s",$$1,$$2,$
> > $3==""?"0":$$3,$$_); };' > $(obj)/.version
> > 
> >  endif
> >  endif
> 
> Seems OK to me. If you're willing to fix those distro-specific stuff, on
> Fedora 15, the 3.0 kernel were renamed as "2.40", as they wanted to avoid
> touching on some scripts (that's what I got from a lwn discussion). Maybe
> other distros might have done weird things like that. The only practical
> consequence I noticed with F15 is that one driver were disabled (the
> firewire one).

I'll see if I can make a patch for this.

> > The last issue I have is that the media.ko module isn't installed when I
> > run 'make install'. I tried to fix it, but I got lost in the
> > Makefile/perl magic :-)
> 
> That's weird... I took a look here. My Makefile.media was generated with a
> line to install it. See:
> 
> @n=0;for i in dvb-ttpci.ko budget-patch.ko ttpci-eeprom.ko budget-av.ko
> budget.ko budget-core.ko budget-ci.ko;do if [ -f "$$i" ]; then if [ $$n
> -eq 0 ]; then echo -n "	dvb/ttpci/: "; install -d
> $(DESTDIR)$(KDIR26)/dvb/ttpci; fi; n=$$(($$n+1)); if [ $$n -eq 4 ]; then
> echo; echo -n "		"; n=1; fi; echo -n "$$i "; install -m 644 -c $$i
> $(DESTDIR)$(KDIR26)/dvb/ttpci; fi; done; if [  $$n -ne 0 ]; then echo;
> strip --strip-debug $(DESTDIR)$(KDIR26)/dvb/ttpci/*.ko; fi;
> 
> 
> @n=0;for i in media.ko;do if [ -f "$$i" ]; then if [ $$n -eq 0 ]; then echo
> -n "	../linux/drivers/media/: "; insta ll -d
> $(DESTDIR)$(KDIR26)/../linux/drivers/media; fi; n=$$(($$n+1)); if [  $$n
> -eq 4 ]; then echo; echo -n "		"; n=1; f i; echo -n "$$i "; install -m 644
> -c $$i $(DESTDIR)$(KDIR26)/../linux/drivers/media; fi; done; if [  $$n -ne
> 0 ]; then echo; stri p --strip-debug
> $(DESTDIR)$(KDIR26)/../linux/drivers/media/*.ko; fi;
> 
> For me, it is likely a trouble at scripts/make_makefile.pl, on that line of
> the script:
> 		$idir =~ s|^../linux/drivers/media/||;
> 
> An one line patch to make the last / optional is probably enough to fix it.

You're absolutely right.

The output from make install looks like this:

        video/cx25840/: cx25840.ko 
        dvb/ttusb-dec/: ttusbdecfe.ko ttusb_dec.ko 
        dvb/ngene/: ngene.ko 
        dvb/dm1105/: dm1105.ko 
        ../linux/drivers/media/: media.ko 
        video/gspca/gl860/: gspca_gl860.ko 
        video/et61x251/: et61x251.ko

As you can see it tries to get media.ko from the wrong place. Making the last /
optional fixes this.

> 
> Care to write the patch and fix it?

This patch fixes all three:

diff --git a/linux/patches_for_kernel.pl b/linux/patches_for_kernel.pl
index c19b216..33348d9 100755
--- a/linux/patches_for_kernel.pl
+++ b/linux/patches_for_kernel.pl
@@ -13,8 +13,11 @@ my $file = "../backports/backports.txt";
 open IN, $file or die "can't find $file\n";
 
 sub kernel_version($) {
-	$_[0] =~ m/^(\d+)\.(\d+)\.(\d+)/;
-	return ($1*65536 + $2*256 + $3);
+	my $sublevel;
+
+	$_[0] =~ m/^(\d+)\.(\d+)\.?(\d*)/;
+	$sublevel = $3 == "" ? 0 : $3;
+	return ($1*65536 + $2*256 + $sublevel);
 }
 
 my $kernel = kernel_version($version);
diff --git a/v4l/Makefile b/v4l/Makefile
index ab07a7a..311924e 100644
--- a/v4l/Makefile
+++ b/v4l/Makefile
@@ -248,7 +248,7 @@ ifneq ($(VER),)
 	@echo $(VER)|perl -ne 'if (/^([0-9]*)\.([0-9])*\.([0-9]*)(.*)$$/) { printf 
("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s.%s.%s%s\n",$$1,$$2,$$3,$$1,$$2,$$3,$$4); };' > $(obj)/.version
 else
 	@echo No version yet, using `uname -r`
-	@uname -r|perl -ne 'if (/^([0-9]*)\.([0-9])*\.([0-9]*)(.*)$$/) { printf ("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s.
%s.%s%s\n",$$1,$$2,$$3,$$1,$$2,$$3,$$4); };' > $(obj)/.version
+	@uname -r|perl -ne 'if (/^([0-9]*)\.([0-9])*\.?([0-9]*)(.*)$$/) { printf 
("VERSION=%s\nPATCHLEVEL:=%s\nSUBLEVEL:=%s\nKERNELRELEASE:=%s",$$1,$$2,$$3==""?"0":$$3,$$_); };' > $(obj)/.version
 endif
 endif
 
diff --git a/v4l/firmware/Makefile b/v4l/firmware/Makefile
index fb53ef2..ff08bf2 100644
--- a/v4l/firmware/Makefile
+++ b/v4l/firmware/Makefile
@@ -22,7 +22,7 @@ distclean: clean
 install: default
 	@echo -n "Installing firmwares at $(FW_DIR): "
 	-@for i in $(DIRS); do if [ ! -d $(FW_DIR)/$$i ]; then mkdir -p $(FW_DIR)/$$i; fi; done
-	-@for i in $(TARGETS) *.fw*; do echo -n "$$i "; cp $$i $(FW_DIR)/$$i; done
+	-@for i in $(TARGETS) $(wildcard *.fw*); do echo -n "$$i "; cp $$i $(FW_DIR)/$$i; done
 	@echo
 
 rminstall:
diff --git a/v4l/scripts/make_makefile.pl b/v4l/scripts/make_makefile.pl
index 4a578a5..1832e5b 100755
--- a/v4l/scripts/make_makefile.pl
+++ b/v4l/scripts/make_makefile.pl
@@ -32,7 +32,7 @@ sub check_line($$$)
 		# It's a file, add it to list of files to install
 		s/\.o$/.ko/;
 		my $idir = $dir;
-		$idir =~ s|^../linux/drivers/media/||;
+		$idir =~ s|^../linux/drivers/media/?||;
 		$instdir{$idir}{$_} = 1;
 		$count++;
 	}

Regards,

	Hans
