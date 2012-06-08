Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:27223 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab2FHNqp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2012 09:46:45 -0400
Date: Fri, 8 Jun 2012 16:46:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: rjkm@metzlerbros.de
Cc: linux-media@vger.kernel.org
Subject: re: [media] DRX-K: Initial check-in
Message-ID: <20120608134635.GA19517@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Ralph Metzler,

The patch 43dd07f758d8: "[media] DRX-K: Initial check-in" from Jul 3, 
2011, leads to the following warning:
drivers/media/dvb/frontends/drxk_hard.c:2980 ADCSynchronization()
	 warn: suspicious bitop condition

  2977                  status = read16(state, IQM_AF_CLKNEG__A, &clkNeg);
  2978                  if (status < 0)
  2979                          goto error;
  2980                  if ((clkNeg | IQM_AF_CLKNEG_CLKNEGDATA__M) ==
  2981                          IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_POS) {

IQM_AF_CLKNEG_CLKNEGDATA__M is 2.
IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_POS is 0.
So this condition can never be true.

  2982                          clkNeg &= (~(IQM_AF_CLKNEG_CLKNEGDATA__M));
  2983                          clkNeg |=
  2984                                  IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_NEG;
  2985                  } else {
  2986                          clkNeg &= (~(IQM_AF_CLKNEG_CLKNEGDATA__M));
  2987                          clkNeg |=
  2988                                  IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_POS;

	clkNeg |= 0; <-- doesn't make much sense to the unenlightened.

  2989                  }

I wrote a Smatch thing to find places that do x |= 0 inspired by the
above oddity and it finds several other places which do that:

drivers/media/dvb/frontends/drxk_hard.c:2525 GetQAMSignalToNoise() info: why not propagate 'status' from read16() instead of -22?
drivers/media/dvb/frontends/drxk_hard.c:2980 ADCSynchronization() warn: suspicious bitop condition
drivers/media/dvb/frontends/drxk_hard.c:2988 ADCSynchronization() warn: x |= 0
drivers/media/dvb/frontends/drxk_hard.c:3833 SetDVBT() warn: x |= 0
drivers/media/dvb/frontends/drxk_hard.c:3847 SetDVBT() warn: x |= 0
drivers/media/dvb/frontends/drxk_hard.c:3888 SetDVBT() warn: x |= 0
drivers/media/dvb/frontends/drxk_hard.c:3915 SetDVBT() warn: x |= 0
drivers/media/dvb/frontends/drxk_hard.c:3931 SetDVBT() warn: x |= 0

regards,
dan carpenter

