Return-path: <linux-media-owner@vger.kernel.org>
Received: from crow.cadsoft.de ([217.86.189.86]:52839 "EHLO raven.cadsoft.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756349Ab0EBJvM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 May 2010 05:51:12 -0400
Message-ID: <4BDD471C.5020401@cadsoft.de>
Date: Sun, 02 May 2010 11:34:20 +0200
From: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] Add FE_CAN_TURBO_FEC (was: Add FE_CAN_PSK_8 to allow
 apps to identify PSK_8 capable DVB devices)
References: <4BC19294.4010200@tvdr.de>	 <s2n1a297b361004151321rb51b5225q79842aac2964371b@mail.gmail.com>	 <4BCB06E7.8050806@tvdr.de>	 <x2l1a297b361004180751y1e8c89f2pafbd257d8107e50c@mail.gmail.com>	 <4BCB50AF.9030008@tvdr.de> <j2g1a297b361004181245redcf8a69odd957f583404b158@mail.gmail.com>
In-Reply-To: <j2g1a297b361004181245redcf8a69odd957f583404b158@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060308080408010801060403"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060308080408010801060403
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Some (North American) providers use a non-standard mode called
"8psk turbo fec". Since there is no flag in the driver that
would allow an application to determine whether a particular
device can handle "turbo fec", the attached patch introduces
FE_CAN_TURBO_FEC.

Since there is no flag in the SI data that would indicate
that a transponder uses "turbo fec", VDR will assume that
all 8psk transponders on DVB-S use "turbo fec".

Signed-off-by: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
Tested-by: Derek Kelly <user.vdr@gmail.com>


--------------060308080408010801060403
Content-Type: text/x-patch;
 name="v4l-dvb-add-FE_CAN_TURBO_FEC.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="v4l-dvb-add-FE_CAN_TURBO_FEC.diff"

--- linux/include/linux/dvb/frontend.h.001	2010-04-05 16:13:08.000000000 +0200
+++ linux/include/linux/dvb/frontend.h	2010-04-25 14:24:50.000000000 +0200
@@ -62,6 +62,7 @@
 	FE_CAN_8VSB			= 0x200000,
 	FE_CAN_16VSB			= 0x400000,
 	FE_HAS_EXTENDED_CAPS		= 0x800000,   /* We need more bitspace for newer APIs, indicate this. */
+	FE_CAN_TURBO_FEC		= 0x8000000,  /* frontend supports "turbo fec modulation" */
 	FE_CAN_2G_MODULATION		= 0x10000000, /* frontend supports "2nd generation modulation" (DVB-S2) */
 	FE_NEEDS_BENDING		= 0x20000000, /* not supported anymore, don't use (frontend requires frequency bending) */
 	FE_CAN_RECOVER			= 0x40000000, /* frontend can recover from a cable unplug automatically */
--- linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c.001	2010-04-05 16:13:08.000000000 +0200
+++ linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c	2010-04-25 14:25:18.000000000 +0200
@@ -349,7 +349,7 @@
 			 * FE_CAN_QAM_16 is for compatibility
 			 * (Myth incorrectly detects Turbo-QPSK as plain QAM-16)
 			 */
-			FE_CAN_QPSK | FE_CAN_QAM_16
+			FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_TURBO_FEC
 	},
 
 	.release = gp8psk_fe_release,


--------------060308080408010801060403--
