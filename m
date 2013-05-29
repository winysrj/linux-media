Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2742 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965542Ab3E2LAd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:00:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv1 04/38] saa7115: add back the dropped 'found' message.
Date: Wed, 29 May 2013 12:59:37 +0200
Message-Id: <1369825211-29770-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The saa7115 driver used to show a 'chip found' message during probe. This
was accidentally dropped during recent commits. Add it back as it is quite
useful.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/saa7115.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 18cf0bf..4daa81c 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1735,6 +1735,8 @@ static int saa711x_probe(struct i2c_client *client,
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &saa711x_ops);
 
+	v4l_info(client, "%s found @ 0x%x (%s)\n", name,
+		 client->addr << 1, client->adapter->name);
 	hdl = &state->hdl;
 	v4l2_ctrl_handler_init(hdl, 6);
 	/* add in ascending ID order */
-- 
1.7.10.4

