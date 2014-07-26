Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:15072 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbaGZOCp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 10:02:45 -0400
Date: Sat, 26 Jul 2014 22:02:44 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: Re: [linux-devel:devel-hourly-2014072619 46/47]
 drivers/media/usb/dvb-usb/cxusb.c:1376:2: error: format not a string literal
 and no format arguments
Message-ID: <20140726140244.GA27497@localhost>
References: <53d3a13f.6JMlKnOAp6I4iHU6%fengguang.wu@intel.com>
 <20140726103759.30890e61.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140726103759.30890e61.m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Sat, Jul 26, 2014 at 10:37:59AM -0300, Mauro Carvalho Chehab wrote:
> Em Sat, 26 Jul 2014 20:38:23 +0800
> kbuild test robot <fengguang.wu@intel.com> escreveu:
> 
> > Hi Wu,
> > 
> > FYI, this happens on a merge commit, which indicates conflicting changes with one of the below merged branches.
> 
> Hmm... I did a rebase on my tree, in order to fix a patch that broke HID
> compilation. Maybe that's the culpit of this error. I generally don't do
> rebase, but in this specific case, I think it was the less worse alternative.

The errors are triggered by sanity checks in this tree

> > 96fb977 Merge 'kees/format-security' into devel-hourly-2014072619

Which can be fixed by

-        request_module(info.type);
+        request_module("%s", info.type);

Thanks,
Fengguang

> > tree:   git://internal_merge_and_test_tree devel-hourly-2014072619
> > head:   2306b58d6fb88dedf7c0cb9e2b11d086c6018b88
> > commit: a0ab48a35c4779850aaca944df1b78c343c0ebd0 [46/47] Merge 'linuxtv-media/master' into devel-hourly-2014072619
> > config: x86_64-rhel (attached as .config)
> > 
> > All error/warnings:
> > 
> >    drivers/media/usb/dvb-usb/cxusb.c: In function 'cxusb_tt_ct2_4400_attach':
> > >> drivers/media/usb/dvb-usb/cxusb.c:1376:2: error: format not a string literal and no format arguments [-Werror=format-security]
> >      request_module(info.type);
> >      ^
> > >> drivers/media/usb/dvb-usb/cxusb.c:1395:2: error: format not a string literal and no format arguments [-Werror=format-security]
> >      request_module(info.type);
> >      ^
> >    cc1: some warnings being treated as errors
> > 
> > vim +1376 drivers/media/usb/dvb-usb/cxusb.c
> > 
> > 26c42b0d Olli Salonen        2014-07-13  1370  	si2168_config.i2c_adapter = &adapter;
> > 26c42b0d Olli Salonen        2014-07-13  1371  	si2168_config.fe = &adap->fe_adap[0].fe;
> > 26c42b0d Olli Salonen        2014-07-13  1372  	memset(&info, 0, sizeof(struct i2c_board_info));
> > 26c42b0d Olli Salonen        2014-07-13  1373  	strlcpy(info.type, "si2168", I2C_NAME_SIZE);
> > 26c42b0d Olli Salonen        2014-07-13  1374  	info.addr = 0x64;
> > 26c42b0d Olli Salonen        2014-07-13  1375  	info.platform_data = &si2168_config;
> > 26c42b0d Olli Salonen        2014-07-13 @1376  	request_module(info.type);
> > 26c42b0d Olli Salonen        2014-07-13  1377  	client_demod = i2c_new_device(&d->i2c_adap, &info);
> > 26c42b0d Olli Salonen        2014-07-13  1378  	if (client_demod == NULL || client_demod->dev.driver == NULL)
> > 26c42b0d Olli Salonen        2014-07-13  1379  		return -ENODEV;
> > 26c42b0d Olli Salonen        2014-07-13  1380  
> > 26c42b0d Olli Salonen        2014-07-13  1381  	if (!try_module_get(client_demod->dev.driver->owner)) {
> > 26c42b0d Olli Salonen        2014-07-13  1382  		i2c_unregister_device(client_demod);
> > 26c42b0d Olli Salonen        2014-07-13  1383  		return -ENODEV;
> > 26c42b0d Olli Salonen        2014-07-13  1384  	}
> > 26c42b0d Olli Salonen        2014-07-13  1385  
> > 26c42b0d Olli Salonen        2014-07-13  1386  	st->i2c_client_demod = client_demod;
> > 26c42b0d Olli Salonen        2014-07-13  1387  
> > 26c42b0d Olli Salonen        2014-07-13  1388  	/* attach tuner */
> > 9f7ca3d4 Matthias Schwarzott 2014-07-15  1389  	memset(&si2157_config, 0, sizeof(si2157_config));
> > 26c42b0d Olli Salonen        2014-07-13  1390  	si2157_config.fe = adap->fe_adap[0].fe;
> > 26c42b0d Olli Salonen        2014-07-13  1391  	memset(&info, 0, sizeof(struct i2c_board_info));
> > 26c42b0d Olli Salonen        2014-07-13  1392  	strlcpy(info.type, "si2157", I2C_NAME_SIZE);
> > 26c42b0d Olli Salonen        2014-07-13  1393  	info.addr = 0x60;
> > 26c42b0d Olli Salonen        2014-07-13  1394  	info.platform_data = &si2157_config;
> > 26c42b0d Olli Salonen        2014-07-13 @1395  	request_module(info.type);
> > 26c42b0d Olli Salonen        2014-07-13  1396  	client_tuner = i2c_new_device(adapter, &info);
> > 26c42b0d Olli Salonen        2014-07-13  1397  	if (client_tuner == NULL || client_tuner->dev.driver == NULL) {
> > 26c42b0d Olli Salonen        2014-07-13  1398  		module_put(client_demod->dev.driver->owner);
> > 
> > :::::: The code at line 1376 was first introduced by commit
> > :::::: 26c42b0dd5fa552bf26451cbd1d4c70fb6b95b67 [media] cxusb: TechnoTrend CT2-4400 USB DVB-T2/C tuner support
> > 
> > :::::: TO: Olli Salonen <olli.salonen@iki.fi>
> > :::::: CC: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > 
> > ---
> > 0-DAY kernel build testing backend              Open Source Technology Center
> > http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
