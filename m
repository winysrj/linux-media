Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20941 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbaB1Vwd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Feb 2014 16:52:33 -0500
Date: Sat, 1 Mar 2014 00:52:17 +0300
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org, Dean Anderson <linux-dev@sensoray.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [linuxtv-media:master 476/499]
 drivers/media/usb/s2255/s2255drv.c:2405 s2255_stop_acquire() warn:
 inconsistent returns mutex:&dev->cmdlock: locked (2391 [(-12)]) unlocked
 (2405 [0], 2405 [s32min-(-1),1-s32max])
Message-ID: <20140228215217.GO26776@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dean,

FYI, there are new smatch warnings show up in

tree:   git://linuxtv.org/media_tree.git master
head:   a06b429df49bb50ec1e671123a45147a1d1a6186
commit: 47d8c881c304642a68d398b87d9e8846e643c81a [476/499] [media] s2255drv: dynamic memory allocation efficiency fix

drivers/media/usb/s2255/s2255drv.c:2405 s2255_stop_acquire() warn: inconsistent returns mutex:&dev->cmdlock: locked (2391 [(-12)]) unlocked (2405 [0], 2405 [s32min-(-1),1-s32max])
drivers/media/usb/s2255/s2255drv.c:2462 s2255_probe() warn: possible memory leak of 'dev'

git remote add linuxtv-media git://linuxtv.org/media_tree.git
git remote update linuxtv-media
git checkout 47d8c881c304642a68d398b87d9e8846e643c81a
vim +2405 drivers/media/usb/s2255/s2255drv.c

