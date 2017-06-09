Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52961 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751591AbdFIMLV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Jun 2017 08:11:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 09 Jun 2017 15:11:14 +0300
From: Antti Palosaari <crope@iki.fi>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media-owner@vger.kernel.org
In-Reply-To: <20170608165137.Horde.bWBBH3ahbuGABOWprQvJwWG@gator4166.hostgator.com>
References: <20170608165137.Horde.bWBBH3ahbuGABOWprQvJwWG@gator4166.hostgator.com>
Message-ID: <63d70a1e4783d95dac79746161f213a0@iki.fi>
Subject: Re: [media-af9013] question about return value in function
 af9013_wr_regs()
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gustavo A. R. Silva kirjoitti 2017-06-09 00:51:
> Hello everybody,
> 
> While looking into Coverity ID 1227035 I ran into the following piece
> of code at drivers/media/dvb-frontends/af9013.c:595:

> The issue here is that the value stored in variable _ret_ at line 608,
>  is not being evaluated as it happens at line 662, 667, 672 and 677.
> Then after looking into function af9013_wr_regs(), I noticed that this
>  function always returns zero, no matter what, as you can see below:
> 
> 121static int af9013_wr_regs(struct af9013_state *priv, u16 reg, const  
> u8 *val,
> 122        int len)
> 123{
> 124        int ret, i;
> 125        u8 mbox = (0 << 7)|(0 << 6)|(1 << 1)|(1 << 0);
> 126
> 127        if ((priv->config.ts_mode == AF9013_TS_USB) &&
> 128                ((reg & 0xff00) != 0xff00) && ((reg & 0xff00) != 
> 0xae00)) {
> 129                mbox |= ((len - 1) << 2);
> 130                ret = af9013_wr_regs_i2c(priv, mbox, reg, val, len);
> 131        } else {
> 132                for (i = 0; i < len; i++) {
> 133                        ret = af9013_wr_regs_i2c(priv, mbox, reg+i,
>  val+i, 1);
> 134                        if (ret)
> 135                                goto err;
> 136                }
> 137        }
> 138
> 139err:
> 140        return 0;
> 141}

That function should return error code on error case, not zero always.


regards
Antti




-- 
http://palosaari.fi/
