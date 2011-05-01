Return-path: <mchehab@pedra>
Received: from mail.wdtv.com ([66.118.69.84]:39037 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755712Ab1EATCg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 May 2011 15:02:36 -0400
To: linux-media@vger.kernel.org
Subject: Cannot build dvb-atsc-tools-1.0.7
From: Gene Heskett <gene.heskett@gmail.com>
Date: Sun, 1 May 2011 15:02:34 -0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201105011502.34227.gene.heskett@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Greetings all;

Currently running 2.6.38.4 here.

Along with kernel 2.6.38.4, kaffiene no longer does tv from my pcHDTV-3000 
card.  And acts like the device is not there.  IIRC it did work with 
2.6.38.2 but won't swear that on the good book, pclos jumped from 
2.6.37.something to 2.6.38.2

So to troubleshoot, I go pull dvb-atsc-tools-1.0.7 from my tarball archive.
Cd'ing to the dir, the README says to type make, which promptly exits, 
can't find linux/videodev.h, so I cp that from the kernel 2.6.33.7 tree to 
/usr/include/linux/.  According to locate, that apparently was the only 
copy of that file on a machine with quite a few newer kernel src trees 
resident.

Wrong!  Now it exits the make:
gcc -Wall -D_FILE_OFFSET_BITS=64     chopatscfile.c   -o chopatscfile
In file included from chopatscfile.c:41:0:
/usr/include/linux/videodev.h:166:27: error: expected ‘:’, ‘,’, ‘;’, ‘}’ or 
‘__attribute__’ before ‘*’ token
make: *** [chopatscfile] Error 1

Can this be fixed?  If so, how?

Thanks for any hints.

PS:  I seem to have found it myself, by editing all the .c files in dvb-
atsc-tools-1.0.7 to look for linux/videodev2.h instead of 
/linux/videodev.h, that was the only change, in all .c files.

The tool chain then built, and installed, and at least 'dvtsignal 5' 
reports a good signal, and all of a sudden kaffiene is working again.

So file that away for good measure.  Its a regression fix.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
New England Life, of course.  Why do you ask?

