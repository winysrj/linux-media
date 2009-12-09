Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:36985 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbZLIRQB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 12:16:01 -0500
Received: by ewy1 with SMTP id 1so4525092ewy.28
        for <linux-media@vger.kernel.org>; Wed, 09 Dec 2009 09:16:06 -0800 (PST)
Message-ID: <4B1FDB55.6040707@gmail.com>
Date: Wed, 09 Dec 2009 18:16:05 +0100
From: Hector Oses <oseszgz@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Make libv4l
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When i try to:
make PREFIX=/usr/hector
or make PREFIX=/usr

# make install PREFIX=/usr/hector

make -C libv4lconvert V4L2_LIB_VERSION=0.6.3 install
make[1]: se ingresa al directorio `/home/hector/Comando para webcam con
libv4l/libv4l-0.6.3/libv4lconvert'
cc -Wp,-MMD,"libv4lconvert.d",-MQ,"libv4lconvert.o",-MP -c -I../include
-I../../../include -fvisibility=hidden -fPIC
-DLIBDIR=\"/usr/hector/lib\" -DLIBSUBDIR=\"libv4l\" -g -O1 -Wall
-Wno-unused -Wpointer-arith -Wstrict-prototypes -Wmissing-prototypes -o
libv4lconvert.o libv4lconvert.c
/bin/sh: cc: no se encontró la orden
make[1]: *** [libv4lconvert.o] Error 127
make[1]: se sale del directorio `/home/hector/Comando para webcam con
libv4l/libv4l-0.6.3/libv4lconvert'
make: *** [install] Error 2

And i cant compile the program. I need it cose my webcam is inverted. Thanks
