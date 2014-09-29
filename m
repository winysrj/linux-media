Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2314 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaI2Jsk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 05:48:40 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id s8T9mbZg012175
	for <linux-media@vger.kernel.org>; Mon, 29 Sep 2014 11:48:38 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.54.92.107] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id 3DA1A2A1CE5
	for <linux-media@vger.kernel.org>; Mon, 29 Sep 2014 11:48:35 +0200 (CEST)
Message-ID: <54292AE0.2020700@xs4all.nl>
Date: Mon, 29 Sep 2014 11:48:16 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH] em28xx: fix uninitialized variable warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this daily build warning:

In file included from build/media_build/v4l/em28xx-core.c:35:0:
build/media_build/v4l/em28xx-core.c: In function 'em28xx_audio_setup':
build/media_build/v4l/em28xx.h:798:2: warning: 'vid' may be used uninitialized in this function [-Wmaybe-uninitialized]
  printk(KERN_INFO "%s: "fmt,\
  ^
build/media_build/v4l/em28xx-core.c:507:6: note: 'vid' was declared here
  u32 vid;
      ^

As far as I can tell 'vid' can not really be used uninitialized here, but the code
is sufficiently complex that apparently gcc can't figure that out.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index b5e52fe..901cf2b 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -504,7 +504,7 @@ EXPORT_SYMBOL_GPL(em28xx_audio_analog_set);
 int em28xx_audio_setup(struct em28xx *dev)
 {
 	int vid1, vid2, feat, cfg;
-	u32 vid;
+	u32 vid = 0;
 	u8 i2s_samplerates;
 
 	if (dev->chip_id == CHIP_ID_EM2870 ||

