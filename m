Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:33582 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756911AbZJBBeV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Oct 2009 21:34:21 -0400
Message-Id: <20091002012426.941628097@mini.kroah.org>
Date: Thu, 01 Oct 2009 18:17:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Brian Rogers <brian@xyzw.org>, linux-media@vger.kernel.org
Subject: [126/136] saa7134: ir-kbd-i2c init data needs a persistent object
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=saa7134-ir-kbd-i2c-init-data-needs-a-persistent-object.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Brian Rogers <brian@xyzw.org>

commit 7aedd5ec87686c557d48584d69ad880c11a0984d upstream.

Tested on MSI TV@nywhere Plus.

Original commit message:

ir-kbd-i2c's ir_probe() function can be called much later (i.e. at
ir-kbd-i2c module load), than the lifetime of a struct IR_i2c_init_data
allocated off of the stack in cx18_i2c_new_ir() at registration time.
Make sure we pass a pointer to a persistent IR_i2c_init_data object at
i2c registration time.

Thanks to Brian Rogers, Dustin Mitchell, Andy Walls and Jean Delvare to
rise this question.

Before this patch, if ir-kbd-i2c were probed after SAA7134, trash data
were used.

Compile tested only, but the patch is identical to em28xx one. So, it
should work properly.

Original-patch-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
[brian@xyzw.org: backported for 2.6.31]
Signed-off-by: Brian Rogers <brian@xyzw.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/saa7134/saa7134-input.c |   56 +++++++++++++---------------
 drivers/media/video/saa7134/saa7134.h       |    4 ++
 2 files changed, 31 insertions(+), 29 deletions(-)

--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -584,6 +584,10 @@ struct saa7134_dev {
 	int                        nosignal;
 	unsigned int               insuspend;
 
+	/* I2C keyboard data */
+	struct i2c_board_info      info;
+	struct IR_i2c_init_data    init_data;
+
 	/* SAA7134_MPEG_* */
 	struct saa7134_ts          ts;
 	struct saa7134_dmaqueue    ts_q;
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -684,8 +684,6 @@ void saa7134_input_fini(struct saa7134_d
 
 void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 {
-	struct i2c_board_info info;
-	struct IR_i2c_init_data init_data;
 	const unsigned short addr_list[] = {
 		0x7a, 0x47, 0x71, 0x2d,
 		I2C_CLIENT_END
@@ -705,32 +703,32 @@ void saa7134_probe_i2c_ir(struct saa7134
 		return;
 	}
 
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	memset(&init_data, 0, sizeof(struct IR_i2c_init_data));
-	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
+	memset(&dev->info, 0, sizeof(dev->info));
+	memset(&dev->init_data, 0, sizeof(dev->init_data));
+	strlcpy(dev->info.type, "ir_video", I2C_NAME_SIZE);
 
 	switch (dev->board) {
 	case SAA7134_BOARD_PINNACLE_PCTV_110i:
 	case SAA7134_BOARD_PINNACLE_PCTV_310i:
-		init_data.name = "Pinnacle PCTV";
+		dev->init_data.name = "Pinnacle PCTV";
 		if (pinnacle_remote == 0) {
-			init_data.get_key = get_key_pinnacle_color;
-			init_data.ir_codes = ir_codes_pinnacle_color;
+			dev->init_data.get_key = get_key_pinnacle_color;
+			dev->init_data.ir_codes = ir_codes_pinnacle_color;
 		} else {
-			init_data.get_key = get_key_pinnacle_grey;
-			init_data.ir_codes = ir_codes_pinnacle_grey;
+			dev->init_data.get_key = get_key_pinnacle_grey;
+			dev->init_data.ir_codes = ir_codes_pinnacle_grey;
 		}
 		break;
 	case SAA7134_BOARD_UPMOST_PURPLE_TV:
-		init_data.name = "Purple TV";
-		init_data.get_key = get_key_purpletv;
-		init_data.ir_codes = ir_codes_purpletv;
+		dev->init_data.name = "Purple TV";
+		dev->init_data.get_key = get_key_purpletv;
+		dev->init_data.ir_codes = ir_codes_purpletv;
 		break;
 	case SAA7134_BOARD_MSI_TVATANYWHERE_PLUS:
-		init_data.name = "MSI TV@nywhere Plus";
-		init_data.get_key = get_key_msi_tvanywhere_plus;
-		init_data.ir_codes = ir_codes_msi_tvanywhere_plus;
-		info.addr = 0x30;
+		dev->init_data.name = "MSI TV@nywhere Plus";
+		dev->init_data.get_key = get_key_msi_tvanywhere_plus;
+		dev->init_data.ir_codes = ir_codes_msi_tvanywhere_plus;
+		dev->info.addr = 0x30;
 		/* MSI TV@nywhere Plus controller doesn't seem to
 		   respond to probes unless we read something from
 		   an existing device. Weird...
@@ -741,9 +739,9 @@ void saa7134_probe_i2c_ir(struct saa7134
 			(1 == rc) ? "yes" : "no");
 		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
-		init_data.name = "HVR 1110";
-		init_data.get_key = get_key_hvr1110;
-		init_data.ir_codes = ir_codes_hauppauge_new;
+		dev->init_data.name = "HVR 1110";
+		dev->init_data.get_key = get_key_hvr1110;
+		dev->init_data.ir_codes = ir_codes_hauppauge_new;
 		break;
 	case SAA7134_BOARD_BEHOLD_607FM_MK3:
 	case SAA7134_BOARD_BEHOLD_607FM_MK5:
@@ -757,26 +755,26 @@ void saa7134_probe_i2c_ir(struct saa7134
 	case SAA7134_BOARD_BEHOLD_M63:
 	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
 	case SAA7134_BOARD_BEHOLD_H6:
-		init_data.name = "BeholdTV";
-		init_data.get_key = get_key_beholdm6xx;
-		init_data.ir_codes = ir_codes_behold;
+		dev->init_data.name = "BeholdTV";
+		dev->init_data.get_key = get_key_beholdm6xx;
+		dev->init_data.ir_codes = ir_codes_behold;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_501:
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
-		info.addr = 0x40;
+		dev->info.addr = 0x40;
 		break;
 	}
 
-	if (init_data.name)
-		info.platform_data = &init_data;
+	if (dev->init_data.name)
+		dev->info.platform_data = &dev->init_data;
 	/* No need to probe if address is known */
-	if (info.addr) {
-		i2c_new_device(&dev->i2c_adap, &info);
+	if (dev->info.addr) {
+		i2c_new_device(&dev->i2c_adap, &dev->info);
 		return;
 	}
 
 	/* Address not known, fallback to probing */
-	i2c_new_probed_device(&dev->i2c_adap, &info, addr_list);
+	i2c_new_probed_device(&dev->i2c_adap, &dev->info, addr_list);
 }
 
 static int saa7134_rc5_irq(struct saa7134_dev *dev)


