Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48707 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab0FVWgx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jun 2010 18:36:53 -0400
Received: by wyi11 with SMTP id 11so296734wyi.19
        for <linux-media@vger.kernel.org>; Tue, 22 Jun 2010 15:36:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C213608.2080709@redhat.com>
References: <AANLkTilP-jf0MaV82LuTz8DjoNJKQ3xGCHuFgds4b212@mail.gmail.com>
	<AANLkTinfZ8M_NlcQFwqRQFfLmMVKKIA3aC3o8v5u7YEF@mail.gmail.com>
	<4C213608.2080709@redhat.com>
Date: Wed, 23 Jun 2010 00:36:50 +0200
Message-ID: <AANLkTimCuoZ2d8BhLRYZwdqwfZ_Sl4kERy0Hp-Vb2sMi@mail.gmail.com>
Subject: Re: em28xx/xc3028 - kernel driver vs. Markus Rechberger's driver
From: Thorsten Hirsch <t.hirsch@web.de>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you, Devin and Mauro.

Unfortunately I don't have the eeprom data. I can only tell you what
happened to the usb id:

original: 0ccd:0043 TerraTec Electronic GmbH
now: eb1a:2871 eMPIA Technology, Inc.

With 2 lines added to em28xx-cards.c (see the diff at the end of this
mail) I was hoping to get back the old behavior. But you're right -
it's not sufficient. Guess I really need to recover the eeprom.

So... Devin, do you have the very same board?

Thorsten


diff --git a/drivers/media/video/em28xx/em28xx-cards.c
b/drivers/media/video/em28xx/em28xx-cards.c
index b0fb083..ef2ecd7 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -1720,6 +1720,8 @@ struct usb_device_id em28xx_id_table[] = {
                        .driver_info = EM2880_BOARD_TERRATEC_HYBRID_XS },
        { USB_DEVICE(0x0ccd, 0x0043),
                        .driver_info = EM2870_BOARD_TERRATEC_XS },
+       { USB_DEVICE(0xeb1a, 0x2871),
+                       .driver_info = EM2870_BOARD_TERRATEC_XS },
        { USB_DEVICE(0x0ccd, 0x0047),
                        .driver_info = EM2880_BOARD_TERRATEC_PRODIGY_XS },
        { USB_DEVICE(0x0ccd, 0x0084),
