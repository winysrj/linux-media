Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45460 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbbEQLiV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2015 07:38:21 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2: correct two SDR format names
Date: Sun, 17 May 2015 14:38:04 +0300
Message-Id: <1431862684-4878-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

U8 and U16LE format human readable names were translated with string
containing emulated word. These strings were taken from msi2500 driver,
where those formats were emulated (after module parameter is set). But
on API correct names should be used, without any special case notes.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index e78b7b8..d6667be 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1221,8 +1221,8 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_PIX_FMT_TM6000:	descr = "A/V + VBI Mux Packet"; break;
 	case V4L2_PIX_FMT_CIT_YYVYUY:	descr = "GSPCA CIT YYVYUY"; break;
 	case V4L2_PIX_FMT_KONICA420:	descr = "GSPCA KONICA420"; break;
-	case V4L2_SDR_FMT_CU8:		descr = "Complex U8 (Emulated)"; break;
-	case V4L2_SDR_FMT_CU16LE:	descr = "Complex U16LE (Emulated)"; break;
+	case V4L2_SDR_FMT_CU8:		descr = "Complex U8"; break;
+	case V4L2_SDR_FMT_CU16LE:	descr = "Complex U16LE"; break;
 	case V4L2_SDR_FMT_CS8:		descr = "Complex S8"; break;
 	case V4L2_SDR_FMT_CS14LE:	descr = "Complex S14LE"; break;
 	case V4L2_SDR_FMT_RU12LE:	descr = "Real U12LE"; break;
-- 
http://palosaari.fi/

