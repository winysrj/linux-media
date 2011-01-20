Return-path: <mchehab@pedra>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42874 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab1ATHDf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 02:03:35 -0500
Received: by gwj20 with SMTP id 20so68119gwj.19
        for <linux-media@vger.kernel.org>; Wed, 19 Jan 2011 23:03:35 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 20 Jan 2011 18:03:34 +1100
Message-ID: <AANLkTi=78fcRbeyx2cSyHKFuxaAqBCC6owQ70QO-G=Xx@mail.gmail.com>
Subject: media_build: build fails against (ubuntu) 2.6.32 on pvrusb2-debugifc.c
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I am building against linux-2.6.32-26-generic from ubuntu, with just
the linux-headers package.

I know there is a big fat warning about doing this but I thought I
should report the issue
because mostly building like this does work.

The build was against a clean checkout of the media_build tree, using build.sh.

The build fails with:
  CC [M]  /home/vjm/git/clones/linuxtv.org/media_build/v4l/pvrusb2-sysfs.o
  CC [M]  /home/vjm/git/clones/linuxtv.org/media_build/v4l/pvrusb2-debugifc.o
/home/vjm/git/clones/linuxtv.org/media_build/v4l/pvrusb2-debugifc.c:
In function 'debugifc_parse_unsigned_number':
/home/vjm/git/clones/linuxtv.org/media_build/v4l/pvrusb2-debugifc.c:108:
error: implicit declaration of function 'hex_to_bin'
make[3]: *** [/home/vjm/git/clones/linuxtv.org/media_build/v4l/pvrusb2-debugifc.o]
Error 1

I was able to get the build to complete by hand-editing v4l/config-compat.h
@@ -11,6 +11,8 @@

 #include <linux/mmdebug.h>

+#define NEED_HEX_TO_BIN 1
+
 #undef CONFIG_VIDEO_SH_VOU
 #undef CONFIG_VIDEO_SH_VOU_MODULE
 #undef CONFIG_MX1_VIDEO

and rerunning make.

After inspecting the relevant commit[1] I'm a bit baffled as to why
this occurred.
It seems as though the header file is not being found correctly,
although it does exist,
at /usr/src/linux-headers-2.6.32-26-generic/include/linux/kernel.h.

 % grep -i hex_to_bin
/usr/src/linux-headers-2.6.32-26-generic/include/linux/kernel.h
 %

I'll poke a bit more into this and hopefully come up with a fix.
Cheers
Vince

[1] http://git.linuxtv.org/media_build.git?a=commit;h=2f3b6a700ee9b687b59a1eda8f8336b9aa4c47a6
