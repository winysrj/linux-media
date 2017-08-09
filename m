Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47770 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751429AbdHIJhi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Aug 2017 05:37:38 -0400
From: Javier Martinez Canillas <javierm@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javierm@redhat.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: i2c: adv748x: Export I2C device table entries as module aliases
Date: Wed,  9 Aug 2017 11:37:30 +0200
Message-Id: <20170809093731.3572-1-javierm@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The I2C core always reports a MODALIAS of the form i2c:<foo> even if the
device was registered via OF, and the driver is only exporting the OF ID
table entries as module aliases.

So if the driver is built as module, autoload won't work since udev/kmod
won't be able to match the registered OF device with its driver module.

Before this patch:

$ modinfo drivers/media/i2c/adv748x/adv748x.ko | grep alias
alias:          of:N*T*Cadi,adv7482C*
alias:          of:N*T*Cadi,adv7482
alias:          of:N*T*Cadi,adv7481C*
alias:          of:N*T*Cadi,adv7481

After this patch:

modinfo drivers/media/i2c/adv748x/adv748x.ko | grep alias
alias:          of:N*T*Cadi,adv7482C*
alias:          of:N*T*Cadi,adv7482
alias:          of:N*T*Cadi,adv7481C*
alias:          of:N*T*Cadi,adv7481
alias:          i2c:adv7482
alias:          i2c:adv7481

Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
---

 drivers/media/i2c/adv748x/adv748x-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index aeb6ae80cb18..5ee14f2c2747 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -807,6 +807,7 @@ static const struct i2c_device_id adv748x_id[] = {
 	{ "adv7482", 0 },
 	{ },
 };
+MODULE_DEVICE_TABLE(i2c, adv748x_id);
 
 static const struct of_device_id adv748x_of_table[] = {
 	{ .compatible = "adi,adv7481", },
-- 
2.13.3
