Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36543 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbcFISaV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2016 14:30:21 -0400
Date: Thu, 9 Jun 2016 15:30:15 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Akihiro TSUKADA <tskd08@gmail.com>, linux-media@vger.kernel.org
Subject: Re: dvb-core: how should i2c subdev drivers be attached?
Message-ID: <20160609153015.108e4d98@recife.lan>
In-Reply-To: <f89f96f0-40a3-6e50-5d83-0cfaf50e8089@iki.fi>
References: <52775753-47c4-bfdf-b8f5-48bdf8ceb6e5@gmail.com>
	<20160609122449.5cfc16cc@recife.lan>
	<07669546-908f-f81c-26e5-af7b720229b3@iki.fi>
	<20160609131813.710e1ab2@recife.lan>
	<f89f96f0-40a3-6e50-5d83-0cfaf50e8089@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 9 Jun 2016 19:38:04 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> On 06/09/2016 07:18 PM, Mauro Carvalho Chehab wrote:
> > Em Thu, 09 Jun 2016 18:41:10 +0300
> > Antti Palosaari <crope@iki.fi> escreveu:
> >  
> >> On 06/09/2016 06:24 PM, Mauro Carvalho Chehab wrote:  
> >>> Hi Akihiro,
> >>>
> >>> Em Thu, 09 Jun 2016 21:49:33 +0900
> >>> Akihiro TSUKADA <tskd08@gmail.com> escreveu:
> >>>  
> >>>> Hi,
> >>>> excuse me for taking up a very old post again,
> >>>> but I'd like to know the status of the patch:
> >>>>   https://patchwork.linuxtv.org/patch/27922/
> >>>> , which provides helper code for defining/loading i2c DVB subdev drivers.
> >>>>
> >>>> Was it rejected and  
> >>>
> >>> It was not rejected. It is just that I didn't have time yet to think
> >>> about that, and Antti has a different view.
> >>>
> >>> The thing is that, whatever we do, it should work fine on drivers that
> >>> also exposes the tuner via V4L2. One of the reasons is that devices
> >>> that also allow the usage for SDR use the V4L2 core for the SDR part.
> >>>  
> >>>> each i2c demod/tuner drivers should provide its own version of "attach" code?  
> >>>
> >>> Antti took this path, but I don't like it. Lots of duplicated and complex
> >>> stuff. Also, some static analyzers refuse to check it (like smatch),
> >>> due to its complexity.
> >>>  
> >>>> Or is it acceptable (with some modifications) ?  
> >>>
> >>> I guess we should discuss a way of doing it that will be acceptable
> >>> on existing drivers. Perhaps you should try to do such change for
> >>> an hybrid driver like em28xx or cx231xx. There are a few ISDB-T
> >>> devices using them. Not sure how easy would be to find one of those
> >>> in Japan, though.
> >>>  
> >>>>
> >>>> Although not many drivers currently use i2c binding model (and use dvb_attach()),
> >>>> but I expect that coming DVB subdev drivers will have a similar attach code,
> >>>> including module request/ref-counting, device creation,
> >>>> (re-)using i2c_board_info.platformdata to pass around both config parameters
> >>>> and the resulting i2c_client* & dvb_frontend*.
> >>>>
> >>>> Since I have a plan to split out demod/tuner drivers from pci/pt1 dvb-usb/friio
> >>>> integrated drivers (because those share the tc90522 demod driver with pt3, and
> >>>> friio also shares the bridge chip with gl861),
> >>>> it would be nice if I can use the helper code,
> >>>> instead of re-iterating similar "attach" code.  
> >>
> >> IMHO only thing which makes it looking complex is that module reference
> >> counting - otherwise it is just standard I2C binding. Ideally I2C
> >> modules should be possible to unbind and unload at runtime and also load
> >> and bind. There is "suppress_bind_attrs = true" set to prevent runtime
> >> unbinding and try_module_get() is to prevent module unloading. For me
> >> eyes all that is still some workaround - and now you want put this
> >> workaround to some generic code. Please find correct solutions for those
> >> two problems and then there we can get rid of things totally - no need
> >> to make generic functions at all.  
> >
> > It *is complex*. A single board binding on the way you're mapping is:
> >
> > 	case EM28174_BOARD_PCTV_460E: {
> > 		struct i2c_client *client;
> > 		struct i2c_board_info board_info;
> > 		struct tda10071_platform_data tda10071_pdata = {};
> > 		struct a8293_platform_data a8293_pdata = {};
> >
> > 		/* attach demod + tuner combo */
> > 		tda10071_pdata.clk = 40444000, /* 40.444 MHz */
> > 		tda10071_pdata.i2c_wr_max = 64,
> > 		tda10071_pdata.ts_mode = TDA10071_TS_SERIAL,
> > 		tda10071_pdata.pll_multiplier = 20,
> > 		tda10071_pdata.tuner_i2c_addr = 0x14,
> > 		memset(&board_info, 0, sizeof(board_info));
> > 		strlcpy(board_info.type, "tda10071_cx24118", I2C_NAME_SIZE);
> > 		board_info.addr = 0x55;
> > 		board_info.platform_data = &tda10071_pdata;
> > 		request_module("tda10071");
> > 		client = i2c_new_device(&dev->i2c_adap[dev->def_i2c_bus], &board_info);
> > 		if (client == NULL || client->dev.driver == NULL) {
> > 			result = -ENODEV;
> > 			goto out_free;
> > 		}
> > 		if (!try_module_get(client->dev.driver->owner)) {
> > 			i2c_unregister_device(client);
> > 			result = -ENODEV;
> > 			goto out_free;
> > 		}
> > 		dvb->fe[0] = tda10071_pdata.get_dvb_frontend(client);
> > 		dvb->i2c_client_demod = client;
> >
> > 		/* attach SEC */
> > 		a8293_pdata.dvb_frontend = dvb->fe[0];
> > 		memset(&board_info, 0, sizeof(board_info));
> > 		strlcpy(board_info.type, "a8293", I2C_NAME_SIZE);
> > 		board_info.addr = 0x08;
> > 		board_info.platform_data = &a8293_pdata;
> > 		request_module("a8293");
> > 		client = i2c_new_device(&dev->i2c_adap[dev->def_i2c_bus], &board_info);
> > 		if (client == NULL || client->dev.driver == NULL) {
> > 			module_put(dvb->i2c_client_demod->dev.driver->owner);
> > 			i2c_unregister_device(dvb->i2c_client_demod);
> > 			result = -ENODEV;
> > 			goto out_free;
> > 		}
> > 		if (!try_module_get(client->dev.driver->owner)) {
> > 			i2c_unregister_device(client);
> > 			module_put(dvb->i2c_client_demod->dev.driver->owner);
> > 			i2c_unregister_device(dvb->i2c_client_demod);
> > 			result = -ENODEV;
> > 			goto out_free;
> > 		}
> > 		dvb->i2c_client_sec = client;
> > 		break;
> > 	}
> >
> > So, 55 lines of code, plus an extra logic to dettach it on this random
> > example (the first occurrence of the i2c binding thing at the em28xx
> > driver).
> >
> > At the V4L2 side, what we do, instead, is a single function call, for
> > each I2C driver that should be attached:
> >
> > 	v4l2_i2c_new_subdev(&v4l2->v4l2_dev,
> > 			    &dev->i2c_adap[dev->def_i2c_bus],
> > 			    "tuner", tuner_addr, NULL);
> >
> > The V4L2 core handles everything that it is needed for it to work, and
> > no extra code is needed to do module_put() or i2c_unregister_device().  
> 
> That example attachs 2 I2C drivers, as your example only 1.

