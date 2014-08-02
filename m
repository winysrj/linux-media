Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:60883 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324AbaHBMhw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Aug 2014 08:37:52 -0400
Message-ID: <53DCDB79.7020209@gentoo.org>
Date: Sat, 02 Aug 2014 14:37:13 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-media@vger.kernel.org
Subject: Re: [media] si2165: Add demod driver for DVB-T only
References: <20140801152300.GA614@mwanda>
In-Reply-To: <20140801152300.GA614@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01.08.2014 17:23, Dan Carpenter wrote:
> Hello Matthias Schwarzott,
> 
Hello Dan,

> The patch 3e54a1697ace: "[media] si2165: Add demod driver for DVB-T
> only" from Jul 22, 2014, leads to the following static checker
> warning:
> 
> 	drivers/media/dvb-frontends/si2165.c:329 si2165_wait_init_done()
> 	warn: signedness bug returning '(-22)'
> 
> drivers/media/dvb-frontends/si2165.c
>    315  static bool si2165_wait_init_done(struct si2165_state *state)
>    316  {
>    317          int ret = -EINVAL;
>    318          u8 val = 0;
>    319          int i;
>    320  
>    321          for (i = 0; i < 3; ++i) {
>    322                  si2165_readreg8(state, 0x0054, &val);
>    323                  if (val == 0x01)
>    324                          return 0;
> 
> This is the success path?
yes it is.

> 
>    325                  usleep_range(1000, 50000);
>    326          }
>    327          dev_err(&state->i2c->dev, "%s: init_done was not set\n",
>    328                  KBUILD_MODNAME);
>    329          return ret;
> 
> -EINVAL becomes 1 when casted to bool.

I already noticed this and prepared a patch to change the return type to
int.

This will be sent the next days.

Regards
Matthias

