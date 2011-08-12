Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:57451 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab1HLHfU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2011 03:35:20 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id p7C7ZH7H031327
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 12 Aug 2011 02:35:19 -0500
Received: from dbde70.ent.ti.com (localhost [127.0.0.1])
	by dbdp20.itg.ti.com (8.13.8/8.13.8) with ESMTP id p7C7ZHQa027201
	for <linux-media@vger.kernel.org>; Fri, 12 Aug 2011 13:05:17 +0530 (IST)
From: "Ravi, Deepthy" <deepthy.ravi@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Koyamangalath, Abhilash" <abhilash.kv@ti.com>
Date: Fri, 12 Aug 2011 13:05:16 +0530
Subject: [QUERY] Inclusion of isp.h in board-omap3evm-camera.c
Message-ID: <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D0907CF@dbde03.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I need to use some isp structures ( isp_v4l2_subdevs_group, isp_platform_data ,isp_subdev_i2c_board_info etc.) in  board-omap3evm-camera.c. For that header file isp.h has to be included .
Currently I am including it in this way:

#include <../drivers/media/video/omap3isp/isp.h>

 Is there a better way to do this ? The relevant hunk of the patch is shown below:

diff --git a/arch/arm/mach-omap2/board-omap3evm-camera.c b/arch/arm/mach-omap2/board-omap3evm-camera.c
new file mode 100644
index 0000000..319a6a1
--- /dev/null
+++ b/arch/arm/mach-omap2/board-omap3evm-camera.c
+#include <linux/io.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+
+#include <mach/gpio.h>
+
+#include <media/tvp514x.h>
+
+#include <../drivers/media/video/omap3isp/isp.h> 



