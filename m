Return-path: <mchehab@pedra>
Received: from nm5.bullet.mail.ukl.yahoo.com ([217.146.182.226]:35058 "HELO
	nm5.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750883Ab1EWKM1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 06:12:27 -0400
Message-ID: <961434.18436.qm@web28309.mail.ukl.yahoo.com>
Date: Mon, 23 May 2011 11:12:25 +0100 (BST)
From: Giwrgos Panou <danzax69@yahoo.gr>
Subject: build.sh fails on kernel 2.6.38
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,
I tried to build the v4l-dvb on an ubuntu machine with kernel 2.6.38.8 generic
and I get make error:
=========================================
/home/z/media_build/v4l/kinect.c:38:19: error: ‘D_ERR’ undeclared here (not in a function)
/home/z/media_build/v4l/kinect.c:38:27: error: ‘D_PROBE’ undeclared here (not in a function)
/home/z/media_build/v4l/kinect.c:38:37: error: ‘D_CONF’ undeclared here (not in a function)
/home/z/media_build/v4l/kinect.c:38:46: error: ‘D_STREAM’ undeclared here (not in a function)
/home/z/media_build/v4l/kinect.c:38:57: error: ‘D_FRAM’ undeclared here (not in a function)
/home/z/media_build/v4l/kinect.c:38:66: error: ‘D_PACK’ undeclared here (not in a function)
/home/z/media_build/v4l/kinect.c:39:2: error: ‘D_USBI’ undeclared here (not in a function)
/home//media_build/v4l/kinect.c:39:11: error: ‘D_USBO’ undeclared here (not in a function)
/home//media_build/v4l/kinect.c:39:20: error: ‘D_V4L2′ undeclared here (not in a function)
make[3]: *** [/home//media_build/v4l/kinect.o] Error 1
make[2]: *** [_module_/home//media_build/v4l] Error 2
=================================================================
