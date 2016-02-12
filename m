Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:39084
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752424AbcBLNqv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 08:46:51 -0500
Date: Fri, 12 Feb 2016 14:37:07 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: Re: [linuxtv-media:master 2108/2127] drivers/media/usb/au0828/au0828-core.c:467:1-7:
 preceding lock on line 364
In-Reply-To: <201602121945.Z51MxRNB%fengguang.wu@intel.com>
Message-ID: <alpine.DEB.2.10.1602121435470.2510@hadrien>
References: <201602121945.Z51MxRNB%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1187631048-1455284227=:2510"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1187631048-1455284227=:2510
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

This looks suspicious, since all the other exist paths do release the
lock.

julia

On Fri, 12 Feb 2016, kbuild test robot wrote:

> CC: kbuild-all@01.org
> TO: Mauro Carvalho Chehab <m.chehab@samsung.com>
> CC: linux-media@vger.kernel.org
>
> tree:   git://linuxtv.org/media_tree.git master
> head:   f7b4b54e63643b740c598e044874c4bffa0f04f2
> commit: 82e92f4cad6e0c42f8dbe7497b39dec7b3eb7b11 [2108/2127] [media] au0828: only create V4L2 graph if V4L2 is registered
> :::::: branch date: 22 hours ago
> :::::: commit date: 2 days ago
>
> >> drivers/media/usb/au0828/au0828-core.c:467:1-7: preceding lock on line 364
>
> git remote add linuxtv-media git://linuxtv.org/media_tree.git
> git remote update linuxtv-media
> git checkout 82e92f4cad6e0c42f8dbe7497b39dec7b3eb7b11
> vim +467 drivers/media/usb/au0828/au0828-core.c
>
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  358  	if (dev == NULL) {
> 83afb32a drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2014-08-09  359  		pr_err("%s() Unable to allocate memory\n", __func__);
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  360  		return -ENOMEM;
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  361  	}
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  362
> 549ee4df drivers/media/video/au0828/au0828-core.c Devin Heitmueller              2012-08-06  363  	mutex_init(&dev->lock);
> 549ee4df drivers/media/video/au0828/au0828-core.c Devin Heitmueller              2012-08-06 @364  	mutex_lock(&dev->lock);
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  365  	mutex_init(&dev->mutex);
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  366  	mutex_init(&dev->dvb.lock);
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  367  	dev->usbdev = usbdev;
> f1add5b5 drivers/media/video/au0828/au0828-core.c Devin Heitmueller              2009-03-11  368  	dev->boardnr = id->driver_info;
> e42c8c6e drivers/media/usb/au0828/au0828-core.c   Rafael Lourenço de Lima Chehab 2015-06-08  369  	dev->board = au0828_boards[dev->boardnr];
> e42c8c6e drivers/media/usb/au0828/au0828-core.c   Rafael Lourenço de Lima Chehab 2015-06-08  370
> 9832e155 drivers/media/usb/au0828/au0828-core.c   Javier Martinez Canillas       2015-12-11  371  	/* Initialize the media controller */
> 9f806795 drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2015-12-28  372  	retval = au0828_media_device_init(dev, usbdev);
> 9f806795 drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2015-12-28  373  	if (retval) {
> 9f806795 drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2015-12-28  374  		pr_err("%s() au0828_media_device_init failed\n",
> 9f806795 drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2015-12-28  375  		       __func__);
> 9f806795 drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2015-12-28  376  		mutex_unlock(&dev->lock);
> 9f806795 drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2015-12-28  377  		kfree(dev);
> 9f806795 drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2015-12-28  378  		return retval;
> 9f806795 drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2015-12-28  379  	}
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  380
> 8a4e7866 drivers/media/usb/au0828/au0828-core.c   Michael Krufky                 2012-12-04  381  #ifdef CONFIG_VIDEO_AU0828_V4L2
> 823beb7e drivers/media/usb/au0828/au0828-core.c   Hans Verkuil                   2013-03-11  382  	dev->v4l2_dev.release = au0828_usb_v4l2_release;
> 823beb7e drivers/media/usb/au0828/au0828-core.c   Hans Verkuil                   2013-03-11  383
> b14667f3 drivers/media/video/au0828/au0828-core.c Devin Heitmueller              2009-03-11  384  	/* Create the v4l2_device */
> bed69196 drivers/media/usb/au0828/au0828-core.c   Rafael Lourenço de Lima Chehab 2015-06-08  385  #ifdef CONFIG_MEDIA_CONTROLLER
> bed69196 drivers/media/usb/au0828/au0828-core.c   Rafael Lourenço de Lima Chehab 2015-06-08  386  	dev->v4l2_dev.mdev = dev->media_dev;
> bed69196 drivers/media/usb/au0828/au0828-core.c   Rafael Lourenço de Lima Chehab 2015-06-08  387  #endif
> a4124aa9 drivers/media/video/au0828/au0828-core.c Janne Grunau                   2009-04-01  388  	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
> b14667f3 drivers/media/video/au0828/au0828-core.c Devin Heitmueller              2009-03-11  389  	if (retval) {
> e8c26f45 drivers/media/usb/au0828/au0828-core.c   Hans Verkuil                   2013-02-15  390  		pr_err("%s() v4l2_device_register failed\n",
> b14667f3 drivers/media/video/au0828/au0828-core.c Devin Heitmueller              2009-03-11  391  		       __func__);
> 549ee4df drivers/media/video/au0828/au0828-core.c Devin Heitmueller              2012-08-06  392  		mutex_unlock(&dev->lock);
> b14667f3 drivers/media/video/au0828/au0828-core.c Devin Heitmueller              2009-03-11  393  		kfree(dev);
> e8c26f45 drivers/media/usb/au0828/au0828-core.c   Hans Verkuil                   2013-02-15  394  		return retval;
> b14667f3 drivers/media/video/au0828/au0828-core.c Devin Heitmueller              2009-03-11  395  	}
> e8c26f45 drivers/media/usb/au0828/au0828-core.c   Hans Verkuil                   2013-02-15  396  	/* This control handler will inherit the controls from au8522 */
> e8c26f45 drivers/media/usb/au0828/au0828-core.c   Hans Verkuil                   2013-02-15  397  	retval = v4l2_ctrl_handler_init(&dev->v4l2_ctrl_hdl, 4);
> e8c26f45 drivers/media/usb/au0828/au0828-core.c   Hans Verkuil                   2013-02-15  398  	if (retval) {
> e8c26f45 drivers/media/usb/au0828/au0828-core.c   Hans Verkuil                   2013-02-15  399  		pr_err("%s() v4l2_ctrl_handler_init failed\n",
> e8c26f45 drivers/media/usb/au0828/au0828-core.c   Hans Verkuil                   2013-02-15  400  		       __func__);
> e8c26f45 drivers/media/usb/au0828/au0828-core.c   Hans Verkuil                   2013-02-15  401  		mutex_unlock(&dev->lock);
> e8c26f45 drivers/media/usb/au0828/au0828-core.c   Hans Verkuil                   2013-02-15  402  		kfree(dev);
> e8c26f45 drivers/media/usb/au0828/au0828-core.c   Hans Verkuil                   2013-02-15  403  		return retval;
> e8c26f45 drivers/media/usb/au0828/au0828-core.c   Hans Verkuil                   2013-02-15  404  	}
> e8c26f45 drivers/media/usb/au0828/au0828-core.c   Hans Verkuil                   2013-02-15  405  	dev->v4l2_dev.ctrl_handler = &dev->v4l2_ctrl_hdl;
> 8a4e7866 drivers/media/usb/au0828/au0828-core.c   Michael Krufky                 2012-12-04  406  #endif
> b14667f3 drivers/media/video/au0828/au0828-core.c Devin Heitmueller              2009-03-11  407
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  408  	/* Power Up the bridge */
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  409  	au0828_write(dev, REG_600, 1 << 4);
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  410
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  411  	/* Bring up the GPIO's and supporting devices */
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  412  	au0828_gpio_setup(dev);
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  413
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  414  	/* I2C */
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  415  	au0828_i2c_register(dev);
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  416
> 28930fa9 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-03-29  417  	/* Setup */
> 28930fa9 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-03-29  418  	au0828_card_setup(dev);
> 28930fa9 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-03-29  419
> 8a4e7866 drivers/media/usb/au0828/au0828-core.c   Michael Krufky                 2012-12-04  420  #ifdef CONFIG_VIDEO_AU0828_V4L2
> 8b2f0795 drivers/media/video/au0828/au0828-core.c Devin Heitmueller              2009-03-11  421  	/* Analog TV */
> 82e92f4c drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2016-02-09  422  	if (AUVI_INPUT(0).type != AU0828_VMUX_UNDEFINED) {
> 82e92f4c drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2016-02-09  423  		retval = au0828_analog_register(dev, interface);
> 82e92f4c drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2016-02-09  424  		if (retval) {
> 82e92f4c drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2016-02-09  425  			pr_err("%s() au0282_dev_register failed to register on V4L2\n",
> 82e92f4c drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2016-02-09  426  			       __func__);
> 82e92f4c drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2016-02-09  427  			goto done;
> 82e92f4c drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2016-02-09  428  		}
> 82e92f4c drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2016-02-09  429
> 82e92f4c drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2016-02-09  430  		retval = au0828_create_media_graph(dev);
> 82e92f4c drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2016-02-09  431  		if (retval) {
> 82e92f4c drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2016-02-09  432  			pr_err("%s() au0282_dev_register failed to create graph\n",
> 82e92f4c drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2016-02-09  433  			       __func__);
> 82e92f4c drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2016-02-09  434  			goto done;
> 82e92f4c drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2016-02-09  435  		}
> 82e92f4c drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2016-02-09  436  	}
> 8a4e7866 drivers/media/usb/au0828/au0828-core.c   Michael Krufky                 2012-12-04  437  #endif
> 8b2f0795 drivers/media/video/au0828/au0828-core.c Devin Heitmueller              2009-03-11  438
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  439  	/* Digital TV */
> f251b3e7 drivers/media/usb/au0828/au0828-core.c   Tim Mester                     2014-01-07  440  	retval = au0828_dvb_register(dev);
> f251b3e7 drivers/media/usb/au0828/au0828-core.c   Tim Mester                     2014-01-07  441  	if (retval)
> f251b3e7 drivers/media/usb/au0828/au0828-core.c   Tim Mester                     2014-01-07  442  		pr_err("%s() au0282_dev_register failed\n",
> f251b3e7 drivers/media/usb/au0828/au0828-core.c   Tim Mester                     2014-01-07  443  		       __func__);
> f251b3e7 drivers/media/usb/au0828/au0828-core.c   Tim Mester                     2014-01-07  444
> 2fcfd317 drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2014-07-24  445  	/* Remote controller */
> 2fcfd317 drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2014-07-24  446  	au0828_rc_register(dev);
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  447
> 2fcfd317 drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2014-07-24  448  	/*
> 2fcfd317 drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2014-07-24  449  	 * Store the pointer to the au0828_dev so it can be accessed in
> 2fcfd317 drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2014-07-24  450  	 * au0828_usb_disconnect
> 2fcfd317 drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2014-07-24  451  	 */
> fe78a49c drivers/media/video/au0828/au0828-core.c Devin Heitmueller              2009-04-28  452  	usb_set_intfdata(interface, dev);
> fe78a49c drivers/media/video/au0828/au0828-core.c Devin Heitmueller              2009-04-28  453
> 83afb32a drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2014-08-09  454  	pr_info("Registered device AU0828 [%s]\n",
> f1add5b5 drivers/media/video/au0828/au0828-core.c Devin Heitmueller              2009-03-11  455  		dev->board.name == NULL ? "Unset" : dev->board.name);
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  456
> 549ee4df drivers/media/video/au0828/au0828-core.c Devin Heitmueller              2012-08-06  457  	mutex_unlock(&dev->lock);
> 549ee4df drivers/media/video/au0828/au0828-core.c Devin Heitmueller              2012-08-06  458
> 9832e155 drivers/media/usb/au0828/au0828-core.c   Javier Martinez Canillas       2015-12-11  459  #ifdef CONFIG_MEDIA_CONTROLLER
> 9832e155 drivers/media/usb/au0828/au0828-core.c   Javier Martinez Canillas       2015-12-11  460  	retval = media_device_register(dev->media_dev);
> 9832e155 drivers/media/usb/au0828/au0828-core.c   Javier Martinez Canillas       2015-12-11  461  #endif
> 9832e155 drivers/media/usb/au0828/au0828-core.c   Javier Martinez Canillas       2015-12-11  462
> 9832e155 drivers/media/usb/au0828/au0828-core.c   Javier Martinez Canillas       2015-12-11  463  done:
> 9832e155 drivers/media/usb/au0828/au0828-core.c   Javier Martinez Canillas       2015-12-11  464  	if (retval < 0)
> 9832e155 drivers/media/usb/au0828/au0828-core.c   Javier Martinez Canillas       2015-12-11  465  		au0828_usb_disconnect(interface);
> 9832e155 drivers/media/usb/au0828/au0828-core.c   Javier Martinez Canillas       2015-12-11  466
> f251b3e7 drivers/media/usb/au0828/au0828-core.c   Tim Mester                     2014-01-07 @467  	return retval;
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  468  }
> 265a6510 drivers/media/video/au0828/au0828-core.c Steven Toth                    2008-04-18  469
> aaeac199 drivers/media/usb/au0828/au0828-core.c   Mauro Carvalho Chehab          2014-08-09  470  static int au0828_suspend(struct usb_interface *interface,
>
> :::::: The code at line 467 was first introduced by commit
> :::::: f251b3e78cc57411627d825eae3c911da77b4035 [media] au0828: Add option to preallocate digital transfer buffers
>
> :::::: TO: Tim Mester <ttmesterr@gmail.com>
> :::::: CC: Mauro Carvalho Chehab <m.chehab@samsung.com>
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>
--8323329-1187631048-1455284227=:2510--
