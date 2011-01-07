Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47254 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab1AGMET (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 07:04:19 -0500
Received: by mail-gx0-f174.google.com with SMTP id 9so4099097gxk.19
        for <linux-media@vger.kernel.org>; Fri, 07 Jan 2011 04:04:18 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 7 Jan 2011 23:04:18 +1100
Message-ID: <AANLkTinZPP337u7nBLDdv1+rTQ1g4z0hMDjJA8Bq0WdY@mail.gmail.com>
Subject: [patch] new_build.git - drop videodev.h
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

'make tar' fails for me (building against ubuntu 2.6.32) unless I
remove videodev.h from TARFILES.

Is this the correct thing to do here?

diff --git a/linux/Makefile b/linux/Makefile
index 695dcf2..8bbeee8 100644
--- a/linux/Makefile
+++ b/linux/Makefile
@@ -20,7 +20,6 @@ TARDIR += include/media/
 TARDIR += include/linux/dvb/
 TARFILES += include/linux/usb/video.h
 TARFILES += include/linux/i2c-id.h
-TARFILES += include/linux/videodev.h
 TARFILES += include/linux/ivtv.h
 TARFILES += include/linux/mmc/sdio_ids.h
 TARFILES += include/linux/ivtvfb.h

Cheers
Vince
