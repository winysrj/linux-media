Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:52943 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756449AbZJALno convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2009 07:43:44 -0400
Date: Thu, 1 Oct 2009 13:43:43 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@radix.net>
Cc: =?UTF-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>,
	linux-kernel@vger.kernel.org, LMML <linux-media@vger.kernel.org>
Subject: Re: [2.6.31] ir-kbd-i2c oops.
Message-ID: <20091001134343.30e7cd98@hyperion.delvare>
In-Reply-To: <1254354727.4771.13.camel@palomino.walls.org>
References: <200909160300.28382.pluto@agmk.net>
	<200909301352.28362.pluto@agmk.net>
	<20090930142516.23eb09df@hyperion.delvare>
	<200909301822.29010.pluto@agmk.net>
	<1254354727.4771.13.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 30 Sep 2009 19:52:07 -0400, Andy Walls wrote:
> On Wed, 2009-09-30 at 18:22 +0200, Paweł Sikora wrote:
> > [   11.701267] ir_probe: addr=0x47
> > [   11.701271] ir_probe: [before override] ir_codes=(null), name=SAA713x remote, get_key=(null)
> > [   11.701273] ir_probe: [after  override] ir_codes=ffffffff814edde0, name=-q, get_key=ffffffff81479204
> > [   11.701276] ir_input_init: dev=ffff880227177000, ir=ffff880221186018, ir_type=99, ir_codes=ffffffff814edde0
> > [   11.701278] ir_input_init: [i=0] Setting bit 1768059695 of dev->keybit
> 
> 1768059695 = 0x6962732f = 'ibs/'
> 
> That doesn't seem right for ir->ir_codes[0] ...

You're right. And name=-q doesn't seem right either. So it would seem
that saa7134-input is passing garbage over to ir_input_init()... or the
data is corrupted meanwhile.

Pawel, please give a try to the following patch. Please keep the debug
patches apply too, in case we need additional info.

 drivers/media/video/saa7134/saa7134-input.c |   41 +++++++++++++--------------
 drivers/media/video/saa7134/saa7134.h       |    3 +
 2 files changed, 23 insertions(+), 21 deletions(-)

--- linux-2.6.31.orig/drivers/media/video/saa7134/saa7134-input.c	2009-09-10 10:08:22.000000000 +0200
+++ linux-2.6.31/drivers/media/video/saa7134/saa7134-input.c	2009-10-01 13:38:38.000000000 +0200
@@ -685,7 +685,6 @@ void saa7134_input_fini(struct saa7134_d
 void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 {
 	struct i2c_board_info info;
-	struct IR_i2c_init_data init_data;
 	const unsigned short addr_list[] = {
 		0x7a, 0x47, 0x71, 0x2d,
 		I2C_CLIENT_END
@@ -706,30 +705,30 @@ void saa7134_probe_i2c_ir(struct saa7134
 	}
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
-	memset(&init_data, 0, sizeof(struct IR_i2c_init_data));
+	memset(&dev->ir_init_data, 0, sizeof(struct IR_i2c_init_data));
 	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
 
 	switch (dev->board) {
 	case SAA7134_BOARD_PINNACLE_PCTV_110i:
 	case SAA7134_BOARD_PINNACLE_PCTV_310i:
-		init_data.name = "Pinnacle PCTV";
+		dev->ir_init_data.name = "Pinnacle PCTV";
 		if (pinnacle_remote == 0) {
-			init_data.get_key = get_key_pinnacle_color;
-			init_data.ir_codes = ir_codes_pinnacle_color;
+			dev->ir_init_data.get_key = get_key_pinnacle_color;
+			dev->ir_init_data.ir_codes = ir_codes_pinnacle_color;
 		} else {
-			init_data.get_key = get_key_pinnacle_grey;
-			init_data.ir_codes = ir_codes_pinnacle_grey;
+			dev->ir_init_data.get_key = get_key_pinnacle_grey;
+			dev->ir_init_data.ir_codes = ir_codes_pinnacle_grey;
 		}
 		break;
 	case SAA7134_BOARD_UPMOST_PURPLE_TV:
-		init_data.name = "Purple TV";
-		init_data.get_key = get_key_purpletv;
-		init_data.ir_codes = ir_codes_purpletv;
+		dev->ir_init_data.name = "Purple TV";
+		dev->ir_init_data.get_key = get_key_purpletv;
+		dev->ir_init_data.ir_codes = ir_codes_purpletv;
 		break;
 	case SAA7134_BOARD_MSI_TVATANYWHERE_PLUS:
-		init_data.name = "MSI TV@nywhere Plus";
-		init_data.get_key = get_key_msi_tvanywhere_plus;
-		init_data.ir_codes = ir_codes_msi_tvanywhere_plus;
+		dev->ir_init_data.name = "MSI TV@nywhere Plus";
+		dev->ir_init_data.get_key = get_key_msi_tvanywhere_plus;
+		dev->ir_init_data.ir_codes = ir_codes_msi_tvanywhere_plus;
 		info.addr = 0x30;
 		/* MSI TV@nywhere Plus controller doesn't seem to
 		   respond to probes unless we read something from
@@ -741,9 +740,9 @@ void saa7134_probe_i2c_ir(struct saa7134
 			(1 == rc) ? "yes" : "no");
 		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
-		init_data.name = "HVR 1110";
-		init_data.get_key = get_key_hvr1110;
-		init_data.ir_codes = ir_codes_hauppauge_new;
+		dev->ir_init_data.name = "HVR 1110";
+		dev->ir_init_data.get_key = get_key_hvr1110;
+		dev->ir_init_data.ir_codes = ir_codes_hauppauge_new;
 		break;
 	case SAA7134_BOARD_BEHOLD_607FM_MK3:
 	case SAA7134_BOARD_BEHOLD_607FM_MK5:
@@ -757,9 +756,9 @@ void saa7134_probe_i2c_ir(struct saa7134
 	case SAA7134_BOARD_BEHOLD_M63:
 	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
 	case SAA7134_BOARD_BEHOLD_H6:
-		init_data.name = "BeholdTV";
-		init_data.get_key = get_key_beholdm6xx;
-		init_data.ir_codes = ir_codes_behold;
+		dev->ir_init_data.name = "BeholdTV";
+		dev->ir_init_data.get_key = get_key_beholdm6xx;
+		dev->ir_init_data.ir_codes = ir_codes_behold;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_501:
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
@@ -767,8 +766,8 @@ void saa7134_probe_i2c_ir(struct saa7134
 		break;
 	}
 
-	if (init_data.name)
-		info.platform_data = &init_data;
+	if (dev->ir_init_data.name)
+		info.platform_data = &dev->ir_init_data;
 	/* No need to probe if address is known */
 	if (info.addr) {
 		i2c_new_device(&dev->i2c_adap, &info);
--- linux-2.6.31.orig/drivers/media/video/saa7134/saa7134.h	2009-09-10 10:08:22.000000000 +0200
+++ linux-2.6.31/drivers/media/video/saa7134/saa7134.h	2009-10-01 13:36:53.000000000 +0200
@@ -584,6 +584,9 @@ struct saa7134_dev {
 	int                        nosignal;
 	unsigned int               insuspend;
 
+	/* I2C keyboard data */
+	struct IR_i2c_init_data    ir_init_data;
+
 	/* SAA7134_MPEG_* */
 	struct saa7134_ts          ts;
 	struct saa7134_dmaqueue    ts_q;

-- 
Jean Delvare
