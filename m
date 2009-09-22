Return-path: <linux-media-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:49489 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963AbZIVSe0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 14:34:26 -0400
Date: Tue, 22 Sep 2009 20:34:29 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, Vaibhav Hiremath <hvaibhav@ti.com>,
	Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] media/tvp514x: recognize the error case in
 tvp514x_read_reg()
Message-ID: <20090922183429.GA8585@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

i2c_smbus_read_byte_data() returns a negative value on error. It is very
likely to be != -1 (-EPERM).

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
Noticed by strange results during signal beeing pending.

 drivers/media/video/tvp514x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
index 2443726..26b4e71 100644
--- a/drivers/media/video/tvp514x.c
+++ b/drivers/media/video/tvp514x.c
@@ -272,7 +272,7 @@ static int tvp514x_read_reg(struct v4l2_subdev *sd, u8 reg)
 read_again:
 
 	err = i2c_smbus_read_byte_data(client, reg);
-	if (err == -1) {
+	if (err < 0) {
 		if (retry <= I2C_RETRY_COUNT) {
 			v4l2_warn(sd, "Read: retry ... %d\n", retry);
 			retry++;
-- 
1.6.3.3

