Return-path: <linux-media-owner@vger.kernel.org>
Received: from etezian.org ([198.101.225.253]:55202 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbcGAOAr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2016 10:00:47 -0400
Date: Fri, 1 Jul 2016 23:00:42 +0900
From: Andi Shyti <andi@etezian.org>
To: Sean Young <sean@mess.org>
Cc: Andi Shyti <andi.shyti@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH] [media] rc: ir-spi: add support for IR LEDs connected
 with SPI
Message-ID: <20160701140042.GB1257@jack.zhora.eu>
References: <1467362022-12704-1-git-send-email-andi.shyti@samsung.com>
 <CGME20160701094505epcas1p469fb8084bd5195cdab5555a9f3368682@epcas1p4.samsung.com>
 <20160701094458.GA8933@gofer.mess.org>
 <20160701123035.GA12029@samsunx.samsung>
 <20160701132219.GA3752@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160701132219.GA3752@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

> > > Also I don't see what justifies this new interface. This can be 
> > > implemented in rc-core in less lines of code and it will be entirely 
> > > compatible with existing user-space.
> > 
> > Also here I'm getting a bit confused. When I started writing
> > this, I didn't even know of the existence of a remote controlling
> > framework, but then I run across this:
> > 
> > "LIRC is a package that allows you to decode and send infra-red
> > signals of many (but not all) commonly used remote controls. "
> > 
> > taken from lirc.org: my case is exactly falling into this
> > description.
> > 
> > Am I missing anything?
> 
> See drivers/staging/media/lirc/TODO: "All drivers should either be 
> ported to ir-core, or dropped entirely".  ir-core has since been renamed 
> to rc-core; it is uses for non-IR purposes like cec.
> 
> lirc exists as the user-space ABI but not it is not the preferred 
> framework for kernel space.

I missed this part and now what you say makes sense.

> I'm happy to help. 

I will do as you recommend and thanks a lot, appreciated :)

Andi
