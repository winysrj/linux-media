Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay118.isp.belgacom.be ([195.238.20.145]:27663 "EHLO
	mailrelay118.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932609AbbCPTy4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 15:54:56 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Fabian Frederick <fabf@skynet.be>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
	Maxime Coquelin <maxime.coquelin@st.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kernel@stlinux.com
Subject: [PATCH 23/35 linux-next] [media] constify of_device_id array
Date: Mon, 16 Mar 2015 20:54:33 +0100
Message-Id: <1426535685-25996-2-git-send-email-fabf@skynet.be>
In-Reply-To: <1426535685-25996-1-git-send-email-fabf@skynet.be>
References: <1426533469-25458-1-git-send-email-fabf@skynet.be>
 <1426535685-25996-1-git-send-email-fabf@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

of_device_id is always used as const.
(See driver.of_match_table and open firmware functions)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/i2c/adv7604.c                  | 2 +-
 drivers/media/platform/fsl-viu.c             | 2 +-
 drivers/media/platform/soc_camera/rcar_vin.c | 2 +-
 drivers/media/rc/gpio-ir-recv.c              | 2 +-
 drivers/media/rc/ir-hix5hd2.c                | 2 +-
 drivers/media/rc/st_rc.c                     | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index d228b7c..5a7c938 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2598,7 +2598,7 @@ static struct i2c_device_id adv7604_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, adv7604_i2c_id);
 
-static struct of_device_id adv7604_of_id[] __maybe_unused = {
+static const struct of_device_id adv7604_of_id[] __maybe_unused = {
 	{ .compatible = "adi,adv7611", .data = &adv7604_chip_info[ADV7611] },
 	{ }
 };
diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index bbf4281..5b76e3d 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -1664,7 +1664,7 @@ static int viu_resume(struct platform_device *op)
 /*
  * Initialization and module stuff
  */
-static struct of_device_id mpc512x_viu_of_match[] = {
+static const struct of_device_id mpc512x_viu_of_match[] = {
 	{
 		.compatible = "fsl,mpc5121-viu",
 	},
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 279ab9f..bbbaa0a 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1818,7 +1818,7 @@ static struct soc_camera_host_ops rcar_vin_host_ops = {
 };
 
 #ifdef CONFIG_OF
-static struct of_device_id rcar_vin_of_table[] = {
+static const struct of_device_id rcar_vin_of_table[] = {
 	{ .compatible = "renesas,vin-r8a7794", .data = (void *)RCAR_GEN2 },
 	{ .compatible = "renesas,vin-r8a7793", .data = (void *)RCAR_GEN2 },
 	{ .compatible = "renesas,vin-r8a7791", .data = (void *)RCAR_GEN2 },
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 229853d..707df54 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -59,7 +59,7 @@ static int gpio_ir_recv_get_devtree_pdata(struct device *dev,
 	return 0;
 }
 
-static struct of_device_id gpio_ir_recv_of_match[] = {
+static const struct of_device_id gpio_ir_recv_of_match[] = {
 	{ .compatible = "gpio-ir-receiver", },
 	{ },
 };
diff --git a/drivers/media/rc/ir-hix5hd2.c b/drivers/media/rc/ir-hix5hd2.c
index b0df629..0a11d55 100644
--- a/drivers/media/rc/ir-hix5hd2.c
+++ b/drivers/media/rc/ir-hix5hd2.c
@@ -327,7 +327,7 @@ static int hix5hd2_ir_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(hix5hd2_ir_pm_ops, hix5hd2_ir_suspend,
 			 hix5hd2_ir_resume);
 
-static struct of_device_id hix5hd2_ir_table[] = {
+static const struct of_device_id hix5hd2_ir_table[] = {
 	{ .compatible = "hisilicon,hix5hd2-ir", },
 	{},
 };
diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
index 0e758ae..50ea09d 100644
--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -381,7 +381,7 @@ static int st_rc_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(st_rc_pm_ops, st_rc_suspend, st_rc_resume);
 
 #ifdef CONFIG_OF
-static struct of_device_id st_rc_match[] = {
+static const struct of_device_id st_rc_match[] = {
 	{ .compatible = "st,comms-irb", },
 	{},
 };
-- 
2.1.0

