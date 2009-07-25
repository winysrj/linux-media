Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f192.google.com ([209.85.222.192]:56077 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbZGYGK4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 02:10:56 -0400
Received: by pzk30 with SMTP id 30so1354590pzk.33
        for <linux-media@vger.kernel.org>; Fri, 24 Jul 2009 23:10:56 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 25 Jul 2009 14:10:56 +0800
Message-ID: <3a665c760907242310p75a98f78tf3e1bbed6dce4414@mail.gmail.com>
Subject: Error message about cross-compile linux-dvb-app
From: loody <miloody@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear all:
I download the latest linux_dvb_apps from
http://packages.debian.org/source/stable/linuxtv-dvb-apps, but find
the compile error message below:

Desktop/dvb-apps-63dae165ffe8# make CROSS_COMPILE=mipsel-linux- V=1
make -C lib all
make[1]: Entering directory `/home/cc/Desktop/dvb-apps-63dae165ffe8/lib'
make -C libdvbapi all
make[2]: Entering directory
`/home/cc/Desktop/dvb-apps-63dae165ffe8/lib/libdvbapi'
mipsel-linux-gcc -c -I../../lib -g -Wall -W -Wshadow -Wpointer-arith
-Wstrict-prototypes -fPIC -MMD -o dvbaudio.o dvbaudio.c
In file included from dvbaudio.c:28:
/media/sda6/uclinux/toolchain/mips/temp/buildroot-2009.05/uclibc_0_9_30_build_mipsel/staging_dir/usr/include/linux/dvb/audio.h:79:
error: expected '=', ',', ';', 'asm' or '__attribute__' before
'audio_attributes_t'
make[2]: *** [dvbaudio.o] Error 1

I google the problem and I find someone has reported this bug before,
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=525580.
It seems fixed at 25th Apri 2009.
Did I get the wrong version or something I forget to set?
If someone knows where the problem come from or have any idea, please
let me know.
Appreciate your help,
miloody
