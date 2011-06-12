Return-path: <mchehab@pedra>
Received: from gelbbaer.kn-bremen.de ([78.46.108.116]:45135 "EHLO
	smtp.kn-bremen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab1FLU0Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 16:26:25 -0400
From: Juergen Lock <nox@jelal.kn-bremen.de>
Date: Sun, 12 Jun 2011 22:25:12 +0200
To: linux-media@vger.kernel.org
Cc: hselasky@c2i.net
Subject: [PATCH] [media] af9015: setup rc keytable for LC-Power LC-USB-DVBT
Message-ID: <20110612202512.GA63911@triton8.kn-bremen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

That's this tuner:

	http://www.lc-power.de/index.php?id=146&L=1

The credit card sized remote more or less works if I set remote=4,
so I added the hash to get it autodetected.  (`more or less' there
meaning sometimes buttons are `stuck on repeat', i.e. ir-keytable -t
keeps repeating the same scancode until i press another button.)

Signed-off-by: Juergen Lock <nox@jelal.kn-bremen.de>

--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -735,6 +735,7 @@ static const struct af9015_rc_setup af90
 	{ 0xb8feb708, RC_MAP_MSI_DIGIVOX_II },
 	{ 0xa3703d00, RC_MAP_ALINK_DTU_M },
 	{ 0x9b7dc64e, RC_MAP_TOTAL_MEDIA_IN_HAND }, /* MYGICTV U718 */
+	{ 0x5d49e3db, RC_MAP_DIGITTRADE }, /* LC-Power LC-USB-DVBT */
 	{ }
 };
 
