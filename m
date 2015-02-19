Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:52253 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbbBSLGr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 06:06:47 -0500
Date: Thu, 19 Feb 2015 11:06:45 +0000
From: Sean Young <sean@mess.org>
To: Philip Downer <pdowner@prospero-tech.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] [media] pci: Add support for DVB PCIe cards from
 Prospero Technologies Ltd.
Message-ID: <20150219110645.GA2608@gofer.mess.org>
References: <1424116126-14052-1-git-send-email-pdowner@prospero-tech.com>
 <1424116126-14052-2-git-send-email-pdowner@prospero-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1424116126-14052-2-git-send-email-pdowner@prospero-tech.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 16, 2015 at 07:48:46PM +0000, Philip Downer wrote:
> This patch adds support for the Vortex 1 PCIe card from Prospero
> Technologies Ltd. The Vortex 1 supports up to 8 tuner modules and
> currently ships with 8xDibcom 7090p tuners. The card also has raw
> infra-red support and a hardware demuxer.
> 
-snip-
> diff --git a/drivers/media/pci/prospero/prospero_ir.c b/drivers/media/pci/prospero/prospero_ir.c
> new file mode 100644
> index 0000000..01e5204
> --- /dev/null
> +++ b/drivers/media/pci/prospero/prospero_ir.c
> @@ -0,0 +1,150 @@
> +/*
> + *  Infra-red driver for PCIe DVB cards from Prospero Technology Ltd.
> + *
> + *  Copyright Prospero Technology Ltd. 2014
> + *  Written/Maintained by Philip Downer
> + *  Contact: pdowner@prospero-tech.com
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + */
> +
> +#include <media/rc-core.h>
> +#include "prospero_ir.h"
> +
> +#define DURATION_MASK 0x7FFFF
> +#define PULSE_MASK 0x1000000
> +#define FIFO_FILL_MASK 0xFF
> +
> +#define FIFO_FILL 0x60
> +#define FIFO 0x64
> +
> +struct prospero_IR {
> +	struct prospero_device *pdev;
> +	struct rc_dev *dev;
> +
> +	int users;

The users field is never used.

> +
> +	char name[32];
> +	char phys[32];
> +};
> +
> +static int prospero_ir_open(struct rc_dev *rc)
> +{
> +	struct prospero_device *p = rc->priv;
> +
> +	p->ir->users++;
> +	return 0;
> +
> +}
> +
> +static void prospero_ir_close(struct rc_dev *rc)
> +{
> +	struct prospero_device *p = rc->priv;
> +
> +	p->ir->users--;
> +
> +}

Since the users field is never read these functions are unnecessary and 
can be removed.

> +
> +void ir_interrupt(struct prospero_pci *p_pci)
> +{
> +
> +	struct prospero_device *p = p_pci->p_dev;
> +	struct prospero_IR *ir = p->ir;
> +	struct ir_raw_event ev;
> +	int tmp = 0;
> +	int fill = 0;
> +	int pulse = 0;
> +	int duration = 0;
> +
> +	pr_debug("Infra: Interrupt!\n");
> +
> +	tmp = ioread32(p_pci->io_mem + FIFO_FILL);
> +	fill = tmp & FIFO_FILL_MASK;
> +
> +	init_ir_raw_event(&ev);
> +
> +	while (fill > 0) {
> +
> +		pr_debug("Infra: fifo fill = %d\n", fill);
> +
> +		tmp = ioread32(p_pci->io_mem + FIFO);
> +		pr_debug("Infra: raw dump = 0x%x\n", tmp);
> +		pulse = (tmp & PULSE_MASK) >> 24;
> +		duration = (tmp & DURATION_MASK) * 1000;	/* Convert uS to nS */
> +
> +		pr_debug("Infra: pulse = %d; duration = %d\n", pulse, duration);
> +
> +		ev.pulse = pulse;
> +		ev.duration = duration;
> +		ir_raw_event_store_with_filter(ir->dev, &ev);
> +		fill--;
> +	}
> +	ir_raw_event_handle(ir->dev);
> +
> +}
> +
> +int prospero_ir_init(struct prospero_device *p)
> +{
> +
> +	struct prospero_pci *p_pci = p->bus_specific;
> +	struct pci_dev *pci = p_pci->pcidev;
> +	struct prospero_IR *ir;
> +	struct rc_dev *dev;
> +	int err = -ENOMEM;
> +
> +	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
> +
> +	dev = rc_allocate_device();
> +
> +	if (!ir || !dev)
> +		goto err_out_free;
> +
> +	ir->dev = dev;
> +
> +	snprintf(ir->name, sizeof(ir->name), "prospero IR");
> +	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0", pci_name(pci));
> +
> +	dev->input_name = ir->name;
> +	dev->input_phys = ir->phys;
> +	dev->input_id.bustype = BUS_PCI;
> +	dev->input_id.version = 1;
> +	dev->input_id.vendor = pci->vendor;
> +	dev->input_id.product = pci->device;
> +
> +	dev->dev.parent = &pci->dev;
> +	dev->map_name = RC_MAP_LIRC;
> +
> +	dev->driver_name = "prospero";
> +	dev->priv = p;
> +	dev->open = prospero_ir_open;
> +	dev->close = prospero_ir_close;
> +	dev->driver_type = RC_DRIVER_IR_RAW;
> +	dev->timeout = 10 * 1000 * 1000;

If you know the rx_resolution, please provide it. The lirc interface
can query it.

> +
> +	iowrite32(0x12000, p_pci->io_mem + FIFO_FILL);
> +
> +	ir->pdev = p;
> +	p->ir = ir;
> +
> +	err = rc_register_device(dev);
> +	if (err)
> +		goto err_out_free;
> +
> +	return 0;
> +
> + err_out_free:
> +	rc_free_device(dev);
> +	p->ir = NULL;
> +	kfree(ir);
> +	return -ENOMEM;
> +
> +}
Thanks

Sean
