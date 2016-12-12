Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:48911 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932328AbcLLVNs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 16:13:48 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>,
        Sifan Naeem <sifan.naeem@imgtec.com>
Subject: [PATCH v5 02/18] [media] img-ir: use new wakeup_protocols sysfs mechanism
Date: Mon, 12 Dec 2016 21:13:43 +0000
Message-Id: <074994409ca834b6fcd950e7da60456247f12ce5.1481575826.git.sean@mess.org>
In-Reply-To: <cover.1481575826.git.sean@mess.org>
References: <cover.1481575826.git.sean@mess.org>
In-Reply-To: <cover.1481575826.git.sean@mess.org>
References: <cover.1481575826.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rather than guessing what variant a scancode is from its length,
use the new wakeup_protocol.

Signed-off-by: Sean Young <sean@mess.org>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Sifan Naeem <sifan.naeem@imgtec.com>
---
 drivers/media/rc/img-ir/img-ir-hw.c    |  2 +-
 drivers/media/rc/img-ir/img-ir-hw.h    |  2 +-
 drivers/media/rc/img-ir/img-ir-jvc.c   |  2 +-
 drivers/media/rc/img-ir/img-ir-nec.c   |  6 +++---
 drivers/media/rc/img-ir/img-ir-rc5.c   |  2 +-
 drivers/media/rc/img-ir/img-ir-rc6.c   |  2 +-
 drivers/media/rc/img-ir/img-ir-sanyo.c |  2 +-
 drivers/media/rc/img-ir/img-ir-sharp.c |  2 +-
 drivers/media/rc/img-ir/img-ir-sony.c  | 11 +++--------
 9 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 1a0811d..841d9d7 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -488,7 +488,7 @@ static int img_ir_set_filter(struct rc_dev *dev, enum rc_filter_type type,
 	/* convert scancode filter to raw filter */
 	filter.minlen = 0;
 	filter.maxlen = ~0;
-	ret = hw->decoder->filter(sc_filter, &filter, hw->enabled_protocols);
+	ret = hw->decoder->filter(sc_filter, &filter, dev->wakeup_protocol);
 	if (ret)
 		goto unlock;
 	dev_dbg(priv->dev, "IR raw %sfilter=%016llx & %016llx\n",
diff --git a/drivers/media/rc/img-ir/img-ir-hw.h b/drivers/media/rc/img-ir/img-ir-hw.h
index 91a2977..e1959ddc 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.h
+++ b/drivers/media/rc/img-ir/img-ir-hw.h
@@ -179,7 +179,7 @@ struct img_ir_decoder {
 	int (*scancode)(int len, u64 raw, u64 enabled_protocols,
 			struct img_ir_scancode_req *request);
 	int (*filter)(const struct rc_scancode_filter *in,
-		      struct img_ir_filter *out, u64 protocols);
+		      struct img_ir_filter *out, enum rc_type protocol);
 };
 
 extern struct img_ir_decoder img_ir_nec;
diff --git a/drivers/media/rc/img-ir/img-ir-jvc.c b/drivers/media/rc/img-ir/img-ir-jvc.c
index d3e2fc0..10b302c 100644
--- a/drivers/media/rc/img-ir/img-ir-jvc.c
+++ b/drivers/media/rc/img-ir/img-ir-jvc.c
@@ -30,7 +30,7 @@ static int img_ir_jvc_scancode(int len, u64 raw, u64 enabled_protocols,
 
 /* Convert JVC scancode to JVC data filter */
 static int img_ir_jvc_filter(const struct rc_scancode_filter *in,
-			     struct img_ir_filter *out, u64 protocols)
+			     struct img_ir_filter *out, enum rc_type protocol)
 {
 	unsigned int cust, data;
 	unsigned int cust_m, data_m;
diff --git a/drivers/media/rc/img-ir/img-ir-nec.c b/drivers/media/rc/img-ir/img-ir-nec.c
index 0931493..fff00d4 100644
--- a/drivers/media/rc/img-ir/img-ir-nec.c
+++ b/drivers/media/rc/img-ir/img-ir-nec.c
@@ -54,7 +54,7 @@ static int img_ir_nec_scancode(int len, u64 raw, u64 enabled_protocols,
 
 /* Convert NEC scancode to NEC data filter */
 static int img_ir_nec_filter(const struct rc_scancode_filter *in,
-			     struct img_ir_filter *out, u64 protocols)
+			     struct img_ir_filter *out, enum rc_type protocol)
 {
 	unsigned int addr, addr_inv, data, data_inv;
 	unsigned int addr_m, addr_inv_m, data_m, data_inv_m;
@@ -62,7 +62,7 @@ static int img_ir_nec_filter(const struct rc_scancode_filter *in,
 	data       = in->data & 0xff;
 	data_m     = in->mask & 0xff;
 
-	if ((in->data | in->mask) & 0xff000000) {
+	if (protocol == RC_TYPE_NEC32) {
 		/* 32-bit NEC (used by Apple and TiVo remotes) */
 		/* scan encoding: as transmitted, MSBit = first received bit */
 		addr       = bitrev8(in->data >> 24);
@@ -73,7 +73,7 @@ static int img_ir_nec_filter(const struct rc_scancode_filter *in,
 		data_m     = bitrev8(in->mask >>  8);
 		data_inv   = bitrev8(in->data >>  0);
 		data_inv_m = bitrev8(in->mask >>  0);
-	} else if ((in->data | in->mask) & 0x00ff0000) {
+	} else if (protocol == RC_TYPE_NECX) {
 		/* Extended NEC */
 		/* scan encoding AAaaDD */
 		addr       = (in->data >> 16) & 0xff;
diff --git a/drivers/media/rc/img-ir/img-ir-rc5.c b/drivers/media/rc/img-ir/img-ir-rc5.c
index a8a28a3..24a6bcf 100644
--- a/drivers/media/rc/img-ir/img-ir-rc5.c
+++ b/drivers/media/rc/img-ir/img-ir-rc5.c
@@ -41,7 +41,7 @@ static int img_ir_rc5_scancode(int len, u64 raw, u64 enabled_protocols,
 
 /* Convert RC5 scancode to RC5 data filter */
 static int img_ir_rc5_filter(const struct rc_scancode_filter *in,
-				 struct img_ir_filter *out, u64 protocols)
+			     struct img_ir_filter *out, enum rc_type protocol)
 {
 	/* Not supported by the hw. */
 	return -EINVAL;
diff --git a/drivers/media/rc/img-ir/img-ir-rc6.c b/drivers/media/rc/img-ir/img-ir-rc6.c
index de1e275..451e2ef8 100644
--- a/drivers/media/rc/img-ir/img-ir-rc6.c
+++ b/drivers/media/rc/img-ir/img-ir-rc6.c
@@ -62,7 +62,7 @@ static int img_ir_rc6_scancode(int len, u64 raw, u64 enabled_protocols,
 
 /* Convert RC6 scancode to RC6 data filter */
 static int img_ir_rc6_filter(const struct rc_scancode_filter *in,
-				 struct img_ir_filter *out, u64 protocols)
+			     struct img_ir_filter *out, enum rc_type protocol)
 {
 	/* Not supported by the hw. */
 	return -EINVAL;
diff --git a/drivers/media/rc/img-ir/img-ir-sanyo.c b/drivers/media/rc/img-ir/img-ir-sanyo.c
index f394994..8f542bd 100644
--- a/drivers/media/rc/img-ir/img-ir-sanyo.c
+++ b/drivers/media/rc/img-ir/img-ir-sanyo.c
@@ -51,7 +51,7 @@ static int img_ir_sanyo_scancode(int len, u64 raw, u64 enabled_protocols,
 
 /* Convert Sanyo scancode to Sanyo data filter */
 static int img_ir_sanyo_filter(const struct rc_scancode_filter *in,
-			       struct img_ir_filter *out, u64 protocols)
+			       struct img_ir_filter *out, enum rc_type protocol)
 {
 	unsigned int addr, addr_inv, data, data_inv;
 	unsigned int addr_m, data_m;
diff --git a/drivers/media/rc/img-ir/img-ir-sharp.c b/drivers/media/rc/img-ir/img-ir-sharp.c
index fe5acc4..c8b4e9b 100644
--- a/drivers/media/rc/img-ir/img-ir-sharp.c
+++ b/drivers/media/rc/img-ir/img-ir-sharp.c
@@ -39,7 +39,7 @@ static int img_ir_sharp_scancode(int len, u64 raw, u64 enabled_protocols,
 
 /* Convert Sharp scancode to Sharp data filter */
 static int img_ir_sharp_filter(const struct rc_scancode_filter *in,
-			       struct img_ir_filter *out, u64 protocols)
+			       struct img_ir_filter *out, enum rc_type protocol)
 {
 	unsigned int addr, cmd, exp = 0, chk = 0;
 	unsigned int addr_m, cmd_m, exp_m = 0, chk_m = 0;
diff --git a/drivers/media/rc/img-ir/img-ir-sony.c b/drivers/media/rc/img-ir/img-ir-sony.c
index 7f7375f..ecae41c 100644
--- a/drivers/media/rc/img-ir/img-ir-sony.c
+++ b/drivers/media/rc/img-ir/img-ir-sony.c
@@ -55,7 +55,7 @@ static int img_ir_sony_scancode(int len, u64 raw, u64 enabled_protocols,
 
 /* Convert NEC scancode to NEC data filter */
 static int img_ir_sony_filter(const struct rc_scancode_filter *in,
-			      struct img_ir_filter *out, u64 protocols)
+			      struct img_ir_filter *out, enum rc_type protocol)
 {
 	unsigned int dev, subdev, func;
 	unsigned int dev_m, subdev_m, func_m;
@@ -68,19 +68,14 @@ static int img_ir_sony_filter(const struct rc_scancode_filter *in,
 	func     = (in->data >> 0)  & 0x7f;
 	func_m   = (in->mask >> 0)  & 0x7f;
 
-	if (subdev & subdev_m) {
+	if (protocol == RC_TYPE_SONY20) {
 		/* can't encode subdev and higher device bits */
 		if (dev & dev_m & 0xe0)
 			return -EINVAL;
-		/* subdevice (extended) bits only in 20 bit encoding */
-		if (!(protocols & RC_BIT_SONY20))
-			return -EINVAL;
 		len = 20;
 		dev_m &= 0x1f;
-	} else if (dev & dev_m & 0xe0) {
+	} else if (protocol == RC_TYPE_SONY15) {
 		/* upper device bits only in 15 bit encoding */
-		if (!(protocols & RC_BIT_SONY15))
-			return -EINVAL;
 		len = 15;
 		subdev_m = 0;
 	} else {
-- 
2.9.3

