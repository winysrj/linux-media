Return-path: <mchehab@pedra>
Received: from moh2-ve2.go2.pl ([193.17.41.200]:43590 "EHLO moh2-ve2.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab1CURaj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 13:30:39 -0400
Received: from moh2-ve2.go2.pl (unknown [10.0.0.200])
	by moh2-ve2.go2.pl (Postfix) with ESMTP id 92B4CB00118
	for <linux-media@vger.kernel.org>; Mon, 21 Mar 2011 18:30:30 +0100 (CET)
Received: from unknown (unknown [10.0.0.74])
	by moh2-ve2.go2.pl (Postfix) with SMTP
	for <linux-media@vger.kernel.org>; Mon, 21 Mar 2011 18:30:28 +0100 (CET)
Message-ID: <4D878B33.2020307@tlen.pl>
Date: Mon, 21 Mar 2011 18:30:27 +0100
From: Wojciech Myrda <vojcek@tlen.pl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Prof_Revolution_DVB-S2_8000_PCI-E & Linux Kernel 2.6.38-rc8-next-20110314
References: <4D86566B.9090803@tlen.pl>
In-Reply-To: <4D86566B.9090803@tlen.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

W dniu 20.03.2011 20:32, Wojciech Myrda pisze:
> Hi all,
> 
> I have purchased Prof_Revolution_DVB-S2_8000_PCI-E which is listed on
> the wiki
> http://linuxtv.org/wiki/index.php/Prof_Revolution_DVB-S2_8000_PCI-E as
> not yet suppoorted, however I found out there is some work ongoing on
> the driver for that card as the producer make the folowing patch
> http://www.proftuners.com/sites/default/files/prof8000_0.patch available
> on their website http://www.prof-tuners.pl/download8000.html This patch
> would not apply agaist the recent Linux Kernel 2.6.38-rc8-next-20110314
> so I did a few quick fixes that moved few lines (patch in the
> attachment). Now that it all applies like it should it fails with the
> following error
> 
> 
>   CC [M]  kernel/configs.o
>   CC [M]  drivers/media/video/cx23885/cx23885-cards.o
>   CC [M]  drivers/media/video/cx23885/cx23885-video.o
>   CC [M]  drivers/media/video/cx23885/cx23885-vbi.o
>   CC [M]  drivers/media/video/cx23885/cx23885-core.o
> drivers/media/video/cx23885/altera-ci.h:71:12: warning:
> ‘altera_ci_tuner_reset’ defined but not used [-Wunused-function]
>   CC [M]  drivers/media/video/cx23885/cx23885-i2c.o
>   CC [M]  drivers/media/video/cx23885/cx23885-dvb.o
> drivers/media/video/cx23885/cx23885-dvb.c:505:15: error: variable
> ‘prof_8000_stb6100_config’ has initializer but incomplete type
> drivers/media/video/cx23885/cx23885-dvb.c:506:2: error: unknown field
> ‘tuner_address’ specified in initializer
> drivers/media/video/cx23885/cx23885-dvb.c:506:2: warning: excess
> elements in struct initializer [enabled by default]
> drivers/media/video/cx23885/cx23885-dvb.c:506:2: warning: (near
> initialization for ‘prof_8000_stb6100_config’) [enabled by default]
> drivers/media/video/cx23885/cx23885-dvb.c:507:2: error: unknown field
> ‘refclock’ specified in initializer
> drivers/media/video/cx23885/cx23885-dvb.c:507:2: warning: excess
> elements in struct initializer [enabled by default]
> drivers/media/video/cx23885/cx23885-dvb.c:507:2: warning: (near
> initialization for ‘prof_8000_stb6100_config’) [enabled by default]
> drivers/media/video/cx23885/cx23885-dvb.c: In function ‘dvb_register’:
> drivers/media/video/cx23885/cx23885-dvb.c:1134:8: error:
> ‘stb6100_attach’ undeclared (first use in this function)
> drivers/media/video/cx23885/cx23885-dvb.c:1134:8: note: each undeclared
> identifier is reported only once for each function it appears in
> drivers/media/video/cx23885/cx23885-dvb.c:1134:8: error: called object
> ‘__a’ is not a function
> drivers/media/video/cx23885/cx23885-dvb.c:1138:32: error:
> ‘stb6100_set_freq’ undeclared (first use in this function)
> drivers/media/video/cx23885/cx23885-dvb.c:1139:32: error:
> ‘stb6100_get_freq’ undeclared (first use in this function)
> drivers/media/video/cx23885/cx23885-dvb.c:1140:32: error:
> ‘stb6100_set_bandw’ undeclared (first use in this function)
> drivers/media/video/cx23885/cx23885-dvb.c:1141:32: error:
> ‘stb6100_get_bandw’ undeclared (first use in this function)
> drivers/media/video/cx23885/cx23885-dvb.c: At top level:
> drivers/media/video/cx23885/altera-ci.h:71:12: warning:
> ‘altera_ci_tuner_reset’ defined but not used [-Wunused-function]
> make[4]: *** [drivers/media/video/cx23885/cx23885-dvb.o] Error 1
> make[3]: *** [drivers/media/video/cx23885] Error 2
> make[2]: *** [drivers/media/video] Error 2
> make[1]: *** [drivers/media] Error 2
> make: *** [drivers] Error 2
> 
> Please help in making it work as my Kung Fu ends here
> 
> Regards,
> Wojciech
> 

It turns ot that revised patch not only applies cleanly but compiles as
well agaist Linux Kernel 2.6.38-rc8-next-20110321. Looking at dmesg
everything is recognized properly as well. Do you guys think if it is
possible to include it into the tree?

mediapc linux-2.6.38 # cat ../dvb/prof8000_1.patch |patch -E -p2
(Stripping trailing CRs from patch.)
patching file drivers/media/video/cx23885/cx23885-cards.c
Hunk #1 succeeded at 183 (offset 14 lines).
Hunk #2 succeeded at 445 (offset 53 lines).
Hunk #3 succeeded at 932 (offset 111 lines).
Hunk #4 succeeded at 1297 (offset 245 lines).
(Stripping trailing CRs from patch.)
patching file drivers/media/video/cx23885/cx23885-dvb.c
Hunk #1 succeeded at 46 (offset -1 lines).
(Stripping trailing CRs from patch.)
patching file drivers/media/video/cx23885/cx23885.h
mediapc linux-2.6.38 # make
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CC [M]  drivers/media/video/cx23885/cx23885-cards.o
  CC [M]  drivers/media/video/cx23885/cx23885-video.o
  CC [M]  drivers/media/video/cx23885/cx23885-vbi.o
  CC [M]  drivers/media/video/cx23885/cx23885-core.o
drivers/media/video/cx23885/altera-ci.h:71:12: warning:
‘altera_ci_tuner_reset’ defined but not used [-Wunused-function]
  CC [M]  drivers/media/video/cx23885/cx23885-i2c.o
  CC [M]  drivers/media/video/cx23885/cx23885-dvb.o
drivers/media/video/cx23885/altera-ci.h:71:12: warning:
‘altera_ci_tuner_reset’ defined but not used [-Wunused-function]
  CC [M]  drivers/media/video/cx23885/cx23885-417.o
  CC [M]  drivers/media/video/cx23885/cx23885-ioctl.o
  CC [M]  drivers/media/video/cx23885/cx23885-ir.o
  CC [M]  drivers/media/video/cx23885/cx23885-av.o
  CC [M]  drivers/media/video/cx23885/cx23885-input.o
  CC [M]  drivers/media/video/cx23885/cx23888-ir.o
drivers/media/video/cx23885/cx23888-ir.c: In function
‘pulse_clocks_to_clock_divider’:
drivers/media/video/cx23885/cx23888-ir.c:334:6: warning: variable ‘rem’
set but not used [-Wunused-but-set-variable]
  CC [M]  drivers/media/video/cx23885/netup-init.o
  CC [M]  drivers/media/video/cx23885/cimax2.o
  CC [M]  drivers/media/video/cx23885/netup-eeprom.o
  CC [M]  drivers/media/video/cx23885/cx23885-f300.o
  LD [M]  drivers/media/video/cx23885/cx23885.o
Kernel: arch/x86/boot/bzImage is ready  (#1)
  Building modules, stage 2.
  MODPOST 697 modules
WARNING: modpost: Found 3 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  LD [M]  drivers/media/video/cx23885/cx23885.ko

Regards,
Wojciech
