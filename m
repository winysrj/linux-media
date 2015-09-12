Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33451 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbbILFs2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2015 01:48:28 -0400
Received: by wiclk2 with SMTP id lk2so84803545wic.0
        for <linux-media@vger.kernel.org>; Fri, 11 Sep 2015 22:48:27 -0700 (PDT)
Message-ID: <55F3BCA9.1060505@gmail.com>
Date: Sat, 12 Sep 2015 07:48:25 +0200
From: =?UTF-8?B?VHljaG8gTMO8cnNlbg==?= <tycholursen@gmail.com>
MIME-Version: 1.0
To: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>,
	Jurgen Kramer <gtmkramer@xs4all.nl>,
	linux-media@vger.kernel.org
Subject: Re: DVBSky T980C CI issues (kernel 4.0.x)
References: <1436697509.2446.14.camel@xs4all.nl> <1440352250.13381.3.camel@xs4all.nl> <55F332FE.7040201@mbox200.swipnet.se>
In-Reply-To: <55F332FE.7040201@mbox200.swipnet.se>
Content-Type: multipart/mixed;
 boundary="------------080509040108010803030108"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080509040108010803030108
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit



Op 11-09-15 om 22:01 schreef Torbjorn Jansson:
>
> did you get it to work?
>
> i got a dvbsky T980C too for dvb-t2 reception and so far the only 
> drivers that have worked at all is the ones from dvbsky directly.
>
> i was very happy when i noticed that recent kernels have support for 
> it built in but unfortunately only the modules and firmware loads but 
> then nothing actually works.
> i use mythtv and it complains a lot about the signal, running femon 
> also produces lots of errors.
>
> so i had to switch back to kernel 4.0.4 with mediabuild from dvbsky.
>
> if there were any other dvb-t2 card with ci support that had better 
> drivers i would change right away.
>
> one problem i have with the mediabuilt from dvbsky is that at boot the 
> cam never works and i have to first tune a channel, then remove and 
> reinstert the cam to get it to work.
> without that nothing works.
>
> and finally a problem i ran into when i tried mediabuilt from 
> linuxtv.org.
> fedora uses kernel modules with .ko.xz extension so when you install 
> the mediabuilt modulels you get one modulename.ko and one modulename.ko.xz
>
> before a make install from mediabuild overwrote the needed modules.
> any advice on how to handle this now?
You could patch the Makefile with a patch from Oliver Endriss (attached).
This way all modules get installed in /lib/modules/`uname -r`/updates/media
If your kernel needs it, you can compress them afterwards.
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--------------080509040108010803030108
Content-Type: text/x-patch;
 name="v4l-make-install.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="v4l-make-install.patch"

--- v4l/Makefile	2013-11-27 16:15:21.528260850 +0100
+++ v4l/Makefile	2013-11-27 16:24:37.171815316 +0100
@@ -154,6 +154,7 @@
 PWD		:= $(shell pwd)
 DEST		:= /lib/modules/$(KERNELRELEASE)/v4l2
 KDIR26		:= /lib/modules/$(KERNELRELEASE)/kernel/drivers/media
+INSTDIR 	:= $(DESTDIR)/lib/modules/$(KERNELRELEASE)/updates/media
 
 #################################################
 # Compiler fixup rules
@@ -202,9 +203,18 @@
 #################################################
 # installation invocation rules
 
-modules_install install:: media-install firmware_install
-
-remove rminstall:: media-rminstall
+modules_install install:: rminstall firmware_install
+	install -d -v $(INSTDIR)
+	@for i in *.ko; do				\
+		echo "install $$i -> $(INSTDIR)/";	\
+		install -p -m 644 $$i $(INSTDIR);	\
+	done;
+	strip --strip-debug $(INSTDIR)/*.ko
+	/sbin/depmod -a $(KERNELRELEASE) $(if $(DESTDIR),-b $(DESTDIR))
+
+remove rminstall::
+	@rm -Rfv $(INSTDIR)
+	/sbin/depmod -a $(KERNELRELEASE) $(if $(DESTDIR),-b $(DESTDIR))
 
 firmware_install::
 	make -C firmware install

--------------080509040108010803030108--
