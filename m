Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f173.google.com ([209.85.221.173]:56689 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbZJFIEr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Oct 2009 04:04:47 -0400
Received: by qyk3 with SMTP id 3so3239957qyk.4
        for <linux-media@vger.kernel.org>; Tue, 06 Oct 2009 01:04:10 -0700 (PDT)
Date: Tue, 6 Oct 2009 11:04:06 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] AVerTV MCE 116 Plus radio
Message-ID: <20091006080406.GA22207@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added FM radio support to Avermedia AVerTV MCE 116 Plus card

Signed-off-by: Aleksandr V. Piskunov <alexandr.v.piskunov@gmail.com>

diff --git a/linux/drivers/media/video/ivtv/ivtv-cards.c b/linux/drivers/media/video/ivtv/ivtv-cards.c
--- a/linux/drivers/media/video/ivtv/ivtv-cards.c
+++ b/linux/drivers/media/video/ivtv/ivtv-cards.c
@@ -965,6 +965,7 @@
                { IVTV_CARD_INPUT_AUD_TUNER,  CX25840_AUDIO5       },
                { IVTV_CARD_INPUT_LINE_IN1,   CX25840_AUDIO_SERIAL, 1 },
        },
+       .radio_input = { IVTV_CARD_INPUT_AUD_TUNER,  CX25840_AUDIO5 },
        /* enable line-in */
        .gpio_init = { .direction = 0xe000, .initial_value = 0x4000 },
        .xceive_pin = 10,
