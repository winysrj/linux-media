Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30301 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbbHSIBm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 04:01:42 -0400
Date: Wed, 19 Aug 2015 11:01:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: serjk@netup.ru
Cc: linux-media@vger.kernel.org
Subject: re: [media] netup_unidvb: NetUP Universal DVB-S/S2/T/T2/C PCI-E card
 driver
Message-ID: <20150819080132.GA30902@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Kozlov Sergey,

The patch 52b1eaf4c59a: "[media] netup_unidvb: NetUP Universal
DVB-S/S2/T/T2/C PCI-E card driver" from Jul 28, 2015, leads to the
following static checker warning:

	drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:84 netup_spi_interrupt()
	error: we previously assumed 'spi' could be null (see line 83)

drivers/media/pci/netup_unidvb/netup_unidvb_spi.c
    78  irqreturn_t netup_spi_interrupt(struct netup_spi *spi)
    79  {
    80          u16 reg;
    81          unsigned long flags;
    82  
    83          if (!spi) {
                    ^^^^
    84                  dev_dbg(&spi->master->dev,
                                ^^^^^^^^^^^^^^^^^
    85                          "%s(): SPI not initialized\n", __func__);
    86                  return IRQ_NONE;
    87          }
    88          spin_lock_irqsave(&spi->lock, flags);


See also:

	drivers/media/pci/netup_unidvb/netup_unidvb_spi.c:238 netup_spi_release()
	error: we previously assumed 'spi' could be null (see line 237)

regards,
dan carpenter
