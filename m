Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:16727 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab2FJUzE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 16:55:04 -0400
Date: Sun, 10 Jun 2012 23:54:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [media] DRX-K: Initial check-in
Message-ID: <20120610205451.GF13539@mwanda>
References: <20120608134635.GA19517@elgon.mountain>
 <20436.63646.824176.351205@morden.metzler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20436.63646.824176.351205@morden.metzler>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 10, 2012 at 09:42:22PM +0200, Ralph Metzler wrote:
> Dan Carpenter writes:
>  > Hello Ralph Metzler,
>  > 
>  > The patch 43dd07f758d8: "[media] DRX-K: Initial check-in" from Jul 3, 
>  > 2011, leads to the following warning:
>  > drivers/media/dvb/frontends/drxk_hard.c:2980 ADCSynchronization()
>  > 	 warn: suspicious bitop condition
>  > 
>  >   2977                  status = read16(state, IQM_AF_CLKNEG__A, &clkNeg);
>  >   2978                  if (status < 0)
>  >   2979                          goto error;
>  >   2980                  if ((clkNeg | IQM_AF_CLKNEG_CLKNEGDATA__M) ==
>  >   2981                          IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_POS) {
>  > 
>  > IQM_AF_CLKNEG_CLKNEGDATA__M is 2.
>  > IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_POS is 0.
>  > So this condition can never be true.
> 
> It seems this should be & instead of |. The mistake was also present in the windows driver.
> 

Good deal.  Do you want me to send a patch, or are you going to
handle it?  Could I get a Reported-by cookie?

> 
>  > 
>  >   2982                          clkNeg &= (~(IQM_AF_CLKNEG_CLKNEGDATA__M));
>  >   2983                          clkNeg |=
>  >   2984                                  IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_NEG;
>  >   2985                  } else {
>  >   2986                          clkNeg &= (~(IQM_AF_CLKNEG_CLKNEGDATA__M));
>  >   2987                          clkNeg |=
>  >   2988                                  IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_POS;
>  > 
>  > 	clkNeg |= 0; <-- doesn't make much sense to the unenlightened.
>  > 
>  >   2989                  }
> 
> This is perfectly normal since those defines were automatically created from the 
> firmware source code. It is better to leave the code as it is. If there ever is a firmware update 
> and these bits change their values it will be much harder to adjust the driver.
> 

Sounds good.  When I ran my script against the kernel it turns out
that doing x |= FOO; where foo is zero is very normal.

regards,
dan carpenter

