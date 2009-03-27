Return-path: <linux-media-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:65278 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbZC0Pou (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 11:44:50 -0400
Received: by fk-out-0910.google.com with SMTP id 18so476601fkq.5
        for <linux-media@vger.kernel.org>; Fri, 27 Mar 2009 08:44:47 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 27 Mar 2009 18:44:46 +0300
Message-ID: <208cbae30903270844r55d0d48eidb5a9ad6f8309f53@mail.gmail.com>
Subject: trouble with v4l-dvb compilation, compat.h: redefinition of
	'usb_endpoint_type'
From: Alexey Klimov <klimov.linux@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I went to /usr/src/linux and run "git pull" (so i get 2.6.29-git1),
and make new kernel.
Then i updated v4l-dvb repository(hg pull, hg update) and configured
to compile, for example dsbr100 radio driver.
I get such message:

tux v4l-dvb # make
make -C /w/new/v4l-dvb/v4l
make[1]: Entering directory `/w/new/v4l-dvb/v4l'
./scripts/make_myconfig.pl
make[1]: Leaving directory `/w/new/v4l-dvb/v4l'
make[1]: Entering directory `/w/new/v4l-dvb/v4l'
perl scripts/make_config_compat.pl /lib/modules/2.6.29/source
./.myconfig ./config-compat.h
creating symbolic links...
Kernel build directory is /lib/modules/2.6.29/build
make -C /lib/modules/2.6.29/build SUBDIRS=/w/new/v4l-dvb/v4l  modules
make[2]: Entering directory `/usr/src/linux-2.6'
  CC [M]  /w/new/v4l-dvb/v4l/tuner-xc2028.o
  CC [M]  /w/new/v4l-dvb/v4l/tuner-simple.o
  CC [M]  /w/new/v4l-dvb/v4l/tuner-types.o
  CC [M]  /w/new/v4l-dvb/v4l/mt20xx.o
  CC [M]  /w/new/v4l-dvb/v4l/tda8290.o
  CC [M]  /w/new/v4l-dvb/v4l/tea5767.o
  CC [M]  /w/new/v4l-dvb/v4l/tea5761.o
  CC [M]  /w/new/v4l-dvb/v4l/tda9887.o
  CC [M]  /w/new/v4l-dvb/v4l/xc5000.o
  CC [M]  /w/new/v4l-dvb/v4l/mc44s803.o
  CC [M]  /w/new/v4l-dvb/v4l/v4l2-dev.o
  CC [M]  /w/new/v4l-dvb/v4l/v4l2-ioctl.o
  CC [M]  /w/new/v4l-dvb/v4l/v4l2-device.o
  CC [M]  /w/new/v4l-dvb/v4l/v4l2-subdev.o
  LD [M]  /w/new/v4l-dvb/v4l/videodev.o
  CC [M]  /w/new/v4l-dvb/v4l/v4l2-int-device.o
  CC [M]  /w/new/v4l-dvb/v4l/v4l2-common.o
/w/new/v4l-dvb/v4l/v4l2-common.c: In function 'v4l2_i2c_new_subdev':
/w/new/v4l-dvb/v4l/v4l2-common.c:834: warning: format not a string
literal and no format arguments
/w/new/v4l-dvb/v4l/v4l2-common.c: In function 'v4l2_i2c_new_probed_subdev':
/w/new/v4l-dvb/v4l/v4l2-common.c:902: warning: format not a string
literal and no format arguments
  CC [M]  /w/new/v4l-dvb/v4l/v4l1-compat.o
  CC [M]  /w/new/v4l-dvb/v4l/dsbr100.o
In file included from /w/new/v4l-dvb/v4l/dsbr100.c:94:
/w/new/v4l-dvb/v4l/compat.h:396: error: redefinition of 'usb_endpoint_type'
include/linux/usb/ch9.h:377: error: previous definition of
'usb_endpoint_type' was here
make[3]: *** [/w/new/v4l-dvb/v4l/dsbr100.o] Error 1
make[2]: *** [_module_/w/new/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/w/new/v4l-dvb/v4l'
make: *** [all] Error 2
tux v4l-dvb #

Well, i have such messages for radio-si470x and radio-mr800 too.
This drivers compile ok in kernel from kernel.org.
As i understand this is compat.h trouble ?

-- 
Best regards, Klimov Alexey
