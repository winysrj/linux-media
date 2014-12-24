Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f42.google.com ([209.85.213.42]:41077 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaLXLhP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Dec 2014 06:37:15 -0500
Received: by mail-yh0-f42.google.com with SMTP id v1so3967143yhn.1
        for <linux-media@vger.kernel.org>; Wed, 24 Dec 2014 03:37:14 -0800 (PST)
From: Ismael Luceno <ismael@iodev.co.uk>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	Ismael Luceno <ismael@iodev.co.uk>
Subject: [PATCH 1/3] solo6x10: s/unsigned char/u8/
Date: Wed, 24 Dec 2014 08:35:59 -0300
Message-Id: <1419420961-7819-1-git-send-email-ismael@iodev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
---
 drivers/media/pci/solo6x10/solo6x10-enc.c      |  6 +++---
 drivers/media/pci/solo6x10/solo6x10-g723.c     |  4 ++--
 drivers/media/pci/solo6x10/solo6x10-jpeg.h     |  4 ++--
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c | 18 +++++++++---------
 drivers/media/pci/solo6x10/solo6x10.h          |  4 ++--
 5 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-enc.c b/drivers/media/pci/solo6x10/solo6x10-enc.c
index d19c0ae..d28211b 100644
--- a/drivers/media/pci/solo6x10/solo6x10-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-enc.c
@@ -136,11 +136,11 @@ static void solo_capture_config(struct solo_dev *solo_dev)
 int solo_osd_print(struct solo_enc_dev *solo_enc)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
-	unsigned char *str = solo_enc->osd_text;
+	u8 *str = solo_enc->osd_text;
 	u8 *buf = solo_enc->osd_buf;
 	u32 reg;
 	const struct font_desc *vga = find_font("VGA8x16");
-	const unsigned char *vga_data;
+	const u8 *vga_data;
 	int i, j;
 
 	if (WARN_ON_ONCE(!vga))
@@ -154,7 +154,7 @@ int solo_osd_print(struct solo_enc_dev *solo_enc)
 	}
 
 	memset(buf, 0, SOLO_OSD_WRITE_SIZE);
