Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761136Ab0J0Mbj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 08:31:39 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Lee Jones <lee.jones@canonical.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 4/7] gspca_xirlink_cit: various usb bandwidth allocation improvements / fixes
Date: Wed, 27 Oct 2010 14:35:23 +0200
Message-Id: <1288182926-25400-5-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1288182926-25400-1-git-send-email-hdegoede@redhat.com>
References: <1288182926-25400-1-git-send-email-hdegoede@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following usb bandwidth allocation changes were made to the ibm netcam
pro code:
- Don't restart negotiation at max packet size on stop0, as that gets called
  by gspca_main during negotiation. Move this to sd_isoc_init.
- Don't ask for full bandwidth when running at 160x120, that does not need
  full bandwidth
- Make minimum acceptable bandwidth depend upon resolution

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/xirlink_cit.c |   41 +++++++++++++++++++++++-------
 1 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/gspca/xirlink_cit.c b/drivers/media/video/gspca/xirlink_cit.c
index 8715577..f0f6279 100644
--- a/drivers/media/video/gspca/xirlink_cit.c
+++ b/drivers/media/video/gspca/xirlink_cit.c
@@ -2769,16 +2769,43 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	return 0;
 }
 
+static int sd_isoc_init(struct gspca_dev *gspca_dev)
+{
+	struct usb_host_interface *alt;
+	int max_packet_size;
+
+	switch (gspca_dev->width) {
+		case 160: max_packet_size = 450; break;
+		case 176: max_packet_size = 600; break;
+		default:  max_packet_size = 1022; break;
+	}
+
+	/* Start isoc bandwidth "negotiation" at max isoc bandwidth */
+	alt = &gspca_dev->dev->config->intf_cache[0]->altsetting[1];
+	alt->endpoint[0].desc.wMaxPacketSize = cpu_to_le16(max_packet_size);
+
+	return 0;
+}
+
 static int sd_isoc_nego(struct gspca_dev *gspca_dev)
 {
-	int ret, packet_size;
+	int ret, packet_size, min_packet_size;
 	struct usb_host_interface *alt;
 
+	switch (gspca_dev->width) {
+		case 160: min_packet_size = 200; break;
+		case 176: min_packet_size = 266; break;
+		default:  min_packet_size = 400; break;
+	}
+
 	alt = &gspca_dev->dev->config->intf_cache[0]->altsetting[1];
 	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
-	packet_size -= 100;
-	if (packet_size < 300)
+	if (packet_size <= min_packet_size)
 		return -EIO;
+
+	packet_size -= 100;
+	if (packet_size < min_packet_size)
+		packet_size = min_packet_size;
 	alt->endpoint[0].desc.wMaxPacketSize = cpu_to_le16(packet_size);
 
 	ret = usb_set_interface(gspca_dev->dev, gspca_dev->iface, 1);
@@ -2796,15 +2823,12 @@ static void sd_stopN(struct gspca_dev *gspca_dev)
 static void sd_stop0(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-	struct usb_host_interface *alt;
 
 	/* We cannot use gspca_dev->present here as that is not set when
 	   sd_init gets called and we get called from sd_init */
 	if (!gspca_dev->dev)
 		return;
 
-	alt = &gspca_dev->dev->config->intf_cache[0]->altsetting[1];
-
 	switch (sd->model) {
 	case CIT_MODEL0:
 		/* HDG windows does this, but it causes the cams autogain to
@@ -2859,10 +2883,6 @@ static void sd_stop0(struct gspca_dev *gspca_dev)
 		   restarting the stream after this */
 		/* cit_write_reg(gspca_dev, 0x0000, 0x0112); */
 		cit_write_reg(gspca_dev, 0x00c0, 0x0100);
-
-		/* Start isoc bandwidth "negotiation" at max isoc bandwith
-		   next stream start */
-		alt->endpoint[0].desc.wMaxPacketSize = cpu_to_le16(1022);
 		break;
 	}
 }
@@ -3179,6 +3199,7 @@ static const struct sd_desc sd_desc_isoc_nego = {
 	.config = sd_config,
 	.init = sd_init,
 	.start = sd_start,
+	.isoc_init = sd_isoc_init,
 	.isoc_nego = sd_isoc_nego,
 	.stopN = sd_stopN,
 	.stop0 = sd_stop0,
-- 
1.7.3.1

