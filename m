Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:59697 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3CWR0a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Mar 2013 13:26:30 -0400
Received: by mail-ea0-f169.google.com with SMTP id n15so173179ead.0
        for <linux-media@vger.kernel.org>; Sat, 23 Mar 2013 10:26:28 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 3/5] em28xx: add support for em25xx/em276x/em277x/em278x frame data processing
Date: Sat, 23 Mar 2013 18:27:10 +0100
Message-Id: <1364059632-29070-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1364059632-29070-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1364059632-29070-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The em25xx/em276x/em277x/em278x frame data format is different to the one used
by the em2710/em2750/em28xx chips.
With the recent cleanups and reorganization of the frame data processing code it
can be easily extended to support these devices.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   72 ++++++++++++++++++++++++++++++-
 1 Datei geändert, 71 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index d585c19..c1bd18d 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -76,6 +76,16 @@ MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 MODULE_VERSION(EM28XX_VERSION);
 
+
+#define EM25XX_FRMDATAHDR_BYTE1			0x02
+#define EM25XX_FRMDATAHDR_BYTE2_STILL_IMAGE	0x20
+#define EM25XX_FRMDATAHDR_BYTE2_FRAME_END	0x02
+#define EM25XX_FRMDATAHDR_BYTE2_FRAME_ID	0x01
+#define EM25XX_FRMDATAHDR_BYTE2_MASK	(EM25XX_FRMDATAHDR_BYTE2_STILL_IMAGE | \
+					 EM25XX_FRMDATAHDR_BYTE2_FRAME_END |   \
+					 EM25XX_FRMDATAHDR_BYTE2_FRAME_ID)
+
+
 static unsigned int video_nr[] = {[0 ... (EM28XX_MAXBOARDS - 1)] = -1U };
 static unsigned int vbi_nr[]   = {[0 ... (EM28XX_MAXBOARDS - 1)] = -1U };
 static unsigned int radio_nr[] = {[0 ... (EM28XX_MAXBOARDS - 1)] = -1U };
@@ -408,6 +418,62 @@ static inline void process_frame_data_em28xx(struct em28xx *dev,
 		em28xx_copy_video(dev, buf, data_pkt, data_len);
 }
 
+/*
+ * Process data packet according to the em25xx/em276x/7x/8x frame data format
+ */
+static inline void process_frame_data_em25xx(struct em28xx *dev,
+					     unsigned char *data_pkt,
+					     unsigned int  data_len)
+{
+	struct em28xx_buffer    *buf = dev->usb_ctl.vid_buf;
+	struct em28xx_dmaqueue  *dmaq = &dev->vidq;
+	bool frame_end = 0;
+
+	/* Check for header */
+	/* NOTE: at least with bulk transfers, only the first packet
+	 * has a header and has always set the FRAME_END bit         */
+	if (data_len >= 2) {	/* em25xx header is only 2 bytes long */
+		if ((data_pkt[0] == EM25XX_FRMDATAHDR_BYTE1) &&
+		    ((data_pkt[1] & ~EM25XX_FRMDATAHDR_BYTE2_MASK) == 0x00)) {
+			dev->top_field = !(data_pkt[1] &
+					   EM25XX_FRMDATAHDR_BYTE2_FRAME_ID);
+			frame_end = data_pkt[1] &
+				    EM25XX_FRMDATAHDR_BYTE2_FRAME_END;
+			data_pkt += 2;
+			data_len -= 2;
+		}
+
+		/* Finish field and prepare next (BULK only) */
+		if (dev->analog_xfer_bulk && frame_end) {
+			buf = finish_field_prepare_next(dev, buf, dmaq);
+			dev->usb_ctl.vid_buf = buf;
+		}
+		/* NOTE: in ISOC mode when a new frame starts and buf==NULL,
+		 * we COULD already prepare a buffer here to avoid skipping the
+		 * first frame.
+		 */
+	}
+
+	/* Copy data */
+	if (buf != NULL && data_len > 0)
+		em28xx_copy_video(dev, buf, data_pkt, data_len);
+
+	/* Finish frame (ISOC only) => avoids lag of 1 frame */
+	if (!dev->analog_xfer_bulk && frame_end) {
+		buf = finish_field_prepare_next(dev, buf, dmaq);
+		dev->usb_ctl.vid_buf = buf;
+	}
+
+	/* NOTE: Tested with USB bulk transfers only !
+	 * The wording in the datasheet suggests that isoc might work different.
+	 * The current code assumes that with isoc transfers each packet has a
+	 * header like with the other em28xx devices.
+	 */
+	/* NOTE: Support for interlaced mode is pure theory. It has not been
+	 * tested and it is unknown if these devices actually support it. */
+	/* NOTE: No VBI support yet (these chips likely do not support VBI). */
+}
+
 /* Processes and copies the URB data content (video and VBI data) */
 static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 {
@@ -460,7 +526,11 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 			continue;
 		}
 
-		process_frame_data_em28xx(dev, usb_data_pkt, usb_data_len);
+		if (dev->is_em25xx)
+			process_frame_data_em25xx(dev, usb_data_pkt, usb_data_len);
+		else
+			process_frame_data_em28xx(dev, usb_data_pkt, usb_data_len);
+
 	}
 	return 1;
 }
-- 
1.7.10.4