38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2399  	if (res != 0)
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2400  		dev_err(&dev->udev->dev, "CMD_STOP error\n");
47d8c881 drivers/media/usb/s2255/s2255drv.c Dean Anderson         2014-02-05  2401  
5e950faf drivers/media/usb/s2255/s2255drv.c Dean Anderson         2014-02-04  2402  	vc->b_acquire = 0;
5e950faf drivers/media/usb/s2255/s2255drv.c Dean Anderson         2014-02-04  2403  	dprintk(dev, 4, "%s: chn %d, res %d\n", __func__, vc->idx, res);
47d8c881 drivers/media/usb/s2255/s2255drv.c Dean Anderson         2014-02-05  2404  	mutex_unlock(&dev->cmdlock);
14d96260 drivers/media/video/s2255drv.c     Dean Anderson         2008-08-25 @2405  	return res;
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2406  }
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2407  
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2408  static void s2255_stop_readpipe(struct s2255_dev *dev)
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2409  {
ab85c6a3 drivers/media/video/s2255drv.c     Dean Anderson         2010-04-08  2410  	struct s2255_pipeinfo *pipe = &dev->pipe;
8b661b50 drivers/media/video/s2255drv.c     Dan Carpenter         2010-05-05  2411  
ab85c6a3 drivers/media/video/s2255drv.c     Dean Anderson         2010-04-08  2412  	pipe->state = 0;
ab85c6a3 drivers/media/video/s2255drv.c     Dean Anderson         2010-04-08  2413  	if (pipe->stream_urb) {
ab85c6a3 drivers/media/video/s2255drv.c     Dean Anderson         2010-04-08  2414  		/* cancel urb */
ab85c6a3 drivers/media/video/s2255drv.c     Dean Anderson         2010-04-08  2415  		usb_kill_urb(pipe->stream_urb);
ab85c6a3 drivers/media/video/s2255drv.c     Dean Anderson         2010-04-08  2416  		usb_free_urb(pipe->stream_urb);
ab85c6a3 drivers/media/video/s2255drv.c     Dean Anderson         2010-04-08  2417  		pipe->stream_urb = NULL;
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2418  	}
f5402007 drivers/media/usb/s2255/s2255drv.c sensoray-dev          2014-01-29  2419  	dprintk(dev, 4, "%s", __func__);
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2420  	return;
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2421  }
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2422  
14d96260 drivers/media/video/s2255drv.c     Dean Anderson         2008-08-25  2423  static void s2255_fwload_start(struct s2255_dev *dev, int reset)
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2424  {
14d96260 drivers/media/video/s2255drv.c     Dean Anderson         2008-08-25  2425  	if (reset)
14d96260 drivers/media/video/s2255drv.c     Dean Anderson         2008-08-25  2426  		s2255_reset_dsppower(dev);
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2427  	dev->fw_data->fw_size = dev->fw_data->fw->size;
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2428  	atomic_set(&dev->fw_data->fw_state, S2255_FW_NOTLOADED);
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2429  	memcpy(dev->fw_data->pfw_data,
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2430  	       dev->fw_data->fw->data, CHUNK_SIZE);
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2431  	dev->fw_data->fw_loaded = CHUNK_SIZE;
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2432  	usb_fill_bulk_urb(dev->fw_data->fw_urb, dev->udev,
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2433  			  usb_sndbulkpipe(dev->udev, 2),
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2434  			  dev->fw_data->pfw_data,
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2435  			  CHUNK_SIZE, s2255_fwchunk_complete,
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2436  			  dev->fw_data);
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2437  	mod_timer(&dev->timer, jiffies + HZ);
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2438  }
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2439  
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2440  /* standard usb probe function */
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2441  static int s2255_probe(struct usb_interface *interface,
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2442  		       const struct usb_device_id *id)
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2443  {
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2444  	struct s2255_dev *dev = NULL;
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2445  	struct usb_host_interface *iface_desc;
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2446  	struct usb_endpoint_descriptor *endpoint;
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2447  	int i;
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2448  	int retval = -ENOMEM;
14d96260 drivers/media/video/s2255drv.c     Dean Anderson         2008-08-25  2449  	__le32 *pdata;
14d96260 drivers/media/video/s2255drv.c     Dean Anderson         2008-08-25  2450  	int fw_size;
47d8c881 drivers/media/usb/s2255/s2255drv.c Dean Anderson         2014-02-05  2451  
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2452  	/* allocate memory for our device state and initialize it to zero */
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2453  	dev = kzalloc(sizeof(struct s2255_dev), GFP_KERNEL);
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2454  	if (dev == NULL) {
be9ed511 drivers/media/video/s2255drv.c     Mauro Carvalho Chehab 2009-01-08  2455  		s2255_dev_err(&interface->dev, "out of memory\n");
ff7e22df drivers/media/video/s2255drv.c     Dean Anderson         2010-04-08  2456  		return -ENOMEM;
38f993ad drivers/media/video/s2255drv.c     Dean Anderson         2008-06-26  2457  	}
47d8c881 drivers/media/usb/s2255/s2255drv.c Dean Anderson         2014-02-05  2458  
47d8c881 drivers/media/usb/s2255/s2255drv.c Dean Anderson         2014-02-05  2459  	dev->cmdbuf = kzalloc(S2255_CMDBUF_SIZE, GFP_KERNEL);
47d8c881 drivers/media/usb/s2255/s2255drv.c Dean Anderson         2014-02-05  2460  	if (dev->cmdbuf == NULL) {
47d8c881 drivers/media/usb/s2255/s2255drv.c Dean Anderson         2014-02-05  2461  		s2255_dev_err(&interface->dev, "out of memory\n");
47d8c881 drivers/media/usb/s2255/s2255drv.c Dean Anderson         2014-02-05 @2462  		return -ENOMEM;
47d8c881 drivers/media/usb/s2255/s2255drv.c Dean Anderson         2014-02-05  2463  	}
47d8c881 drivers/media/usb/s2255/s2255drv.c Dean Anderson         2014-02-05  2464  
fe85ce90 drivers/media/video/s2255drv.c     Dean Anderson         2010-06-01  2465  	atomic_set(&dev->num_channels, 0);

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
