Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2933 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab3CRONP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 10:13:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andy Walls <awalls@md.metrocast.net>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Brian Johnson <brijohn@gmail.com>,
	Mike Isely <isely@pobox.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Huang Shijie <shijie8@gmail.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Takashi Iwai <tiwai@suse.de>,
	Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 6/6] v4l2-ioctl: add precision when printing names.
Date: Mon, 18 Mar 2013 15:12:05 +0100
Message-Id: <1363615925-19507-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363615925-19507-1-git-send-email-hverkuil@xs4all.nl>
References: <1363615925-19507-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Never print more than the size of the buffer containing the name.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c |   60 +++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 26 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index b3fe148..168b51e 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -167,9 +167,11 @@ static void v4l_print_querycap(const void *arg, bool write_only)
 {
 	const struct v4l2_capability *p = arg;
 
-	pr_cont("driver=%s, card=%s, bus=%s, version=0x%08x, "
+	pr_cont("driver=%.*s, card=%.*s, bus=%.*s, version=0x%08x, "
 		"capabilities=0x%08x, device_caps=0x%08x\n",
-		p->driver, p->card, p->bus_info,
+		(int)sizeof(p->driver), p->driver,
+		(int)sizeof(p->card), p->card,
+		(int)sizeof(p->bus_info), p->bus_info,
 		p->version, p->capabilities, p->device_caps);
 }
 
@@ -177,20 +179,21 @@ static void v4l_print_enuminput(const void *arg, bool write_only)
 {
 	const struct v4l2_input *p = arg;
 
-	pr_cont("index=%u, name=%s, type=%u, audioset=0x%x, tuner=%u, "
+	pr_cont("index=%u, name=%.*s, type=%u, audioset=0x%x, tuner=%u, "
 		"std=0x%08Lx, status=0x%x, capabilities=0x%x\n",
-		p->index, p->name, p->type, p->audioset, p->tuner,
-		(unsigned long long)p->std, p->status, p->capabilities);
+		p->index, (int)sizeof(p->name), p->name, p->type, p->audioset,
+		p->tuner, (unsigned long long)p->std, p->status,
+		p->capabilities);
 }
 
 static void v4l_print_enumoutput(const void *arg, bool write_only)
 {
 	const struct v4l2_output *p = arg;
 
-	pr_cont("index=%u, name=%s, type=%u, audioset=0x%x, "
+	pr_cont("index=%u, name=%.*s, type=%u, audioset=0x%x, "
 		"modulator=%u, std=0x%08Lx, capabilities=0x%x\n",
-		p->index, p->name, p->type, p->audioset, p->modulator,
-		(unsigned long long)p->std, p->capabilities);
+		p->index, (int)sizeof(p->name), p->name, p->type, p->audioset,
+		p->modulator, (unsigned long long)p->std, p->capabilities);
 }
 
 static void v4l_print_audio(const void *arg, bool write_only)
@@ -200,8 +203,9 @@ static void v4l_print_audio(const void *arg, bool write_only)
 	if (write_only)
 		pr_cont("index=%u, mode=0x%x\n", p->index, p->mode);
 	else
-		pr_cont("index=%u, name=%s, capability=0x%x, mode=0x%x\n",
-			p->index, p->name, p->capability, p->mode);
+		pr_cont("index=%u, name=%.*s, capability=0x%x, mode=0x%x\n",
+			p->index, (int)sizeof(p->name), p->name,
+			p->capability, p->mode);
 }
 
 static void v4l_print_audioout(const void *arg, bool write_only)
@@ -211,21 +215,22 @@ static void v4l_print_audioout(const void *arg, bool write_only)
 	if (write_only)
 		pr_cont("index=%u\n", p->index);
 	else
-		pr_cont("index=%u, name=%s, capability=0x%x, mode=0x%x\n",
-			p->index, p->name, p->capability, p->mode);
+		pr_cont("index=%u, name=%.*s, capability=0x%x, mode=0x%x\n",
+			p->index, (int)sizeof(p->name), p->name,
+			p->capability, p->mode);
 }
 
 static void v4l_print_fmtdesc(const void *arg, bool write_only)
 {
 	const struct v4l2_fmtdesc *p = arg;
 
-	pr_cont("index=%u, type=%s, flags=0x%x, pixelformat=%c%c%c%c, description='%s'\n",
+	pr_cont("index=%u, type=%s, flags=0x%x, pixelformat=%c%c%c%c, description='%.*s'\n",
 		p->index, prt_names(p->type, v4l2_type_names),
 		p->flags, (p->pixelformat & 0xff),
 		(p->pixelformat >>  8) & 0xff,
 		(p->pixelformat >> 16) & 0xff,
 		(p->pixelformat >> 24) & 0xff,
-		p->description);
+		(int)sizeof(p->description), p->description);
 }
 
 static void v4l_print_format(const void *arg, bool write_only)
