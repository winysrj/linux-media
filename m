Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:54884 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbbFSKUn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2015 06:20:43 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] MEDIA PCI Kconfig ANALOG_TV -> CAMERA
Date: Fri, 19 Jun 2015 12:20:40 +0200
Message-ID: <m3k2v0rocn.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I noticed certain cards are currently under MEDIA_ANALOG_TV_SUPPORT
but it seems they are frame grabbers (with CVBS, Svideo etc. inputs)
rather than TV receivers (with analog TV tuners).

MEDIA_CAMERA_SUPPORT maybe isn't the best name (only "meye" driver seems
to drive a real camera in a laptop) but it at least doesn't select the
TUNERs.

Perhaps the following patch would make sense.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -11,16 +11,16 @@ if MEDIA_PCI_SUPPORT
 if MEDIA_CAMERA_SUPPORT
 	comment "Media capture support"
 source "drivers/media/pci/meye/Kconfig"
+source "drivers/media/pci/solo6x10/Kconfig"
 source "drivers/media/pci/sta2x11/Kconfig"
+source "drivers/media/pci/tw68/Kconfig"
+source "drivers/media/pci/zoran/Kconfig"
 endif
 
 if MEDIA_ANALOG_TV_SUPPORT
 	comment "Media capture/analog TV support"
 source "drivers/media/pci/ivtv/Kconfig"
-source "drivers/media/pci/zoran/Kconfig"
 source "drivers/media/pci/saa7146/Kconfig"
-source "drivers/media/pci/solo6x10/Kconfig"
-source "drivers/media/pci/tw68/Kconfig"
 endif
 
 if MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
