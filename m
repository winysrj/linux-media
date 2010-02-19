Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:47829 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab0BSWr6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 17:47:58 -0500
Received: by qw-out-2122.google.com with SMTP id 8so110905qwh.37
        for <linux-media@vger.kernel.org>; Fri, 19 Feb 2010 14:47:57 -0800 (PST)
Message-ID: <4B7F13B2.50804@pelagicore.com>
Date: Fri, 19 Feb 2010 15:41:54 -0700
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	sameo@linux.intel.com
Subject: Re: [PATCH] mfd: Add timb-radio to the timberdale MFD
References: <4B7845F0.1070800@pelagicore.com> <4B7E7B75.3040205@redhat.com>
In-Reply-To: <4B7E7B75.3040205@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------080008070206040807050900"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080008070206040807050900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

On 02/19/2010 04:52 AM, Mauro Carvalho Chehab wrote:
> Richard Röjfors wrote:
>> This patch addes timb-radio to all configurations of the timberdale MFD.
>>
>> Connected to the FPGA is a TEF6862 tuner and a SAA7706H DSP, the I2C
>> board info of these devices is passed via the timb-radio platform data.
>
> Hi Richard,
>
> I'm trying to apply it to my git tree (http://git.linuxtv.org/v4l-dvb.git),
> but it is failing:

Hi Mauro,

Right now my mail client, icedove, confuses me. Just upgraded to ver 3.
It seem to add in an extra space to lines not starting with a plus in the patch.

I attached the patch.

Sorry for the inconvenience.

--Richard

--------------080008070206040807050900
Content-Type: text/x-patch;
 name="timberdale-add-timb-radio.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="timberdale-add-timb-radio.patch"

This patch addes timb-radio to all configurations of the timberdale MFD.

Connected to the FPGA is a TEF6862 tuner and a SAA7706H DSP, the I2C
board info of these devices is passed via the timb-radio platform data.

Signed-off-by: Richard RÃ¶jfors <richard.rojfors@pelagicore.com>
--- 
diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index 603cf06..1ed44d2 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -37,6 +37,8 @@
 #include <linux/spi/max7301.h>
 #include <linux/spi/mc33880.h>
 
+#include <media/timb_radio.h>
+
 #include "timberdale.h"
 
 #define DRIVER_NAME "timberdale"
@@ -213,6 +215,40 @@ const static __devinitconst struct resource timberdale_uartlite_resources[] = {
 	},
 };
 
+const static __devinitconst struct resource timberdale_radio_resources[] = {
+	{
+		.start	= RDSOFFSET,
+		.end	= RDSEND,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= IRQ_TIMBERDALE_RDS,
+		.end	= IRQ_TIMBERDALE_RDS,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static __devinitdata struct i2c_board_info timberdale_tef6868_i2c_board_info = {
+	I2C_BOARD_INFO("tef6862", 0x60)
+};
+
+static __devinitdata struct i2c_board_info timberdale_saa7706_i2c_board_info = {
+	I2C_BOARD_INFO("saa7706h", 0x1C)
+};
+
+static __devinitdata struct timb_radio_platform_data
+	timberdale_radio_platform_data = {
+	.i2c_adapter = 0,
+	.tuner = {
+		.module_name = "tef6862",
+		.info = &timberdale_tef6868_i2c_board_info
+	},
+	.dsp = {
+		.module_name = "saa7706h",
+		.info = &timberdale_saa7706_i2c_board_info
+	}
+};
+
 const static __devinitconst struct resource timberdale_dma_resources[] = {
 	{
 		.start	= DMAOFFSET,
@@ -240,6 +276,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg0[] = {
 		.data_size = sizeof(timberdale_gpio_platform_data),
 	},
 	{
+		.name = "timb-radio",
+		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
+		.resources = timberdale_radio_resources,
+		.platform_data = &timberdale_radio_platform_data,
+		.data_size = sizeof(timberdale_radio_platform_data),
+	},
+	{
 		.name = "xilinx_spi",
 		.num_resources = ARRAY_SIZE(timberdale_spi_resources),
 		.resources = timberdale_spi_resources,
@@ -282,6 +325,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg1[] = {
 		.resources = timberdale_mlogicore_resources,
 	},
 	{
+		.name = "timb-radio",
+		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
+		.resources = timberdale_radio_resources,
+		.platform_data = &timberdale_radio_platform_data,
+		.data_size = sizeof(timberdale_radio_platform_data),
+	},
+	{
 		.name = "xilinx_spi",
 		.num_resources = ARRAY_SIZE(timberdale_spi_resources),
 		.resources = timberdale_spi_resources,
@@ -314,6 +364,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg2[] = {
 		.data_size = sizeof(timberdale_gpio_platform_data),
 	},
 	{
+		.name = "timb-radio",
+		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
+		.resources = timberdale_radio_resources,
+		.platform_data = &timberdale_radio_platform_data,
+		.data_size = sizeof(timberdale_radio_platform_data),
+	},
+	{
 		.name = "xilinx_spi",
 		.num_resources = ARRAY_SIZE(timberdale_spi_resources),
 		.resources = timberdale_spi_resources,
@@ -348,6 +405,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg3[] = {
 		.data_size = sizeof(timberdale_gpio_platform_data),
 	},
 	{
+		.name = "timb-radio",
+		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
+		.resources = timberdale_radio_resources,
+		.platform_data = &timberdale_radio_platform_data,
+		.data_size = sizeof(timberdale_radio_platform_data),
+	},
+	{
 		.name = "xilinx_spi",
 		.num_resources = ARRAY_SIZE(timberdale_spi_resources),
 		.resources = timberdale_spi_resources,

--------------080008070206040807050900--
