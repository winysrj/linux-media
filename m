Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:43371 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab2FOQyO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 12:54:14 -0400
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20443.26804.127414.204912@morden.metzler>
Date: Fri, 15 Jun 2012 18:54:12 +0200
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [media] DRX-K: Initial check-in
In-Reply-To: <20120610205451.GF13539@mwanda>
References: <20120608134635.GA19517@elgon.mountain>
	<20436.63646.824176.351205@morden.metzler>
	<20120610205451.GF13539@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dan Carpenter writes:
 > On Sun, Jun 10, 2012 at 09:42:22PM +0200, Ralph Metzler wrote:
 > > Dan Carpenter writes:
 > >  > Hello Ralph Metzler,
 > >  > 
 > >  > The patch 43dd07f758d8: "[media] DRX-K: Initial check-in" from Jul 3, 
 > >  > 2011, leads to the following warning:
 > >  > drivers/media/dvb/frontends/drxk_hard.c:2980 ADCSynchronization()
 > >  > 	 warn: suspicious bitop condition
 > >  > 
 > >  >   2977                  status = read16(state, IQM_AF_CLKNEG__A, &clkNeg);
 > >  >   2978                  if (status < 0)
 > >  >   2979                          goto error;
 > >  >   2980                  if ((clkNeg | IQM_AF_CLKNEG_CLKNEGDATA__M) ==
 > >  >   2981                          IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_POS) {
 > >  > 
 > >  > IQM_AF_CLKNEG_CLKNEGDATA__M is 2.
 > >  > IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_POS is 0.
 > >  > So this condition can never be true.
 > > 
 > > It seems this should be & instead of |. The mistake was also present in the windows driver.
 > > 
 > 
 > Good deal.  Do you want me to send a patch, or are you going to
 > handle it?  Could I get a Reported-by cookie?

Please send a patch. 
I am not maintaining the kernel version.

Regards,
Ralph
