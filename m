Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34045 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751416AbeD0LoX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 07:44:23 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, hans.verkuil@cisco.com, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 2/2] [media] sta2x11: Use gpio_is_valid() and remove unnecessary check
Date: Fri, 27 Apr 2018 17:14:01 +0530
Message-Id: <a87a9598074db4eaa439e433af38e274d32870bd.1524828993.git.arvind.yadav.cs@gmail.com>
In-Reply-To: <cover.1524828993.git.arvind.yadav.cs@gmail.com>
References: <cover.1524828993.git.arvind.yadav.cs@gmail.com>
In-Reply-To: <cover.1524828993.git.arvind.yadav.cs@gmail.com>
References: <cover.1524828993.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the manual validity checks for the GPIO with the
gpio_is_valid().

In vip_gpio_reserve(), Error checking for gpio pin is not correct.
If pwr_pin = -1, It will return 0. This should be return an error.

In sta2x11_vip_init_one(), Error checking for gpio 'reset_pin'
is unnecessary. Because vip_gpio_reserve() is also checking for
valid gpio pin. So removed extra error checking for gpio 'reset_pin'.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/pci/sta2x11/sta2x11_vip.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index dd199bf..069c4a8 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -908,10 +908,10 @@ static int sta2x11_vip_init_controls(struct sta2x11_vip *vip)
 static int vip_gpio_reserve(struct device *dev, int pin, int dir,
 			    const char *name)
 {
-	int ret;
+	int ret = -ENODEV;
 
-	if (pin == -1)
-		return 0;
+	if (!gpio_is_valid(pin))
+		return ret;
 
 	ret = gpio_request(pin, name);
 	if (ret) {
@@ -946,7 +946,7 @@ static int vip_gpio_reserve(struct device *dev, int pin, int dir,
  */
 static void vip_gpio_release(struct device *dev, int pin, const char *name)
 {
-	if (pin != -1) {
+	if (gpio_is_valid(pin)) {
 		dev_dbg(dev, "releasing pin %d (%s)\n",	pin, name);
 		gpio_unexport(pin);
 		gpio_free(pin);
@@ -1003,25 +1003,24 @@ static int sta2x11_vip_init_one(struct pci_dev *pdev,
 	if (ret)
 		goto disable;
 
-	if (config->reset_pin >= 0) {
-		ret = vip_gpio_reserve(&pdev->dev, config->reset_pin, 0,
-				       config->reset_name);
-		if (ret) {
-			vip_gpio_release(&pdev->dev, config->pwr_pin,
-					 config->pwr_name);
-			goto disable;
-		}
+	ret = vip_gpio_reserve(&pdev->dev, config->reset_pin, 0,
+			       config->reset_name);
+	if (ret) {
+		vip_gpio_release(&pdev->dev, config->pwr_pin,
+				 config->pwr_name);
+		goto disable;
 	}
-	if (config->pwr_pin != -1) {
+
+	if (gpio_is_valid(config->pwr_pin)) {
 		/* Datasheet says 5ms between PWR and RST */
 		usleep_range(5000, 25000);
-		ret = gpio_direction_output(config->pwr_pin, 1);
+		gpio_direction_output(config->pwr_pin, 1);
 	}
 
-	if (config->reset_pin != -1) {
+	if (gpio_is_valid(config->reset_pin)) {
 		/* Datasheet says 5ms between PWR and RST */
 		usleep_range(5000, 25000);
-		ret = gpio_direction_output(config->reset_pin, 1);
+		gpio_direction_output(config->reset_pin, 1);
 	}
 	usleep_range(5000, 25000);
 
-- 
1.9.1
