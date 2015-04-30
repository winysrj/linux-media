Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60048 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbbD3OIy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:08:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 03/22] xirlink_cit: comment unreachable code
Date: Thu, 30 Apr 2015 11:08:23 -0300
Message-Id: <ac2194e10fd032a580b251c02af3967951ca0c6e.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/gspca/xirlink_cit.c:1776 cit_start_model2() info: ignoring unreachable code.
drivers/media/usb/gspca/xirlink_cit.c:1858 cit_start_model2() info: ignoring unreachable code.
drivers/media/usb/gspca/xirlink_cit.c:1910 cit_start_model2() info: ignoring unreachable code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/gspca/xirlink_cit.c b/drivers/media/usb/gspca/xirlink_cit.c
index a41aa7817c54..d5ed9d36ce25 100644
--- a/drivers/media/usb/gspca/xirlink_cit.c
+++ b/drivers/media/usb/gspca/xirlink_cit.c
@@ -1772,7 +1772,8 @@ static int cit_start_model2(struct gspca_dev *gspca_dev)
 		cit_write_reg(gspca_dev, 0x0070, 0x0119);	/* All except 176x144 */
 		sd->sof_len = 2;
 		break;
-	/* case VIDEOSIZE_352x240: */
+#if 0
+	case VIDEOSIZE_352x240:
 		cit_write_reg(gspca_dev, 0x002c, 0x0103);	/* All except 320x240 */
 		cit_write_reg(gspca_dev, 0x0000, 0x0104);	/* Same */
 		cit_write_reg(gspca_dev, 0x001e, 0x0105);	/* 320x240, 352x240 */
@@ -1780,6 +1781,7 @@ static int cit_start_model2(struct gspca_dev *gspca_dev)
 		cit_write_reg(gspca_dev, 0x0070, 0x0119);	/* All except 176x144 */
 		sd->sof_len = 2;
 		break;
+#endif
 	case 352: /* 352x288 */
 		cit_write_reg(gspca_dev, 0x002c, 0x0103);	/* All except 320x240 */
 		cit_write_reg(gspca_dev, 0x0000, 0x0104);	/* Same */
@@ -1853,13 +1855,15 @@ static int cit_start_model2(struct gspca_dev *gspca_dev)
 		cit_model2_Packet1(gspca_dev, 0x0018, 0x0044); /* Another hardware setting */
 		clock_div = 8;
 		break;
-	/* case VIDEOSIZE_352x240: */
+#if 0
+	case VIDEOSIZE_352x240:
 		/* This mode doesn't work as Windows programs it; changed to work */
 		cit_model2_Packet1(gspca_dev, 0x0014, 0x0009); /* Windows sets this to 8 */
 		cit_model2_Packet1(gspca_dev, 0x0016, 0x0003); /* Horizontal shift */
 		cit_model2_Packet1(gspca_dev, 0x0018, 0x0044); /* Windows sets this to 0x0045 */
 		clock_div = 10;
 		break;
+#endif
 	case 352: /* 352x288 */
 		cit_model2_Packet1(gspca_dev, 0x0014, 0x0003);
 		cit_model2_Packet1(gspca_dev, 0x0016, 0x0002); /* Horizontal shift */
@@ -1906,9 +1910,11 @@ static int cit_start_model2(struct gspca_dev *gspca_dev)
 	case 320: /* 320x240 */
 		cit_model2_Packet1(gspca_dev, 0x0026, 0x0044);
 		break;
-	/* case VIDEOSIZE_352x240: */
+#if 0
+	case VIDEOSIZE_352x240:
 		cit_model2_Packet1(gspca_dev, 0x0026, 0x0046);
 		break;
+#endif
 	case 352: /* 352x288 */
 		cit_model2_Packet1(gspca_dev, 0x0026, 0x0048);
 		break;
-- 
2.1.0

