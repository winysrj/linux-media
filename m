Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab2ETBVa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 21:21:30 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Ondrej Zary <linux@rainbow-software.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 1/6] snd_tea575x: Add write_/read_val operations
Date: Sun, 20 May 2012 03:25:26 +0200
Message-Id: <1337477131-21578-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1337477131-21578-1-git-send-email-hdegoede@redhat.com>
References: <1337477131-21578-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some devices which use the tea575x tuner chip don't allow bit banging the
lines, instead they offer a method to directly set / get the contents of the
25 bit shift-register in the chip. Notably the Griffin radioSHARK USB radio
receiver does this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
CC: Ondrej Zary <linux@rainbow-software.org>
---
 include/sound/tea575x-tuner.h   |    4 ++++
 sound/i2c/other/tea575x-tuner.c |    6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/include/sound/tea575x-tuner.h b/include/sound/tea575x-tuner.h
index ec3f910..1ae933f 100644
--- a/include/sound/tea575x-tuner.h
+++ b/include/sound/tea575x-tuner.h
@@ -37,6 +37,10 @@
 struct snd_tea575x;
 
 struct snd_tea575x_ops {
+	/* Drivers using snd_tea575x must either define read_ and write_val */
+	void (*write_val)(struct snd_tea575x *tea, u32 val);
+	u32 (*read_val)(struct snd_tea575x *tea);
+	/* Or define the 3 pin functions */
 	void (*set_pins)(struct snd_tea575x *tea, u8 pins);
 	u8 (*get_pins)(struct snd_tea575x *tea);
 	void (*set_direction)(struct snd_tea575x *tea, bool output);
diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
index 582aace..b74fc63 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -71,6 +71,9 @@ static void snd_tea575x_write(struct snd_tea575x *tea, unsigned int val)
 	u16 l;
 	u8 data;
 
+	if (tea->ops->write_val)
+		return tea->ops->write_val(tea, val);
+
 	tea->ops->set_direction(tea, 1);
 	udelay(16);
 
@@ -94,6 +97,9 @@ static u32 snd_tea575x_read(struct snd_tea575x *tea)
 	u16 l, rdata;
 	u32 data = 0;
 
+	if (tea->ops->read_val)
+		return tea->ops->read_val(tea);
+
 	tea->ops->set_direction(tea, 0);
 	tea->ops->set_pins(tea, 0);
 	udelay(16);
-- 
1.7.10

