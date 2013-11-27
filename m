Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-138.synserver.de ([212.40.185.138]:1083 "EHLO
	smtp-out-025.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751749Ab3K0Otx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Nov 2013 09:49:53 -0500
Message-ID: <529606AA.7050209@metafoo.de>
Date: Wed, 27 Nov 2013 15:50:18 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Hans Verkuil <hansverk@cisco.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Valentine <valentine.barshak@cogentembedded.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH V2] media: i2c: Add ADV761X support
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com> <52951270.9040804@cogentembedded.com> <5295AB82.2010003@xs4all.nl> <7965472.68k6QZsVH1@avalon> <5295E231.9030200@cisco.com>
In-Reply-To: <5295E231.9030200@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/27/2013 01:14 PM, Hans Verkuil wrote:
[...]
>>> For our systems the adv7604 interrupts is not always hooked up to a gpio
>>> irq, instead a register has to be read to figure out which device actually
>>> produced the irq.
>>
>> Where is that register located ? Shouldn't it be modeled as an interrupt 
>> controller ?
> 
> It's a PCIe interrupt whose handler needs to read several FPGA registers
> in order to figure out which interrupt was actually triggered. I don't
> know enough about interrupt controller to understand whether it can be
> modeled as a 'standard' interrupt.

This sounds as if it should be implemented as a irq_chip driver. There are a
couple of examples in drivers/irqchip/

- Lars

