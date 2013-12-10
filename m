Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3112 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab3LJPGH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 10:06:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 10/22] adv7842: set default input in platform-data
Date: Tue, 10 Dec 2013 16:03:56 +0100
Message-Id: <c5e5261e413caf2e7ebb3a68b9924a6a6d92e016.1386687810.git.hans.verkuil@cisco.com>
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
 drivers/media/i2c/adv7842.c | 2 +-
 include/media/adv7842.h     | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 3e8d7cc..4fa2e23 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2802,7 +2802,7 @@ static int adv7842_probe(struct i2c_client *client,
 	state->connector_hdmi = pdata->connector_hdmi;
 	state->mode = pdata->mode;
 
-	state->hdmi_port_a = true;
+	state->hdmi_port_a = pdata->input == ADV7842_SELECT_HDMI_PORT_A;
 
 	/* i2c access to adv7842? */
 	rev = adv_smbus_read_byte_data_check(client, 0xea, false) << 8 |
diff --git a/include/media/adv7842.h b/include/media/adv7842.h
index 5327ba3..c12de2d 100644
--- a/include/media/adv7842.h
+++ b/include/media/adv7842.h
@@ -160,6 +160,9 @@ struct adv7842_platform_data {
 	/* Default mode */
 	enum adv7842_mode mode;
 
+	/* Default input */
+	unsigned input;
+
 	/* Video standard */
 	enum adv7842_vid_std_select vid_std_select;
 
-- 
1.8.4.rc3

