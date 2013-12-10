Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4325 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab3LJPGM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 10:06:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 22/22] adv7842: Composite sync adjustment
Date: Tue, 10 Dec 2013 16:04:08 +0100
Message-Id: <9e9eaa702db4b0e0626dbf7200578e66d8281312.1386687810.git.hans.verkuil@cisco.com>
In-Reply-To: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
References: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
References: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 8 ++++++++
 include/media/adv7842.h     | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index fac5c4f..bafe3b5 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2437,6 +2437,10 @@ static void adv7842_s_sdp_io(struct v4l2_subdev *sd, struct adv7842_sdp_io_sync_
 		sdp_io_write(sd, 0x99, s->de_beg & 0xff);
 		sdp_io_write(sd, 0x9a, (s->de_end >> 8) & 0xf);
 		sdp_io_write(sd, 0x9b, s->de_end & 0xff);
+		sdp_io_write(sd, 0xa8, s->vs_beg_o);
+		sdp_io_write(sd, 0xa9, s->vs_beg_e);
+		sdp_io_write(sd, 0xaa, s->vs_end_o);
+		sdp_io_write(sd, 0xab, s->vs_end_e);
 		sdp_io_write(sd, 0xac, s->de_v_beg_o);
 		sdp_io_write(sd, 0xad, s->de_v_beg_e);
 		sdp_io_write(sd, 0xae, s->de_v_end_o);
@@ -2451,6 +2455,10 @@ static void adv7842_s_sdp_io(struct v4l2_subdev *sd, struct adv7842_sdp_io_sync_
 		sdp_io_write(sd, 0x99, 0x00);
 		sdp_io_write(sd, 0x9a, 0x00);
 		sdp_io_write(sd, 0x9b, 0x00);
+		sdp_io_write(sd, 0xa8, 0x04);
+		sdp_io_write(sd, 0xa9, 0x04);
+		sdp_io_write(sd, 0xaa, 0x04);
+		sdp_io_write(sd, 0xab, 0x04);
 		sdp_io_write(sd, 0xac, 0x04);
 		sdp_io_write(sd, 0xad, 0x04);
 		sdp_io_write(sd, 0xae, 0x04);
diff --git a/include/media/adv7842.h b/include/media/adv7842.h
index 4e36496..8b336ab 100644
--- a/include/media/adv7842.h
+++ b/include/media/adv7842.h
@@ -131,6 +131,10 @@ struct adv7842_sdp_io_sync_adjustment {
 	uint16_t hs_width;
 	uint16_t de_beg;
 	uint16_t de_end;
+	uint8_t vs_beg_o;
+	uint8_t vs_beg_e;
+	uint8_t vs_end_o;
+	uint8_t vs_end_e;
 	uint8_t de_v_beg_o;
 	uint8_t de_v_beg_e;
 	uint8_t de_v_end_o;
-- 
1.8.4.rc3

