Return-path: <linux-media-owner@vger.kernel.org>
Received: from etezian.org ([198.101.225.253]:55601 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320AbcGEPIf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Jul 2016 11:08:35 -0400
Date: Wed, 6 Jul 2016 00:08:26 +0900
From: Andi Shyti <andi@etezian.org>
To: Rob Herring <robh@kernel.org>
Cc: Andi Shyti <andi.shyti@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mark Rutland <mark.rutland@arm.com>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH] [media] rc: ir-spi: add support for IR LEDs connected
 with SPI
Message-ID: <20160705150826.GG1257@jack.zhora.eu>
References: <1467362022-12704-1-git-send-email-andi.shyti@samsung.com>
 <20160705142211.GA19930@rob-hp-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160705142211.GA19930@rob-hp-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

> > The ir-spi is a simple device driver which supports the
> > connection between an IR LED and the MOSI line of an SPI device.
> 
> Please split the binding from the driver.

OK!

> > +Device tree bindings for IR LED connected through SPI bus which is used as
> > +remote controller.
> 
> Do said devices have part numbers? Seems kind of generic and I've never 
> seen such device.

No, it doesn't, this is a simple irled driven by the SPI MOSI
line that works as a remote controller.

It looked strange to me as well when I heard of it the first
time, but it will be present in the upcoming tm2/tm2e patchset 
(i.e. Samsung Note 4 and Note 4 edge).

> > +Optional properties:
> > +	- irled,switch: specifies the gpio switch which enables the irled
> 
> Just "switch-gpios"

OK!

> > +                controller-data {
> 
> This is part of the controller binding? Omit that from the example.

OK!

Thanks,
Andi
