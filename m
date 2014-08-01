Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49721 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaHAPX2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Aug 2014 11:23:28 -0400
Date: Fri, 1 Aug 2014 18:23:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: zzam@gentoo.org
Cc: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org
Subject: re: [media] si2165: Add demod driver for DVB-T only
Message-ID: <20140801152300.GA614@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Matthias Schwarzott,

The patch 3e54a1697ace: "[media] si2165: Add demod driver for DVB-T
only" from Jul 22, 2014, leads to the following static checker
warning:

	drivers/media/dvb-frontends/si2165.c:329 si2165_wait_init_done()
	warn: signedness bug returning '(-22)'

drivers/media/dvb-frontends/si2165.c
   315  static bool si2165_wait_init_done(struct si2165_state *state)
   316  {
   317          int ret = -EINVAL;
   318          u8 val = 0;
   319          int i;
   320  
   321          for (i = 0; i < 3; ++i) {
   322                  si2165_readreg8(state, 0x0054, &val);
   323                  if (val == 0x01)
   324                          return 0;

This is the success path?

   325                  usleep_range(1000, 50000);
   326          }
   327          dev_err(&state->i2c->dev, "%s: init_done was not set\n",
   328                  KBUILD_MODNAME);
   329          return ret;

-EINVAL becomes 1 when casted to bool.

   330  }

regards,
dan carpenter
