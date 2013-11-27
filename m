Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54737 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540Ab3K0RWk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Nov 2013 12:22:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Hans Verkuil <hansverk@cisco.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Valentine <valentine.barshak@cogentembedded.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH V2] media: i2c: Add ADV761X support
Date: Wed, 27 Nov 2013 17:29:47 +0100
Message-ID: <3727129.B5lM1JXKsv@avalon>
In-Reply-To: <529606AA.7050209@metafoo.de>
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com> <5295E231.9030200@cisco.com> <529606AA.7050209@metafoo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 27 November 2013 15:50:18 Lars-Peter Clausen wrote:
> On 11/27/2013 01:14 PM, Hans Verkuil wrote:
> [...]
> 
> >>> For our systems the adv7604 interrupts is not always hooked up to a gpio
> >>> irq, instead a register has to be read to figure out which device
> >>> actually produced the irq.
> >> 
> >> Where is that register located ? Shouldn't it be modeled as an interrupt
> >> controller ?
> > 
> > It's a PCIe interrupt whose handler needs to read several FPGA registers
> > in order to figure out which interrupt was actually triggered. I don't
> > know enough about interrupt controller to understand whether it can be
> > modeled as a 'standard' interrupt.
> 
> This sounds as if it should be implemented as a irq_chip driver. There are a
> couple of examples in drivers/irqchip/

Exactly, that was my point. A piece of hardware that takes several interrupt 
inputs, includes mask and flag registers and generate a single interrupt 
towards the system is an interrupt controller and should have be handled by 
the Linux irqchip infrastructure.

-- 
Regards,

Laurent Pinchart

