Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp23.services.sfr.fr ([93.17.128.19]:28116 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbZJ1Rmz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2009 13:42:55 -0400
Message-ID: <4AE882B7.6020406@9online.fr>
Date: Wed, 28 Oct 2009 18:43:19 +0100
From: Pierre <pierre42d@9online.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: "pierre42d@9online.fr" <pierre42d@9online.fr>
Subject: Problem compiling libv4l 0.6.3
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# make
make -C libv4lconvert V4L2_LIB_VERSION=0.6.3 all
make[1]: Entering directory `/tmp/libv4l-0.6.3/libv4lconvert'
gcc -Wp,-MMD,"libv4lconvert.d",-MQ,"libv4lconvert.o",-MP -c 
-I../include -I../../../include -fvisibility=hidden -fPIC 
-DLIBDIR=\"/usr/local/lib\" -DLIBSUBDIR=\"libv4l\" -g -O1 -Wall 
-Wno-unused -Wpointer-arith -Wstrict-prototypes -Wmissing-prototypes -o 
libv4lconvert.o libv4lconvert.c
cc1: error: unrecognized command line option "-fvisibility=hidden"
make[1]: *** [libv4lconvert.o] Error 1
make[1]: Leaving directory `/tmp/libv4l-0.6.3/libv4lconvert'
make: *** [all] Error 2

