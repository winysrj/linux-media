Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:54808
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751026AbbKVKoo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Nov 2015 05:44:44 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Hans de Goede <hdegoede@redhat.com>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media, sound: tea575x: constify snd_tea575x_ops structures
Date: Sun, 22 Nov 2015 11:32:53 +0100
Message-Id: <1448188373-27089-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The snd_tea575x_ops structures are never modified, so declare them as
const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/pci/bt8xx/bttv-cards.c  |    2 +-
 drivers/media/radio/radio-maxiradio.c |    2 +-
 drivers/media/radio/radio-sf16fmr2.c  |    2 +-
 drivers/media/radio/radio-shark.c     |    2 +-
 include/media/drv-intf/tea575x.h      |    2 +-
 sound/pci/es1968.c                    |    2 +-
 sound/pci/fm801.c                     |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index cb38cd1..514f260 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -2605,7 +2605,7 @@ static void snd_es1968_tea575x_set_direction(struct snd_tea575x *tea, bool outpu
 	}
 }
 
-static struct snd_tea575x_ops snd_es1968_tea_ops = {
+static const struct snd_tea575x_ops snd_es1968_tea_ops = {
 	.set_pins = snd_es1968_tea575x_set_pins,
 	.get_pins = snd_es1968_tea575x_get_pins,
 	.set_direction = snd_es1968_tea575x_set_direction,
diff --git a/sound/pci/fm801.c b/sound/pci/fm801.c
index 5144a7f..759295a 100644
--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -815,7 +815,7 @@ static void snd_fm801_tea575x_set_direction(struct snd_tea575x *tea, bool output
 	fm801_writew(chip, GPIO_CTRL, reg);
 }
 
-static struct snd_tea575x_ops snd_fm801_tea_ops = {
+static const struct snd_tea575x_ops snd_fm801_tea_ops = {
 	.set_pins = snd_fm801_tea575x_set_pins,
 	.get_pins = snd_fm801_tea575x_get_pins,
 	.set_direction = snd_fm801_tea575x_set_direction,
diff --git a/drivers/media/pci/bt8xx/bttv-cards.c b/drivers/media/pci/bt8xx/bttv-cards.c
index 7a08102..8a17cc0 100644
--- a/drivers/media/pci/bt8xx/bttv-cards.c
+++ b/drivers/media/pci/bt8xx/bttv-cards.c
@@ -3808,7 +3808,7 @@ static void bttv_tea575x_set_direction(struct snd_tea575x *tea, bool output)
 		gpio_inout(mask, (1 << gpio.clk) | (1 << gpio.wren));
 }
 
-static struct snd_tea575x_ops bttv_tea_ops = {
+static const struct snd_tea575x_ops bttv_tea_ops = {
 	.set_pins = bttv_tea575x_set_pins,
 	.get_pins = bttv_tea575x_get_pins,
 	.set_direction = bttv_tea575x_set_direction,
diff --git a/drivers/media/radio/radio-sf16fmr2.c b/drivers/media/radio/radio-sf16fmr2.c
index 8e4f1d1..dc81d42 100644
--- a/drivers/media/radio/radio-sf16fmr2.c
+++ b/drivers/media/radio/radio-sf16fmr2.c
@@ -82,7 +82,7 @@ static void fmr2_tea575x_set_direction(struct snd_tea575x *tea, bool output)
 {
 }
 
-static struct snd_tea575x_ops fmr2_tea_ops = {
+static const struct snd_tea575x_ops fmr2_tea_ops = {
 	.set_pins = fmr2_tea575x_set_pins,
 	.get_pins = fmr2_tea575x_get_pins,
 	.set_direction = fmr2_tea575x_set_direction,
diff --git a/include/media/drv-intf/tea575x.h b/include/media/drv-intf/tea575x.h
index 5d09657..fb272d4 100644
--- a/include/media/drv-intf/tea575x.h
+++ b/include/media/drv-intf/tea575x.h
@@ -63,7 +63,7 @@ struct snd_tea575x {
 	u32 band;			/* 0: FM, 1: FM-Japan, 2: AM */
 	u32 freq;			/* frequency */
 	struct mutex mutex;
-	struct snd_tea575x_ops *ops;
+	const struct snd_tea575x_ops *ops;
 	void *private_data;
 	u8 card[32];
 	u8 bus_info[32];
diff --git a/drivers/media/radio/radio-shark.c b/drivers/media/radio/radio-shark.c
index 409fac1..85667a9 100644
--- a/drivers/media/radio/radio-shark.c
+++ b/drivers/media/radio/radio-shark.c
@@ -150,7 +150,7 @@ static u32 shark_read_val(struct snd_tea575x *tea)
 	return val;
 }
 
-static struct snd_tea575x_ops shark_tea_ops = {
+static const struct snd_tea575x_ops shark_tea_ops = {
 	.write_val = shark_write_val,
 	.read_val  = shark_read_val,
 };
diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index 41c1652..70fd8e8 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -108,7 +108,7 @@ static void maxiradio_tea575x_set_direction(struct snd_tea575x *tea, bool output
 {
 }
 
-static struct snd_tea575x_ops maxiradio_tea_ops = {
+static const struct snd_tea575x_ops maxiradio_tea_ops = {
 	.set_pins = maxiradio_tea575x_set_pins,
 	.get_pins = maxiradio_tea575x_get_pins,
 	.set_direction = maxiradio_tea575x_set_direction,

