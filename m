Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-m02.mx.aol.com ([64.12.143.76]:61919 "EHLO
	omr-m02.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab3KMPhn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Nov 2013 10:37:43 -0500
Message-ID: <52839505.6090700@netscape.net>
Date: Wed, 13 Nov 2013 12:04:37 -0300
From: =?UTF-8?B?QWxmcmVkbyBKZXPDunMgRGVsYWl0aQ==?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: [PATCH 2/2] X8502/8507 Radio Support [was: cx23885: Add basic analog
 radio support]
References: <CAEN_-SBR5qGJfUk6h+n04Q4zP-zofiLO+Jr6pOBJU2nqYBuDWQ@mail.gmail.com> <524F0F57.5020605@netscape.net> <20131031081255.65111ad6@samsung.com>
In-Reply-To: <20131031081255.65111ad6@samsung.com>
Content-Type: multipart/mixed;
 boundary="------------060603000207060803040801"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060603000207060803040801
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Mauro and all

El 31/10/13 07:12, Mauro Carvalho Chehab escribió:
> Hi Alfredo, My understanding is that the patch you've enclosed is 
> incomplete and depends on Miroslav's patch. As he have you his ack to 
> rework on it, could you please prepare a patch series addressing the 
> above comments for us to review? Than 



I tested this patch with the latest versions of git.


I found some issue, although it may be through a bad implementation of 
mine. Details of them:

1) No reports signal strength or stereo signal with KRadio. XC5000 
neither reported (modprobe xc5000 debug=1). Maybe a feature XC5000.
To listen in stereo, sometimes, you have to turn on the Digital TV then 
Analog TV and then radio.

2) To listen Analog TV I need changed to NTSC standard and then PAL-Nc 
(the norm in my country is PAL-Nc). If I leave the tune in NTSC no 
problem with sound. The patch (https://linuxtv.org/patch/9505/) corrects 
the latter, but not always.

3) If I see-Digital TV (ISDB-T), then so as to listen the radio I have 
first put the TV-Analog, because I hear very low and a strong white noise.
The latter is likely to be corrected by resetting the tuner, but I have 
not been able to do.

Thank you,

Alfredo


Signed-off-by: Alfredo J. Delaiti<alfredodelaiti@netscape.net>


--------------060603000207060803040801
Content-Type: text/x-patch;
 name="Radio_X8507.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Radio_X8507.patch"

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 79f20c8..f97002a 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -574,6 +574,8 @@ struct cx23885_board cx23885_boards[] = {
 		.name		= "Mygica X8502/X8507 ISDB-T",
 		.tuner_type = TUNER_XC5000,
 		.tuner_addr = 0x61,
+		.radio_type	= TUNER_XC5000,
+		.radio_addr	= 0x61,
 		.tuner_bus	= 1,
 		.porta		= CX23885_ANALOG_VIDEO,
 		.portb		= CX23885_MPEG_DVB,
@@ -603,6 +605,10 @@ struct cx23885_board cx23885_boards[] = {
 				.amux   = CX25840_AUDIO7,
 			},
 		},
+		.radio = {
+				.type= CX23885_RADIO,
+				.amux= CX25840_AUDIO8,
+			},
 	},
 	[CX23885_BOARD_TERRATEC_CINERGY_T_PCIE_DUAL] = {
 		.name		= "TerraTec Cinergy T PCIe Dual",
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 0549205..b09d97f 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -505,6 +505,7 @@ static struct mb86a20s_config mygica_x8507_mb86a20s_config = {
 static struct xc5000_config mygica_x8507_xc5000_config = {
 	.i2c_address = 0x61,
 	.if_khz = 4000,
+	.radio_input = XC5000_RADIO_FM1,
 };
 
 static struct stv090x_config prof_8000_stv090x_config = {

--------------060603000207060803040801--
