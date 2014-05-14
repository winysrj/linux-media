Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11173 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbaENJwa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 May 2014 05:52:30 -0400
Date: Wed, 14 May 2014 17:52:24 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:master 499/499] powercap_sys.c:undefined reference to
 `__media_device_register'
Message-ID: <20140514095224.GB30414@localhost>
References: <53730770.czdvbxQxtjIP34sN%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53730770.czdvbxQxtjIP34sN%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

It's probably a bug fix that unveils the link errors.

tree:   git://linuxtv.org/media_tree.git master
head:   ba0d342ecc21fbbe2f6c178f4479944d1fb34f3b
commit: ba0d342ecc21fbbe2f6c178f4479944d1fb34f3b [499/499] saa7134-alsa: include vmalloc.h
config: make ARCH=arm allmodconfig

All error/warnings:

   drivers/built-in.o: In function `iss_unregister_entities':
   powercap_sys.c:(.text+0x142ef0): undefined reference to `v4l2_device_unregister'
   powercap_sys.c:(.text+0x142ef8): undefined reference to `media_device_unregister'
   drivers/built-in.o: In function `iss_initialize_modules':
   powercap_sys.c:(.text+0x143550): undefined reference to `media_entity_create_link'
   powercap_sys.c:(.text+0x143574): undefined reference to `media_entity_create_link'
   powercap_sys.c:(.text+0x14359c): undefined reference to `media_entity_create_link'
   powercap_sys.c:(.text+0x1435c4): undefined reference to `media_entity_create_link'
   powercap_sys.c:(.text+0x1435e4): undefined reference to `media_entity_create_link'
   drivers/built-in.o: In function `iss_register_subdev_group':
   powercap_sys.c:(.text+0x1436a8): undefined reference to `v4l2_i2c_new_subdev_board'
   drivers/built-in.o: In function `iss_register_entities':
>> powercap_sys.c:(.text+0x143754): undefined reference to `__media_device_register'
   powercap_sys.c:(.text+0x143784): undefined reference to `v4l2_device_register'
   powercap_sys.c:(.text+0x143878): undefined reference to `media_entity_create_link'
   powercap_sys.c:(.text+0x1438a0): undefined reference to `v4l2_device_register_subdev_nodes'
   drivers/built-in.o: In function `iss_pipeline_pm_use_count':
   powercap_sys.c:(.text+0x1438fc): undefined reference to `media_entity_graph_walk_start'
   powercap_sys.c:(.text+0x143920): undefined reference to `media_entity_graph_walk_next'
   drivers/built-in.o: In function `iss_pipeline_pm_power':
   powercap_sys.c:(.text+0x143a94): undefined reference to `media_entity_graph_walk_start'
   powercap_sys.c:(.text+0x143ac0): undefined reference to `media_entity_graph_walk_next'
   powercap_sys.c:(.text+0x143adc): undefined reference to `media_entity_graph_walk_start'
   powercap_sys.c:(.text+0x143b04): undefined reference to `media_entity_graph_walk_next'
   drivers/built-in.o: In function `iss_pipeline_disable':
   powercap_sys.c:(.text+0x143e40): undefined reference to `media_entity_remote_pad'
   drivers/built-in.o: In function `iss_pipeline_enable':
   powercap_sys.c:(.text+0x143f60): undefined reference to `media_entity_remote_pad'
   drivers/built-in.o: In function `omap4iss_get_external_info':
   powercap_sys.c:(.text+0x144234): undefined reference to `v4l2_ctrl_find'
   powercap_sys.c:(.text+0x144258): undefined reference to `v4l2_ctrl_g_ctrl_int64'
   drivers/built-in.o: In function `omap4iss_module_sync_idle':
   powercap_sys.c:(.text+0x1444c4): undefined reference to `media_entity_remote_pad'
   drivers/built-in.o: In function `csi2_link_validate':
   powercap_sys.c:(.text+0x144d0c): undefined reference to `v4l2_subdev_link_validate_default'
   drivers/built-in.o: In function `csi2_init_entities':
   powercap_sys.c:(.text+0x146014): undefined reference to `v4l2_subdev_init'
   powercap_sys.c:(.text+0x14607c): undefined reference to `media_entity_init'
   powercap_sys.c:(.text+0x1460f4): undefined reference to `media_entity_create_link'
   powercap_sys.c:(.text+0x146110): undefined reference to `media_entity_cleanup'
   drivers/built-in.o: In function `csi2_configure':
   powercap_sys.c:(.text+0x146414): undefined reference to `media_entity_remote_pad'
   drivers/built-in.o: In function `omap4iss_csi2_unregister_entities':
   powercap_sys.c:(.text+0x146ac0): undefined reference to `v4l2_device_unregister_subdev'
   drivers/built-in.o: In function `omap4iss_csi2_register_entities':
   powercap_sys.c:(.text+0x146af4): undefined reference to `v4l2_device_register_subdev'
   drivers/built-in.o: In function `omap4iss_csi2_cleanup':
   powercap_sys.c:(.text+0x146c40): undefined reference to `media_entity_cleanup'
   powercap_sys.c:(.text+0x146c54): undefined reference to `media_entity_cleanup'
   drivers/built-in.o: In function `ipipeif_init_entities':
   powercap_sys.c:(.text+0x1483fc): undefined reference to `v4l2_subdev_init'
   powercap_sys.c:(.text+0x148458): undefined reference to `media_entity_init'
   powercap_sys.c:(.text+0x1484cc): undefined reference to `media_entity_create_link'
   drivers/built-in.o: In function `omap4iss_ipipeif_unregister_entities':
   powercap_sys.c:(.text+0x1485f0): undefined reference to `media_entity_cleanup'
   powercap_sys.c:(.text+0x1485f8): undefined reference to `v4l2_device_unregister_subdev'
   drivers/built-in.o: In function `omap4iss_ipipeif_register_entities':
   powercap_sys.c:(.text+0x14862c): undefined reference to `v4l2_device_register_subdev'
   drivers/built-in.o: In function `omap4iss_ipipe_unregister_entities':
   powercap_sys.c:(.text+0x149220): undefined reference to `media_entity_cleanup'
   powercap_sys.c:(.text+0x149228): undefined reference to `v4l2_device_unregister_subdev'
   drivers/built-in.o: In function `omap4iss_ipipe_register_entities':
   powercap_sys.c:(.text+0x149250): undefined reference to `v4l2_device_register_subdev'
   drivers/built-in.o: In function `omap4iss_ipipe_init':
   powercap_sys.c:(.text+0x1492bc): undefined reference to `v4l2_subdev_init'
   powercap_sys.c:(.text+0x14931c): undefined reference to `media_entity_init'
   drivers/built-in.o: In function `resizer_init_entities':
   powercap_sys.c:(.text+0x14b184): undefined reference to `v4l2_subdev_init'
   powercap_sys.c:(.text+0x14b1d8): undefined reference to `media_entity_init'
   powercap_sys.c:(.text+0x14b250): undefined reference to `media_entity_create_link'
   drivers/built-in.o: In function `omap4iss_resizer_unregister_entities':
   powercap_sys.c:(.text+0x14b394): undefined reference to `media_entity_cleanup'
   powercap_sys.c:(.text+0x14b39c): undefined reference to `v4l2_device_unregister_subdev'
   drivers/built-in.o: In function `omap4iss_resizer_register_entities':
   powercap_sys.c:(.text+0x14b3d0): undefined reference to `v4l2_device_register_subdev'
   drivers/built-in.o: In function `iss_video_set_param':
   powercap_sys.c:(.text+0x14b570): undefined reference to `video_devdata'
   drivers/built-in.o: In function `iss_video_get_param':
   powercap_sys.c:(.text+0x14b5e4): undefined reference to `video_devdata'
   drivers/built-in.o: In function `iss_video_get_format':
   powercap_sys.c:(.text+0x14b784): undefined reference to `video_devdata'
   drivers/built-in.o: In function `iss_video_remote_subdev':
   powercap_sys.c:(.text+0x14b7fc): undefined reference to `media_entity_remote_pad'
   drivers/built-in.o: In function `iss_video_set_crop':
   powercap_sys.c:(.text+0x14b850): undefined reference to `video_devdata'
   drivers/built-in.o: In function `iss_video_get_crop':
   powercap_sys.c:(.text+0x14b8f8): undefined reference to `video_devdata'
   drivers/built-in.o: In function `iss_video_cropcap':
   powercap_sys.c:(.text+0x14b9e4): undefined reference to `video_devdata'
   drivers/built-in.o: In function `iss_video_enum_format':
   powercap_sys.c:(.text+0x14bc60): undefined reference to `video_devdata'
   drivers/built-in.o: In function `iss_video_querycap':
   powercap_sys.c:(.text+0x14bd14): undefined reference to `video_devdata'
   drivers/built-in.o:powercap_sys.c:(.text+0x14bd9c): more undefined references to `video_devdata' follow
   drivers/built-in.o: In function `iss_video_streamoff':
   powercap_sys.c:(.text+0x14be20): undefined reference to `vb2_streamoff'
   powercap_sys.c:(.text+0x14be48): undefined reference to `media_entity_pipeline_stop'
   drivers/built-in.o: In function `iss_video_far_end':
   powercap_sys.c:(.text+0x14bea4): undefined reference to `media_entity_graph_walk_start'
   powercap_sys.c:(.text+0x14bed8): undefined reference to `media_entity_graph_walk_next'
   drivers/built-in.o: In function `iss_video_streamon':
   powercap_sys.c:(.text+0x14bf18): undefined reference to `video_devdata'
   powercap_sys.c:(.text+0x14bf94): undefined reference to `media_entity_pipeline_start'
   powercap_sys.c:(.text+0x14bfac): undefined reference to `media_entity_graph_walk_start'
   powercap_sys.c:(.text+0x14bfcc): undefined reference to `media_entity_graph_walk_next'
   powercap_sys.c:(.text+0x14c0ac): undefined reference to `vb2_streamon'
   powercap_sys.c:(.text+0x14c118): undefined reference to `vb2_streamoff'
   powercap_sys.c:(.text+0x14c128): undefined reference to `media_entity_pipeline_stop'
   drivers/built-in.o: In function `iss_video_dqbuf':
   powercap_sys.c:(.text+0x14c194): undefined reference to `vb2_dqbuf'
   drivers/built-in.o: In function `iss_video_qbuf':
   powercap_sys.c:(.text+0x14c1b8): undefined reference to `vb2_qbuf'
   drivers/built-in.o: In function `iss_video_querybuf':

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
