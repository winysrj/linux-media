Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:44683 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757188AbbEVOGm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 10:06:42 -0400
Message-ID: <555F37EB.6040404@xs4all.nl>
Date: Fri, 22 May 2015 16:06:35 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 12/11] adv7604/cobalt: missing GPIOLIB dependency
References: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl> <1432303184-8594-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1432303184-8594-12-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The adv7604 driver depends on GPIOLIB, and therefore cobalt depends
on it as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/Kconfig        | 2 +-
 drivers/media/pci/cobalt/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 6f30ea7..36f5563 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -196,7 +196,7 @@ config VIDEO_ADV7183
 
 config VIDEO_ADV7604
 	tristate "Analog Devices ADV7604 decoder"
-	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && GPIOLIB
 	---help---
 	  Support for the Analog Devices ADV7604 video decoder.
 
diff --git a/drivers/media/pci/cobalt/Kconfig b/drivers/media/pci/cobalt/Kconfig
index e3c03e9..3be1b2c 100644
--- a/drivers/media/pci/cobalt/Kconfig
+++ b/drivers/media/pci/cobalt/Kconfig
@@ -1,7 +1,7 @@
 config VIDEO_COBALT
 	tristate "Cisco Cobalt support"
 	depends on VIDEO_V4L2 && I2C && MEDIA_CONTROLLER
-	depends on PCI_MSI && MTD_COMPLEX_MAPPINGS
+	depends on PCI_MSI && MTD_COMPLEX_MAPPINGS && GPIOLIB
 	select I2C_ALGOBIT
 	select VIDEO_ADV7604
 	select VIDEO_ADV7511
-- 
2.1.4



On 05/22/2015 03:59 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> drivers/media/pci/saa7164/saa7164-i2c.c:45:33: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/pci/saa7164/saa7164-i2c.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/pci/saa7164/saa7164-i2c.c b/drivers/media/pci/saa7164/saa7164-i2c.c
> index 6ea9d4f..0342d84 100644
> --- a/drivers/media/pci/saa7164/saa7164-i2c.c
> +++ b/drivers/media/pci/saa7164/saa7164-i2c.c
> @@ -42,7 +42,7 @@ static int i2c_xfer(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs, int num)
>  			retval = saa7164_api_i2c_read(bus,
>  				msgs[i].addr,
>  				0 /* reglen */,
> -				0 /* reg */, msgs[i].len, msgs[i].buf);
> +				NULL /* reg */, msgs[i].len, msgs[i].buf);
>  		} else if (i + 1 < num && (msgs[i + 1].flags & I2C_M_RD) &&
>  			   msgs[i].addr == msgs[i + 1].addr) {
>  			/* write then read from same address */
> 

