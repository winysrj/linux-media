Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:36263 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbcGUBJ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 21:09:29 -0400
Date: Thu, 21 Jul 2016 10:09:26 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi@etezian.org>
Subject: Re: [RFC 7/7] [media] rc: add support for IR LEDs driven through SPI
Message-id: <20160721010926.GG23521@samsunx.samsung>
References: <1468943818-26025-1-git-send-email-andi.shyti@samsung.com>
 <1468943818-26025-8-git-send-email-andi.shyti@samsung.com>
 <CGME20160719231129epcas1p1ac5071e745ba5b938be1ed1de5220fbe@epcas1p1.samsung.com>
 <20160719231122.GA25146@gofer.mess.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20160719231122.GA25146@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

> > +	int ret;
> > +	struct ir_spi_data *idata = (struct ir_spi_data *) dev->priv;
> 
> No cast needed.

yes, thanks.

> > +	ret = regulator_enable(idata->regulator);
> > +	if (ret)
> > +		return ret;
> > +
> > +	mutex_lock(&idata->mutex);
> > +	idata->xfer.len = n;
> > +	idata->xfer.tx_buf = buffer;
> > +	mutex_unlock(&idata->mutex);
> 
> I'm not convinced the locking works here. You want to guard against 
> someone modifying xfer while you are sending (so in spi_sync_transfer), 
> which this locking is not doing. You could declare a 
> local "struct spi_transfer xfer" and avoid the mutex altogether.

I cannot declare xfer locally because the spi framework needs
a statically allocated xfer, so that either I dynamically
allocate it in the function or I declare it global in idata.

With the mutex I would like to prevent different tasks to change
the value at the same time, it's an easy case, it shouldn't make
much difference.

There are checkpatch issues, in the next patchset I will fix
them.

Thanks a lot for your review,
Andi
