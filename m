Return-Path: <SRS0=Cdzf=R3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD6BC43381
	for <linux-media@archiver.kernel.org>; Sun, 24 Mar 2019 09:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17399222BE
	for <linux-media@archiver.kernel.org>; Sun, 24 Mar 2019 09:53:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=horus.com header.i=@horus.com header.b="VW3ROwrQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfCXJw7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Mar 2019 05:52:59 -0400
Received: from mail.horus.com ([78.46.148.228]:35543 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727221AbfCXJw7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Mar 2019 05:52:59 -0400
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Mar 2019 05:52:57 EDT
Received: from [192.168.1.20] (62-116-61-196.adsl.highway.telekom.at [62.116.61.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "E-Mail Matthias Reichl", Issuer "HiassofT CA 2014" (verified OK))
        by mail.horus.com (Postfix) with ESMTPSA id 16B36641D2;
        Sun, 24 Mar 2019 10:43:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=horus.com;
        s=20180324; t=1553420632;
        bh=NC0jAgRcu43/1DJcRaYJ/0ynx0WKJlSvrctvAbwi0WI=;
        h=From:To:Cc:Subject:Date:From;
        b=VW3ROwrQKb16M74PX66SxVdpGke7GFT42wdQlecfTaPlhXcG9XEo9lfHpDuy+yKke
         XejS5kragJryyoXxhCprwYTdmlBpvSx2XpQMFCGzf5krOYL5ttolMRgnJe9Fs0CF8g
         iMjL81zfRS8Gwm5ccQ6vkjMIJn+veQ3ohnJpVFLg=
Received: by camel2.lan (Postfix, from userid 1000)
        id 6B0A81C72C8; Sun, 24 Mar 2019 10:43:51 +0100 (CET)
From:   Matthias Reichl <hias@horus.com>
To:     Benjamin Valentin <benpicco@googlemail.com>,
        Sean Young <sean@mess.org>
Cc:     linux-media@vger.kernel.org
Subject: [PATCH] media: rc: xbox_remote: add protocol and set timeout
Date:   Sun, 24 Mar 2019 10:43:51 +0100
Message-Id: <20190324094351.5584-1-hias@horus.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The timestamps in ir-keytable -t output showed that the Xbox DVD
IR dongle decodes scancodes every 64ms. The last scancode of a
longer button press is decodes 64ms after the last-but-one which
indicates the decoder doesn't use a timeout but decodes on the last
edge of the signal.

267.042629: lirc protocol(unknown): scancode = 0xace
267.042665: event type EV_MSC(0x04): scancode = 0xace
267.042665: event type EV_KEY(0x01) key_down: KEY_1(0x0002)
267.042665: event type EV_SYN(0x00).
267.106625: lirc protocol(unknown): scancode = 0xace
267.106643: event type EV_MSC(0x04): scancode = 0xace
267.106643: event type EV_SYN(0x00).
267.170623: lirc protocol(unknown): scancode = 0xace
267.170638: event type EV_MSC(0x04): scancode = 0xace
267.170638: event type EV_SYN(0x00).
267.234621: lirc protocol(unknown): scancode = 0xace
267.234636: event type EV_MSC(0x04): scancode = 0xace
267.234636: event type EV_SYN(0x00).
267.298623: lirc protocol(unknown): scancode = 0xace
267.298638: event type EV_MSC(0x04): scancode = 0xace
267.298638: event type EV_SYN(0x00).
267.543345: event type EV_KEY(0x01) key_down: KEY_1(0x0002)
267.543345: event type EV_SYN(0x00).
267.570015: event type EV_KEY(0x01) key_up: KEY_1(0x0002)
267.570015: event type EV_SYN(0x00).

Add a protocol with the repeat value and set the timeout in the
driver to 10ms (to have a bit of headroom for delays) so the Xbox
DVD remote performs more responsive.

Signed-off-by: Matthias Reichl <hias@horus.com>
---
Bug report about sluggish response of the Xbox DVD remote and test
results can be found in this thread:
https://forum.libreelec.tv/thread/14861-the-adventures-of-libreelec-and-a-really-old-ir-remote/

We tried to capture some more protocol details with an mceusb receiver
but this didn't work well - could be that the Xbox DVD remote uses a
different carrier frequency and/or the IR receiver can't cope well with
it's burst lengths.


 Documentation/media/lirc.h.rst.exceptions | 1 +
 drivers/media/rc/keymaps/rc-xbox-dvd.c    | 2 +-
 drivers/media/rc/rc-main.c                | 2 ++
 drivers/media/rc/xbox_remote.c            | 4 +++-
 include/media/rc-map.h                    | 4 +++-
 include/uapi/linux/lirc.h                 | 2 ++
 6 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/lirc.h.rst.exceptions b/Documentation/media/lirc.h.rst.exceptions
index 7a8b8ff4f076..ac768d769113 100644
--- a/Documentation/media/lirc.h.rst.exceptions
+++ b/Documentation/media/lirc.h.rst.exceptions
@@ -63,6 +63,7 @@ ignore symbol RC_PROTO_IMON
 ignore symbol RC_PROTO_RCMM12
 ignore symbol RC_PROTO_RCMM24
 ignore symbol RC_PROTO_RCMM32
+ignore symbol RC_PROTO_XBOX_DVD
 
 # Undocumented macros
 
diff --git a/drivers/media/rc/keymaps/rc-xbox-dvd.c b/drivers/media/rc/keymaps/rc-xbox-dvd.c
index af387244636b..42815ab57bff 100644
--- a/drivers/media/rc/keymaps/rc-xbox-dvd.c
+++ b/drivers/media/rc/keymaps/rc-xbox-dvd.c
@@ -42,7 +42,7 @@ static struct rc_map_list xbox_dvd_map = {
 	.map = {
 		.scan     = xbox_dvd,
 		.size     = ARRAY_SIZE(xbox_dvd),
-		.rc_proto = RC_PROTO_UNKNOWN,
+		.rc_proto = RC_PROTO_XBOX_DVD,
 		.name     = RC_MAP_XBOX_DVD,
 	}
 };
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index e8fa28e20192..be5fd129d728 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -76,6 +76,7 @@ static const struct {
 		.scancode_bits = 0x00ffffff, .repeat_period = 114 },
 	[RC_PROTO_RCMM32] = { .name = "rc-mm-32",
 		.scancode_bits = 0xffffffff, .repeat_period = 114 },
+	[RC_PROTO_XBOX_DVD] = { .name = "xbox-dvd", .repeat_period = 64 },
 };
 
 /* Used to keep track of known keymaps */
@@ -1027,6 +1028,7 @@ static const struct {
 	{ RC_PROTO_BIT_RCMM12 |
 	  RC_PROTO_BIT_RCMM24 |
 	  RC_PROTO_BIT_RCMM32,	"rc-mm",	"ir-rcmm-decoder"	},
+	{ RC_PROTO_BIT_XBOX_DVD, "xbox-dvd",	NULL			},
 };
 
 /**
diff --git a/drivers/media/rc/xbox_remote.c b/drivers/media/rc/xbox_remote.c
index f959cbb94744..79470c09989e 100644
--- a/drivers/media/rc/xbox_remote.c
+++ b/drivers/media/rc/xbox_remote.c
@@ -148,7 +148,7 @@ static void xbox_remote_rc_init(struct xbox_remote *xbox_remote)
 	struct rc_dev *rdev = xbox_remote->rdev;
 
 	rdev->priv = xbox_remote;
-	rdev->allowed_protocols = RC_PROTO_BIT_UNKNOWN;
+	rdev->allowed_protocols = RC_PROTO_BIT_XBOX_DVD;
 	rdev->driver_name = "xbox_remote";
 
 	rdev->open = xbox_remote_rc_open;
@@ -157,6 +157,8 @@ static void xbox_remote_rc_init(struct xbox_remote *xbox_remote)
 	rdev->device_name = xbox_remote->rc_name;
 	rdev->input_phys = xbox_remote->rc_phys;
 
+	rdev->timeout = MS_TO_NS(10);
+
 	usb_to_input_id(xbox_remote->udev, &rdev->input_id);
 	rdev->dev.parent = &xbox_remote->interface->dev;
 }
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 5e684bb0d64c..367d983188f7 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -40,6 +40,7 @@
 #define RC_PROTO_BIT_RCMM12		BIT_ULL(RC_PROTO_RCMM12)
 #define RC_PROTO_BIT_RCMM24		BIT_ULL(RC_PROTO_RCMM24)
 #define RC_PROTO_BIT_RCMM32		BIT_ULL(RC_PROTO_RCMM32)
+#define RC_PROTO_BIT_XBOX_DVD		BIT_ULL(RC_PROTO_XBOX_DVD)
 
 #define RC_PROTO_BIT_ALL \
 			(RC_PROTO_BIT_UNKNOWN | RC_PROTO_BIT_OTHER | \
@@ -55,7 +56,8 @@
 			 RC_PROTO_BIT_RC6_MCE | RC_PROTO_BIT_SHARP | \
 			 RC_PROTO_BIT_XMP | RC_PROTO_BIT_CEC | \
 			 RC_PROTO_BIT_IMON | RC_PROTO_BIT_RCMM12 | \
-			 RC_PROTO_BIT_RCMM24 | RC_PROTO_BIT_RCMM32)
+			 RC_PROTO_BIT_RCMM24 | RC_PROTO_BIT_RCMM32 | \
+			 RC_PROTO_BIT_XBOX_DVD)
 /* All rc protocols for which we have decoders */
 #define RC_PROTO_BIT_ALL_IR_DECODER \
 			(RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC5X_20 | \
diff --git a/include/uapi/linux/lirc.h b/include/uapi/linux/lirc.h
index 45fcbf99d72e..f99d9dcae667 100644
--- a/include/uapi/linux/lirc.h
+++ b/include/uapi/linux/lirc.h
@@ -195,6 +195,7 @@ struct lirc_scancode {
  * @RC_PROTO_RCMM12: RC-MM protocol 12 bits
  * @RC_PROTO_RCMM24: RC-MM protocol 24 bits
  * @RC_PROTO_RCMM32: RC-MM protocol 32 bits
+ * @RC_PROTO_XBOX_DVD: Xbox DVD Movie Playback Kit protocol
  */
 enum rc_proto {
 	RC_PROTO_UNKNOWN	= 0,
@@ -224,6 +225,7 @@ enum rc_proto {
 	RC_PROTO_RCMM12		= 24,
 	RC_PROTO_RCMM24		= 25,
 	RC_PROTO_RCMM32		= 26,
+	RC_PROTO_XBOX_DVD	= 27,
 };
 
 #endif
-- 
2.20.1

