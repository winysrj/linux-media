Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:51317 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab0A2UbE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 15:31:04 -0500
Message-ID: <4B63457D.5010702@freemail.hu>
Date: Fri, 29 Jan 2010 21:30:53 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Janne Grunau <j@jannau.net>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] hdpvr-core: make module parameters local
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The default_video_input and default_audio_input module parameters are
only used inside the hdpvr-core.c file so make them static.

This will remove the following sparse warnings (see "make C=1"):
 * warning: symbol 'default_video_input' was not declared. Should it be static?
 * warning: symbol 'default_audio_input' was not declared. Should it be static?

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 8b9a62386b64 linux/drivers/media/video/hdpvr/hdpvr-core.c
--- a/linux/drivers/media/video/hdpvr/hdpvr-core.c	Fri Jan 29 01:23:57 2010 -0200
+++ b/linux/drivers/media/video/hdpvr/hdpvr-core.c	Fri Jan 29 21:25:45 2010 +0100
@@ -39,12 +39,12 @@
 module_param(hdpvr_debug, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(hdpvr_debug, "enable debugging output");

-uint default_video_input = HDPVR_VIDEO_INPUTS;
+static uint default_video_input = HDPVR_VIDEO_INPUTS;
 module_param(default_video_input, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(default_video_input, "default video input: 0=Component / "
 		 "1=S-Video / 2=Composite");

-uint default_audio_input = HDPVR_AUDIO_INPUTS;
+static uint default_audio_input = HDPVR_AUDIO_INPUTS;
 module_param(default_audio_input, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(default_audio_input, "default audio input: 0=RCA back / "
 		 "1=RCA front / 2=S/PDIF");


