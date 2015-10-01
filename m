Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:16183 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbbJAXa4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Oct 2015 19:30:56 -0400
Date: Fri, 2 Oct 2015 07:29:57 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Kozlov Sergey <serjk@netup.ru>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:84:16-22: ERROR:
 spi is NULL but dereferenced.
Message-ID: <201510020755.fZppgHzI%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   ccf70ddcbe9984cee406be2bacfedd5e4776919d
commit: 52b1eaf4c59a3bbd07afbb4ab4f43418a807d02e [media] netup_unidvb: NetUP Universal DVB-S/S2/T/T2/C PCI-E card driver
date:   7 weeks ago


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:84:16-22: ERROR: spi is NULL but dereferenced.
   drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:238:16-22: ERROR: spi is NULL but dereferenced.

vim +84 drivers/media/pci/netup_unidvb/netup_unidvb_spi.c

    68	};
    69	
    70	static struct spi_board_info netup_spi_board = {
    71		.modalias = "m25p128",
    72		.max_speed_hz = 11000000,
    73		.chip_select = 0,
    74		.mode = SPI_MODE_0,
    75		.platform_data = &spi_flash_data,
    76	};
    77	
    78	irqreturn_t netup_spi_interrupt(struct netup_spi *spi)
    79	{
    80		u16 reg;
    81		unsigned long flags;
    82	
    83		if (!spi) {
  > 84			dev_dbg(&spi->master->dev,
    85				"%s(): SPI not initialized\n", __func__);
    86			return IRQ_NONE;
    87		}
    88		spin_lock_irqsave(&spi->lock, flags);
    89		reg = readw(&spi->regs->control_stat);
    90		if (!(reg & NETUP_SPI_CTRL_IRQ)) {
    91			spin_unlock_irqrestore(&spi->lock, flags);
    92			dev_dbg(&spi->master->dev,

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
