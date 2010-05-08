Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpi3.ngi.it ([88.149.128.33]:50588 "EHLO smtpi3.ngi.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab0EHNkB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 May 2010 09:40:01 -0400
Received: from [127.0.0.1] (81-174-56-138.static.ngi.it [81.174.56.138])
	by smtpi3.ngi.it (Postfix) with ESMTP id DBC813182A3
	for <linux-media@vger.kernel.org>; Sat,  8 May 2010 15:31:47 +0200 (CEST)
Message-ID: <4BE567C3.6090603@robertoragusa.it>
Date: Sat, 08 May 2010 15:31:47 +0200
From: Roberto Ragusa <mail@robertoragusa.it>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: em28xx build failure (backport tree)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm getting build errors on this tree

  http://linuxtv.org/hg/v4l-dvb/archive/tip.tar.bz2

The make command fails with the output pasted below (I didn't
touch any config).
As a bizarre coincidence, the em28xx IR support (for Pinnacle PCTV USB2)
is _exactly_ what I'm interested to have working, as I had no
luck with my kernel (official Fedora 2.6.29 based).

Thank you for any help.

  CC [M]  /somewhere/v4l-dvb-4a8d6d981f07/v4l/em28xx-cards.o
/somewhere/v4l-dvb-4a8d6d981f07/v4l/em28xx-cards.c: In function 'em28xx_set_ir':
/somewhere/v4l-dvb-4a8d6d981f07/v4l/em28xx-cards.c:2410: error: 'ir_codes_em_terratec_table' undeclared (first use in this function)
/somewhere/v4l-dvb-4a8d6d981f07/v4l/em28xx-cards.c:2410: error: (Each undeclared identifier is reported only once
/somewhere/v4l-dvb-4a8d6d981f07/v4l/em28xx-cards.c:2410: error: for each function it appears in.)
/somewhere/v4l-dvb-4a8d6d981f07/v4l/em28xx-cards.c:2422: error: 'ir_codes_pinnacle_grey_table' undeclared (first use in this function)
/somewhere/v4l-dvb-4a8d6d981f07/v4l/em28xx-cards.c:2434: error: 'ir_codes_rc5_hauppauge_new_table' undeclared (first use in this function)
/somewhere/v4l-dvb-4a8d6d981f07/v4l/em28xx-cards.c:2445: error: 'ir_codes_winfast_usbii_deluxe_table' undeclared (first use in this function)
make[3]: *** [/somewhere/v4l-dvb-4a8d6d981f07/v4l/em28xx-cards.o] Error 1
make[2]: *** [_module_/somewhere/v4l-dvb-4a8d6d981f07/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.29.4-75.fc10.i686.PAE'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/somewhere/v4l-dvb-4a8d6d981f07/v4l'
make: *** [all] Error 2


-- 
   Roberto Ragusa    mail at robertoragusa.it
