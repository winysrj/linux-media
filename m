Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:48216 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbcGUAoR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 20:44:17 -0400
Date: Thu, 21 Jul 2016 09:44:14 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi@etezian.org>
Subject: Re: [RFC 3/7] [media] rc-core: add support for IR raw transmitters
Message-id: <20160721004414.GE23521@samsunx.samsung>
References: <1468943818-26025-1-git-send-email-andi.shyti@samsung.com>
 <1468943818-26025-4-git-send-email-andi.shyti@samsung.com>
 <CGME20160719221032epcas1p2b16f0fef9fb0db8ecb650995fa702bb5@epcas1p2.samsung.com>
 <20160719221027.GB24697@gofer.mess.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20160719221027.GB24697@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

> > +	if (dev->driver_type == RC_DRIVER_IR_RAW ||
> > +				dev->driver_type == RC_DRIVER_IR_RAW_TX) {
> 
> Here the if is wrong. It should be 
> "if (dev->driver_type != RC_DRIVER_IR_RAW_TX)". Note that as result
> the decoder thread is not started, so patch 4 won't be needed either.

but I need the ir-lirc-codec as it handles the interface with
userspace and it calls the tx_ir and s_tx_carrier.

if I do "if (dev->driver_type != RC_DRIVER_IR_RAW_TX)" the
lirc-codec is not called and I would need to handle it on my
driver, but then we fall in the first version of the driver.

Thanks,
Andi

> >  		if (!raw_init) {
> >  			request_module_nowait("ir-lirc-codec");
> >  			raw_init = true;
