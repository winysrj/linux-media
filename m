Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:58243 "EHLO
        usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752784AbcJLCMW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 22:12:22 -0400
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
 by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OEW00MO5WSKXP50@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 11 Oct 2016 22:12:20 -0400 (EDT)
Date: Tue, 11 Oct 2016 23:12:16 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: Re:
 [linux-review:Mauro-Carvalho-Chehab/Don-t-use-stack-for-DMA-transers-on-media-usb-drivers/20161011-182408 3/31]
 drivers/media/usb/dvb-usb/cinergyT2-core.c:174:2-8: preceding lock on line 169
Message-id: <20161011231216.21b1c8fb.m.chehab@samsung.com>
In-reply-to: <alpine.DEB.2.10.1610112341380.3192@hadrien>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
References: <alpine.DEB.2.10.1610111515300.2883@hadrien>
 <CGME20161011131638uscas1p2f968a6dadabcf9b3c95eabe17116b3fd@uscas1p2.samsung.com>
 <alpine.DEB.2.10.1610111516130.2883@hadrien>
 <20161011182844.12e00307.m.chehab@samsung.com>
 <alpine.DEB.2.10.1610112341380.3192@hadrien>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Oct 2016 23:41:53 +0200 (CEST)
Julia Lawall <julia.lawall@lip6.fr> escreveu:

> On Tue, 11 Oct 2016, Mauro Carvalho Chehab wrote:
> 
> > Em Tue, 11 Oct 2016 15:16:24 +0200 (CEST)
> > Julia Lawall <julia.lawall@lip6.fr> escreveu:
> >  
> > > On Tue, 11 Oct 2016, Julia Lawall wrote:
> > >  
> > > > It looks like a lock may be needed before line 174.  
> > >
> > > Sorry, an unlock.  
> >
> > I suspect that this is a false positive warning, as there is a
> > mutex unlock on the same routine, at line 203. All exit
> > conditions go to the unlock condition.  
> 
> There is a direct exit in line 174.

Ah! I was looking at the wrong patch (cinergyT2-core: don't do DMA on stack).

Thanks for pointing it. I'll the affected code to:

-       dvb_usb_generic_rw(d, st->data, 1, st->data, 5, 0);
+       ret = dvb_usb_generic_rw(d, st->data, 1, st->data, 5, 0);
+       if (ret < 0)
+               goto ret;

Regards,
Mauro
-- 
Thanks,
Mauro
