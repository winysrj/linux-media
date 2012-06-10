Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:14016 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab2FJTmZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 15:42:25 -0400
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20436.63646.824176.351205@morden.metzler>
Date: Sun, 10 Jun 2012 21:42:22 +0200
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org
Subject: re: [media] DRX-K: Initial check-in
In-Reply-To: <20120608134635.GA19517@elgon.mountain>
References: <20120608134635.GA19517@elgon.mountain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dan Carpenter writes:
 > Hello Ralph Metzler,
 > 
 > The patch 43dd07f758d8: "[media] DRX-K: Initial check-in" from Jul 3, 
 > 2011, leads to the following warning:
 > drivers/media/dvb/frontends/drxk_hard.c:2980 ADCSynchronization()
 > 	 warn: suspicious bitop condition
 > 
 >   2977                  status = read16(state, IQM_AF_CLKNEG__A, &clkNeg);
 >   2978                  if (status < 0)
 >   2979                          goto error;
 >   2980                  if ((clkNeg | IQM_AF_CLKNEG_CLKNEGDATA__M) ==
 >   2981                          IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_POS) {
 > 
 > IQM_AF_CLKNEG_CLKNEGDATA__M is 2.
 > IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_POS is 0.
 > So this condition can never be true.

It seems this should be & instead of |. The mistake was also present in the windows driver.


 > 
 >   2982                          clkNeg &= (~(IQM_AF_CLKNEG_CLKNEGDATA__M));
 >   2983                          clkNeg |=
 >   2984                                  IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_NEG;
 >   2985                  } else {
 >   2986                          clkNeg &= (~(IQM_AF_CLKNEG_CLKNEGDATA__M));
 >   2987                          clkNeg |=
 >   2988                                  IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_POS;
 > 
 > 	clkNeg |= 0; <-- doesn't make much sense to the unenlightened.
 > 
 >   2989                  }

This is perfectly normal since those defines were automatically created from the 
firmware source code. It is better to leave the code as it is. If there ever is a firmware update 
and these bits change their values it will be much harder to adjust the driver.


Regards,
Ralph