@@ -348,9 +353,9 @@ static void v4l_print_modulator(const void *arg, bool write_only)
 	if (write_only)
 		pr_cont("index=%u, txsubchans=0x%x", p->index, p->txsubchans);
 	else
-		pr_cont("index=%u, name=%s, capability=0x%x, "
+		pr_cont("index=%u, name=%.*s, capability=0x%x, "
 			"rangelow=%u, rangehigh=%u, txsubchans=0x%x\n",
-			p->index, p->name, p->capability,
+			p->index, (int)sizeof(p->name), p->name, p->capability,
 			p->rangelow, p->rangehigh, p->txsubchans);
 }
 
@@ -361,10 +366,10 @@ static void v4l_print_tuner(const void *arg, bool write_only)
 	if (write_only)
 		pr_cont("index=%u, audmode=%u\n", p->index, p->audmode);
 	else
-		pr_cont("index=%u, name=%s, type=%u, capability=0x%x, "
+		pr_cont("index=%u, name=%.*s, type=%u, capability=0x%x, "
 			"rangelow=%u, rangehigh=%u, signal=%u, afc=%d, "
 			"rxsubchans=0x%x, audmode=%u\n",
-			p->index, p->name, p->type,
+			p->index, (int)sizeof(p->name), p->name, p->type,
 			p->capability, p->rangelow,
 			p->rangehigh, p->signal, p->afc,
 			p->rxsubchans, p->audmode);
@@ -382,9 +387,9 @@ static void v4l_print_standard(const void *arg, bool write_only)
 {
 	const struct v4l2_standard *p = arg;
 
-	pr_cont("index=%u, id=0x%Lx, name=%s, fps=%u/%u, "
+	pr_cont("index=%u, id=0x%Lx, name=%.*s, fps=%u/%u, "
 		"framelines=%u\n", p->index,
-		(unsigned long long)p->id, p->name,
+		(unsigned long long)p->id, (int)sizeof(p->name), p->name,
 		p->frameperiod.numerator,
 		p->frameperiod.denominator,
 		p->framelines);
@@ -504,9 +509,9 @@ static void v4l_print_queryctrl(const void *arg, bool write_only)
 {
 	const struct v4l2_queryctrl *p = arg;
 
-	pr_cont("id=0x%x, type=%d, name=%s, min/max=%d/%d, "
+	pr_cont("id=0x%x, type=%d, name=%.*s, min/max=%d/%d, "
 		"step=%d, default=%d, flags=0x%08x\n",
-			p->id, p->type, p->name,
+			p->id, p->type, (int)sizeof(p->name), p->name,
 			p->minimum, p->maximum,
 			p->step, p->default_value, p->flags);
 }
@@ -623,7 +628,8 @@ static void v4l_print_dbg_chip_ident(const void *arg, bool write_only)
 
 	pr_cont("type=%u, ", p->match.type);
 	if (p->match.type == V4L2_CHIP_MATCH_I2C_DRIVER)
-		pr_cont("name=%s, ", p->match.name);
+		pr_cont("name=%.*s, ",
+				(int)sizeof(p->match.name), p->match.name);
 	else
 		pr_cont("addr=%u, ", p->match.addr);
 	pr_cont("chip_ident=%u, revision=0x%x\n",
@@ -636,7 +642,8 @@ static void v4l_print_dbg_register(const void *arg, bool write_only)
 
 	pr_cont("type=%u, ", p->match.type);
 	if (p->match.type == V4L2_CHIP_MATCH_I2C_DRIVER)
-		pr_cont("name=%s, ", p->match.name);
+		pr_cont("name=%.*s, ",
+				(int)sizeof(p->match.name), p->match.name);
 	else
 		pr_cont("addr=%u, ", p->match.addr);
 	pr_cont("reg=0x%llx, val=0x%llx\n",
@@ -647,8 +654,9 @@ static void v4l_print_dv_enum_presets(const void *arg, bool write_only)
 {
 	const struct v4l2_dv_enum_preset *p = arg;
 
-	pr_cont("index=%u, preset=%u, name=%s, width=%u, height=%u\n",
-			p->index, p->preset, p->name, p->width, p->height);
+	pr_cont("index=%u, preset=%u, name=%.*s, width=%u, height=%u\n",
+			p->index, p->preset,
+			(int)sizeof(p->name), p->name, p->width, p->height);
 }
 
 static void v4l_print_dv_preset(const void *arg, bool write_only)
-- 
1.7.10.4

