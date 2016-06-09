Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37139 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbcFITfd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2016 15:35:33 -0400
Date: Thu, 9 Jun 2016 16:35:28 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Akihiro TSUKADA <tskd08@gmail.com>, linux-media@vger.kernel.org
Subject: Re: dvb-core: how should i2c subdev drivers be attached?
Message-ID: <20160609163528.67394569@recife.lan>
In-Reply-To: <a67edaab-4da2-6ccf-9b2a-08f95cc1072e@iki.fi>
References: <52775753-47c4-bfdf-b8f5-48bdf8ceb6e5@gmail.com>
	<20160609122449.5cfc16cc@recife.lan>
	<07669546-908f-f81c-26e5-af7b720229b3@iki.fi>
	<20160609131813.710e1ab2@recife.lan>
	<f89f96f0-40a3-6e50-5d83-0cfaf50e8089@iki.fi>
	<20160609153015.108e4d98@recife.lan>
	<a67edaab-4da2-6ccf-9b2a-08f95cc1072e@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti,

Em Thu, 09 Jun 2016 22:14:12 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> On 06/09/2016 09:30 PM, Mauro Carvalho Chehab wrote:
> > Em Thu, 9 Jun 2016 19:38:04 +0300
> > Antti Palosaari <crope@iki.fi> escreveu:  
> 
> >>> The V4L2 core handles everything that it is needed for it to work, and
> >>> no extra code is needed to do module_put() or i2c_unregister_device().  
> >>
> >> That example attachs 2 I2C drivers, as your example only 1.  
> >
> > Well, on V4L2, 2 I2C drivers, two statements.
> >  
> >> Also it
> >> populates all the config to platform data on both I2C driver.  
> >
> > Yes, this is annoying, but lots of the converted entries are
> > doing the same crap, instead of using a const var outside
> > the code.
> >  
> >> Which
> >> annoys me is that try_module_get/module_put functionality.  
> >
> > That is scary, as any failure there would prevent removing/unbinding
> > a module. The core or some helper function should be handle it,
> > to avoid the risk of get twice, put twice, never call put, etc.
> >  
> >> You should be ideally able to unbind (and bind) modules like that:
> >> echo 6-0008 > /sys/bus/i2c/drivers/a8293/unbind  
> >
> > I guess unbinding a V4L2 module in real time won't cause any
> > crash (obviously, the device will stop work properly, if you
> > remove a component that it is being used).
> >
> > I actually tested remove/reinsert the I2C remote controller
> > drivers a long time ago, while looking at some bugs. Those are
> > usually harder to get it right, as most of them have a poll logic
> > internally to get IR events on every 10ms. I guess I tested
> > removing/reinserting the tuner too, but that was at the
> > "stone ages"... to old for me to remember what I did.
> >
> > Yet, I don't see any troubles preventing the I2C "slave" drivers to
> > be unbound before the master, by increasing their module refcounts
> > during their usage.
> >  
> >> and as it is not possible, that stuff is here to avoid problems. Some
> >> study is needed in order to find out how dynamic unbind/bind could be
> >> get working and after that I hope whole ref counting could be removed.
> >> Currently you cannot allow remove module as it leads to unbind, which
> >> does not work.  
> 
> I did tons of work in order to get things work properly with I2C 
> binding. And following things are now possible due to that:
> * Kernel logging. You could now use standard dev_ logging.
> * regmap. Could now use regmap in order to cover register access.
> * I2C-mux. No need for i2c_gate_control.
> 
> And everytime there is someone asking why just don't do things like 
> earlier :S
> 
> I really don't want add any new hacks but implement things as much as 
> possible the way driver core makes possible. For long ran I feel it is 
> better approach to follow driver core than make own hacks. Until someone 
> study things and says it is not possible to implement things like core 
> offers, then lets implement things. That's bind/unbind is one thing to 
> study, another thing is power-management.

Nobody is proposing to add hacks. I'm with you with that: hacks
should be removed (like that hybrid_instance ugly code used by most
hybrid tuners).

We should, however, put common code at the core or provide helper
functions, in order to:

1) Make life easier for developers to add support for new boards;

2) Prevent, as much as possible, the risk of developer's mistakes
   to cause harm to the drivers;

3) Simplify the logic at the drivers, and, if possible, remove that
   long per-card switch() at the dvb part of the hybrid drivers;

4) Prevent, as much as possible, the risk of developer's mistakes
   to cause harm to the drivers;

5) Allow the code to be better reviewed by static code analyzers.

> 
> I suspect bind/unbind could be simple like just:
> i2c_driver_remove()
> {
>      if (frontend_is_running)
>          return -EBUSY;
> 
>      kfree(dev)
>      return 0;
> }

The above code is racy, as some other request to the frontend
may arrive between the if() statement and kfree(). A kref would
likely be safer.

Thanks,
Mauro
