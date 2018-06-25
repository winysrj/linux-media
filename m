Return-path: <linux-media-owner@vger.kernel.org>
Received: from dragon.icm.edu.pl ([213.135.60.13]:37993 "EHLO
        dragon.icm.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935001AbeFYUPU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 16:15:20 -0400
Received: from [95.160.15.100] (helo=pc-b29)
        by dragon.icm.edu.pl with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <rrp@dragon.icm.edu.pl>)
        id 1fXXmU-0005o9-3s
        for linux-media@vger.kernel.org; Mon, 25 Jun 2018 20:08:10 +0000
Date: Mon, 25 Jun 2018 20:08:09 +0000
From: Robert Paciorek <robert@opcode.eu.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] [libdvbv5] basic support for videoX and audioX devices
Message-ID: <20180625200809.7fb10f6f@pc-b29>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Su/sBbJDNAEgrzPLL1X5ZSD"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/Su/sBbJDNAEgrzPLL1X5ZSD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

currently libdvbv5 generate warning about ignoring dvb output devices
(videoX and audioX):
	WARNING  Ignoring device /dev/dvb/adapter0/audio0
	WARNING  Ignoring device /dev/dvb/adapter0/video0
and does not allow search and open those devices.

DVB output device are used (for example) in Linux based STB devices and
IMHO would be nice to be able to handle them with libdvbv5.

Attached patch enabled elementary support for those devices - remove
warning and allow search it by dvb_dev_seek_by_adapter(), open and
close with dvb_dev_* functions.

Best Regards,
Robert Paciorek

--MP_/Su/sBbJDNAEgrzPLL1X5ZSD
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=video_audio_dev.patch

diff --git a/lib/include/libdvbv5/dvb-dev.h b/lib/include/libdvbv5/dvb-dev.h
index 6dbd2ae..2eeae51 100644
--- a/lib/include/libdvbv5/dvb-dev.h
+++ b/lib/include/libdvbv5/dvb-dev.h
@@ -62,6 +62,8 @@ enum dvb_dev_type {
 	DVB_DEVICE_NET,
 	DVB_DEVICE_CA,
 	DVB_DEVICE_CA_SEC,
+	DVB_DEVICE_VIDEO,
+	DVB_DEVICE_AUDIO,
 };
 
 /**
diff --git a/lib/libdvbv5/dvb-dev.c b/lib/libdvbv5/dvb-dev.c
index 9a0952b..c379f40 100644
--- a/lib/libdvbv5/dvb-dev.c
+++ b/lib/libdvbv5/dvb-dev.c
@@ -37,7 +37,7 @@
 #endif
 
 const char * const dev_type_names[] = {
-        "frontend", "demux", "dvr", "net", "ca", "sec"
+        "frontend", "demux", "dvr", "net", "ca", "sec", "video", "audio"
 };
 
 const unsigned int

--MP_/Su/sBbJDNAEgrzPLL1X5ZSD--
