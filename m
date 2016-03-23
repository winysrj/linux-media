Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:16572 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790AbcCWDkz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2016 23:40:55 -0400
Date: Wed, 23 Mar 2016 11:39:46 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: [sailus-media:master 9/14] DockBook:
 include/media/media-device.h:629: warning: No description found for
 parameter 'mdev'
Message-ID: <201603231143.9NdbQxM6%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://linuxtv.org/media_tree.git master
head:   2705c1a96f978450377f1019d4bef34190b4ef05
commit: 44ff16d0b7ccb4c872de7a53196b2d3f83089607 [9/14] [media] media-device: use kref for media_device instance
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   include/linux/init.h:1: warning: no structured comments found
   kernel/sys.c:1: warning: no structured comments found
   drivers/dma-buf/seqno-fence.c:1: warning: no structured comments found
   drivers/dma-buf/reservation.c:1: warning: no structured comments found
   include/linux/reservation.h:1: warning: no structured comments found
>> include/media/media-device.h:629: warning: No description found for parameter 'mdev'
>> include/media/media-device.h:629: warning: Excess function parameter 'dev' description in 'media_device_unregister_devres'
>> include/media/media-device.h:629: warning: No description found for parameter 'mdev'
>> include/media/media-device.h:629: warning: Excess function parameter 'dev' description in 'media_device_unregister_devres'

vim +/mdev +629 include/media/media-device.h

   613	 *
   614	 * @dev: pointer to struct &device.
   615	 */
   616	struct media_device *media_device_find_devres(struct device *dev);
   617	
   618	/**
   619	 * media_device_unregister_devres) - Unregister media device allocated as
   620	 *				     as device resource
   621	 *
   622	 * @dev: pointer to struct &device.
   623	 *
   624	 * Devices allocated via media_device_get_devres should be de-alocalted
   625	 * and freed via this function. Callers should not call
   626	 * media_device_unregister() nor media_device_cleanup() on devices
   627	 * allocated via media_device_get_devres().
   628	 */
 > 629	void media_device_unregister_devres(struct media_device *mdev);
   630	
   631	/* Iterate over all entities. */
   632	#define media_device_for_each_entity(entity, mdev)			\
   633		list_for_each_entry(entity, &(mdev)->entities, graph_obj.list)
   634	
   635	/* Iterate over all interfaces. */
   636	#define media_device_for_each_intf(intf, mdev)			\
   637		list_for_each_entry(intf, &(mdev)->interfaces, graph_obj.list)

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--bp/iNruPH9dso1Pn
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--bp/iNruPH9dso1Pn--
