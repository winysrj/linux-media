Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:37750 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438AbZANXlq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2009 18:41:46 -0500
Received: by yx-out-2324.google.com with SMTP id 8so351966yxm.1
        for <linux-media@vger.kernel.org>; Wed, 14 Jan 2009 15:41:45 -0800 (PST)
Message-ID: <157f4a8c0901141541l47389800wbe64299ac633b745@mail.gmail.com>
Date: Wed, 14 Jan 2009 23:41:45 +0000
From: "Chris Silva" <2manybills@gmail.com>
To: vdr@linuxtv.org
Subject: Can't compile VDR
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

I'm having problems compiling VDR 1.7.0 and 1.7.3.

This is the error:

/usr/local/src/s2-liplianin/linux/include/linux/videodev2.h:64:28:
error: linux/compiler.h: No such file or directory
In file included from
/usr/local/src/s2-liplianin/linux/include/linux/videodev.h:16,
                 from dvbdevice.c:13:
/usr/local/src/s2-liplianin/linux/include/linux/videodev2.h:560:
error: field '__user' has incomplete type
/usr/local/src/s2-liplianin/linux/include/linux/videodev2.h:560:
error: expected ';' before '*' token
/usr/local/src/s2-liplianin/linux/include/linux/videodev2.h:567:
error: expected ';' before '*' token
/usr/local/src/s2-liplianin/linux/include/linux/videodev2.h:569:
error: variable or field '__user' declared void
/usr/local/src/s2-liplianin/linux/include/linux/videodev2.h:569:
error: expected ';' before '*' token
In file included from dvbdevice.c:13:
/usr/local/src/s2-liplianin/linux/include/linux/videodev.h:148: error:
expected ';' before '*' token
In file included from dvbdevice.c:17:
/usr/local/src/s2-liplianin/linux/include/linux/dvb/video.h:162:
error: expected ';' before '*' token
/usr/local/src/s2-liplianin/linux/include/linux/dvb/video.h:195:
error: expected ';' before '*' token
dvbdevice.c: In member function 'virtual void
cDvbDevice::StillPicture(const uchar*, int)':
dvbdevice.c:1299: error: too many initializers for 'video_still_picture'
dvbdevice.c:1299: error: invalid conversion from 'char*' to 'int32_t'
dvbdevice.c:1305: error: too many initializers for 'video_still_picture'
dvbdevice.c:1305: error: invalid conversion from 'char*' to 'int32_t'
make: *** [dvbdevice.o] Error 1

Same error happens with s2-liplianin *and* v4l-dvb, with latest revisions.

Tried googling for it, but no solution...

Any thoughts?

Thanks
