Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:49953 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385AbcF0KZs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 06:25:48 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Florian Echtler <floe@butterbrot.org>,
	Nick Dyer <nick.dyer@itdev.co.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] sur40: drop unnecessary format description
Message-ID: <74bf380b-0c5f-8f55-5340-afd4db77e82e@xs4all.nl>
Date: Mon, 27 Jun 2016 12:25:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't fill in the format description. This is now done in the V4L2 core to ensure
consistent descriptions.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 880c40b..5f1617b 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -793,7 +793,6 @@ static int sur40_vidioc_enum_fmt(struct file *file, void *priv,
 {
 	if (f->index != 0)
 		return -EINVAL;
-	strlcpy(f->description, "8-bit greyscale", sizeof(f->description));
 	f->pixelformat = V4L2_PIX_FMT_GREY;
 	f->flags = 0;
 	return 0;
