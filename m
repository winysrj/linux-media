Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:40578 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbbBSMkj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 07:40:39 -0500
Date: Thu, 19 Feb 2015 12:40:37 +0000
From: Sean Young <sean@mess.org>
To: Philip Downer <pdowner@prospero-tech.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] [media] pci: Add support for DVB PCIe cards from
 Prospero Technologies Ltd.
Message-ID: <20150219124037.GA3500@gofer.mess.org>
References: <1424116126-14052-1-git-send-email-pdowner@prospero-tech.com>
 <1424116126-14052-2-git-send-email-pdowner@prospero-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1424116126-14052-2-git-send-email-pdowner@prospero-tech.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 16, 2015 at 07:48:46PM +0000, Philip Downer wrote:
-snip-
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

RC_MAP_LIRC isn't really a useful default; no remote will work with that.
Other drivers default to RC_MAP_RC6_MCE if no remote was provided with 
the product. I don't know if this is good choice, but at least it is
consistent.

> +
> +	dev->driver_name = "prospero";
> +	dev->priv = p;
> +	dev->open = prospero_ir_open;
> +	dev->close = prospero_ir_close;
> +	dev->driver_type = RC_DRIVER_IR_RAW;
> +	dev->timeout = 10 * 1000 * 1000;

There is a MS_TO_NS() macro for this.


Sean