-	vga_data = (const unsigned char *)vga->data;
+	vga_data = (const u8 *)vga->data;
 
 	for (i = 0; *str; i++, str++) {
 		for (j = 0; j < 16; j++) {
diff --git a/drivers/media/pci/solo6x10/solo6x10-g723.c b/drivers/media/pci/solo6x10/solo6x10-g723.c
index c7141f2..7ddc767 100644
--- a/drivers/media/pci/solo6x10/solo6x10-g723.c
+++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
@@ -56,8 +56,8 @@
 struct solo_snd_pcm {
 	int				on;
 	spinlock_t			lock;
-	struct solo_dev		*solo_dev;
-	unsigned char			*g723_buf;
+	struct solo_dev			*solo_dev;
+	u8				*g723_buf;
 	dma_addr_t			g723_dma;
 };
 
diff --git a/drivers/media/pci/solo6x10/solo6x10-jpeg.h b/drivers/media/pci/solo6x10/solo6x10-jpeg.h
index 1c66a46..3c611bd 100644
--- a/drivers/media/pci/solo6x10/solo6x10-jpeg.h
+++ b/drivers/media/pci/solo6x10/solo6x10-jpeg.h
@@ -21,7 +21,7 @@
 #ifndef __SOLO6X10_JPEG_H
 #define __SOLO6X10_JPEG_H
 
-static const unsigned char jpeg_header[] = {
+static const u8 jpeg_header[] = {
 	0xff, 0xd8, 0xff, 0xfe, 0x00, 0x0d, 0x42, 0x6c,
 	0x75, 0x65, 0x63, 0x68, 0x65, 0x72, 0x72, 0x79,
 	0x20, 0xff, 0xdb, 0x00, 0x43, 0x00, 0x20, 0x16,
@@ -106,7 +106,7 @@ static const unsigned char jpeg_header[] = {
 /* This is the byte marker for the start of the DQT */
 #define DQT_START	17
 #define DQT_LEN		138
-static const unsigned char jpeg_dqt[4][DQT_LEN] = {
+static const u8 jpeg_dqt[4][DQT_LEN] = {
 	{
 		0xff, 0xdb, 0x00, 0x43, 0x00,
 		0x08, 0x06, 0x06, 0x07, 0x06, 0x05, 0x08, 0x07,
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 6e933d3..e752140 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -38,28 +38,28 @@
 #define DMA_ALIGN		4096
 
 /* 6010 M4V */
-static unsigned char vop_6010_ntsc_d1[] = {
+static u8 vop_6010_ntsc_d1[] = {
 	0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x20,
 	0x02, 0x48, 0x1d, 0xc0, 0x00, 0x40, 0x00, 0x40,
 	0x00, 0x40, 0x00, 0x80, 0x00, 0x97, 0x53, 0x04,
 	0x1f, 0x4c, 0x58, 0x10, 0xf0, 0x71, 0x18, 0x3f,
 };
 
-static unsigned char vop_6010_ntsc_cif[] = {
+static u8 vop_6010_ntsc_cif[] = {
 	0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x20,
 	0x02, 0x48, 0x1d, 0xc0, 0x00, 0x40, 0x00, 0x40,
 	0x00, 0x40, 0x00, 0x80, 0x00, 0x97, 0x53, 0x04,
 	0x1f, 0x4c, 0x2c, 0x10, 0x78, 0x51, 0x18, 0x3f,
 };
 
-static unsigned char vop_6010_pal_d1[] = {
+static u8 vop_6010_pal_d1[] = {
 	0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x20,
 	0x02, 0x48, 0x15, 0xc0, 0x00, 0x40, 0x00, 0x40,
 	0x00, 0x40, 0x00, 0x80, 0x00, 0x97, 0x53, 0x04,
 	0x1f, 0x4c, 0x58, 0x11, 0x20, 0x71, 0x18, 0x3f,
 };
 
-static unsigned char vop_6010_pal_cif[] = {
+static u8 vop_6010_pal_cif[] = {
 	0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x20,
 	0x02, 0x48, 0x15, 0xc0, 0x00, 0x40, 0x00, 0x40,
 	0x00, 0x40, 0x00, 0x80, 0x00, 0x97, 0x53, 0x04,
@@ -67,25 +67,25 @@ static unsigned char vop_6010_pal_cif[] = {
 };
 
 /* 6110 h.264 */
-static unsigned char vop_6110_ntsc_d1[] = {
+static u8 vop_6110_ntsc_d1[] = {
 	0x00, 0x00, 0x00, 0x01, 0x67, 0x42, 0x00, 0x1e,
 	0x9a, 0x74, 0x05, 0x81, 0xec, 0x80, 0x00, 0x00,
 	0x00, 0x01, 0x68, 0xce, 0x32, 0x28, 0x00, 0x00,
 };
 
-static unsigned char vop_6110_ntsc_cif[] = {
+static u8 vop_6110_ntsc_cif[] = {
 	0x00, 0x00, 0x00, 0x01, 0x67, 0x42, 0x00, 0x1e,
 	0x9a, 0x74, 0x0b, 0x0f, 0xc8, 0x00, 0x00, 0x00,
 	0x01, 0x68, 0xce, 0x32, 0x28, 0x00, 0x00, 0x00,
 };
 
-static unsigned char vop_6110_pal_d1[] = {
+static u8 vop_6110_pal_d1[] = {
 	0x00, 0x00, 0x00, 0x01, 0x67, 0x42, 0x00, 0x1e,
 	0x9a, 0x74, 0x05, 0x80, 0x93, 0x20, 0x00, 0x00,
 	0x00, 0x01, 0x68, 0xce, 0x32, 0x28, 0x00, 0x00,
 };
 
-static unsigned char vop_6110_pal_cif[] = {
+static u8 vop_6110_pal_cif[] = {
 	0x00, 0x00, 0x00, 0x01, 0x67, 0x42, 0x00, 0x1e,
 	0x9a, 0x74, 0x0b, 0x04, 0xb2, 0x00, 0x00, 0x00,
 	0x01, 0x68, 0xce, 0x32, 0x28, 0x00, 0x00, 0x00,
@@ -149,7 +149,7 @@ void solo_update_mode(struct solo_enc_dev *solo_enc)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	int vop_len;
-	unsigned char *vop;
+	u8 *vop;
 
 	solo_enc->interlaced = (solo_enc->mode & 0x08) ? 1 : 0;
 	solo_enc->bw_weight = max(solo_dev->fps / solo_enc->interval, 1);
diff --git a/drivers/media/pci/solo6x10/solo6x10.h b/drivers/media/pci/solo6x10/solo6x10.h
index bd8edfa..e2f1759 100644
--- a/drivers/media/pci/solo6x10/solo6x10.h
+++ b/drivers/media/pci/solo6x10/solo6x10.h
@@ -170,9 +170,9 @@ struct solo_enc_dev {
 					__aligned(4);
 
 	/* VOP stuff */
-	unsigned char		vop[64];
+	u8			vop[64];
 	int			vop_len;
-	unsigned char		jpeg_header[1024];
+	u8			jpeg_header[1024];
 	int			jpeg_len;
 
 	u32			fmt;
-- 
2.2.0

