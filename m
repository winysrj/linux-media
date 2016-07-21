Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:48455 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbcGUOnQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 10:43:16 -0400
Date: Thu, 21 Jul 2016 15:43:13 +0100
From: Sean Young <sean@mess.org>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi@etezian.org>
Subject: Re: [RFC 5/7] [media] ir-lirc-codec: do not handle any buffer for
 raw transmitters
Message-ID: <20160721144313.GA2820@gofer.mess.org>
References: <1468943818-26025-1-git-send-email-andi.shyti@samsung.com>
 <1468943818-26025-6-git-send-email-andi.shyti@samsung.com>
 <CGME20160719221617epcas1p45a886e86e2040ce40565acd32d778555@epcas1p4.samsung.com>
 <20160719221610.GC24697@gofer.mess.org>
 <20160721004812.GF23521@samsunx.samsung>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160721004812.GF23521@samsunx.samsung>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andi,

On Thu, Jul 21, 2016 at 09:48:12AM +0900, Andi Shyti wrote:
> > > Raw transmitters receive the data which need to be sent to
> > > receivers from userspace as stream of bits, they don't require
> > > any handling from the lirc framework.
> > 
> > No drivers of type RC_DRIVER_IR_RAW_TX should handle tx just like any
> > other device, so data should be provided as an array of u32 alternating
> > pulse-space. If your device does not handle input like that then convert
> > it into that format in the driver. Every other driver has to do some
> > sort of conversion of that kind.
> 
> I don't see anything wrong here, that's how it works for example
> in Tizen or in Android for the boards I'm on: userspace sends a
> stream of bits that are then submitted to the IR as they are.

This introduces a new, incompatible api with no way of detecting it.

It's not a good format. For example the leading pulse (9ms) for nec ir
with a carrier of 38000 will be 342 bits. With the pulse-space format
it will be 32 bits.

Doing the conversion in kernel space will be cheap.

> If I change it to only pulse-space domain, then I wouldn't
> provide support for those platforms. Eventually I can add a new
> protocol.

But this is forcing an new, incompatible api onto the rest of us. 

This is the code in tizen:

https://build.tizen.org/package/rdiff?linkrev=base&package=device-manager-plugin-exynos5433&project=Tizen%3AIVI&rev=2

If this patch was merged as-is tizen would have to be changed anyway
to use different ioctls. If that is true, can it switch to use 
pulse-space format in the same change? If LIRC_GET_FREQUENCY fails then
it would be a main-line kernel, else the existent driver.

I could not find the code in android. It might be useful to see so we
can find a solution that works for everyone.


Sean
