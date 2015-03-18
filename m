Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f195.google.com ([209.85.212.195]:33860 "EHLO
	mail-wi0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbbCRGuY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 02:50:24 -0400
Received: by wivr20 with SMTP id r20so3119553wiv.1
        for <linux-media@vger.kernel.org>; Tue, 17 Mar 2015 23:50:23 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 18 Mar 2015 14:50:23 +0800
Message-ID: <CAFvf8-hLA3o6m+xAiKORJrO=bfr6ohJ1Zz1vh5vj4xDz2krzsA@mail.gmail.com>
Subject: two UVC simultaneous devices impossible?
From: dongdong zhang <dongguangit@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using kernel 3.2.0 on ti am3354 ,
Kernel 2.6.35.7 on samsung s5pv210,
Kernel 3.0.8 on samsung s5pv210,
Linux ubuntu 3.13.0-24-generic #46-Ubuntu SMP Thu Apr 10 19:08:14 UTC
2014 i686 i686 i686 GNU/Linux
Ubuntu 14.04 on x86

I find it impossible to
start motion with two UVC cameras:

uvcvideo: Failed to submit URB 0 (-28).
 Error starting stream.
 VIDIOC_STREAMON: No space left on  device
 ioctl(VIDIOCGMBUF) - Error device does not support memory map
When using one UVC camera with the same configuration it works fine.
 Is there a limitation in the UVC driver regarding simultaneous camera.


Lowering the resolution on both two cameras to the minimum (160x120)
open simultaneously doesn't
help. However with the same camera of two UVC at 1280x720 open
simultaneously  on windows xp software platform it works fine.
So it doesn't seem to be a USB bandwidth problem