Well, on V4L2, 2 I2C drivers, two statements.

> Also it 
> populates all the config to platform data on both I2C driver. 

Yes, this is annoying, but lots of the converted entries are
doing the same crap, instead of using a const var outside
the code.

> Which 
> annoys me is that try_module_get/module_put functionality.

That is scary, as any failure there would prevent removing/unbinding
a module. The core or some helper function should be handle it,
to avoid the risk of get twice, put twice, never call put, etc.

> You should be ideally able to unbind (and bind) modules like that:
> echo 6-0008 > /sys/bus/i2c/drivers/a8293/unbind

I guess unbinding a V4L2 module in real time won't cause any
crash (obviously, the device will stop work properly, if you
remove a component that it is being used).

I actually tested remove/reinsert the I2C remote controller
drivers a long time ago, while looking at some bugs. Those are
usually harder to get it right, as most of them have a poll logic
internally to get IR events on every 10ms. I guess I tested 
removing/reinserting the tuner too, but that was at the 
"stone ages"... to old for me to remember what I did.

Yet, I don't see any troubles preventing the I2C "slave" drivers to
be unbound before the master, by increasing their module refcounts
during their usage.

> and as it is not possible, that stuff is here to avoid problems. Some 
> study is needed in order to find out how dynamic unbind/bind could be 
> get working and after that I hope whole ref counting could be removed. 
> Currently you cannot allow remove module as it leads to unbind, which 
> does not work.
> 
> regards
> Antti
> 


-- 
Thanks,
Mauro
