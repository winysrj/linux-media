Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:49194 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932620AbeGJMPu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 08:15:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        linux-i2c@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH -next v3 1/2] i2c: add SCCB helpers
Date: Tue, 10 Jul 2018 15:16:21 +0300
Message-ID: <30027540.g4E5J49NzT@avalon>
In-Reply-To: <20180710120747.s7yg36moaw2xsrim@tetsubishi>
References: <1531150874-4595-1-git-send-email-akinobu.mita@gmail.com> <5320256.KVvq6sUnyz@avalon> <20180710120747.s7yg36moaw2xsrim@tetsubishi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wolfram,

On Tuesday, 10 July 2018 15:07:47 EEST Wolfram Sang wrote:
> >> +static inline int sccb_read_byte(struct i2c_client *client, u8 addr)
> >> +{
> >> +	int ret;
> >> +	union i2c_smbus_data data;
> >> +
> >> +	i2c_lock_bus(client->adapter, I2C_LOCK_SEGMENT);
> >> +
> >> +	ret = __i2c_smbus_xfer(client->adapter, client->addr, client->flags,
> >> +				I2C_SMBUS_WRITE, addr, I2C_SMBUS_BYTE, NULL);
> >> +	if (ret < 0)
> >> +		goto out;
> >> +
> >> +	ret = __i2c_smbus_xfer(client->adapter, client->addr, client->flags,
> >> +				I2C_SMBUS_READ, 0, I2C_SMBUS_BYTE, &data);
> >> +out:
> >> +	i2c_unlock_bus(client->adapter, I2C_LOCK_SEGMENT);
> >> +
> >> +	return ret < 0 ? ret : data.byte;
> >> +}
> > 
> > I think I mentioned in a previous review of this patch that the function
> > is too big to be a static inline. It should instead be moved to a .c file.
> 
> Can be argued.

Especially if sccb_read_byte() is called in multiple places in a driver, not 
just once in a read helper, as you've advised for patch 2/2 in this series :-)

> I assume just removing the 'inline' won't do it for you?

Just removing the inline keyword will create many instances of the function, 
even when not used. I think it will also cause the compiler to emit warnings 
for unused functions. I don't think that's a good idea.

> I'd be fine with that, there are not many SCCB useres out there...
> 
> But if you insist on drivers/i2c/i2c-sccb.c, then it should be a
> seperate module, I'd think?

Given how small the functions are, I wouldn't request that, as it would 
introduce another Kconfig symbol, but I'm not opposed to such a new module 
either.

-- 
Regards,

Laurent Pinchart
