Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:41706
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751057AbdGFGEu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Jul 2017 02:04:50 -0400
Date: Thu, 6 Jul 2017 08:04:46 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Cyprian Wronka <cwronka@cadence.com>,
        Neil Webb <neilw@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        =?ISO-8859-15?Q?Niklas_S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, kbuild-all@01.org
Subject: Re: [PATCH 2/2] v4l: cadence: Add Cadence MIPI-CSI2 RX driver
 (fwd)
Message-ID: <alpine.DEB.2.20.1707060803210.2028@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please check on this (line 199).

julia

---------- Forwarded message ----------
Date: Thu, 6 Jul 2017 13:58:29 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 2/2] v4l: cadence: Add Cadence MIPI-CSI2 RX driver

Hi Maxime,

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.12]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Maxime-Ripard/dt-bindings-media-Add-Cadence-MIPI-CSI2RX-Device-Tree-bindings/20170705-205643
base:   git://linuxtv.org/media_tree.git master
:::::: branch date: 17 hours ago
:::::: commit date: 17 hours ago

>> drivers/media/platform/cadence/cdns-csi2rx.c:199:5-23: WARNING: Unsigned expression compared with zero: csi2rx -> sensor_pad < 0

git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout fb3d2879ba0623bcdc83c99ba70229ec1713feaf
vim +199 drivers/media/platform/cadence/cdns-csi2rx.c

fb3d2879 Maxime Ripard 2017-07-03  183  	return media_create_pad_link(&csi2rx->sensor_subdev->entity,
fb3d2879 Maxime Ripard 2017-07-03  184  				     csi2rx->sensor_pad,
fb3d2879 Maxime Ripard 2017-07-03  185  				     &csi2rx->subdev.entity, 0,
fb3d2879 Maxime Ripard 2017-07-03  186  				     MEDIA_LNK_FL_ENABLED |
fb3d2879 Maxime Ripard 2017-07-03  187  				     MEDIA_LNK_FL_IMMUTABLE);
fb3d2879 Maxime Ripard 2017-07-03  188  }
fb3d2879 Maxime Ripard 2017-07-03  189
fb3d2879 Maxime Ripard 2017-07-03  190  static int csi2rx_async_bound(struct v4l2_async_notifier *notifier,
fb3d2879 Maxime Ripard 2017-07-03  191  			      struct v4l2_subdev *subdev,
fb3d2879 Maxime Ripard 2017-07-03  192  			      struct v4l2_async_subdev *asd)
fb3d2879 Maxime Ripard 2017-07-03  193  {
fb3d2879 Maxime Ripard 2017-07-03  194  	struct csi2rx_priv *csi2rx = v4l2_notifier_to_csi2rx(notifier);
fb3d2879 Maxime Ripard 2017-07-03  195
fb3d2879 Maxime Ripard 2017-07-03  196  	csi2rx->sensor_pad = media_entity_get_fwnode_pad(&subdev->entity,
fb3d2879 Maxime Ripard 2017-07-03  197  							 &csi2rx->sensor_node->fwnode,
fb3d2879 Maxime Ripard 2017-07-03  198  							 MEDIA_PAD_FL_SOURCE);
fb3d2879 Maxime Ripard 2017-07-03 @199  	if (csi2rx->sensor_pad < 0) {
fb3d2879 Maxime Ripard 2017-07-03  200  		dev_err(csi2rx->dev, "Couldn't find output pad for subdev %s\n",
fb3d2879 Maxime Ripard 2017-07-03  201  			subdev->name);
fb3d2879 Maxime Ripard 2017-07-03  202  		return csi2rx->sensor_pad;
fb3d2879 Maxime Ripard 2017-07-03  203  	}
fb3d2879 Maxime Ripard 2017-07-03  204
fb3d2879 Maxime Ripard 2017-07-03  205  	csi2rx->sensor_subdev = subdev;
fb3d2879 Maxime Ripard 2017-07-03  206
fb3d2879 Maxime Ripard 2017-07-03  207  	dev_dbg(csi2rx->dev, "Bound %s pad: %d\n", subdev->name,

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
