Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout7.poczta.onet.pl ([213.180.147.167]:36575 "EHLO
	smtpout7.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbZKVLH7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Nov 2009 06:07:59 -0500
Received: from nat-237.ghnet.pl ([83.175.191.237]:55008 "EHLO mat.localnet"
	rhost-flags-OK-OK-OK-FAIL) by ps3.m5r2.onet with ESMTPSA
	id S134218505AbZKVLCaNurK- convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Nov 2009 12:02:30 +0100
From: Mateusz =?utf-8?q?Szyma=C5=84ski?= <dasiek@onet.eu>
To: linux-media@vger.kernel.org
Subject: libv4l-0.6.2-test problem with compiling on 32 bit
Date: Sun, 22 Nov 2009 12:02:36 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911221202.36703.dasiek@onet.eu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Good morning, I am using arch linux on 64 bit architecture, this version v4l 
helped me to rotate view from my webcam, but only in 64 bit apps, like  
mplayer, I have a problem with compiling it to 32 bits (for skype), I have 32 
bit libs, but they are in /opt/lib32/usr/lib directory and during the 
compiling i am receiving an error: 

[libv4l-0.6.2-test]$ make PREFIX=/usr CFLAGS=-m32 LDFLAGS=-m32 
LIBDIR=/opt/lib32/usr
...
/usr/bin/ld: skipping incompatible /usr/lib/gcc/x86_64-unknown-linux-
gnu/4.4.2/../../../librt.so when searching for -lrt
/usr/bin/ld: skipping incompatible /usr/lib/gcc/x86_64-unknown-linux-
gnu/4.4.2/../../../librt.a when searching for -lrt
/usr/bin/ld: skipping incompatible /usr/lib/librt.so when searching for -lrt
/usr/bin/ld: skipping incompatible /usr/lib/librt.a when searching for -lrt
/usr/bin/ld: cannot find -lrt
collect2: ld returned 1 exit status
make[1]: *** [libv4lconvert.so] Error 1

In /opt/lib32/usr/lib, there are files librt.so and librt.a, but ld doesn't 
seem to find them.

$ cat /etc/ld.so.conf
#
# /etc/ld.so.conf
#

# End of file
/usr/lib/libfakeroot
/opt/lib32/usr/lib
/opt/lib32/lib

I would be grateful if You could help me with this problem.

Best regards,
Mateusz Szymański
