Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:32892 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753007Ab1FRU6G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2011 16:58:06 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-media@vger.kernel.org
Subject: Bug: media_build always compiles with '-DDEBUG'
Date: Sat, 18 Jun 2011 22:46:01 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Helmut Auer <helmut@helmutauer.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106182246.03051@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

bug is triggered by the code block

  ifdef CONFIG_VIDEO_OMAP3_DEBUG
  EXTRA_CFLAGS += -DDEBUG
  endif

from media/video/omap3isp/Makefile,
which is part of Makefile.media.

The expression above is always true, as make_myconfig.pl initialises
boolean options to 'n', i.e. 
  CONFIG_VIDEO_OMAP3_DEBUG := n

As a result, EXTRA_CFLAGS contains -DDEBUG.

So either make_myconfig.pl or omap3isp/Makefile must be fixed.

Replacing
    ifdef CONFIG_VIDEO_OMAP3_DEBUG
by
    ifeq ($(CONFIG_VIDEO_OMAP3_DEBUG),y)
would do the trick.

Thanks to Helmut Auer for reporting the bug.

CU
Oliver

----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
