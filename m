Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36971 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbbIZHGT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Sep 2015 03:06:19 -0400
Received: by igbni9 with SMTP id ni9so22760047igb.0
        for <linux-media@vger.kernel.org>; Sat, 26 Sep 2015 00:06:18 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 26 Sep 2015 10:06:18 +0300
Message-ID: <CAM_ZknWDkGPSAQmH0cKo1DyDMepF=pOUBBJ+kvRDz5dS6Bq-+Q@mail.gmail.com>
Subject: Help to debug h264 headers (or video) generation in kernel driver
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: x264-devel@videolan.org,
	FFmpeg development discussions and patches
	<ffmpeg-devel@ffmpeg.org>,
	Linux Media <linux-media@vger.kernel.org>,
	"kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm working on Linux kernel driver for multimedia grabber and H264
encoder based on Techwell/Intersil 5864 chip. Of course it will be
open and pushed into upstream kernel.

The device produces H264 encoded data, but it lacks any headers. The
reference driver generates headers and glues frames together in code,
but I failed both reverse-engineering and porting that code. The code
of reference driver is overwhelmingly complicated, and I have no
knowledge how H264 bitstream is formed, that's why my attempts failed.

I have reached a limited success with both setting up the hardware
encoder and forming the headers. You can see the samples of produced
video here:
http://lizard.bluecherry.net/~autkin/tw5864_tiled_video/ntsc_cif.h264
http://lizard.bluecherry.net/~autkin/tw5864_tiled_video/ntsc_d1.h264
http://lizard.bluecherry.net/~autkin/tw5864_tiled_video/pal_cif.h264
http://lizard.bluecherry.net/~autkin/tw5864_tiled_video/pal_d1.h264

Currently it produces "tiled" picture. The width of tiles on these
sample videos is 256 pixels.
I am not sure whether the issue is in hardware settings, or incorrect
headers which lead to partial failure of decoding.
Here is ffplay log for playing back such video:
https://gist.github.com/krieger-od/5269c762a36bcb52b93a . Obviously
some enhancements to headers generation are needed.

Playing with hardware mirroring flags proves that the raw frame gets
caught fully and correctly. But for h264 encoding, it gets garbled.
Also please notice that frame order is incorrect, the motion goes back
and forth.

You can see our latest code for this development at
https://github.com/bluecherrydvr/linux/tree/tw5864/drivers/staging/media/tw5864
(branch tw5864, subdirectory drivers/staging/media/tw5864).

Any input is extremely appreciated.

-- 
Bluecherry developer.
