Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:32964 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933233AbbFJHsb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 03:48:31 -0400
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Christopher Reimer <linux@creimer.net>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] [media] ddbridge: fix wait_event_timeout return handling
Date: Wed, 10 Jun 2015 09:40:02 +0200
Message-Id: <1433922002-22971-1-git-send-email-hofrat@osadl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

API conformance testing for completions with coccinelle spatches are being
used to locate API usage inconsistencies:
./drivers/media/pci/ddbridge/ddbridge-core.c:89 
        incorrect check for negative return

Return type of wait_event_timeout is signed long not int and the 
return type is >=0 always thus the negative check is unnecessary..
As stat is used here exclusively its type is simply changed and the
negative return check dropped.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Patch was compile tested with x86_64_defconfig + CONFIG_MEDIA_SUPPORT=m,
MEDIA_DIGITAL_TV_SUPPORT=y, CONFIG_MEDIA_PCI_SUPPORT=y, 
CONFIG_DVB_DDBRIDGE=m

Patch is against 4.1-rc7 (localversion-next is -next-20150609)

 drivers/media/pci/ddbridge/ddbridge-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 9e3492e..7f1b3b3 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -81,13 +81,13 @@ static int i2c_read_reg16(struct i2c_adapter *adapter, u8 adr,
 static int ddb_i2c_cmd(struct ddb_i2c *i2c, u32 adr, u32 cmd)
 {
 	struct ddb *dev = i2c->dev;
-	int stat;
+	long stat;
 	u32 val;
 
 	i2c->done = 0;
 	ddbwritel((adr << 9) | cmd, i2c->regs + I2C_COMMAND);
 	stat = wait_event_timeout(i2c->wq, i2c->done == 1, HZ);
-	if (stat <= 0) {
+	if (stat == 0) {
 		printk(KERN_ERR "I2C timeout\n");
 		{ /* MSI debugging*/
 			u32 istat = ddbreadl(INTERRUPT_STATUS);
-- 
1.7.10.4

