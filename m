Return-path: <mchehab@pedra>
Received: from mail.eperm.de ([89.247.134.16]:3841 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab1DDQeV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Apr 2011 12:34:21 -0400
Received: from myon.localnet
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S93> for <linux-media@vger.kernel.org> from <smueller@chronox.de>;
	Mon, 4 Apr 2011 18:26:11 +0200
From: Stephan Mueller <smueller@chronox.de>
To: linux-media@vger.kernel.org
Subject: [PATCH] cx231xx Hauppauge WinTV 950HD
Date: Mon, 4 Apr 2011 18:24:43 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104041824.43562.smueller@chronox.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

please apply the attached patch to make the 950HD USB card working.

Ciao
Stephan

---

Hauppauge WinTV 950HD

Signed-off-by: Stephan Mueller <smueller@chronox.de>

--- drivers/media/video/cx231xx/cx231xx-cards.c.orig    2011-04-04 18:17:55.245769669 +0200
+++ drivers/media/video/cx231xx/cx231xx-cards.c 2011-04-04 15:48:37.257376578 +0200
@@ -458,6 +458,8 @@
         .driver_info = CX231XX_BOARD_CNXT_RDU_250},
        {USB_DEVICE(0x2040, 0xb120),
         .driver_info = CX231XX_BOARD_HAUPPAUGE_EXETER},
+       {USB_DEVICE(0x2040, 0xb138),
+        .driver_info = CX231XX_BOARD_HAUPPAUGE_EXETER},
        {USB_DEVICE(0x2040, 0xb140),
         .driver_info = CX231XX_BOARD_HAUPPAUGE_EXETER},
        {USB_DEVICE(0x2040, 0xc200),
