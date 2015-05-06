Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bmw-carit.de ([62.245.222.98]:59313 "EHLO
	mail.bmw-carit.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbbEFLyb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2015 07:54:31 -0400
Message-ID: <554A00F2.5000007@bmw-carit.de>
Date: Wed, 6 May 2015 13:54:26 +0200
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	<linux-media@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IG92MjY1OTogImVycm9yOiBpbXBsaWNpdCBkZWNsYXJhdGlvbiA=?=
 =?UTF-8?B?b2YgZnVuY3Rpb24g4oCYdjRsMl9zdWJkZXZfZ2V0X3RyeV9mb3JtYXTigJki?=
References: <5549FA91.7040700@bmw-carit.de>
In-Reply-To: <5549FA91.7040700@bmw-carit.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 05/06/2015 01:27 PM, Daniel Wagner wrote:
> Hi,
> 
> I got this doing a randconfig on v4.1-rc2

Since this hits me all the time I did following hack which is probably
completely stupid but hey it works :)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 6f30ea7..8b05681 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -468,7 +468,7 @@ config VIDEO_SMIAPP_PLL

 config VIDEO_OV2659
        tristate "OmniVision OV2659 sensor support"
-       depends on VIDEO_V4L2 && I2C
+       depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
        depends on MEDIA_CAMERA_SUPPORT
        ---help---
          This is a Video4Linux2 sensor-level driver for the OmniVision
