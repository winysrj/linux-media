Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4602 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab3LTJcE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:04 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 30/50] adv7842: added DE vertical position in SDP-io-sync
Date: Fri, 20 Dec 2013 10:31:23 +0100
Message-Id: <1387531903-20496-31-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 4 ++++
 include/media/adv7842.h     | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 4f93526..05d65a8 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2397,6 +2397,10 @@ static int adv7842_core_init(struct v4l2_subdev *sd,
 		sdp_io_write(sd, 0x99, s->de_beg & 0xff);
 		sdp_io_write(sd, 0x9a, (s->de_end>>8) & 0xf);
 		sdp_io_write(sd, 0x9b, s->de_end & 0xff);
+		sdp_io_write(sd, 0xac, s->de_v_beg_o);
+		sdp_io_write(sd, 0xad, s->de_v_beg_e);
+		sdp_io_write(sd, 0xae, s->de_v_end_o);
+		sdp_io_write(sd, 0xaf, s->de_v_end_e);
 	}
 
 	/* todo, improve settings for sdram */
diff --git a/include/media/adv7842.h b/include/media/adv7842.h
index c02201d..c023f88 100644
--- a/include/media/adv7842.h
+++ b/include/media/adv7842.h
@@ -131,6 +131,10 @@ struct adv7842_sdp_io_sync_adjustment {
 	uint16_t hs_width;
 	uint16_t de_beg;
 	uint16_t de_end;
+	uint8_t de_v_beg_o;
+	uint8_t de_v_beg_e;
+	uint8_t de_v_end_o;
+	uint8_t de_v_end_e;
 };
 
 /* Platform dependent definition */
-- 
1.8.4.4

