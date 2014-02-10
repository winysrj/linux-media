Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3151 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbaBJLJU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 06:09:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 1/5] radio-usb-si4713: make array of structs const.
Date: Mon, 10 Feb 2014 12:08:43 +0100
Message-Id: <1392030527-32661-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392030527-32661-1-git-send-email-hverkuil@xs4all.nl>
References: <1392030527-32661-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The start_seq[] should be const.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/si4713/radio-usb-si4713.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/si4713/radio-usb-si4713.c b/drivers/media/radio/si4713/radio-usb-si4713.c
index 779855b..86502b2 100644
--- a/drivers/media/radio/si4713/radio-usb-si4713.c
+++ b/drivers/media/radio/si4713/radio-usb-si4713.c
@@ -223,7 +223,7 @@ struct si4713_start_seq_table {
  * (0x03): Get serial number of the board (Response : CB000-00-00)
  * (0x06, 0x03, 0x03, 0x08, 0x01, 0x0f) : Get Component revision
  */
-static struct si4713_start_seq_table start_seq[] = {
+static const struct si4713_start_seq_table start_seq[] = {
 
 	{ 1, { 0x03 } },
 	{ 2, { 0x32, 0x7f } },
@@ -261,7 +261,7 @@ static int si4713_start_seq(struct si4713_usb_device *radio)
 
 	for (i = 0; i < ARRAY_SIZE(start_seq); i++) {
 		int len = start_seq[i].len;
-		u8 *payload = start_seq[i].payload;
+		const u8 *payload = start_seq[i].payload;
 
 		memcpy(radio->buffer + 1, payload, len);
 		memset(radio->buffer + len + 1, 0, BUFFER_LENGTH - 1 - len);
-- 
1.8.5.2

