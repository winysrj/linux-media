Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:57663 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752243AbdIBLmv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 07:42:51 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/7] media: rc: avermedia keymap for a800
Date: Sat,  2 Sep 2017 12:42:44 +0100
Message-Id: <f210004a2b2de6df08d6fbfac8f9724611fa66fc.1504352252.git.sean@mess.org>
In-Reply-To: <cover.1504352252.git.sean@mess.org>
References: <cover.1504352252.git.sean@mess.org>
In-Reply-To: <cover.1504352252.git.sean@mess.org>
References: <cover.1504352252.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The keymap is missing one key, and correct another.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/keymaps/rc-avermedia-m135a.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/keymaps/rc-avermedia-m135a.c b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
index 9882e2cde975..6d5a73b7ccec 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-m135a.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
@@ -43,7 +43,8 @@ static struct rc_map_table avermedia_m135a[] = {
 	{ 0x0213, KEY_RIGHT },		/* -> or L */
 	{ 0x0212, KEY_LEFT },		/* <- or R */
 
-	{ 0x0217, KEY_SLEEP },		/* Capturar Imagem or Snapshot */
+	{ 0x0215, KEY_MENU },
+	{ 0x0217, KEY_CAMERA },		/* Capturar Imagem or Snapshot */
 	{ 0x0210, KEY_SHUFFLE },	/* Amostra or 16 chan prev */
 
 	{ 0x0303, KEY_CHANNELUP },
-- 
2.13.5
