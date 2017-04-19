Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:33744 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938360AbdDSXOj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 19:14:39 -0400
Received: by mail-qt0-f179.google.com with SMTP id m36so32543852qtb.0
        for <linux-media@vger.kernel.org>; Wed, 19 Apr 2017 16:14:34 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 08/12] Add USB quirk for HVR-950q to avoid intermittent device resets
Date: Wed, 19 Apr 2017 19:13:51 -0400
Message-Id: <1492643635-30823-9-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
References: <1492643635-30823-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The USB core and sysfs will attempt to enumerate certain parameters
which are unsupported by the au0828 - causing inconsistent behavior
and sometimes causing the chip to reset.  Avoid making these calls.

This problem manifested as intermittent cases where the au8522 would
be reset on analog video startup, in particular when starting up ALSA
audio streaming in parallel - the sysfs entries created by
snd-usb-audio on streaming startup would result in unsupported control
messages being sent during tuning which would put the chip into an
unknown state.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/usb/core/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 96b21b0..3116edf 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -223,6 +223,10 @@
 	/* Blackmagic Design UltraStudio SDI */
 	{ USB_DEVICE(0x1edb, 0xbd4f), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Hauppauge HVR-950q */
+	{ USB_DEVICE(0x2040, 0x7200), .driver_info =
+			USB_QUIRK_CONFIG_INTF_STRINGS },
+
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 
-- 
1.9.1
