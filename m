Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:35321 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbZFSAwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 20:52:01 -0400
Received: by gxk10 with SMTP id 10so2351708gxk.13
        for <linux-media@vger.kernel.org>; Thu, 18 Jun 2009 17:52:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ccdf9f470906180606w1046ee88nda933b4e6638357a@mail.gmail.com>
References: <ccdf9f470906171618r26518ce7pa97d747e301009ca@mail.gmail.com>
	 <1a297b360906180132l49aa7be4j8a1e238aa9bac65@mail.gmail.com>
	 <1a297b360906180148lefc2d8fp972647ad0df64320@mail.gmail.com>
	 <ccdf9f470906180606w1046ee88nda933b4e6638357a@mail.gmail.com>
Date: Thu, 18 Jun 2009 19:52:03 -0500
Message-ID: <ccdf9f470906181752u65c8d7f1nce46e3d46991b70c@mail.gmail.com>
Subject: Re: [Patch] New utility program atsc_epg added to dvb-apps utility
	suite.
From: Yufei Yuan <yfyuan@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Okay, this one serves as a test as well. It's a trivial one to fix the
broken dvb-apps building process with gcc4.4 on kernel 2.6.30, another
way to eliminate the packed bitfield warning is to split the field,
but that is unwanted.

previous build error:

make[2]: Entering directory `/home/alex/source/dvb-apps/util/scan'
perl section_generate.pl atsc_psip_section.pl
CC scan.o
In file included from scan.c:48:
atsc_psip_section.h:57: note: Offset of packed bit-field ‘reserved2’
has changed in GCC 4.4
CC atsc_psip_section.o
In file included from atsc_psip_section.c:2:
atsc_psip_section.h:57: note: Offset of packed bit-field ‘reserved2’
has changed in GCC 4.4
CC diseqc.o
In file included from diseqc.c:4:
/usr/include/time.h:104: error: conflicting types for ‘timer_t’
/usr/include/linux/types.h:22: note: previous declaration of ‘timer_t’ was here
make[2]: *** [diseqc.o] Error 1
make[2]: Leaving directory `/home/alex/source/dvb-apps/util/scan'
make[1]: *** [all] Error 2
make[1]: Leaving directory `/home/alex/source/dvb-apps/util'
make: *** [all] Error 2

--- dvb-apps/util/scan/Makefile.orig    2009-06-18 19:43:52.397924757 -0500
+++ dvb-apps/util/scan/Makefile 2009-06-18 19:44:34.764925070 -0500
@@ -14,7 +14,7 @@ inst_bin = $(binaries)

 removing = atsc_psip_section.c atsc_psip_section.h

-CPPFLAGS += -DDATADIR=\"$(prefix)/share\"
+CPPFLAGS += -Wno-packed-bitfield-compat -D__KERNEL_STRICT_NAMES
-DDATADIR=\"$(prefix)/share\"

 .PHONY: all




-- 
Even uttering "HI" or "HAO" is offensive, sometime, somewhere. Reader
discretion is advised.
