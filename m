Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:48812 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbZISIIS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Sep 2009 04:08:18 -0400
Received: by bwz6 with SMTP id 6so1108598bwz.37
        for <linux-media@vger.kernel.org>; Sat, 19 Sep 2009 01:08:20 -0700 (PDT)
Message-ID: <4AB49171.9070300@googlemail.com>
Date: Sat, 19 Sep 2009 10:08:17 +0200
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: pete@sensoray.com, dougsland@redhat.com
Subject: Unable to compile the current tree
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

parts of changsets 13020:644c243de54d/13030:9af6fb98d272 are wrong:

      2.1 --- a/linux/drivers/staging/go7007/Makefile	Fri Sep 18 21:17:20 2009 -0300
      2.2 +++ b/linux/drivers/staging/go7007/Makefile	Fri Sep 18 21:21:55 2009 -0300
...
     2.37 +
     2.38 +# Ubuntu 8.04 has CONFIG_SND undefined, so include lum sound/config.h too
     2.39 +ifeq ($(CONFIG_SND),)
     2.40 +EXTRA_CFLAGS += -include sound/config.h
     2.41 +endif

If CONFIG_SND is undefined, sound/config.h doesn't exist. I'm not able to compile the 
current tree. I get the following error message:

make -C /usr/src/linux-2.6.30.7 O=/usr/src/linux-2.6.30.7-obj/x86_64/mp-suse-11/. modules
   CC [M]  /usr/src/v4l-dvb/v4l/tuner-xc2028.o
In file included from <command-line>:0:
./include/linux/autoconf.h:1743:1: error: sound/config.h: No such file or directory
make[5]: *** [/usr/src/v4l-dvb/v4l/tuner-xc2028.o] Error 1
make[4]: *** [_module_/usr/src/v4l-dvb/v4l] Error 2
make[3]: *** [sub-make] Error 2
make[2]: *** [all] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.30.7-obj/x86_64/mp-suse-11'
make[1]: *** [default] Fehler 2
make[1]: Leaving directory `/usr/src/v4l-dvb/v4l'
make: *** [all] Fehler 2

Regards,
Hartmut
