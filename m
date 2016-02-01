Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:29773 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752019AbcBARJq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2016 12:09:46 -0500
Date: Mon, 1 Feb 2016 18:09:43 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: Re: [linuxtv-media:master 1995/2084] drivers/media/tuners/tuner-xc2028.c:1411:3-9:
 preceding lock on line 1398
In-Reply-To: <201602020014.cXUTbGMi%fengguang.wu@intel.com>
Message-ID: <alpine.DEB.2.10.1602011809070.2525@hadrien>
References: <201602020014.cXUTbGMi%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks suspicious, please check.

julia

On Tue, 2 Feb 2016, kbuild test robot wrote:

> CC: kbuild-all@01.org
> TO: Mauro Carvalho Chehab <m.chehab@samsung.com>
> CC: linux-media@vger.kernel.org
>
> tree:   git://linuxtv.org/media_tree.git master
> head:   6b3f99989eb73e5250bba9dfeaa852939acfbf70
> commit: 8dfbcc4351a0b6d2f2d77f367552f48ffefafe18 [1995/2084] [media] xc2028: avoid use after free
> :::::: branch date: 63 minutes ago
> :::::: commit date: 7 hours ago
>
> >> drivers/media/tuners/tuner-xc2028.c:1411:3-9: preceding lock on line 1398
>
> git remote add linuxtv-media git://linuxtv.org/media_tree.git
> git remote update linuxtv-media
> git checkout 8dfbcc4351a0b6d2f2d77f367552f48ffefafe18
> vim +1411 drivers/media/tuners/tuner-xc2028.c
>
> de3fe21b drivers/media/video/tuner-xc2028.c         Mauro Carvalho Chehab 2007-10-24  1392  	struct xc2028_data *priv = fe->tuner_priv;
> de3fe21b drivers/media/video/tuner-xc2028.c         Mauro Carvalho Chehab 2007-10-24  1393  	struct xc2028_ctrl *p    = priv_cfg;
> 0a196b6f drivers/media/video/tuner-xc2028.c         Chris Pascoe          2007-11-19  1394  	int                 rc   = 0;
> de3fe21b drivers/media/video/tuner-xc2028.c         Mauro Carvalho Chehab 2007-10-24  1395
> 7e28adb2 drivers/media/video/tuner-xc2028.c         Harvey Harrison       2008-04-08  1396  	tuner_dbg("%s called\n", __func__);
> de3fe21b drivers/media/video/tuner-xc2028.c         Mauro Carvalho Chehab 2007-10-24  1397
> 06fd82dc drivers/media/video/tuner-xc2028.c         Chris Pascoe          2007-11-19 @1398  	mutex_lock(&priv->lock);
> 06fd82dc drivers/media/video/tuner-xc2028.c         Chris Pascoe          2007-11-19  1399
> 61a96113 drivers/media/common/tuners/tuner-xc2028.c Mauro Carvalho Chehab 2012-06-30  1400  	/*
> 61a96113 drivers/media/common/tuners/tuner-xc2028.c Mauro Carvalho Chehab 2012-06-30  1401  	 * Copy the config data.
> 61a96113 drivers/media/common/tuners/tuner-xc2028.c Mauro Carvalho Chehab 2012-06-30  1402  	 * For the firmware name, keep a local copy of the string,
> 61a96113 drivers/media/common/tuners/tuner-xc2028.c Mauro Carvalho Chehab 2012-06-30  1403  	 * in order to avoid troubles during device release.
> 61a96113 drivers/media/common/tuners/tuner-xc2028.c Mauro Carvalho Chehab 2012-06-30  1404  	 */
> 61a96113 drivers/media/common/tuners/tuner-xc2028.c Mauro Carvalho Chehab 2012-06-30  1405  	kfree(priv->ctrl.fname);
> 8dfbcc43 drivers/media/tuners/tuner-xc2028.c        Mauro Carvalho Chehab 2016-01-28  1406  	priv->ctrl.fname = NULL;
> 0a196b6f drivers/media/video/tuner-xc2028.c         Chris Pascoe          2007-11-19  1407  	memcpy(&priv->ctrl, p, sizeof(priv->ctrl));
> 0a196b6f drivers/media/video/tuner-xc2028.c         Chris Pascoe          2007-11-19  1408  	if (p->fname) {
> 0a196b6f drivers/media/video/tuner-xc2028.c         Chris Pascoe          2007-11-19  1409  		priv->ctrl.fname = kstrdup(p->fname, GFP_KERNEL);
> 0a196b6f drivers/media/video/tuner-xc2028.c         Chris Pascoe          2007-11-19  1410  		if (priv->ctrl.fname == NULL)
> 8dfbcc43 drivers/media/tuners/tuner-xc2028.c        Mauro Carvalho Chehab 2016-01-28 @1411  			return -ENOMEM;
> de3fe21b drivers/media/video/tuner-xc2028.c         Mauro Carvalho Chehab 2007-10-24  1412  	}
> de3fe21b drivers/media/video/tuner-xc2028.c         Mauro Carvalho Chehab 2007-10-24  1413
> 61a96113 drivers/media/common/tuners/tuner-xc2028.c Mauro Carvalho Chehab 2012-06-30  1414  	/*
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>
