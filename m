Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33502 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbZFCMGa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jun 2009 08:06:30 -0400
Date: Wed, 3 Jun 2009 09:06:27 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Matt Doran <matt.doran@papercut.com>
Cc: linux-media@vger.kernel.org
Subject: Re: videodev: Unknown symbol i2c_unregister_device (in kernels
 older than 2.6.26)
Message-ID: <20090603090627.4418694f@pedra.chehab.org>
In-Reply-To: <4A26637D.1070009@papercut.com>
References: <4A19D3D9.9010800@papercut.com>
	<20090527154107.6b79a160@pedra.chehab.org>
	<4A26637D.1070009@papercut.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 03 Jun 2009 21:50:21 +1000
Matt Doran <matt.doran@papercut.com> escreveu:

> Mauro Carvalho Chehab wrote:
> > Em Mon, 25 May 2009 09:10:17 +1000
> > Matt Doran <matt.doran@papercut.com> escreveu:
> >
> >   
> >> Hi there,
> >>
> >> I tried using the latest v4l code on an Mythtv box running 2.6.20, but 
> >> the v4l videodev module fails to load with the following warnings:
> >>
> >>     videodev: Unknown symbol i2c_unregister_device
> >>     v4l2_common: Unknown symbol v4l2_device_register_subdev
> >>
> > I've just applied a patch at the tree that should fix this issue. It adds
> > several tests and the code, but, hopefully, it should be possible even to use
> > the IR's with kernels starting from 2.6.16.
> >
> >
> >   
> Thanks Mauro. 
> 
> I've recompiled all drivers without compile error and I've been using 
> everything for a few days now and it all works great.

Great!
> 
> Thanks again!

Anytime.




Cheers,
Mauro
