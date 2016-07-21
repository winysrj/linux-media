Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:52749 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbcGUKWM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 06:22:12 -0400
Date: Thu, 21 Jul 2016 11:22:09 +0100
From: Sean Young <sean@mess.org>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi@etezian.org>
Subject: Re: [RFC 7/7] [media] rc: add support for IR LEDs driven through SPI
Message-ID: <20160721102208.GA1246@gofer.mess.org>
References: <1468943818-26025-1-git-send-email-andi.shyti@samsung.com>
 <1468943818-26025-8-git-send-email-andi.shyti@samsung.com>
 <CGME20160719231129epcas1p1ac5071e745ba5b938be1ed1de5220fbe@epcas1p1.samsung.com>
 <20160719231122.GA25146@gofer.mess.org>
 <20160721010926.GG23521@samsunx.samsung>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160721010926.GG23521@samsunx.samsung>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andi,

On Thu, Jul 21, 2016 at 10:09:26AM +0900, Andi Shyti wrote:
> > > +	ret = regulator_enable(idata->regulator);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	mutex_lock(&idata->mutex);
> > > +	idata->xfer.len = n;
> > > +	idata->xfer.tx_buf = buffer;
> > > +	mutex_unlock(&idata->mutex);
> > 
> > I'm not convinced the locking works here. You want to guard against 
> > someone modifying xfer while you are sending (so in spi_sync_transfer), 
> > which this locking is not doing. You could declare a 
> > local "struct spi_transfer xfer" and avoid the mutex altogether.
> 
> I cannot declare xfer locally because the spi framework needs
> a statically allocated xfer, so that either I dynamically
> allocate it in the function or I declare it global in idata.

It can be stack allocated for sync transfers. You might want to lock
the spi bus.

> With the mutex I would like to prevent different tasks to change
> the value at the same time, it's an easy case, it shouldn't make
> much difference.

That's cargo-cult locking. It does not achieve anything.


Sean
