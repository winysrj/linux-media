Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:37715 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964963AbaLMLyd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Dec 2014 06:54:33 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 10/10] s5k5baf: fix sparse warnings
Date: Sat, 13 Dec 2014 12:53:00 +0100
Message-Id: <1418471580-26510-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
References: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/i2c/s5k5baf.c:1796:33: warning: duplicate const
drivers/media/i2c/s5k5baf.c:379:24: warning: cast to restricted __le16
drivers/media/i2c/s5k5baf.c:437:11: warning: incorrect type in assignment (different base types)
drivers/media/i2c/s5k5baf.c:445:16: warning: incorrect type in return expression (different base types)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/i2c/s5k5baf.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 60a74d8..a3d7d03 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -353,7 +353,7 @@ static struct v4l2_rect s5k5baf_cis_rect = {
  *
  */
 static int s5k5baf_fw_parse(struct device *dev, struct s5k5baf_fw **fw,
-			    size_t count, const u16 *data)
+			    size_t count, const __le16 *data)
 {
 	struct s5k5baf_fw *f;
 	u16 *d, i, *end;
@@ -421,6 +421,7 @@ static u16 s5k5baf_i2c_read(struct s5k5baf *state, u16 addr)
 {
 	struct i2c_client *c = v4l2_get_subdevdata(&state->sd);
 	__be16 w, r;
+	u16 res;
 	struct i2c_msg msg[] = {
 		{ .addr = c->addr, .flags = 0,
 		  .len = 2, .buf = (u8 *)&w },
@@ -434,15 +435,15 @@ static u16 s5k5baf_i2c_read(struct s5k5baf *state, u16 addr)
 
 	w = cpu_to_be16(addr);
 	ret = i2c_transfer(c->adapter, msg, 2);
-	r = be16_to_cpu(r);
+	res = be16_to_cpu(r);
 
-	v4l2_dbg(3, debug, c, "i2c_read: 0x%04x : 0x%04x\n", addr, r);
+	v4l2_dbg(3, debug, c, "i2c_read: 0x%04x : 0x%04x\n", addr, res);
 
 	if (ret != 2) {
 		v4l2_err(c, "i2c_read: error during transfer (%d)\n", ret);
 		state->error = ret;
 	}
-	return r;
+	return res;
 }
 
 static void s5k5baf_i2c_write(struct s5k5baf *state, u16 addr, u16 val)
@@ -1037,7 +1038,7 @@ static int s5k5baf_load_setfile(struct s5k5baf *state)
 	}
 
 	ret = s5k5baf_fw_parse(&c->dev, &state->fw, fw->size / 2,
-			       (u16 *)fw->data);
+			       (__le16 *)fw->data);
 
 	release_firmware(fw);
 
@@ -1793,7 +1794,7 @@ static const struct v4l2_subdev_ops s5k5baf_subdev_ops = {
 
 static int s5k5baf_configure_gpios(struct s5k5baf *state)
 {
-	static const char const *name[] = { "S5K5BAF_STBY", "S5K5BAF_RST" };
+	static const char * const name[] = { "S5K5BAF_STBY", "S5K5BAF_RST" };
 	struct i2c_client *c = v4l2_get_subdevdata(&state->sd);
 	struct s5k5baf_gpio *g = state->gpios;
 	int ret, i;
-- 
2.1.3

