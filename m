Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps-vb.mhejs.net ([37.28.154.113]:55710 "EHLO vps-vb.mhejs.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbcGBXoH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Jul 2016 19:44:07 -0400
Message-ID: <57784DF2.9050904@maciej.szmigiero.name>
Date: Sun, 03 Jul 2016 01:27:46 +0200
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@kernel.org>
CC: linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH][media] saa7134: fix warm Medion 7134 EEPROM read
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When saa7134 module driving a Medion 7134 card is reloaded reads of this
card EEPROM (required for automatic detection of tuner model) will be
corrupted due to I2C gate in DVB-T demod being left closed.
This sometimes also happens on first saa7134 module load after a warm
reboot.

Fix this by opening this I2C gate before doing EEPROM read during i2c
initialization.

Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
---
This is a modified version of patch submitted a few years ago:
http://www.spinics.net/lists/linux-media/msg24455.html .

That patch was fixing two problems: with TDA9887 detection on cold
board and EEPROM read on warm.

TDA9887 detection issue have been solved since by commit
4aed283c0f7c2 ("switch tuner FMD1216ME_MK3 to analog"),
however EEPROM read issue remained.

This submission fixes this a little bit earlier in the code than previous
attempt (during i2c initialization instead of later board init) so
informational EEPROM read shown in kernel log will also be correct.

 drivers/media/pci/saa7134/saa7134-i2c.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/media/pci/saa7134/saa7134-i2c.c b/drivers/media/pci/saa7134/saa7134-i2c.c
index 8ef6399d794f..bc957528f69f 100644
--- a/drivers/media/pci/saa7134/saa7134-i2c.c
+++ b/drivers/media/pci/saa7134/saa7134-i2c.c
@@ -355,12 +355,43 @@ static struct i2c_client saa7134_client_template = {
 
 /* ----------------------------------------------------------- */
 
+/* On Medion 7134 reading EEPROM needs DVB-T demod i2c gate open */
+static void saa7134_i2c_eeprom_md7134_gate(struct saa7134_dev *dev)
+{
+	u8 subaddr = 0x7, dmdregval;
+	u8 data[2];
+	int ret;
+	struct i2c_msg i2cgatemsg_r[] = { {.addr = 0x08, .flags = 0,
+					   .buf = &subaddr, .len = 1},
+					  {.addr = 0x08,
+					   .flags = I2C_M_RD,
+					   .buf = &dmdregval, .len = 1}
+					};
+	struct i2c_msg i2cgatemsg_w[] = { {.addr = 0x08, .flags = 0,
+					   .buf = data, .len = 2} };
+
+	ret = i2c_transfer(&dev->i2c_adap, i2cgatemsg_r, 2);
+	if ((ret == 2) && (dmdregval & 0x2)) {
+		pr_debug("%s: DVB-T demod i2c gate was left closed\n",
+			 dev->name);
+
+		data[0] = subaddr;
+		data[1] = (dmdregval & ~0x2);
+		if (i2c_transfer(&dev->i2c_adap, i2cgatemsg_w, 1) != 1)
+			pr_err("%s: EEPROM i2c gate open failure\n",
+			  dev->name);
+	}
+}
+
 static int
 saa7134_i2c_eeprom(struct saa7134_dev *dev, unsigned char *eedata, int len)
 {
 	unsigned char buf;
 	int i,err;
 
+	if (dev->board == SAA7134_BOARD_MD7134)
+		saa7134_i2c_eeprom_md7134_gate(dev);
+
 	dev->i2c_client.addr = 0xa0 >> 1;
 	buf = 0;
 	if (1 != (err = i2c_master_send(&dev->i2c_client,&buf,1))) {
