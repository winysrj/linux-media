Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38963 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab0JYHoK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Oct 2010 03:44:10 -0400
Received: by iwn10 with SMTP id 10so478480iwn.19
        for <linux-media@vger.kernel.org>; Mon, 25 Oct 2010 00:44:09 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 25 Oct 2010 00:44:09 -0700
Message-ID: <AANLkTi=Z88WFJ_9jbQW0ZU6JvDmpTB9ceGrNuVB50LKp@mail.gmail.com>
Subject: V4L hg doesn't compile for current stable kernel 2.6.36
From: VDR User <user.vdr@gmail.com>
To: "mailing list: linux-media" <linux-media@vger.kernel.org>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

hg hash abd3aac6644e tip

make[2]: Entering directory `/usr/src/linux-2.6.36'
  CC [M]  /tmp/v4l_dvb.20101025/v4l-dvb/v4l/dvbdev.o
  CC [M]  /tmp/v4l_dvb.20101025/v4l-dvb/v4l/dmxdev.o
/tmp/v4l_dvb.20101025/v4l-dvb/v4l/dmxdev.c:1142: error: unknown field
'ioctl' specified in initializer
/tmp/v4l_dvb.20101025/v4l-dvb/v4l/dmxdev.c:1142: warning:
initialization from incompatible pointer type
/tmp/v4l_dvb.20101025/v4l-dvb/v4l/dmxdev.c:1211: error: unknown field
'ioctl' specified in initializer
/tmp/v4l_dvb.20101025/v4l-dvb/v4l/dmxdev.c:1211: warning:
initialization from incompatible pointer type
make[3]: *** [/tmp/v4l_dvb.20101025/v4l-dvb/v4l/dmxdev.o] Error 1
make[2]: *** [_module_/tmp/v4l_dvb.20101025/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.36'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/tmp/v4l_dvb.20101025/v4l-dvb/v4l'
make: *** [all] Error 2
