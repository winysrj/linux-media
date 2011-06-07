Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:37230 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071Ab1FGQVM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 12:21:12 -0400
Received: from [94.248.227.150] (helo=linux-mrjj.localnet)
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QTz1b-0006mD-8V
	for linux-media@vger.kernel.org; Tue, 07 Jun 2011 18:21:10 +0200
From: Istvan Varga <istvan_v@mailbox.hu>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/4] cx88: replaced duplicated code with function call
MIME-Version: 1.0
Date: Tue, 7 Jun 2011 18:21:02 +0200
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106071821.02820.istvan_v@mailbox.hu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following patch replaces code to reset the XC3028 tuner with a call
to the tuner reset callback.

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>

diff -uNr xc4000_orig/drivers/media/video/cx88/cx88-cards.c xc4000/drivers/media/video/cx88/cx88-cards.c
--- xc4000_orig/drivers/media/video/cx88/cx88-cards.c	2011-06-07 18:02:28.000000000 +0200
+++ xc4000/drivers/media/video/cx88/cx88-cards.c	2011-06-07 18:09:01.000000000 +0200
@@ -3245,13 +3245,7 @@
 
 	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
 	case CX88_BOARD_WINFAST_DTV1800H:
-		/* GPIO 12 (xc3028 tuner reset) */
-		cx_set(MO_GP1_IO, 0x1010);
-		mdelay(50);
-		cx_clear(MO_GP1_IO, 0x10);
-		mdelay(50);
-		cx_set(MO_GP1_IO, 0x10);
-		mdelay(50);
+		cx88_xc3028_winfast1800h_callback(core, XC2028_TUNER_RESET, 0);
 		break;
 
 	case CX88_BOARD_WINFAST_DTV1800H_XC4000:
