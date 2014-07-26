Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:60700 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaGZNiF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 09:38:05 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9B00HBCN7FOO60@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 26 Jul 2014 09:38:03 -0400 (EDT)
Date: Sat, 26 Jul 2014 10:37:59 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: Re: [linux-devel:devel-hourly-2014072619 46/47]
 drivers/media/usb/dvb-usb/cxusb.c:1376:2: error: format not a string literal
 and no format arguments
Message-id: <20140726103759.30890e61.m.chehab@samsung.com>
In-reply-to: <53d3a13f.6JMlKnOAp6I4iHU6%fengguang.wu@intel.com>
References: <53d3a13f.6JMlKnOAp6I4iHU6%fengguang.wu@intel.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 26 Jul 2014 20:38:23 +0800
kbuild test robot <fengguang.wu@intel.com> escreveu:

> Hi Wu,
> 
> FYI, this happens on a merge commit, which indicates conflicting changes with one of the below merged branches.

Hmm... I did a rebase on my tree, in order to fix a patch that broke HID
compilation. Maybe that's the culpit of this error. I generally don't do
rebase, but in this specific case, I think it was the less worse alternative.

Regards,
Mauro

> 
> a0ab48a Merge 'linuxtv-media/master' into devel-hourly-2014072619
> f09db3d Merge 'kees/nak/devtmpfs-safe' into devel-hourly-2014072619
> 265aa8f Merge 'kees/nak/recv-leak' into devel-hourly-2014072619
> 42b5627 Merge 'wireless-next/master' into devel-hourly-2014072619
> b4c4c2c Merge 'drm-intel/drm-intel-nightly' into devel-hourly-2014072619
> a226ec8 Merge 'trace/for-next' into devel-hourly-2014072619
> 22b3744 Merge 'kees/arm-mm' into devel-hourly-2014072619
> 52c147b Merge 'kees/nak/tcp-simult' into devel-hourly-2014072619
> de210e8 Merge 'dhowells-fs/keys-next' into devel-hourly-2014072619
> 371cd13 Merge 'tip/x86/vdso' into devel-hourly-2014072619
> af8decc Merge 'omap/omap-for-v3.17/dt' into devel-hourly-2014072619
> a241650 Merge 'regulator/for-next' into devel-hourly-2014072619
> c19890d Merge 'spi/for-next' into devel-hourly-2014072619
> 0b83717 Merge 'xen-tip/linux-next' into devel-hourly-2014072619
> 60aa361 Merge 'regulator/topic/s2mps11' into devel-hourly-2014072619
> 5210477 Merge 'ath6kl/ath-qca' into devel-hourly-2014072619
> e48a37b Merge 'ath6kl/ath-next-test' into devel-hourly-2014072619
> 09bf8b8 Merge 'arm-soc/for-next' into devel-hourly-2014072619
> 8051032 Merge 'nf-next/master' into devel-hourly-2014072619
> 8167e61 Merge 'arm64/for-next/core' into devel-hourly-2014072619
> 9adeff0 Merge 'jcmvbkbc-xtensa/xtensa-linux-201406' into devel-hourly-2014072619
> 50b5b8a Merge 'arm-soc/next/cleanup' into devel-hourly-2014072619
> 505921b Merge 'spi/topic/rockchip' into devel-hourly-2014072619
> 554764d Merge 'nomadik/mmci-fix' into devel-hourly-2014072619
> 82d122b7 Merge 'kees/fw-restrict/fd' into devel-hourly-2014072619
> 1005bb2 Merge 'realmz6/master' into devel-hourly-2014072619
> bfc3ad3 Merge 'ljones-mfd/for-mfd-next' into devel-hourly-2014072619
> 1a06a6d Merge 'pshelar-openvswitch/net_next_ovs' into devel-hourly-2014072619
> 67caf0d Merge 'kees/gcc-bug' into devel-hourly-2014072619
> 566c56d Merge 'kees/seccomp/fastpath' into devel-hourly-2014072619
> 3fc107c Merge 'ath6kl/master' into devel-hourly-2014072619
> 96fb977 Merge 'kees/format-security' into devel-hourly-2014072619
> ce40d35 Merge 'ulf.hansson-mmc/next' into devel-hourly-2014072619
> b5c9b2a Merge 'btrfs/integration' into devel-hourly-2014072619
> 358f1e2 Merge 'spi/topic/orion' into devel-hourly-2014072619
> 891ade2 Merge 'kees/lsm-mnt-restrict' into devel-hourly-2014072619
> e48de48 Merge 'regmap/for-next' into devel-hourly-2014072619
> ecae232 Merge 'kees/yama/extras' into devel-hourly-2014072619
> d0fc372 Merge 'kees/ptdump' into devel-hourly-2014072619
> 13d5f8b53 Merge 'kees/stack-protector' into devel-hourly-2014072619
> 81aefe5 Merge 'regulator/topic/da9211' into devel-hourly-2014072619
> 6eebd13 Merge 'asoc/for-next' into devel-hourly-2014072619
> 3807c43 Merge 'samsung-clk/for-next' into devel-hourly-2014072619
> 0045335 Merge 'realmz6/for-linus' into devel-hourly-2014072619
> b673aa4 Merge 'kees/nak/dcache-oob-read' into devel-hourly-2014072619
> 843bf94 0day base guard for 'devel-hourly-2014072619'
> 9a3c414 Linux 3.16-rc6
> 
> 
> tree:   git://internal_merge_and_test_tree devel-hourly-2014072619
> head:   2306b58d6fb88dedf7c0cb9e2b11d086c6018b88
> commit: a0ab48a35c4779850aaca944df1b78c343c0ebd0 [46/47] Merge 'linuxtv-media/master' into devel-hourly-2014072619
> config: x86_64-rhel (attached as .config)
> 
> All error/warnings:
> 
>    drivers/media/usb/dvb-usb/cxusb.c: In function 'cxusb_tt_ct2_4400_attach':
> >> drivers/media/usb/dvb-usb/cxusb.c:1376:2: error: format not a string literal and no format arguments [-Werror=format-security]
>      request_module(info.type);
>      ^
> >> drivers/media/usb/dvb-usb/cxusb.c:1395:2: error: format not a string literal and no format arguments [-Werror=format-security]
>      request_module(info.type);
>      ^
>    cc1: some warnings being treated as errors
> 
> vim +1376 drivers/media/usb/dvb-usb/cxusb.c
> 
> 26c42b0d Olli Salonen        2014-07-13  1370  	si2168_config.i2c_adapter = &adapter;
> 26c42b0d Olli Salonen        2014-07-13  1371  	si2168_config.fe = &adap->fe_adap[0].fe;
> 26c42b0d Olli Salonen        2014-07-13  1372  	memset(&info, 0, sizeof(struct i2c_board_info));
> 26c42b0d Olli Salonen        2014-07-13  1373  	strlcpy(info.type, "si2168", I2C_NAME_SIZE);
> 26c42b0d Olli Salonen        2014-07-13  1374  	info.addr = 0x64;
> 26c42b0d Olli Salonen        2014-07-13  1375  	info.platform_data = &si2168_config;
> 26c42b0d Olli Salonen        2014-07-13 @1376  	request_module(info.type);
> 26c42b0d Olli Salonen        2014-07-13  1377  	client_demod = i2c_new_device(&d->i2c_adap, &info);
> 26c42b0d Olli Salonen        2014-07-13  1378  	if (client_demod == NULL || client_demod->dev.driver == NULL)
> 26c42b0d Olli Salonen        2014-07-13  1379  		return -ENODEV;
> 26c42b0d Olli Salonen        2014-07-13  1380  
> 26c42b0d Olli Salonen        2014-07-13  1381  	if (!try_module_get(client_demod->dev.driver->owner)) {
> 26c42b0d Olli Salonen        2014-07-13  1382  		i2c_unregister_device(client_demod);
> 26c42b0d Olli Salonen        2014-07-13  1383  		return -ENODEV;
> 26c42b0d Olli Salonen        2014-07-13  1384  	}
> 26c42b0d Olli Salonen        2014-07-13  1385  
> 26c42b0d Olli Salonen        2014-07-13  1386  	st->i2c_client_demod = client_demod;
> 26c42b0d Olli Salonen        2014-07-13  1387  
> 26c42b0d Olli Salonen        2014-07-13  1388  	/* attach tuner */
> 9f7ca3d4 Matthias Schwarzott 2014-07-15  1389  	memset(&si2157_config, 0, sizeof(si2157_config));
> 26c42b0d Olli Salonen        2014-07-13  1390  	si2157_config.fe = adap->fe_adap[0].fe;
> 26c42b0d Olli Salonen        2014-07-13  1391  	memset(&info, 0, sizeof(struct i2c_board_info));
> 26c42b0d Olli Salonen        2014-07-13  1392  	strlcpy(info.type, "si2157", I2C_NAME_SIZE);
> 26c42b0d Olli Salonen        2014-07-13  1393  	info.addr = 0x60;
> 26c42b0d Olli Salonen        2014-07-13  1394  	info.platform_data = &si2157_config;
> 26c42b0d Olli Salonen        2014-07-13 @1395  	request_module(info.type);
> 26c42b0d Olli Salonen        2014-07-13  1396  	client_tuner = i2c_new_device(adapter, &info);
> 26c42b0d Olli Salonen        2014-07-13  1397  	if (client_tuner == NULL || client_tuner->dev.driver == NULL) {
> 26c42b0d Olli Salonen        2014-07-13  1398  		module_put(client_demod->dev.driver->owner);
> 
> :::::: The code at line 1376 was first introduced by commit
> :::::: 26c42b0dd5fa552bf26451cbd1d4c70fb6b95b67 [media] cxusb: TechnoTrend CT2-4400 USB DVB-T2/C tuner support
> 
> :::::: TO: Olli Salonen <olli.salonen@iki.fi>
> :::::: CC: Mauro Carvalho Chehab <m.chehab@samsung.com>
> 
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
