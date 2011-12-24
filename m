Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37730 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab1LXV6P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 16:58:15 -0500
Received: by eekc4 with SMTP id c4so10299325eek.19
        for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 13:58:14 -0800 (PST)
Message-ID: <4EF64AF4.2040705@gmail.com>
Date: Sat, 24 Dec 2011 22:58:12 +0100
From: Dennis Sperlich <dsperlich@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: em28xx_isoc_dvb_max_packetsize for EM2884 (Terratec Cinergy HTC Stick)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a Terratec Cinergy HTC Stick an tried the new support for the 
DVB-C part. It works for SD material (at least for free receivable 
stations, I tried afair only QAM64), but did not for HD stations 
(QAM256). I have only access to unencrypted ARD HD, ZDF HD and arte HD 
(via KabelDeutschland). The HD material was just digital artefacts, as 
far as mplayer could decode it. When I did a dumpstream and looked at 
the resulting file size I got something about 1MB/s which seems a little 
too low, because SD was already about 870kB/s. After looking around I 
found a solution in increasing the isoc_dvb_max_packetsize from 752 to 
940 (multiple of 188). Then an HD stream was about 1.4MB/s and looked 
good. I'm not sure, whether this is the correct fix, but it works for me.

If you need more testing pleas tell.

Regards,
Dennis



index 804a4ab..c518d13 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -1157,7 +1157,7 @@ int em28xx_isoc_dvb_max_packetsize(struct em28xx *dev)
                  * FIXME: same as em2874. 564 was enough for 22 Mbit DVB-T
                  * but not enough for 44 Mbit DVB-C.
                  */
-               packet_size = 752;
+               packet_size = 940;
         }

         return packet_size;

