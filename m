Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48237 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753163AbeB0Pkn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 10:40:43 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@s-opensource.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, g.liakhovetski@gmx.de, bhumirks@gmail.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 01/13] media: tw9910: Fix parameter alignment issue
Date: Tue, 27 Feb 2018 16:40:18 +0100
Message-Id: <1519746030-15407-2-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1519746030-15407-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1519746030-15407-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Align parameters to first open brace.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

---
 drivers/media/i2c/tw9910.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
index cc5d383..70e0ae2 100644
--- a/drivers/media/i2c/tw9910.c
+++ b/drivers/media/i2c/tw9910.c
@@ -533,10 +533,10 @@ static int tw9910_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
 	}
 	if (!ret)
 		ret = i2c_smbus_write_byte_data(client, CROP_HI,
-						((vdelay >> 2) & 0xc0) |
-			((vact >> 4) & 0x30) |
-			((hdelay >> 6) & 0x0c) |
-			((hact >> 8) & 0x03));
+						((vdelay >> 2) & 0xc0)	|
+						((vact >> 4) & 0x30)	|
+						((hdelay >> 6) & 0x0c)	|
+						((hact >> 8) & 0x03));
 	if (!ret)
 		ret = i2c_smbus_write_byte_data(client, VDELAY_LO,
 						vdelay & 0xff);
--
2.7.4
