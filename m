Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:52930 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750752AbeEEIWL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 5 May 2018 04:22:11 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH] [media] gspca: Stop using GFP_DMA for buffers for USB bulk transfers
Date: Sat,  5 May 2018 10:22:08 +0200
Message-Id: <20180505082208.32553-1-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The recent "x86 ZONE_DMA love" discussion at LSF/MM pointed out that some
gspca sub-drivvers are using GFP_DMA to allocate buffers which are used
for USB bulk transfers, there is absolutely no need for this, drop it.

Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/usb/gspca/jl2005bcd.c | 2 +-
 drivers/media/usb/gspca/sq905.c     | 2 +-
 drivers/media/usb/gspca/sq905c.c    | 2 +-
 drivers/media/usb/gspca/vicam.c     | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/gspca/jl2005bcd.c b/drivers/media/usb/gspca/jl2005bcd.c
index d668589598d6..c40245950553 100644
--- a/drivers/media/usb/gspca/jl2005bcd.c
+++ b/drivers/media/usb/gspca/jl2005bcd.c
@@ -321,7 +321,7 @@ static void jl2005c_dostream(struct work_struct *work)
 	int ret;
 	u8 *buffer;
 
-	buffer = kmalloc(JL2005C_MAX_TRANSFER, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(JL2005C_MAX_TRANSFER, GFP_KERNEL);
 	if (!buffer) {
 		pr_err("Couldn't allocate USB buffer\n");
 		goto quit_stream;
diff --git a/drivers/media/usb/gspca/sq905.c b/drivers/media/usb/gspca/sq905.c
index cc8ff41b8ab3..ffea9c35b0a0 100644
--- a/drivers/media/usb/gspca/sq905.c
+++ b/drivers/media/usb/gspca/sq905.c
@@ -217,7 +217,7 @@ static void sq905_dostream(struct work_struct *work)
 	u8 *data;
 	u8 *buffer;
 
-	buffer = kmalloc(SQ905_MAX_TRANSFER, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(SQ905_MAX_TRANSFER, GFP_KERNEL);
 	if (!buffer) {
 		pr_err("Couldn't allocate USB buffer\n");
 		goto quit_stream;
diff --git a/drivers/media/usb/gspca/sq905c.c b/drivers/media/usb/gspca/sq905c.c
index 5e1269eb7c50..274921c0bb46 100644
--- a/drivers/media/usb/gspca/sq905c.c
+++ b/drivers/media/usb/gspca/sq905c.c
@@ -138,7 +138,7 @@ static void sq905c_dostream(struct work_struct *work)
 	int ret;
 	u8 *buffer;
 
-	buffer = kmalloc(SQ905C_MAX_TRANSFER, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(SQ905C_MAX_TRANSFER, GFP_KERNEL);
 	if (!buffer) {
 		pr_err("Couldn't allocate USB buffer\n");
 		goto quit_stream;
diff --git a/drivers/media/usb/gspca/vicam.c b/drivers/media/usb/gspca/vicam.c
index 554b90ef2200..8562bda0ef88 100644
--- a/drivers/media/usb/gspca/vicam.c
+++ b/drivers/media/usb/gspca/vicam.c
@@ -182,7 +182,7 @@ static void vicam_dostream(struct work_struct *work)
 
 	frame_sz = gspca_dev->cam.cam_mode[gspca_dev->curr_mode].sizeimage +
 		   HEADER_SIZE;
-	buffer = kmalloc(frame_sz, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(frame_sz, GFP_KERNEL);
 	if (!buffer) {
 		pr_err("Couldn't allocate USB buffer\n");
 		goto exit;
-- 
2.17.0
