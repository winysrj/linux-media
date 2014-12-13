Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:50469 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964963AbaLMLyQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Dec 2014 06:54:16 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 08/10] s5k4ecgx: fix sparse warnings
Date: Sat, 13 Dec 2014 12:52:58 +0100
Message-Id: <1418471580-26510-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
References: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/i2c/s5k4ecgx.c:223:16: warning: cast to restricted __be16
drivers/media/i2c/s5k4ecgx.c:223:16: warning: cast to restricted __be16
drivers/media/i2c/s5k4ecgx.c:223:16: warning: cast to restricted __be16
drivers/media/i2c/s5k4ecgx.c:223:16: warning: cast to restricted __be16
drivers/media/i2c/s5k4ecgx.c:344:20: warning: cast to restricted __le32
drivers/media/i2c/s5k4ecgx.c:354:20: warning: cast to restricted __le32
drivers/media/i2c/s5k4ecgx.c:364:24: warning: cast to restricted __le32
drivers/media/i2c/s5k4ecgx.c:366:23: warning: cast to restricted __le16

The get_unaligned_le*() functions return the value using cpu endianness,
so calling le*_to_cpu is wrong.

It hasn't been not noticed because this code has only been run on little
endian systems, so le*_to_cpu doesn't do anything.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/i2c/s5k4ecgx.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/s5k4ecgx.c b/drivers/media/i2c/s5k4ecgx.c
index d1c50c9..7007131 100644
--- a/drivers/media/i2c/s5k4ecgx.c
+++ b/drivers/media/i2c/s5k4ecgx.c
@@ -220,7 +220,7 @@ static int s5k4ecgx_i2c_read(struct i2c_client *client, u16 addr, u16 *val)
 	msg[1].buf = rbuf;
 
 	ret = i2c_transfer(client->adapter, msg, 2);
-	*val = be16_to_cpu(*((u16 *)rbuf));
+	*val = be16_to_cpu(*((__be16 *)rbuf));
 
 	v4l2_dbg(4, debug, client, "i2c_read: 0x%04X : 0x%04x\n", addr, *val);
 
@@ -341,7 +341,7 @@ static int s5k4ecgx_load_firmware(struct v4l2_subdev *sd)
 		v4l2_err(sd, "Failed to read firmware %s\n", S5K4ECGX_FIRMWARE);
 		return err;
 	}
-	regs_num = le32_to_cpu(get_unaligned_le32(fw->data));
+	regs_num = get_unaligned_le32(fw->data);
 
 	v4l2_dbg(3, debug, sd, "FW: %s size %zu register sets %d\n",
 		 S5K4ECGX_FIRMWARE, fw->size, regs_num);
@@ -351,8 +351,7 @@ static int s5k4ecgx_load_firmware(struct v4l2_subdev *sd)
 		err = -EINVAL;
 		goto fw_out;
 	}
-	crc_file = le32_to_cpu(get_unaligned_le32(fw->data +
-						  regs_num * FW_RECORD_SIZE));
+	crc_file = get_unaligned_le32(fw->data + regs_num * FW_RECORD_SIZE);
 	crc = crc32_le(~0, fw->data, regs_num * FW_RECORD_SIZE);
 	if (crc != crc_file) {
 		v4l2_err(sd, "FW: invalid crc (%#x:%#x)\n", crc, crc_file);
@@ -361,9 +360,9 @@ static int s5k4ecgx_load_firmware(struct v4l2_subdev *sd)
 	}
 	ptr = fw->data + FW_RECORD_SIZE;
 	for (i = 1; i < regs_num; i++) {
-		addr = le32_to_cpu(get_unaligned_le32(ptr));
+		addr = get_unaligned_le32(ptr);
 		ptr += sizeof(u32);
-		val = le16_to_cpu(get_unaligned_le16(ptr));
+		val = get_unaligned_le16(ptr);
 		ptr += sizeof(u16);
 		if (addr - addr_inc != 2)
 			err = s5k4ecgx_write(client, addr, val);
-- 
2.1.3

