Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:32270 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZHJHsQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 03:48:16 -0400
Received: by fg-out-1718.google.com with SMTP id e12so394005fga.17
        for <linux-media@vger.kernel.org>; Mon, 10 Aug 2009 00:48:16 -0700 (PDT)
Date: Mon, 10 Aug 2009 17:48:16 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATCH] Fix control AC-3 of the 6752HS
Message-ID: <20090810174816.61e7a34e@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/5W_zn7wp=NCg5ppOqUx+O0V"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/5W_zn7wp=NCg5ppOqUx+O0V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All

Fix error for AC-3 control of the 6752HS MPEG-2 coder.

diff -r e72c463783ab linux/drivers/media/video/saa7134/saa6752hs.c
--- a/linux/drivers/media/video/saa7134/saa6752hs.c	Sat Aug 08 03:28:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa6752hs.c	Mon Aug 10 12:41:30 2009 +1000
@@ -475,7 +475,7 @@
 		if (set && new != V4L2_MPEG_AUDIO_ENCODING_LAYER_2 &&
 		    (!has_ac3 || new != V4L2_MPEG_AUDIO_ENCODING_AC3))
 			return -ERANGE;
-		new = old;
+		params->au_encoding = new;
 		break;
 	case V4L2_CID_MPEG_AUDIO_L2_BITRATE:
 		old = params->au_l2_bitrate;

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.
--MP_/5W_zn7wp=NCg5ppOqUx+O0V
Content-Type: text/x-patch; name=6752hs_ac3_ctrl.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=6752hs_ac3_ctrl.patch

diff -r e72c463783ab linux/drivers/media/video/saa7134/saa6752hs.c
--- a/linux/drivers/media/video/saa7134/saa6752hs.c	Sat Aug 08 03:28:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa6752hs.c	Mon Aug 10 12:41:30 2009 +1000
@@ -475,7 +475,7 @@
 		if (set && new != V4L2_MPEG_AUDIO_ENCODING_LAYER_2 &&
 		    (!has_ac3 || new != V4L2_MPEG_AUDIO_ENCODING_AC3))
 			return -ERANGE;
-		new = old;
+		params->au_encoding = new;
 		break;
 	case V4L2_CID_MPEG_AUDIO_L2_BITRATE:
 		old = params->au_l2_bitrate;

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/5W_zn7wp=NCg5ppOqUx+O0V--
