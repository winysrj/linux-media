Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7F3gEXR031230
	for <video4linux-list@redhat.com>; Fri, 14 Aug 2009 23:42:14 -0400
Received: from nschwmtas02p.mx.bigpond.com (nschwmtas02p.mx.bigpond.com
	[61.9.189.140])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7F3fwEl006598
	for <video4linux-list@redhat.com>; Fri, 14 Aug 2009 23:41:59 -0400
Received: from nschwotgx02p.mx.bigpond.com ([58.167.198.131])
	by nschwmtas02p.mx.bigpond.com with ESMTP id
	<20090815034156.BEVY1863.nschwmtas02p.mx.bigpond.com@nschwotgx02p.mx.bigpond.com>
	for <video4linux-list@redhat.com>; Sat, 15 Aug 2009 03:41:56 +0000
Received: from [192.168.0.1] (really [58.167.198.131])
	by nschwotgx02p.mx.bigpond.com with ESMTP
	id <20090815034155.CZBM13014.nschwotgx02p.mx.bigpond.com@[192.168.0.1]>
	for <video4linux-list@redhat.com>; Sat, 15 Aug 2009 03:41:55 +0000
Message-ID: <4A862E83.20801@bigpond.com>
Date: Sat, 15 Aug 2009 13:11:55 +0930
From: Tony Cook <tony-cook@bigpond.com>
MIME-Version: 1.0
To: Video4linux List <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [PATCH] em28xx-cards - added composite input capability to Hauppauge
 WinTV USB 2
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

The Hauppauge WinTV USB 2 device has a composite input capability via the s-video input
connector and a presumably proprietary adapter cable. In order to be able to select this
capability it needs to be added to the descriptor table at EM2820_BOARD_HAUPPAUGE_WINTV_USB_2
which is what this patch does.

I have tested the resulting 3 possible input modes with this patch with success.

--

# HG changeset patch
# User "Tony Cook <tony-cook@bigpond.com>"
# Date 1250296801 -34200
# Node ID 93a0e421297b029c61a4837e8f4860669722e8d8
# Parent  d2843f5f8fdef65f51ad83f868e5c7f0b2c2e4ce
Added composite input capability to EM2820_BOARD_HAUPPAUGE_WINTV_USB_2

From: Tony Cook <tony-cook@bigpond.com>

The Hauppauge WinTV USB 2 device has a composite input capability via
a provided adapter cable that plugs into the s-video input connector.

Priority: normal

Signed-off-by: "Tony Cook <tony-cook@bigpond.com>"

diff -r d2843f5f8fde -r 93a0e421297b linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c	Tue Aug 11 13:58:54 2009 -0300
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c	Sat Aug 15 10:10:01 2009 +0930
@@ -362,6 +362,11 @@
 			.vmux     = TVP5150_COMPOSITE0,
 			.amux     = MSP_INPUT_DEFAULT,
 		}, {
+			.type     = EM28XX_VMUX_COMPOSITE1,
+			.vmux     = TVP5150_COMPOSITE1,
+			.amux     = MSP_INPUT(MSP_IN_SCART1, MSP_IN_TUNER1,
+					MSP_DSP_IN_SCART, MSP_DSP_IN_SCART),
+		}, {
 			.type     = EM28XX_VMUX_SVIDEO,
 			.vmux     = TVP5150_SVIDEO,
 			.amux     = MSP_INPUT(MSP_IN_SCART1, MSP_IN_TUNER1,


-- 
Tony Cook
Lewiston 5501
Ph.  +61 (0)8 8524 3418
Mob. +61 (0)4 2885 2512

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
