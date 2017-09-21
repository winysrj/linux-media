Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:6537 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751929AbdIUOgu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 10:36:50 -0400
Date: Thu, 21 Sep 2017 15:36:29 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
Subject: Re: [RFC PATCH v5 2/6] i2c: add helpers to ease DMA handling
Message-ID: <20170921153629.00001aae@huawei.com>
In-Reply-To: <20170921141528.xre53zpxwk355uih@ninjato>
References: <20170920185956.13874-1-wsa+renesas@sang-engineering.com>
        <20170920185956.13874-3-wsa+renesas@sang-engineering.com>
        <20170921145922.000017b5@huawei.com>
        <20170921150554.0000273b@huawei.com>
        <20170921141528.xre53zpxwk355uih@ninjato>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 21 Sep 2017 16:15:28 +0200
Wolfram Sang <wsa@the-dreams.de> wrote:

> > > > +/**
> > > > + * i2c_release_dma_safe_msg_buf - release DMA safe buffer and sync with i2c_msg
> > > > + * @msg: the message to be synced with
> > > > + * @buf: the buffer obtained from i2c_get_dma_safe_msg_buf(). May be NULL.
> > > > + */
> > > > +void i2c_release_dma_safe_msg_buf(struct i2c_msg *msg, u8 *buf)
> > > > +{
> > > > +	if (!buf || buf == msg->buf)
> > > > +		return;
> > > > +
> > > > +	if (msg->flags & I2C_M_RD)
> > > > +		memcpy(msg->buf, buf, msg->len);
> > > > +
> > > > +	kfree(buf);  
> > 
> > Only free when you actually allocated it.  Seems to me like you need
> > to check if (!(msg->flags & I2C_M_DMA_SAFE)) before kfree.
> > 
> > Otherwise the logic to do this will be needed in every driver
> > which will get irritating fast.  
> 
> Well, I return early if (buf == msg->buf) which is only true for
> I2C_M_DMA_SAFE. If not, I allocated the buffer. Am I missing something?
> It would be very strange to call this function if the caller allocated
> the buffer manually.
> 
> Thanks for the review!

Doh missed that check and my comment was bonkers even if it hadn't been there.
I come back to the claim of insufficient caffeine.

You are quite correct.  Please ignore previous comment - the code is
fine as is. 

Jonathan
> 
> 
