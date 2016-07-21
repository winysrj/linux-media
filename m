Return-path: <linux-media-owner@vger.kernel.org>
Received: from etezian.org ([198.101.225.253]:57937 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbcGUO5Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 10:57:24 -0400
Date: Thu, 21 Jul 2016 23:57:19 +0900
From: Andi Shyti <andi@etezian.org>
To: Sean Young <sean@mess.org>
Cc: Andi Shyti <andi.shyti@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi@etezian.org>
Subject: Re: [RFC 7/7] [media] rc: add support for IR LEDs driven through SPI
Message-ID: <20160721145719.GB1448@jack.zhora.eu>
References: <1468943818-26025-1-git-send-email-andi.shyti@samsung.com>
 <1468943818-26025-8-git-send-email-andi.shyti@samsung.com>
 <CGME20160719231129epcas1p1ac5071e745ba5b938be1ed1de5220fbe@epcas1p1.samsung.com>
 <20160719231122.GA25146@gofer.mess.org>
 <20160721010926.GG23521@samsunx.samsung>
 <20160721102208.GA1246@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160721102208.GA1246@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

> > > > +	ret = regulator_enable(idata->regulator);
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > > +	mutex_lock(&idata->mutex);
> > > > +	idata->xfer.len = n;
> > > > +	idata->xfer.tx_buf = buffer;
> > > > +	mutex_unlock(&idata->mutex);
> > > 
> > > I'm not convinced the locking works here. You want to guard against 
> > > someone modifying xfer while you are sending (so in spi_sync_transfer), 
> > > which this locking is not doing. You could declare a 
> > > local "struct spi_transfer xfer" and avoid the mutex altogether.
> > 
> > I cannot declare xfer locally because the spi framework needs
> > a statically allocated xfer, so that either I dynamically
> > allocate it in the function or I declare it global in idata.
> 
> It can be stack allocated for sync transfers. You might want to lock
> the spi bus.

no, actually it's just dirty data and laziness, a memset to 0
fixes it :)

> > With the mutex I would like to prevent different tasks to change
> > the value at the same time, it's an easy case, it shouldn't make
> > much difference.
> 
> That's cargo-cult locking. It does not achieve anything.

yes, as I said, it's not a big thing, I can remove the mutex.

Thanks,
Andi
