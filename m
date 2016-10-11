Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:42550
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752718AbcJKVms (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 17:42:48 -0400
Date: Tue, 11 Oct 2016 23:41:53 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: Re: [linux-review:Mauro-Carvalho-Chehab/Don-t-use-stack-for-DMA-transers-on-media-usb-drivers/20161011-182408
 3/31] drivers/media/usb/dvb-usb/cinergyT2-core.c:174:2-8: preceding lock on
 line 169
In-Reply-To: <20161011182844.12e00307.m.chehab@samsung.com>
Message-ID: <alpine.DEB.2.10.1610112341380.3192@hadrien>
References: <alpine.DEB.2.10.1610111515300.2883@hadrien> <CGME20161011131638uscas1p2f968a6dadabcf9b3c95eabe17116b3fd@uscas1p2.samsung.com> <alpine.DEB.2.10.1610111516130.2883@hadrien> <20161011182844.12e00307.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 11 Oct 2016, Mauro Carvalho Chehab wrote:

> Em Tue, 11 Oct 2016 15:16:24 +0200 (CEST)
> Julia Lawall <julia.lawall@lip6.fr> escreveu:
>
> > On Tue, 11 Oct 2016, Julia Lawall wrote:
> >
> > > It looks like a lock may be needed before line 174.
> >
> > Sorry, an unlock.
>
> I suspect that this is a false positive warning, as there is a
> mutex unlock on the same routine, at line 203. All exit
> conditions go to the unlock condition.

There is a direct exit in line 174.

julia

>
> Am I missing something?
>
> >
> > >
> > > julia
> > >
> > > ---------- Forwarded message ----------
> > > Date: Tue, 11 Oct 2016 21:06:18 +0800
> > > From: kbuild test robot <fengguang.wu@intel.com>
> > > To: kbuild@01.org
> > > Cc: Julia Lawall <julia.lawall@lip6.fr>
> > > Subject:
> > >     [linux-review:Mauro-Carvalho-Chehab/Don-t-use-stack-for-DMA-transers-on-medi
> > >     a-usb-drivers/20161011-182408 3/31]
> > >     drivers/media/usb/dvb-usb/cinergyT2-core.c:174:2-8: preceding lock on line
> > >     169
> > >
> > > CC: kbuild-all@01.org
> > > TO: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > > CC: linux-media@vger.kernel.org
> > > CC: 0day robot <fengguang.wu@intel.com>
> > >
> > > tree:   https://github.com/0day-ci/linux Mauro-Carvalho-Chehab/Don-t-use-stack-for-DMA-transers-on-media-usb-drivers/20161011-182408
> > > head:   ff49f775552fe4ebe2944527cf882073679cb1e5
> > > commit: b38d98275e144aaea9db69ba2dcba58466046d9b [3/31] cinergyT2-core: handle error code on RC query
> > > :::::: branch date: 3 hours ago
> > > :::::: commit date: 3 hours ago
> > >
> > > >> drivers/media/usb/dvb-usb/cinergyT2-core.c:174:2-8: preceding lock on line 169
> > >
> > > git remote add linux-review https://github.com/0day-ci/linux
> > > git remote update linux-review
> > > git checkout b38d98275e144aaea9db69ba2dcba58466046d9b
> > > vim +174 drivers/media/usb/dvb-usb/cinergyT2-core.c
> > >
> > > 986bd1e5 drivers/media/dvb/dvb-usb/cinergyT2-core.c Tomi Orava            2008-09-19  163  {
> > > 7f987678 drivers/media/dvb/dvb-usb/cinergyT2-core.c Thierry MERLE         2008-09-19  164  	struct cinergyt2_state *st = d->priv;
> > > b38d9827 drivers/media/usb/dvb-usb/cinergyT2-core.c Mauro Carvalho Chehab 2016-10-11  165  	int i, ret;
> > > 7f987678 drivers/media/dvb/dvb-usb/cinergyT2-core.c Thierry MERLE         2008-09-19  166
> > > 986bd1e5 drivers/media/dvb/dvb-usb/cinergyT2-core.c Tomi Orava            2008-09-19  167  	*state = REMOTE_NO_KEY_PRESSED;
> > > 986bd1e5 drivers/media/dvb/dvb-usb/cinergyT2-core.c Tomi Orava            2008-09-19  168
> > > 48922468 drivers/media/usb/dvb-usb/cinergyT2-core.c Mauro Carvalho Chehab 2016-10-11 @169  	mutex_lock(&st->data_mutex);
> > > 48922468 drivers/media/usb/dvb-usb/cinergyT2-core.c Mauro Carvalho Chehab 2016-10-11  170  	st->data[0] = CINERGYT2_EP1_GET_RC_EVENTS;
> > > 48922468 drivers/media/usb/dvb-usb/cinergyT2-core.c Mauro Carvalho Chehab 2016-10-11  171
> > > b38d9827 drivers/media/usb/dvb-usb/cinergyT2-core.c Mauro Carvalho Chehab 2016-10-11  172  	ret = dvb_usb_generic_rw(d, st->data, 1, st->data, 5, 0);
> > > b38d9827 drivers/media/usb/dvb-usb/cinergyT2-core.c Mauro Carvalho Chehab 2016-10-11  173  	if (ret < 0)
> > > b38d9827 drivers/media/usb/dvb-usb/cinergyT2-core.c Mauro Carvalho Chehab 2016-10-11 @174  		return ret;
> > > 48922468 drivers/media/usb/dvb-usb/cinergyT2-core.c Mauro Carvalho Chehab 2016-10-11  175
> > > 48922468 drivers/media/usb/dvb-usb/cinergyT2-core.c Mauro Carvalho Chehab 2016-10-11  176  	if (st->data[4] == 0xff) {
> > > 7f987678 drivers/media/dvb/dvb-usb/cinergyT2-core.c Thierry MERLE         2008-09-19  177  		/* key repeat */
> > >
> > > ---
> > > 0-DAY kernel test infrastructure                Open Source Technology Center
> > > https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> > >
> >
> >
>
>
> --
> Thanks,
> Mauro
>
