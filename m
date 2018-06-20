Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54720 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754166AbeFTXCF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 19:02:05 -0400
Subject: Re: drivers/media/platform/cadence/cdns-csi2tx.c:477:11: error:
 implicit declaration of function 'kzalloc'; did you mean 'vzalloc'?
To: kbuild test robot <lkp@intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <201806180714.gwQUkLIy%fengguang.wu@intel.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <0e6e7b2a-1624-4c15-85ff-3796e0104a3b@infradead.org>
Date: Wed, 20 Jun 2018 16:02:00 -0700
MIME-Version: 1.0
In-Reply-To: <201806180714.gwQUkLIy%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/17/2018 04:29 PM, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   ce397d215ccd07b8ae3f71db689aedb85d56ab40
> commit: 6f684d4fcce5eddd7e216a18975fb798d11a83dd media: v4l: cadence: Add Cadence MIPI-CSI2 TX driver
> date:   5 weeks ago
> config: x86_64-randconfig-s5-06180700 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
> reproduce:
>         git checkout 6f684d4fcce5eddd7e216a18975fb798d11a83dd
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All error/warnings (new ones prefixed by >>):
> 
>    drivers/media/platform/cadence/cdns-csi2tx.c: In function 'csi2tx_probe':
>>> drivers/media/platform/cadence/cdns-csi2tx.c:477:11: error: implicit declaration of function 'kzalloc'; did you mean 'vzalloc'? [-Werror=implicit-function-declaration]
>      csi2tx = kzalloc(sizeof(*csi2tx), GFP_KERNEL);
>               ^~~~~~~
>               vzalloc
>>> drivers/media/platform/cadence/cdns-csi2tx.c:477:9: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
>      csi2tx = kzalloc(sizeof(*csi2tx), GFP_KERNEL);
>             ^
>>> drivers/media/platform/cadence/cdns-csi2tx.c:531:2: error: implicit declaration of function 'kfree'; did you mean 'vfree'? [-Werror=implicit-function-declaration]
>      kfree(csi2tx);
>      ^~~~~
>      vfree
>    cc1: some warnings being treated as errors

>From 2018-06-08:

https://patchwork.kernel.org/patch/10455245/
or
https://marc.info/?l=linux-kernel&m=152849276709302&w=2

I marked it as for linux-next, but it does need to be applied to mainline.


> vim +477 drivers/media/platform/cadence/cdns-csi2tx.c
> 
>    470	
>    471	static int csi2tx_probe(struct platform_device *pdev)
>    472	{
>    473		struct csi2tx_priv *csi2tx;
>    474		unsigned int i;
>    475		int ret;
>    476	
>  > 477		csi2tx = kzalloc(sizeof(*csi2tx), GFP_KERNEL);
>    478		if (!csi2tx)
>    479			return -ENOMEM;
>    480		platform_set_drvdata(pdev, csi2tx);
>    481		mutex_init(&csi2tx->lock);
>    482		csi2tx->dev = &pdev->dev;
>    483	
>    484		ret = csi2tx_get_resources(csi2tx, pdev);
>    485		if (ret)
>    486			goto err_free_priv;
>    487	
>    488		v4l2_subdev_init(&csi2tx->subdev, &csi2tx_subdev_ops);
>    489		csi2tx->subdev.owner = THIS_MODULE;
>    490		csi2tx->subdev.dev = &pdev->dev;
>    491		csi2tx->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>    492		snprintf(csi2tx->subdev.name, V4L2_SUBDEV_NAME_SIZE, "%s.%s",
>    493			 KBUILD_MODNAME, dev_name(&pdev->dev));
>    494	
>    495		ret = csi2tx_check_lanes(csi2tx);
>    496		if (ret)
>    497			goto err_free_priv;
>    498	
>    499		/* Create our media pads */
>    500		csi2tx->subdev.entity.function = MEDIA_ENT_F_VID_IF_BRIDGE;
>    501		csi2tx->pads[CSI2TX_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
>    502		for (i = CSI2TX_PAD_SINK_STREAM0; i < CSI2TX_PAD_MAX; i++)
>    503			csi2tx->pads[i].flags = MEDIA_PAD_FL_SINK;
>    504	
>    505		/*
>    506		 * Only the input pads are considered to have a format at the
>    507		 * moment. The CSI link can multiplex various streams with
>    508		 * different formats, and we can't expose this in v4l2 right
>    509		 * now.
>    510		 */
>    511		for (i = CSI2TX_PAD_SINK_STREAM0; i < CSI2TX_PAD_MAX; i++)
>    512			csi2tx->pad_fmts[i] = fmt_default;
>    513	
>    514		ret = media_entity_pads_init(&csi2tx->subdev.entity, CSI2TX_PAD_MAX,
>    515					     csi2tx->pads);
>    516		if (ret)
>    517			goto err_free_priv;
>    518	
>    519		ret = v4l2_async_register_subdev(&csi2tx->subdev);
>    520		if (ret < 0)
>    521			goto err_free_priv;
>    522	
>    523		dev_info(&pdev->dev,
>    524			 "Probed CSI2TX with %u/%u lanes, %u streams, %s D-PHY\n",
>    525			 csi2tx->num_lanes, csi2tx->max_lanes, csi2tx->max_streams,
>    526			 csi2tx->has_internal_dphy ? "internal" : "no");
>    527	
>    528		return 0;
>    529	
>    530	err_free_priv:
>  > 531		kfree(csi2tx);
>    532		return ret;
>    533	}
>    534	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 


-- 
~Randy
