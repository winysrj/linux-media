Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:20401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab0JIPXM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Oct 2010 11:23:12 -0400
Message-ID: <4CB088DA.60508@redhat.com>
Date: Sat, 09 Oct 2010 12:23:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "linux-me >> Linux Media Mailing List" <linux-media@vger.kernel.org>
CC: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: V4L/DVB: cx231xx: Colibri carrier offset was wrong for PAL/M
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

cx231xx: Colibri carrier offset was wrong for PAL/M

The carrier offset check at cx231xx is incomplete. I got here one concrete case
where it is broken: if PAL/M is used (and this is the default for Pixelview SBTVD),
the routine will return zero, and the device will be programmed incorrectly,
producing a bad image. A workaround were to change to NTSC and back to PAL/M,
but the better is to just fix the code ;)

PS.: The checks there for other video standards are incomplete. the proper
solution is to fix the routine in a way that it will always return the proper
value for any valid V4L2_STD.

Cc: stable@kernel.org    
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-avcore.c b/drivers/media/video/cx231xx/cx231xx-avcore.c
index 0903773..d52955c 100644
--- a/drivers/media/video/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/video/cx231xx/cx231xx-avcore.c
@@ -1540,7 +1540,7 @@ u32 cx231xx_Get_Colibri_CarrierOffset(u32 mode, u32 standerd)
 
 	if (mode == TUNER_MODE_FM_RADIO) {
 		colibri_carrier_offset = 1100000;
-	} else if (standerd & (V4L2_STD_NTSC | V4L2_STD_NTSC_M_JP)) {
+	} else if (standerd & (V4L2_STD_MN | V4L2_STD_NTSC_M_JP)) {
 		colibri_carrier_offset = 4832000;  /*4.83MHz	*/
 	} else if (standerd & (V4L2_STD_PAL_B | V4L2_STD_PAL_G)) {
 		colibri_carrier_offset = 2700000;  /*2.70MHz       */
