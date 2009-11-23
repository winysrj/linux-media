Return-path: <linux-media-owner@vger.kernel.org>
Received: from n64.bullet.mail.sp1.yahoo.com ([98.136.44.189]:43306 "HELO
	n64.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751781AbZKWSBA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 13:01:00 -0500
Message-ID: <754577.88092.qm@web110614.mail.gq1.yahoo.com>
Date: Mon, 23 Nov 2009 10:01:06 -0800 (PST)
From: Dominic Fernandes <dalf198@yahoo.com>
Subject: Compile error saa7134 - compro videomate S350
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I need help to compile v4l-dvb drivers for saa7134 modules. 
I'm new to v4l-dvb not sure how to get past the errors concerning
undefined declarations found in saa7134-inputs.c file for the videomate
S350 board, saying ir_codes, mask_keycodes, mask_keydown as undeclared:

snip:-

make[2]: Entering directory `/usr/src/linux-headers-2.6.31-14-generic'
  CC [M]  /home/tvbox/v4l-dvb/v4l/saa7134-input.o
/home/tvbox/v4l-dvb/v4l/saa7134-input.c: In function 'build_key':
/home/tvbox/v4l-dvb/v4l/saa7134-input.c:90: error: 'ir_codes' undeclared (first use in this function)
/home/tvbox/v4l-dvb/v4l/saa7134-input.c:90: error: (Each undeclared identifier is reported only once
/home/tvbox/v4l-dvb/v4l/saa7134-input.c:90: error: for each function it appears in.)
/home/tvbox/v4l-dvb/v4l/saa7134-input.c:90: error: 'ir_codes_videomate_s350' undeclared (first use in this function)
/home/tvbox/v4l-dvb/v4l/saa7134-input.c:91: error: 'mask_keycode' undeclared (first use in this function)
/home/tvbox/v4l-dvb/v4l/saa7134-input.c:92: error: 'mask_keydown' undeclared (first use in this function)
make[3]: *** [/home/tvbox/v4l-dvb/v4l/saa7134-input.o] Error 1
make[2]: *** [_module_/home/tvbox/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.31-14-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/tvbox/v4l-dvb/v4l'
make: *** [all] Error 2

background:
Justbought last week a new compro videomate s350 (dvb-s) card after seeing
some positive feedback on forumes saying it is working.  But the card I
got has a newer chip set incorporating a saa7135 device and after some
searching found someone else also had the same issue back in June but
managed to fix it with a few changes.  I trying to re-produce the
actions (see link below) and re-build the drivers but I'm stuck at the
compile stage (make all). 

http://osdir.com/ml/linux-media/2009-06/msg01256.html

Can someone advise me on how get past the make error?

Thanks,
Dominic



      

