Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932286Ab0BCJQR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 04:16:17 -0500
Message-ID: <4B693ED7.4060401@redhat.com>
Date: Wed, 03 Feb 2010 07:16:07 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>,
	"Ortiz, Samuel" <samuel.ortiz@intel.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] mfd: Add support for the timberdale FPGA.
References: <4B66C36A.4000005@pelagicore.com>
In-Reply-To: <4B66C36A.4000005@pelagicore.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Richard,

Richard Röjfors wrote:
> The timberdale FPGA is found on the Intel in-Vehicle Infotainment reference board
> russelville.
> 
> The driver is a PCI driver which chunks up the I/O memory and distributes interrupts
> to a number of platform devices for each IP inside the FPGA.
> 
> Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>

I'm not sure how to deal with this patch. It doesn't contain anything related
to V4L2 inside it, nor it applies to drivers/media, but it depends on the radio-timb
driver that you submitted us.

As this patch will be committed at mfd tree, the better is if Samuel can review
this patch and give his ack. I'll add it together with the V4L2 driver and submit them
via my tree.

Samuel,

Would this way work for you?

Cheers,
Mauro.

> ---
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 8782978..f92673b 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -348,6 +348,17 @@ config AB4500_CORE
>  	  read/write functions for the devices to get access to this chip.
>  	  This chip embeds various other multimedia funtionalities as well.
> 
> +config MFD_TIMBERDALE
> +	tristate "Support for the Timberdale FPGA"
> +	select MFD_CORE
> +	depends on PCI
> +	---help---
> +	This is the core driver for the timberdale FPGA. This device is a
> +	multifunction device which exposes numerous platform devices.
> +
> +	The timberdale FPGA can be found on the Intel Atom development board
> +	for in-vehicle infontainment, called Russellville.
> +
>  endmenu
> 
>  menu "Multimedia Capabilities Port drivers"
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index e09eb48..53375ac 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -55,4 +55,6 @@ obj-$(CONFIG_AB3100_CORE)	+= ab3100-core.o
>  obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
>  obj-$(CONFIG_AB4500_CORE)	+= ab4500-core.o
>  obj-$(CONFIG_MFD_88PM8607)	+= 88pm8607.o
> -obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
> \ No newline at end of file
> +obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
> +
> +obj-$(CONFIG_MFD_TIMBERDALE)		+= timberdale.o
> diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
> new file mode 100644
> index 0000000..90f745b
> --- /dev/null
> +++ b/drivers/mfd/timberdale.c
> @@ -0,0 +1,667 @@
> +/*
> + * timberdale.c timberdale FPGA MFD driver
> + * Copyright (c) 2009 Intel Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +/* Supports:
> + * Timberdale FPGA
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/msi.h>
> +#include <linux/mfd/core.h>
> +
> +#include <linux/timb_gpio.h>
> +
> +#include <linux/i2c.h>
> +#include <linux/i2c-ocores.h>
> +#include <linux/i2c/tsc2007.h>
> +
> +#include <linux/spi/spi.h>
> +#include <linux/spi/xilinx_spi.h>
> +#include <linux/spi/max7301.h>
> +#include <linux/spi/mc33880.h>
> +
> +#include "timberdale.h"
> +
> +#define DRIVER_NAME "timberdale"
> +
> +struct timberdale_device {
> +	resource_size_t		ctl_mapbase;
> +	unsigned char __iomem   *ctl_membase;
> +	struct {
> +		u32 major;
> +		u32 minor;
> +		u32 config;
> +	} fw;
> +};
> +
> +/*--------------------------------------------------------------------------*/
> +
> +static struct tsc2007_platform_data timberdale_tsc2007_platform_data = {
> +	.model = 2003,
> +	.x_plate_ohms = 100
> +};
> +
> +static struct i2c_board_info timberdale_i2c_board_info[] = {
> +	{
> +		I2C_BOARD_INFO("tsc2007", 0x48),
> +		.platform_data = &timberdale_tsc2007_platform_data,
> +		.irq = IRQ_TIMBERDALE_TSC_INT
> +	},
> +};
> +
> +static __devinitdata struct ocores_i2c_platform_data
> +timberdale_ocores_platform_data = {
> +	.regstep = 4,
> +	.clock_khz = 62500,
> +	.devices = timberdale_i2c_board_info,
> +	.num_devices = ARRAY_SIZE(timberdale_i2c_board_info)
> +};
> +
> +const static __devinitconst struct resource timberdale_ocores_resources[] = {
> +	{
> +		.start	= OCORESOFFSET,
> +		.end	= OCORESEND,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start 	= IRQ_TIMBERDALE_I2C,
> +		.end	= IRQ_TIMBERDALE_I2C,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +const struct max7301_platform_data timberdale_max7301_platform_data = {
> +	.base = 200
> +};
> +
> +const struct mc33880_platform_data timberdale_mc33880_platform_data = {
> +	.base = 100
> +};
> +
> +static struct spi_board_info timberdale_spi_16bit_board_info[] = {
> +	{
> +		.modalias = "max7301",
> +		.max_speed_hz = 26000,
> +		.chip_select = 2,
> +		.mode = SPI_MODE_0,
> +		.platform_data = &timberdale_max7301_platform_data
> +	},
> +};
> +
> +static struct spi_board_info timberdale_spi_8bit_board_info[] = {
> +	{
> +		.modalias = "mc33880",
> +		.max_speed_hz = 4000,
> +		.chip_select = 1,
> +		.mode = SPI_MODE_1,
> +		.platform_data = &timberdale_mc33880_platform_data
> +	},
> +};
> +
> +static __devinitdata struct xspi_platform_data timberdale_xspi_platform_data = {
> +	.num_chipselect = 3,
> +	.little_endian = true,
> +	/* bits per word and devices will be filled in runtime depending
> +	 * on the HW config
> +	 */
> +};
> +
> +const static __devinitconst struct resource timberdale_spi_resources[] = {
> +	{
> +		.start 	= SPIOFFSET,
> +		.end	= SPIEND,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= IRQ_TIMBERDALE_SPI,
> +		.end	= IRQ_TIMBERDALE_SPI,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +const static __devinitconst struct resource timberdale_eth_resources[] = {
> +	{
> +		.start	= ETHOFFSET,
> +		.end	= ETHEND,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= IRQ_TIMBERDALE_ETHSW_IF,
> +		.end	= IRQ_TIMBERDALE_ETHSW_IF,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +static __devinitdata struct timbgpio_platform_data
> +	timberdale_gpio_platform_data = {
> +	.gpio_base = 0,
> +	.nr_pins = GPIO_NR_PINS,
> +	.irq_base = 200,
> +};
> +
> +const static __devinitconst struct resource timberdale_gpio_resources[] = {
> +	{
> +		.start	= GPIOOFFSET,
> +		.end	= GPIOEND,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= IRQ_TIMBERDALE_GPIO,
> +		.end	= IRQ_TIMBERDALE_GPIO,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +const static __devinitconst struct resource timberdale_mlogicore_resources[] = {
> +	{
> +		.start	= MLCOREOFFSET,
> +		.end	= MLCOREEND,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= IRQ_TIMBERDALE_MLCORE,
> +		.end	= IRQ_TIMBERDALE_MLCORE,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	{
> +		.start	= IRQ_TIMBERDALE_MLCORE_BUF,
> +		.end	= IRQ_TIMBERDALE_MLCORE_BUF,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +const static __devinitconst struct resource timberdale_uart_resources[] = {
> +	{
> +		.start	= UARTOFFSET,
> +		.end	= UARTEND,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= IRQ_TIMBERDALE_UART,
> +		.end	= IRQ_TIMBERDALE_UART,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +const static __devinitconst struct resource timberdale_uartlite_resources[] = {
> +	{
> +		.start	= UARTLITEOFFSET,
> +		.end	= UARTLITEEND,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= IRQ_TIMBERDALE_UARTLITE,
> +		.end	= IRQ_TIMBERDALE_UARTLITE,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +const static __devinitconst struct resource timberdale_dma_resources[] = {
> +	{
> +		.start	= DMAOFFSET,
> +		.end	= DMAEND,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= IRQ_TIMBERDALE_DMA,
> +		.end	= IRQ_TIMBERDALE_DMA,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg0[] = {
> +	{
> +		.name = "timb-uart",
> +		.num_resources = ARRAY_SIZE(timberdale_uart_resources),
> +		.resources = timberdale_uart_resources,
> +	},
> +	{
> +		.name = "timb-gpio",
> +		.num_resources = ARRAY_SIZE(timberdale_gpio_resources),
> +		.resources = timberdale_gpio_resources,
> +		.platform_data = &timberdale_gpio_platform_data,
> +		.data_size = sizeof(timberdale_gpio_platform_data),
> +	},
> +	{
> +		.name = "xilinx_spi",
> +		.num_resources = ARRAY_SIZE(timberdale_spi_resources),
> +		.resources = timberdale_spi_resources,
> +		.platform_data = &timberdale_xspi_platform_data,
> +		.data_size = sizeof(timberdale_xspi_platform_data),
> +	},
> +	{
> +		.name = "ks8842",
> +		.num_resources = ARRAY_SIZE(timberdale_eth_resources),
> +		.resources = timberdale_eth_resources,
> +	},
> +	{
> +		.name = "timb-dma",
> +		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
> +		.resources = timberdale_dma_resources,
> +	},
> +};
> +
> +static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg1[] = {
> +	{
> +		.name = "timb-uart",
> +		.num_resources = ARRAY_SIZE(timberdale_uart_resources),
> +		.resources = timberdale_uart_resources,
> +	},
> +	{
> +		.name = "uartlite",
> +		.num_resources = ARRAY_SIZE(timberdale_uartlite_resources),
> +		.resources = timberdale_uartlite_resources,
> +	},
> +	{
> +		.name = "timb-gpio",
> +		.num_resources = ARRAY_SIZE(timberdale_gpio_resources),
> +		.resources = timberdale_gpio_resources,
> +		.platform_data = &timberdale_gpio_platform_data,
> +		.data_size = sizeof(timberdale_gpio_platform_data),
> +	},
> +	{
> +		.name = "timb-mlogicore",
> +		.num_resources = ARRAY_SIZE(timberdale_mlogicore_resources),
> +		.resources = timberdale_mlogicore_resources,
> +	},
> +	{
> +		.name = "xilinx_spi",
> +		.num_resources = ARRAY_SIZE(timberdale_spi_resources),
> +		.resources = timberdale_spi_resources,
> +		.platform_data = &timberdale_xspi_platform_data,
> +		.data_size = sizeof(timberdale_xspi_platform_data),
> +	},
> +	{
> +		.name = "ks8842",
> +		.num_resources = ARRAY_SIZE(timberdale_eth_resources),
> +		.resources = timberdale_eth_resources,
> +	},
> +	{
> +		.name = "timb-dma",
> +		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
> +		.resources = timberdale_dma_resources,
> +	},
> +};
> +
> +static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg2[] = {
> +	{
> +		.name = "timb-uart",
> +		.num_resources = ARRAY_SIZE(timberdale_uart_resources),
> +		.resources = timberdale_uart_resources,
> +	},
> +	{
> +		.name = "timb-gpio",
> +		.num_resources = ARRAY_SIZE(timberdale_gpio_resources),
> +		.resources = timberdale_gpio_resources,
> +		.platform_data = &timberdale_gpio_platform_data,
> +		.data_size = sizeof(timberdale_gpio_platform_data),
> +	},
> +	{
> +		.name = "xilinx_spi",
> +		.num_resources = ARRAY_SIZE(timberdale_spi_resources),
> +		.resources = timberdale_spi_resources,
> +		.platform_data = &timberdale_xspi_platform_data,
> +		.data_size = sizeof(timberdale_xspi_platform_data),
> +	},
> +	{
> +		.name = "timb-dma",
> +		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
> +		.resources = timberdale_dma_resources,
> +	},
> +};
> +
> +static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg3[] = {
> +	{
> +		.name = "timb-uart",
> +		.num_resources = ARRAY_SIZE(timberdale_uart_resources),
> +		.resources = timberdale_uart_resources,
> +	},
> +	{
> +		.name = "ocores-i2c",
> +		.num_resources = ARRAY_SIZE(timberdale_ocores_resources),
> +		.resources = timberdale_ocores_resources,
> +		.platform_data = &timberdale_ocores_platform_data,
> +		.data_size = sizeof(timberdale_ocores_platform_data),
> +	},
> +	{
> +		.name = "timb-gpio",
> +		.num_resources = ARRAY_SIZE(timberdale_gpio_resources),
> +		.resources = timberdale_gpio_resources,
> +		.platform_data = &timberdale_gpio_platform_data,
> +		.data_size = sizeof(timberdale_gpio_platform_data),
> +	},
> +	{
> +		.name = "xilinx_spi",
> +		.num_resources = ARRAY_SIZE(timberdale_spi_resources),
> +		.resources = timberdale_spi_resources,
> +		.platform_data = &timberdale_xspi_platform_data,
> +		.data_size = sizeof(timberdale_xspi_platform_data),
> +	},
> +	{
> +		.name = "ks8842",
> +		.num_resources = ARRAY_SIZE(timberdale_eth_resources),
> +		.resources = timberdale_eth_resources,
> +	},
> +	{
> +		.name = "timb-dma",
> +		.num_resources = ARRAY_SIZE(timberdale_dma_resources),
> +		.resources = timberdale_dma_resources,
> +	},
> +};
> +
> +static const __devinitconst struct resource timberdale_sdhc_resources[] = {
> +	/* located in bar 1 and bar 2 */
> +	{
> +		.start	= SDHC0OFFSET,
> +		.end	= SDHC0END,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= IRQ_TIMBERDALE_SDHC,
> +		.end	= IRQ_TIMBERDALE_SDHC,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +static __devinitdata struct mfd_cell timberdale_cells_bar1[] = {
> +	{
> +		.name = "sdhci",
> +		.num_resources = ARRAY_SIZE(timberdale_sdhc_resources),
> +		.resources = timberdale_sdhc_resources,
> +	},
> +};
> +
> +static __devinitdata struct mfd_cell timberdale_cells_bar2[] = {
> +	{
> +		.name = "sdhci",
> +		.num_resources = ARRAY_SIZE(timberdale_sdhc_resources),
> +		.resources = timberdale_sdhc_resources,
> +	},
> +};
> +
> +static ssize_t show_fw_ver(struct device *dev, struct device_attribute *attr,
> +	char *buf)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct timberdale_device *priv = pci_get_drvdata(pdev);
> +
> +	return sprintf(buf, "%d.%d.%d\n", priv->fw.major, priv->fw.minor,
> +		priv->fw.config);
> +}
> +
> +static DEVICE_ATTR(fw_ver, S_IRUGO, show_fw_ver, NULL);
> +
> +/*--------------------------------------------------------------------------*/
> +
> +static int __devinit timb_probe(struct pci_dev *dev,
> +	const struct pci_device_id *id)
> +{
> +	struct timberdale_device *priv;
> +	int err, i;
> +	resource_size_t mapbase;
> +	struct msix_entry *msix_entries = NULL;
> +	u8 ip_setup;
> +
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	pci_set_drvdata(dev, priv);
> +
> +	err = pci_enable_device(dev);
> +	if (err)
> +		goto err_enable;
> +
> +	mapbase = pci_resource_start(dev, 0);
> +	if (!mapbase) {
> +		printk(KERN_ERR DRIVER_NAME ": No resource\n");
> +		goto err_start;
> +	}
> +
> +	/* create a resource for the PCI master register */
> +	priv->ctl_mapbase = mapbase + CHIPCTLOFFSET;
> +	if (!request_mem_region(priv->ctl_mapbase, CHIPCTLSIZE, "timb-ctl")) {
> +		printk(KERN_ERR DRIVER_NAME ": Failed to request ctl mem\n");
> +		goto err_request;
> +	}
> +
> +	priv->ctl_membase = ioremap(priv->ctl_mapbase, CHIPCTLSIZE);
> +	if (!priv->ctl_membase) {
> +		printk(KERN_ALERT DRIVER_NAME": Map error, ctl\n");
> +		goto err_ioremap;
> +	}
> +
> +	/* read the HW config */
> +	priv->fw.major = ioread32(priv->ctl_membase + TIMB_REV_MAJOR);
> +	priv->fw.minor = ioread32(priv->ctl_membase + TIMB_REV_MINOR);
> +	priv->fw.config = ioread32(priv->ctl_membase + TIMB_HW_CONFIG);
> +
> +	if (priv->fw.major > TIMB_SUPPORTED_MAJOR) {
> +		printk(KERN_ERR DRIVER_NAME": The driver supports an older "
> +			"version of the FPGA, please update the driver to "
> +			"support %d.%d\n", priv->fw.major, priv->fw.minor);
> +		goto err_ioremap;
> +	}
> +	if (priv->fw.major < TIMB_SUPPORTED_MAJOR ||
> +		priv->fw.minor < TIMB_REQUIRED_MINOR) {
> +		printk(KERN_ERR DRIVER_NAME
> +			": The FPGA image is too old (%d.%d), "
> +			"please upgrade the FPGA to at least: %d.%d\n",
> +			priv->fw.major, priv->fw.minor,
> +			TIMB_SUPPORTED_MAJOR, TIMB_REQUIRED_MINOR);
> +		goto err_ioremap;
> +	}
> +
> +	msix_entries = kzalloc(TIMBERDALE_NR_IRQS * sizeof(*msix_entries),
> +		GFP_KERNEL);
> +	if (!msix_entries)
> +		goto err_ioremap;
> +
> +	for (i = 0; i < TIMBERDALE_NR_IRQS; i++)
> +		msix_entries[i].entry = i;
> +
> +	err = pci_enable_msix(dev, msix_entries, TIMBERDALE_NR_IRQS);
> +	if (err) {
> +		printk(KERN_WARNING DRIVER_NAME
> +			": MSI-X init failed: %d, expected entries: %d\n",
> +			err, TIMBERDALE_NR_IRQS);
> +		goto err_msix;
> +	}
> +
> +	err = device_create_file(&dev->dev, &dev_attr_fw_ver);
> +	if (err)
> +		goto err_create_file;
> +
> +	/* Reset all FPGA PLB peripherals */
> +	iowrite32(0x1, priv->ctl_membase + TIMB_SW_RST);
> +
> +	/* update IRQ offsets in I2C board info */
> +	for (i = 0; i < ARRAY_SIZE(timberdale_i2c_board_info); i++)
> +		timberdale_i2c_board_info[i].irq =
> +			msix_entries[timberdale_i2c_board_info[i].irq].vector;
> +
> +	/* Update the SPI configuration depending on the HW (8 or 16 bit) */
> +	if (priv->fw.config & TIMB_HW_CONFIG_SPI_8BIT) {
> +		timberdale_xspi_platform_data.bits_per_word = 8;
> +		timberdale_xspi_platform_data.devices =
> +			timberdale_spi_8bit_board_info;
> +		timberdale_xspi_platform_data.num_devices =
> +			ARRAY_SIZE(timberdale_spi_8bit_board_info);
> +	} else {
> +		timberdale_xspi_platform_data.bits_per_word = 16;
> +		timberdale_xspi_platform_data.devices =
> +			timberdale_spi_16bit_board_info;
> +		timberdale_xspi_platform_data.num_devices =
> +			ARRAY_SIZE(timberdale_spi_16bit_board_info);
> +	}
> +
> +	ip_setup = priv->fw.config & TIMB_HW_VER_MASK;
> +	switch (ip_setup) {
> +	case TIMB_HW_VER0:
> +		err = mfd_add_devices(&dev->dev, -1,
> +			timberdale_cells_bar0_cfg0,
> +			ARRAY_SIZE(timberdale_cells_bar0_cfg0),
> +			&dev->resource[0], msix_entries[0].vector);
> +		break;
> +	case TIMB_HW_VER1:
> +		err = mfd_add_devices(&dev->dev, -1,
> +			timberdale_cells_bar0_cfg1,
> +			ARRAY_SIZE(timberdale_cells_bar0_cfg1),
> +			&dev->resource[0], msix_entries[0].vector);
> +		break;
> +	case TIMB_HW_VER2:
> +		err = mfd_add_devices(&dev->dev, -1,
> +			timberdale_cells_bar0_cfg2,
> +			ARRAY_SIZE(timberdale_cells_bar0_cfg2),
> +			&dev->resource[0], msix_entries[0].vector);
> +		break;
> +	case TIMB_HW_VER3:
> +		err = mfd_add_devices(&dev->dev, -1,
> +			timberdale_cells_bar0_cfg3,
> +			ARRAY_SIZE(timberdale_cells_bar0_cfg3),
> +			&dev->resource[0], msix_entries[0].vector);
> +		break;
> +	default:
> +		printk(KERN_ERR"Uknown IP setup: %d.%d.%d\n",
> +			priv->fw.major, priv->fw.minor, ip_setup);
> +		err = -ENODEV;
> +		goto err_mfd;
> +		break;
> +	}
> +
> +	if (err) {
> +		printk(KERN_WARNING DRIVER_NAME
> +			": mfd_add_devices failed: %d\n", err);
> +		goto err_mfd;
> +	}
> +
> +	err = mfd_add_devices(&dev->dev, 0,
> +		timberdale_cells_bar1, ARRAY_SIZE(timberdale_cells_bar1),
> +		&dev->resource[1], msix_entries[0].vector);
> +	if (err) {
> +		printk(KERN_WARNING DRIVER_NAME
> +			"mfd_add_devices failed: %d\n", err);
> +		goto err_mfd2;
> +	}
> +
> +	/* only version 0 and 3 have the iNand routed to SDHCI */
> +	if (((priv->fw.config & TIMB_HW_VER_MASK) == TIMB_HW_VER0) ||
> +		((priv->fw.config & TIMB_HW_VER_MASK) == TIMB_HW_VER3)) {
> +		err = mfd_add_devices(&dev->dev, 1, timberdale_cells_bar2,
> +			ARRAY_SIZE(timberdale_cells_bar2),
> +			&dev->resource[2], msix_entries[0].vector);
> +		if (err) {
> +			printk(KERN_WARNING DRIVER_NAME
> +				": mfd_add_devices failed: %d\n", err);
> +			goto err_mfd2;
> +		}
> +	}
> +
> +	kfree(msix_entries);
> +
> +	printk(KERN_INFO
> +		"Found Timberdale Card. Rev: %d.%d, HW config: 0x%02x\n",
> +		priv->fw.major, priv->fw.minor, priv->fw.config);
> +
> +	return 0;
> +
> +err_mfd2:
> +	mfd_remove_devices(&dev->dev);
> +err_mfd:
> +	device_remove_file(&dev->dev, &dev_attr_fw_ver);
> +err_create_file:
> +	pci_disable_msix(dev);
> +err_msix:
> +	iounmap(priv->ctl_membase);
> +err_ioremap:
> +	release_mem_region(priv->ctl_mapbase, CHIPCTLSIZE);
> +err_request:
> +	pci_set_drvdata(dev, NULL);
> +err_start:
> +	pci_disable_device(dev);
> +err_enable:
> +	kfree(msix_entries);
> +	kfree(priv);
> +	pci_set_drvdata(dev, NULL);
> +	return -ENODEV;
> +}
> +
> +static void __devexit timb_remove(struct pci_dev *dev)
> +{
> +	struct timberdale_device *priv = pci_get_drvdata(dev);
> +
> +	mfd_remove_devices(&dev->dev);
> +
> +	device_remove_file(&dev->dev, &dev_attr_fw_ver);
> +
> +	iounmap(priv->ctl_membase);
> +	release_mem_region(priv->ctl_mapbase, CHIPCTLSIZE);
> +
> +	pci_disable_msix(dev);
> +	pci_disable_device(dev);
> +	pci_set_drvdata(dev, NULL);
> +	kfree(priv);
> +}
> +
> +static struct pci_device_id timberdale_pci_tbl[] = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_TIMB, PCI_DEVICE_ID_TIMB) },
> +	{ 0 }
> +};
> +MODULE_DEVICE_TABLE(pci, timberdale_pci_tbl);
> +
> +static struct pci_driver timberdale_pci_driver = {
> +	.name = DRIVER_NAME,
> +	.id_table = timberdale_pci_tbl,
> +	.probe = timb_probe,
> +	.remove = __devexit_p(timb_remove),
> +};
> +
> +static int __init timberdale_init(void)
> +{
> +	int err;
> +
> +	err = pci_register_driver(&timberdale_pci_driver);
> +	if (err < 0) {
> +		printk(KERN_ERR
> +			"Failed to register PCI driver for %s device.\n",
> +			timberdale_pci_driver.name);
> +		return -ENODEV;
> +	}
> +
> +	printk(KERN_INFO "Driver for %s has been successfully registered.\n",
> +		timberdale_pci_driver.name);
> +
> +	return 0;
> +}
> +
> +static void __exit timberdale_exit(void)
> +{
> +	pci_unregister_driver(&timberdale_pci_driver);
> +
> +	printk(KERN_INFO "Driver for %s has been successfully unregistered.\n",
> +				timberdale_pci_driver.name);
> +}
> +
> +module_init(timberdale_init);
> +module_exit(timberdale_exit);
> +
> +MODULE_AUTHOR("Mocean Laboratories <info@mocean-labs.com>");
> +MODULE_VERSION(DRV_VERSION);
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/mfd/timberdale.h b/drivers/mfd/timberdale.h
> new file mode 100644
> index 0000000..8d27ffa
> --- /dev/null
> +++ b/drivers/mfd/timberdale.h
> @@ -0,0 +1,130 @@
> +/*
> + * timberdale.h timberdale FPGA MFD driver defines
> + * Copyright (c) 2009 Intel Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +/* Supports:
> + * Timberdale FPGA
> + */
> +
> +#ifndef MFD_TIMBERDALE_H
> +#define MFD_TIMBERDALE_H
> +
> +#define DRV_VERSION		"0.1"
> +
> +/* This driver only support versions >= 3.8 and < 4.0  */
> +#define TIMB_SUPPORTED_MAJOR	3
> +
> +/* This driver only support minor >= 8 */
> +#define TIMB_REQUIRED_MINOR	8
> +
> +/* Registers of the control area */
> +#define TIMB_REV_MAJOR	0x00
> +#define TIMB_REV_MINOR	0x04
> +#define TIMB_HW_CONFIG	0x08
> +#define TIMB_SW_RST	0x40
> +
> +/* bits in the TIMB_HW_CONFIG register */
> +#define TIMB_HW_CONFIG_SPI_8BIT	0x80
> +
> +#define TIMB_HW_VER_MASK	0x0f
> +#define TIMB_HW_VER0		0x00
> +#define TIMB_HW_VER1		0x01
> +#define TIMB_HW_VER2		0x02
> +#define TIMB_HW_VER3		0x03
> +
> +#define OCORESOFFSET	0x0
> +#define OCORESEND	0x1f
> +
> +#define SPIOFFSET	0x80
> +#define SPIEND		0xff
> +
> +#define UARTLITEOFFSET	0x100
> +#define UARTLITEEND	0x10f
> +
> +#define RDSOFFSET	0x180
> +#define RDSEND		0x183
> +
> +#define ETHOFFSET	0x300
> +#define ETHEND		0x3ff
> +
> +#define GPIOOFFSET	0x400
> +#define GPIOEND		0x7ff
> +
> +#define CHIPCTLOFFSET	0x800
> +#define CHIPCTLEND	0x8ff
> +#define CHIPCTLSIZE	(CHIPCTLEND - CHIPCTLOFFSET)
> +
> +#define INTCOFFSET	0xc00
> +#define INTCEND		0xfff
> +#define INTCSIZE	(INTCEND - INTCOFFSET)
> +
> +#define MOSTOFFSET	0x1000
> +#define MOSTEND		0x13ff
> +
> +#define UARTOFFSET	0x1400
> +#define UARTEND		0x17ff
> +
> +#define XIICOFFSET	0x1800
> +#define XIICEND		0x19ff
> +
> +#define I2SOFFSET	0x1C00
> +#define I2SEND		0x1fff
> +
> +#define LOGIWOFFSET	0x30000
> +#define LOGIWEND	0x37fff
> +
> +#define MLCOREOFFSET	0x40000
> +#define MLCOREEND	0x43fff
> +
> +#define DMAOFFSET	0x01000000
> +#define DMAEND		0x013fffff
> +
> +/* SDHC0 is placed in PCI bar 1 */
> +#define SDHC0OFFSET	0x00
> +#define SDHC0END	0xff
> +
> +/* SDHC1 is placed in PCI bar 2 */
> +#define SDHC1OFFSET	0x00
> +#define SDHC1END	0xff
> +
> +#define PCI_VENDOR_ID_TIMB	0x10ee
> +#define PCI_DEVICE_ID_TIMB	0xa123
> +
> +#define IRQ_TIMBERDALE_INIC		0
> +#define IRQ_TIMBERDALE_MLB		1
> +#define IRQ_TIMBERDALE_GPIO		2
> +#define IRQ_TIMBERDALE_I2C		3
> +#define IRQ_TIMBERDALE_UART		4
> +#define IRQ_TIMBERDALE_DMA		5
> +#define IRQ_TIMBERDALE_I2S		6
> +#define IRQ_TIMBERDALE_TSC_INT		7
> +#define IRQ_TIMBERDALE_SDHC		8
> +#define IRQ_TIMBERDALE_ADV7180		9
> +#define IRQ_TIMBERDALE_ETHSW_IF		10
> +#define IRQ_TIMBERDALE_SPI		11
> +#define IRQ_TIMBERDALE_UARTLITE		12
> +#define IRQ_TIMBERDALE_MLCORE		13
> +#define IRQ_TIMBERDALE_MLCORE_BUF	14
> +#define IRQ_TIMBERDALE_RDS		15
> +#define TIMBERDALE_NR_IRQS		16
> +
> +#define GPIO_PIN_ASCB		8
> +#define GPIO_PIN_INIC_RST	14
> +#define GPIO_PIN_BT_RST		15
> +#define GPIO_NR_PINS		16
> +
> +#endif
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
